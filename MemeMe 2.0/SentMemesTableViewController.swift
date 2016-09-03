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
    
    var memes: [MemeStruct] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sentMemeTableCell")!
        let currentMeme = memes[indexPath.row]
        cell.imageView?.image = currentMeme.memedImage
        cell.textLabel?.text = currentMeme.topMemeString + "..." + currentMeme.bottomMemeString
        
        return cell
    }
}
