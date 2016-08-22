//
//  ImagePickerDelegate.swift
//  MemeMe 1.0
//
//  Created by Jack Ngai on 8/21/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import Foundation
import UIKit

extension MemeViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImage.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
