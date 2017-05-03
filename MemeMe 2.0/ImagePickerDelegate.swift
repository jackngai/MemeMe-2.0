//
//  ImagePickerDelegate.swift
//  MemeMe 2.0
//
//  Created by Jack Ngai on 8/21/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import Foundation
import UIKit

extension MemeViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
