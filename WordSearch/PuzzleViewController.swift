//
//  PuzzleViewController.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController, CharacterGridViewDelegate {

    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var characterGridView: CharacterGridView!

    private var matchedWordLocations = [WordLocation]()
    private let highlightColor = UIColor.random()

    var puzzles: [Puzzle]? {
        didSet {
            if let puzzles = puzzles, puzzle = puzzles.first {
                loadPuzzle(puzzle)
            }
        }
    }

    var puzzleIndex = 0

    var puzzle: Puzzle? {
        didSet {
            sourceLabel.text = puzzle?.word
            characterGridView.characterGrid = puzzle?.characterGrid
            self.updateTargetLabel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.alpha = 0

        // Can't link this in IB ¯\_(ツ)_/¯
        characterGridView.delegate = self
        characterGridView.highlightColor = highlightColor

        Network.requestPuzzles { puzzles, error in
            if let puzzles = puzzles {
                dispatch_async(dispatch_get_main_queue(), {
                    self.puzzles = puzzles
                })
            }
        }
    }

    func updateTargetLabel() {
        var text = NSMutableAttributedString()
        defer {
            targetLabel.attributedText = text
        }
        guard let puzzle = puzzle else { return }
        let strikeThroughAttributes = [
            NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleThick.rawValue,
            NSStrikethroughColorAttributeName: highlightColor
        ]
        for wordLocation in puzzle.wordLocations {
            if text.length > 0 {
                text.appendAttributedString(NSAttributedString(string: " "))
            }
            if matchedWordLocations.contains(wordLocation) {
                text.appendAttributedString(NSAttributedString(string: wordLocation.word, attributes: strikeThroughAttributes))
            } else {
                text.appendAttributedString(NSAttributedString(string: wordLocation.word))
            }
        }
    }

    func checkCompleteness() {
        guard let puzzle = puzzle else { return }
        if Set(puzzle.wordLocations) == Set(matchedWordLocations) {
            // we're done! on to the next!
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
            dispatch_after(delayTime, dispatch_get_main_queue(), {
                self.transitionToNextPuzzle()
            })
        }
    }

    func transitionToNextPuzzle() {
        let nextPuzzleIndex = (puzzleIndex + 1) % puzzles!.count
        self.unloadPuzzle({ () -> Void in
            self.loadPuzzle(self.puzzles![nextPuzzleIndex])
            self.puzzleIndex = nextPuzzleIndex
        })
    }

    func loadPuzzle(puzzle: Puzzle, completionHandler: (() -> Void)? = nil) {
        self.puzzle = puzzle
        UIView.animateWithDuration(0.35,
            animations: {
                self.view.alpha = 1
            }, completion: { _ in
                self.view.userInteractionEnabled = true
                completionHandler?()
        })
    }

    func unloadPuzzle(completionHandler: (() -> Void)? = nil) {
        self.view.userInteractionEnabled = false
        UIView.animateWithDuration(0.35,
            animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.puzzle = nil
                self.matchedWordLocations.removeAll()
                completionHandler?()
        })
    }

    // MARK: - CharacterGridViewDelegate

    func shouldHighlight(highlight: Highlight) -> Bool {
        guard let puzzle = puzzle else { return false }
        // find matching words, regardless of which direction the highlight was dragged in
        let matchingWordLocation = puzzle.wordLocations.find({
            ($0.coordinates.first! == highlight.startCoordinate && $0.coordinates.last! == highlight.endCoordinate) ||
                ($0.coordinates.first! == highlight.endCoordinate && $0.coordinates.last! == highlight.startCoordinate)
        })
        return matchingWordLocation != nil
    }

    func didHighlight(highlight: Highlight) {
        guard let puzzle = puzzle else { return }
        // find matching words, regardless of which direction the highlight was dragged in
        if let matchingWordLocation = puzzle.wordLocations.find({
            ($0.coordinates.first! == highlight.startCoordinate && $0.coordinates.last! == highlight.endCoordinate) ||
                ($0.coordinates.first! == highlight.endCoordinate && $0.coordinates.last! == highlight.startCoordinate)
        }) {
            matchedWordLocations.append(matchingWordLocation)
        }
        updateTargetLabel()
        checkCompleteness()
    }
}

