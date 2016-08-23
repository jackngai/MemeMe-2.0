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
    @IBOutlet internal weak var selectedImage: UIImageView!
    @IBOutlet private weak var topTextField: UITextField!
    @IBOutlet private weak var bottomTextField: UITextField!
    @IBOutlet private weak var cameraButton: UIBarButtonItem!
    @IBOutlet private weak var navbar: UIToolbar!
    @IBOutlet private weak var toolbar: UIToolbar!
    @IBOutlet private weak var shareButton: UIBarButtonItem!
    
    private let textFieldDelgate = TextFieldDelegate()
    
    private var viewShiftedUp = false
    
    // Create a custom font type that will resemble the "Impact" font
    private let memeTextAttributes = [
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
    
    @IBAction private func selectFromAlbum(sender: UIBarButtonItem) {
        chooseSource(.PhotoLibrary)
    }

    @IBAction private func getImageFromCamera(sender: UIBarButtonItem) {
        chooseSource(.Camera)
    }

    @IBAction private func share(sender: UIBarButtonItem) {
        
        // Generate an image with memes permanently affixed, present activity controller to send this image
        // Upon completion, save the meme
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (_, completed, _, _) in
            completed ? self.save() : print("Share operation cancelled.")
        }
    }

    @IBAction private func cancel(sender: UIBarButtonItem) {
        
        // Reset Meme Editor to starting state
        selectedImage.image = nil
        topTextField.text = "TOP"
        topTextField.resignFirstResponder()
        bottomTextField.text = "BOTTOM"
        bottomTextField.resignFirstResponder()
        shareButton.enabled = false
        
    }
    
    
// MARK: Supporting Functions
    
    private func chooseSource(source: UIImagePickerControllerSourceType){
        
        // Call camera or album imagePicker depending on which button initiated the call
        // Enable share button in the completion handler
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true){
            _ in self.shareButton.enabled = true
        }
    }

    
    private func moveViewForKeyboard(notification: NSNotification){
        
        // Only run this code if user is editing the bottom text field
        guard bottomTextField.isFirstResponder() else{
            return
        }
        
        // Get keyboard height
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        // Adjust view base on notification, but only if the view hasn't already been shifted up
        if notification.name == "UIKeyboardWillShowNotification" && !viewShiftedUp{
            view.frame.origin.y = keyboardSize.CGRectValue().height * -1
            viewShiftedUp = true
        } else if notification.name == "UIKeyboardWillHideNotification"  && viewShiftedUp{
            view.frame.origin.y = 0
            viewShiftedUp = false
        }
    }
    
    private func generateMemedImage() -> UIImage {
        
        // Make toolbar and navbar invisible
        navbar.alpha = 0.0
        toolbar.alpha = 0.0
        
        
        // Screen capture
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Revert toolbar and navbar back to visible
        navbar.alpha = 1.0
        toolbar.alpha = 1.0
        
        return memedImage
    }

    private func save(){
        
        // Save the meme into a struct object
        let meme = MemeStruct(topMemeString: topTextField.text!, bottomMemeString: bottomTextField.text!, originalImage: selectedImage.image!, memedImage: generateMemedImage())
        print(meme)
    }
    
    private func setTextAttributes(textField:UITextField){
        
        // Set the font type to the Impact like font, center the text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
    }

}

