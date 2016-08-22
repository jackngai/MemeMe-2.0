//
//  MemeStruct.swift
//  MemeMe 1.0
//
//  Created by Jack Ngai on 8/22/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//
import UIKit
import Foundation

struct MemeStruct{
    var topMemeString:String
    var bottomMemeString:String
    var originalImage:UIImage
    var memedImage:UIImage
    
    
    init(topMemeString: String, bottomMemeString: String, originalImage: UIImage, memedImage: UIImage){
        self.topMemeString = topMemeString
        self.bottomMemeString = bottomMemeString
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    
}