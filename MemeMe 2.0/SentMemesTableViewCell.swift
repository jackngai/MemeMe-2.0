//
//  SentMemesTableViewCell.swift
//  MemeMe 2.0
//
//  Created by Jack Ngai on 9/8/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {

    @IBOutlet private weak var memeImageView: UIImageView!
    @IBOutlet private weak var topTextField: UILabel!
    @IBOutlet private weak var bottomTextField: UILabel!
    
    internal var currentMeme:MemeStruct!

    override internal func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        memeImageView.image = currentMeme.originalImage
        topTextField.text = "Top: " + currentMeme.topMemeString
        bottomTextField.text = "Bottom: " + currentMeme.bottomMemeString
        
    }

}
