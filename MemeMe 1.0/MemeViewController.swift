//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Jack Ngai on 8/19/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController{

//MARK: Outlets and Properties
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navbar: UIToolbar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let textFieldDelgate = TextFieldDelegate()
    
    var viewShiftedUp = false
    
    // Create a custom font type that will resemble the "Impact" font
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]

//MARK: View Controller Lifecycle Methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable Share button if no image is loaded
        if selectedImage.image == nil{
            shareButton.enabled = false
        }
        
        // Disable camera if running in simulator or hardware w/o camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Set both text fields to meme like fonts and center align
        setTextAttributes(topTextField)
        setTextAttributes(bottomTextField)
        
        // Notify when keyboard is shown/hidden; call method to shift view up/down
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil){ notification in self.moveViewForKeyboard(notification) }
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil){ notification in self.moveViewForKeyboard(notification) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust image to fit in the screen but keeping aspect ratio
        selectedImage.contentMode = .ScaleAspectFit
        
        // Assign text field delegates
        topTextField.delegate = textFieldDelgate
        bottomTextField.delegate = textFieldDelgate
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Stop receiving notification for showing/hiding keyboard
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

// MARK: IB Actions
    
    @IBAction func selectFromAlbum(sender: UIBarButtonItem) {
        chooseSource("album")
    }

    @IBAction func getImageFromCamera(sender: UIBarButtonItem) {
        chooseSource("camera")
    }

    @IBAction func share(sender: UIBarButtonItem) {
        
        // Generate an image with memes permanently affixed, present activity controller to send this image
        // Upon completion, save the meme
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true){
          _ in self.save()
        }
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        
        // Reset Meme Editor to starting state
        selectedImage.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
    }
    
    
// MARK: Supporting Functions
    
    func chooseSource(type: String){
        
        // Call camera or album imagePicker depending on which button initiated the call
        // Enable share button in the completion handler
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if type == "album"{
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else if type == "camera" {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        self.presentViewController(imagePicker, animated: true){
            _ in self.shareButton.enabled = true
        }
    }

    
    func moveViewForKeyboard(notification: NSNotification){
        
        // Only run this code if user is editing the bottom text field
        guard bottomTextField.isFirstResponder() else{
            return
        }
        
        // Get keyboard height
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        // Adjust view base on notification, but only if the view hasn't already been shifted up
        if notification.name == "UIKeyboardWillShowNotification" && !viewShiftedUp{
            self.view.frame.origin.y -= keyboardSize.CGRectValue().height
            viewShiftedUp = true
        } else if notification.name == "UIKeyboardWillHideNotification"  && viewShiftedUp{
            self.view.frame.origin.y += keyboardSize.CGRectValue().height
            viewShiftedUp = false
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navbar.hidden = true
        toolbar.hidden = true
        
        //S creen capture
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Unhide toolbar and navbar
        navbar.hidden = false
        toolbar.hidden = false
        
        return memedImage
    }

    func save(){
        
        // Save the meme into a struct object
        let meme = MemeStruct(topMemeString: topTextField.text!, bottomMemeString: bottomTextField.text!, originalImage: selectedImage.image!, memedImage: generateMemedImage())
        print(meme)
    }
    
    func setTextAttributes(textField:UITextField){
        
        // Set the font type to the Impact like font, center the text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
    }

}

