//
//  VillainDetailView.swift
//  MemeMe 2.0
//
//  Created by Jack Ngai on 9/6/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
// MARK: Properties
    
    @IBOutlet private weak var memeImageView: UIImageView!

    internal var meme:MemeStruct!
    internal var currentMemeIndex:Int!
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = meme.originalImage
    }

// MARK: Methods
    @IBAction private func deleteMeme(sender: UIBarButtonItem) {
        
        // Create warning view controller to confirm user really wants to delete the meme
        let warningController = UIAlertController(title: "Delete Meme", message: "Are you sure?", preferredStyle: .Alert)
        
        // If user confirms, remove the meme from the array and return user to previous view
        let deleteAction = UIAlertAction(title: "Yes", style: .Destructive) {
            _ in
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(self.currentMemeIndex)
            self.navigationController?.popViewControllerAnimated(true)
        }
        // If user cancels, no action is taken
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        
        warningController.addAction(deleteAction)
        warningController.addAction(cancelAction)
        presentViewController(warningController, animated: true, completion: nil)
    }
}
