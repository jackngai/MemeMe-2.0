//
//  SentMemesViewController.swift
//  MemeMe 2.0
//
//  Created by Jack Ngai on 9/1/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController{
    
// MARK: Properties
    
    var memes: [MemeStruct] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
// MARK: View Lifecycle Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
// MARK: Table View Methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SentMemesTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sentMemeTableCell")! as! SentMemesTableViewCell
        cell.currentMeme = memes[indexPath.row]
        return cell
    }
    
    // Show meme in detail view when tapped
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        detailController.currentMemeIndex = indexPath.row
        navigationController!.pushViewController(detailController, animated: true)
    }
}
