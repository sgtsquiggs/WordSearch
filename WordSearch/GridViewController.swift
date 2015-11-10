//
//  GridViewController.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/9/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

class GridViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var puzzle: Puzzle? {
        didSet {
            collectionView?.reloadData()
            let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Network.getPuzzles { (result) in
            if let puzzles = result.value {
                self.puzzle = puzzles.first
            }
        }
    }

    func itemAtIndexPath(indexPath: NSIndexPath) -> String? {
        let strings = puzzle?.characterGrid.flatMap({ $0 })
        return strings?[indexPath.item]
    }

    //# MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let puzzle = puzzle {
            return puzzle.characterGrid.map({ $0.count }).reduce(0, combine: +)
        }
        return 0
    }

    //# MARK: - UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let characterCell = collectionView.dequeueReusableCellWithReuseIdentifier("CharacterCell", forIndexPath: indexPath) as! CharacterCell

        characterCell.textLabel.text = itemAtIndexPath(indexPath)

        return characterCell
    }

    //# MARK: - UICollectionViewDelegateFlowLayout

    //  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //
    //  }
    
}
