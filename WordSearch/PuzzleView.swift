//
//  PuzzleView.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/8/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

/**
 Displays a word search letter grid.

 I would normally use an AutoLayout wrapper (such as PureLayout) to tidy up constraints, but I didn't want
 to use 3rd party librarys in this example.
 */
class PuzzleView : UIView {

    /// The puzzle that the view displays.
    var puzzle: Puzzle? {
        didSet {
            updateGrid()
        }
    }

    /// The two-dimensional array of labels representing the puzzle's character grid.
    private var labelGrid: [[UILabel]] = []

    private func updateGrid() {
        resetGrid()

        if let puzzle = puzzle {
            for characterRow in puzzle.characterGrid {
                var labelRow: [UILabel] = []
                for character in characterRow {
                    let label = createLabelForString(character)
                    labelRow.append(label)
                }
                labelGrid.append(labelRow)
            }
        }

        layoutGrid()
    }

    private func resetGrid() {
        labelGrid.forEach({ row in
            row.forEach({ label in
                label.removeFromSuperview()
            })
        })
        labelGrid.removeAll()
    }

    private func layoutGrid() {
        for (i, row) in labelGrid.enumerate() {
            for (j, label) in row.enumerate() {
                addSubview(label)
//                createAspectRatioConstraintForLabel(label)
                if j > 0 {
                    let leftLabel = row[j-1]
                    createLeftRightConstraintsForLabels(leftLabel, rightLabel: label)
                }
                if i > 0 {
                    let topLabel = labelGrid[i-1][j]
                    createTopBottomConstraintsForLabels(topLabel, bottomLabel: label)
                }
            }
        }

        if let firstRow = labelGrid.first, firstLabel = firstRow.first {
            createTopLeftCornerConstraintsForLabel(firstLabel)
        }

        if let lastRow = labelGrid.last, lastLabel = lastRow.last {
            createBottomRightCornerConstraintsForLabel(lastLabel)
        }
    }

    private func createLabelForString(string: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(24)
        label.text = string
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createAspectRatioConstraintForLabel(label: UILabel) {
        let squareConstraint = NSLayoutConstraint(
            item: label,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: label,
            attribute: .Height,
            multiplier: 1,
            constant: 0)
        label.addConstraint(squareConstraint)
    }

    private func createTopLeftCornerConstraintsForLabel(label: UILabel) {
        guard let superview = label.superview else {
            assertionFailure("label does not have a superview")
            return
        }

        let leftConstraint = NSLayoutConstraint(
            item: label,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: superview,
            attribute: .Left,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(leftConstraint)

        let topConstraint = NSLayoutConstraint(
            item: label,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: superview,
            attribute: .Top,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(topConstraint)
    }

    private func createBottomRightCornerConstraintsForLabel(label: UILabel) {
        guard let superview = label.superview else {
            assertionFailure("label does not have a superview")
            return
        }

        let rightConstraint = NSLayoutConstraint(
            item: label,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: superview,
            attribute: .Right,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(rightConstraint)

        let bottomConstraint = NSLayoutConstraint(
            item: label,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: superview,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(bottomConstraint)
    }

    private func createLeftRightConstraintsForLabels(leftLabel: UILabel, rightLabel: UILabel) {
        guard let superview = rightLabel.superview else {
            assertionFailure("label does not have a superview")
            return
        }
        guard leftLabel.superview == rightLabel.superview else {
            assertionFailure("left and right labels do not have the same superview")
            return
        }

        let sameWidthConstraint = NSLayoutConstraint(
            item: rightLabel,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Width,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(sameWidthConstraint)

        let sameHeightConstraint = NSLayoutConstraint(
            item: rightLabel,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Height,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(sameHeightConstraint)

        let borderConstraint = NSLayoutConstraint(
            item: rightLabel,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Right,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(borderConstraint)

        let topEdgeConstraint = NSLayoutConstraint(
            item: rightLabel,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Top,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(topEdgeConstraint)

        let bottomEdgeConstraint = NSLayoutConstraint(
            item: rightLabel,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(bottomEdgeConstraint)
    }

    private func createTopBottomConstraintsForLabels(topLabel: UILabel, bottomLabel: UILabel) {
        guard let superview = bottomLabel.superview else {
            assertionFailure("label does not have a superview")
            return
        }
        guard topLabel.superview == bottomLabel.superview else {
            assertionFailure("left and right labels do not have the same superview")
            return
        }

        let sameWidthConstraint = NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Width,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(sameWidthConstraint)
        
        let sameHeightConstraint = NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Height,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(sameHeightConstraint)
        
        let borderConstraint = NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(borderConstraint)
        
        let leftEdgeConstraint = NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Left,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(leftEdgeConstraint)
        
        let rightEdgeConstraint = NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Right,
            multiplier: 1,
            constant: 0)
        superview.addConstraint(rightEdgeConstraint)
    }
}
