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
    
    @IBOutlet fileprivate weak var memeImageView: UIImageView!

    internal var meme:MemeStruct!
    internal var currentMemeIndex:Int!
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = meme.memedImage
    }

// MARK: Methods
    @IBAction fileprivate func deleteMeme(_ sender: UIBarButtonItem) {
        
        // Create warning view controller to confirm user really wants to delete the meme
        let warningController = UIAlertController(title: "Delete Meme", message: "Are you sure?", preferredStyle: .alert)
        
        // If user confirms, remove the meme from the array and return user to previous view
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) {
            _ in
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: self.currentMemeIndex)
            self.navigationController?.popViewController(animated: true)
        }
        // If user cancels, no action is taken
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        warningController.addAction(deleteAction)
        warningController.addAction(cancelAction)
        present(warningController, animated: true, completion: nil)
    }
}
