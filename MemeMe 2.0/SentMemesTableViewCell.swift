//
//  SentMemesTableViewCell.swift
//  MemeMe 2.0
//
//  Created by Jack Ngai on 9/8/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var memeImageView: UIImageView!
    @IBOutlet fileprivate weak var topTextField: UILabel!
    @IBOutlet fileprivate weak var bottomTextField: UILabel!
    
    internal var currentMeme:MemeStruct!

    override internal func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        memeImageView.image = currentMeme.originalImage
        topTextField.text = "Top: " + currentMeme.topMemeString
        bottomTextField.text = "Bottom: " + currentMeme.bottomMemeString
        
    }

}
