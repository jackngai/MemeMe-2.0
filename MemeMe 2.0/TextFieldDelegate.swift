//
//  TextFieldDelegate.swift
//  MemeMe 2.0
//
//  Created by Jack Ngai on 8/21/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
