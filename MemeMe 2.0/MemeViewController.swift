//
//  MemeViewController.swift
//  MemeMe 2.0
//
//  Created by Jack Ngai on 8/19/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController{

//MARK: Outlets and Properties
    @IBOutlet internal weak var selectedImage: UIImageView!
    @IBOutlet fileprivate weak var topTextField: UITextField!
    @IBOutlet fileprivate weak var bottomTextField: UITextField!
    @IBOutlet fileprivate weak var cameraButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var navbar: UIToolbar!
    @IBOutlet fileprivate weak var toolbar: UIToolbar!
    @IBOutlet fileprivate weak var shareButton: UIBarButtonItem!
    
    fileprivate let textFieldDelgate = TextFieldDelegate()
    
    fileprivate var viewShiftedUp = false
    
    // Create a custom font type that will resemble the "Impact" font
    fileprivate let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ] as [String : Any]

//MARK: View Controller Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable Share button if no image is loaded
        if selectedImage.image == nil{
            shareButton.isEnabled = false
        }
        
        // Disable camera if running in simulator or hardware w/o camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // Notify when keyboard is shown/hidden; call method to shift view up/down
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil){ notification in self.moveViewForKeyboard(notification) }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil){ notification in self.moveViewForKeyboard(notification) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set both text fields to meme like fonts and center align
        setTextAttributes(topTextField)
        setTextAttributes(bottomTextField)
        
        // Adjust image to fit in the screen but keeping aspect ratio
        selectedImage.contentMode = .scaleAspectFit
        
        // Assign text field delegates
        topTextField.delegate = textFieldDelgate
        bottomTextField.delegate = textFieldDelgate
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Stop receiving notification for showing/hiding keyboard
        NotificationCenter.default.removeObserver(self)
    }

// MARK: IB Actions
    
    @IBAction fileprivate func selectFromAlbum(_ sender: UIBarButtonItem) {
        chooseSource(.photoLibrary)
    }

    @IBAction fileprivate func getImageFromCamera(_ sender: UIBarButtonItem) {
        chooseSource(.camera)
    }

    @IBAction fileprivate func share(_ sender: UIBarButtonItem) {
        
        // Resign first responder for both text fields so the blinking blue bar indicating active textfield does not show up in the memed image
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        
        // Generate an image with memes permanently affixed, present activity controller to send this image
        // Upon completion, save the meme
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (_, completed, _, _) in
            completed ? self.save() : print("Share operation cancelled.")
        }
    }

    @IBAction fileprivate func cancel(_ sender: UIBarButtonItem) {
        
        // Show alert if text was entered so user doesn't lose typed text if they hit cancel by accident
        if topTextField.text != "TOP" || bottomTextField.text != "BOTTOM"{
            let warningController = UIAlertController(title: "Lose all changes", message: "Are you sure?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) {
                _ in
                self.cancelAssist()
            }
            
            let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
            
            warningController.addAction(yesAction)
            warningController.addAction(noAction)
            present(warningController, animated: true, completion: nil)
        } else {
        // If user didn't type any text, run cancel action w/o warning
        cancelAssist()
        }

        
    }
    
    
// MARK: Supporting Functions
    
    fileprivate func chooseSource(_ source: UIImagePickerControllerSourceType){
        
        // Call camera or album imagePicker depending on which button initiated the call
        // Enable share button in the completion handler
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true){
            _ in self.shareButton.isEnabled = true
        }
    }

    
    fileprivate func moveViewForKeyboard(_ notification: Notification){
        
        // Only run this code if user is editing the bottom text field
        guard bottomTextField.isFirstResponder else{
            return
        }
        
        // Get keyboard height
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        // Adjust view base on notification, but only if the view hasn't already been shifted up
        if notification.name == Notification.Name.UIKeyboardWillShow && !viewShiftedUp{
            view.frame.origin.y = keyboardSize.cgRectValue.height * -1
            viewShiftedUp = true
        } else if notification.name == Notification.Name.UIKeyboardWillHide && viewShiftedUp{
            view.frame.origin.y = 0
            viewShiftedUp = false
        }
    }
    
    fileprivate func generateMemedImage() -> UIImage {
        
        // Make toolbar and navbar invisible
        navbar.alpha = 0.0
        toolbar.alpha = 0.0
        
        
        // Screen capture
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Revert toolbar and navbar back to visible
        navbar.alpha = 1.0
        toolbar.alpha = 1.0
        
        return memedImage
    }

    fileprivate func save(){
        
        // Save the meme into a struct object, then append meme struct object to meme array, then dismiss the meme editor
        let meme = MemeStruct(topMemeString: topTextField.text!, bottomMemeString: bottomTextField.text!, originalImage: selectedImage.image!, memedImage: generateMemedImage())
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
        
    }
    
    fileprivate func setTextAttributes(_ textField:UITextField){
        
        // Set the font type to the Impact like font, center the text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    fileprivate func cancelAssist() {
        // Reset Meme Editor to starting state
        selectedImage.image = nil
        topTextField.text = "TOP"
        topTextField.resignFirstResponder()
        bottomTextField.text = "BOTTOM"
        bottomTextField.resignFirstResponder()
        shareButton.isEnabled = false
        
        // Dismiss editor and return to Sent Memes view
        dismiss(animated: true, completion: nil)
    }

}

