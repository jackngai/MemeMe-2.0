//
//  SentMemesViewController.swift
//  MemeMe 2.0
//
//  Created by Jack Ngai on 9/1/16.
//  Copyright © 2016 Jack Ngai. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    @IBOutlet fileprivate weak var layout: UICollectionViewFlowLayout!

    fileprivate var memes: [MemeStruct] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    fileprivate var rotation = UIInterfaceOrientation.portrait

    // MARK: View Lifecycle Methods
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload data in case a new meme is saved
        collectionView?.reloadData()
        // Determine layout based on current size
        calculateLayout(view.frame.size)
    }
    
    
    // MARK: Methods
    // Runs when view changes size, override to call calculateLayout
    override internal func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        calculateLayout(size)
    }
    

    // Determine how many memes per row in portrait and landscape
    fileprivate func calculateLayout(_ size: CGSize){
        
        // Set spacing to 1 pixel, although this is the minimum spacing
        let spacing:CGFloat = 1.0
        
        // Size of the meme will be determined by screen size and rotation
        var memeSize:CGFloat!
        
        // If portrait, make memeSize big enough to fit 3 per row
        if size.height >= size.width{
            memeSize = (size.width - (2 * spacing)) / 3.0
        }
        // If landscape, memeSize should fit 4 per row
        else {
            memeSize = (size.width - (3 * spacing)) / 4.0
        }
        // Set spacing and size for layout
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: memeSize, height: memeSize)
    }
    
    // MARK: Collection View Delegate Methods
    
    // Required so collection view knows how many cells is needed
    override internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    // Required to show memes in collection view
    override internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memedImageView.image = meme.memedImage
        
        return cell
    }
    
    // Create a Detail View Controller instance, populate it with the memed Image, push on to Navigation stack
    override internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        detailController.currentMemeIndex = indexPath.row
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    // Enable user to re-organize memes in collection view
    override internal func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath,to destinationIndexPath: IndexPath) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let tempMeme = appDelegate.memes[sourceIndexPath.row]
        appDelegate.memes[sourceIndexPath.row] = appDelegate.memes[destinationIndexPath.row]
        appDelegate.memes[destinationIndexPath.row] = tempMeme
    
    }
}
