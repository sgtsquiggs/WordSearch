//
//  ViewController.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var puzzleView: PuzzleView!

    var puzzles: [Puzzle]?
    var puzzleIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Network.getPuzzles { result in
            dispatch_async(dispatch_get_main_queue()) {
                self.puzzles = result.value
                self.cycleThroughPuzzles()
//                if let puzzles = result.value, let puzzle = puzzles.first {
//                    self.puzzleView.puzzle = puzzle
//                }
            }
        }
    }

    func cycleThroughPuzzles() {
        if puzzleIndex >= puzzles?.count { puzzleIndex = 0 }
        puzzleView.puzzle = puzzles?[puzzleIndex]
        puzzleIndex += 1

        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.cycleThroughPuzzles()
        }
    }
    
    
}

