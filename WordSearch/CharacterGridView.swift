//
//  CharacterGridView.swift
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
@IBDesignable
class CharacterGridView: UIView {

    // One day, maybe we can set fonts via IBInspectable
    @IBInspectable var font: UIFont? {
        didSet {
            updateGrid()
        }
    }

    var delegate: CharacterGridViewDelegate?

    /// The puzzle that the view displays.
    var characterGrid: [[String]]? {
        didSet {
            highlights.removeAll()
            draggingHighlight = nil
            updateGrid()
            setNeedsDisplay()
        }
    }

    var highlightColor = UIColor.random()

    // MARK: - Initializers

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    private func initialize() {
        opaque = false

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("recognizePanGesture:"))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        addGestureRecognizer(panGestureRecognizer)
    }

    override func prepareForInterfaceBuilder() {
        characterGrid = [
            ["a", "b", "c", "d", "e"],
            ["f", "g", "h", "i", "j"],
            ["k", "l", "m", "n", "o"],
            ["p", "q", "r", "s", "t"],
            ["u", "v", "w", "x", "y"]]
    }

    // MARK: - Touch handling

    /// The array of highlights currently displayed
    private var highlights = [Highlight]()
    private var draggingHighlight: Highlight?

    /// The two-dimensional array of labels representing the puzzle's character grid.
    private var startPoint: CGPoint?

    // NOTE: Overriding touchesBegan was necessary to find where the pan gesture actually began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            startPoint = touch.locationInView(self)
        }
    }

    @objc private func recognizePanGesture(recognizer: UIPanGestureRecognizer) {
        var highlight: Highlight?
        defer {
            if recognizer.state == .Changed {
                if let highlight = highlight {
                    draggingHighlight = highlight
                }
            } else if recognizer.state == .Ended || recognizer.state == .Cancelled {
                if let highlight = highlight ?? draggingHighlight, delegate = delegate {
                    if delegate.shouldHighlight(highlight) {
                        highlights.append(highlight)
                        delegate.didHighlight(highlight)
                        print("highlighted!")
                    }
                }
                draggingHighlight = nil
            }
            setNeedsDisplay()
        }
        guard recognizer.state == .Changed || recognizer.state == .Ended else { return }
        guard let startPoint = startPoint else { return }
        let endPoint = recognizer.locationInView(self)
        guard let startLabel = hitTest(startPoint, withEvent: nil) as? CharacterLabel else { return }
        guard let endLabel = hitTest(endPoint, withEvent: nil) as? CharacterLabel else { return }
        guard startLabel.coordinate.isCardinalToCoordinate(endLabel.coordinate) else { return }
        highlight = Highlight(
            startCoordinate: startLabel.coordinate,
            endCoordinate: endLabel.coordinate,
            startPoint: startLabel.center,
            endPoint: endLabel.center)
    }

    private func coordinateOfLabelAtPoint(point: CGPoint) -> Coordinate? {
        guard let label = hitTest(point, withEvent: nil) as? CharacterLabel else {
            return nil
        }
        return label.coordinate
    }

    // MARK: - Drawing

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        highlightColor.setStroke()
        let path = UIBezierPath()
        path.lineCapStyle = .Round
        path.lineWidth = 30
        for highlight in highlights {
            path.moveToPoint(highlight.startPoint)
            path.addLineToPoint(highlight.endPoint)
        }
        if let highlight = draggingHighlight {
            path.moveToPoint(highlight.startPoint)
            path.addLineToPoint(highlight.endPoint)
        }
        path.stroke()
    }

    // MARK: - Subviews and layout

    /// The two-dimensional array of labels representing the puzzle's character grid.
    private var labelGrid = [[CharacterLabel]]()

    /// Clears and recreates grid labels. Calls `applyConstraints()` if `puzzle` is not nil.
    private func updateGrid() {
        labelGrid.forEach({ row in
            row.forEach({ label in
                label.removeFromSuperview()
            })
        })
        labelGrid.removeAll()

        guard let characterGrid = characterGrid else {
            return
        }

        for (y, characterRow) in characterGrid.enumerate() {
            var labelRow = [CharacterLabel]()
            for (x, character) in characterRow.enumerate() {
                let coordinate = Coordinate(x, y)
                let label = CharacterLabel(character: character, coordinate: coordinate)
                if let font = font {
                    label.font = font
                }
                label.userInteractionEnabled = true
                labelRow.append(label)
            }
            labelGrid.append(labelRow)
        }

        applyConstraints()
    }

    /// Applies constraints to layout grid
    private func applyConstraints() {
        for (i, row) in labelGrid.enumerate() {
            for (j, label) in row.enumerate() {
                addSubview(label)
                if j > 0 {
                    let leftLabel = row[j-1]
                    applyLeftRightConstraintsForLabels(leftLabel, rightLabel: label)
                }
                if i > 0 {
                    let topLabel = labelGrid[i-1][j]
                    applyTopBottomConstraintsForLabels(topLabel, bottomLabel: label)
                }
            }
        }

        if let firstRow = labelGrid.first, firstLabel = firstRow.first {
            applyTopLeftCornerConstraintsForLabel(firstLabel)
        }

        if let lastRow = labelGrid.last, lastLabel = lastRow.last {
            applyBottomRightCornerConstraintsForLabel(lastLabel)
        }
    }

    // MARK: - Constraints

    /// Applies top left corner constraints
    private func applyTopLeftCornerConstraintsForLabel(label: UILabel) {
        addConstraint(NSLayoutConstraint(
            item: label,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: label,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1,
            constant: 0))
    }

    /// Applies bottom right corner constraints
    private func applyBottomRightCornerConstraintsForLabel(label: UILabel) {
        addConstraint(NSLayoutConstraint(
            item: label,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Right,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: label,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0))
    }

    /// Applies left-right constraints between labels
    private func applyLeftRightConstraintsForLabels(leftLabel: UILabel, rightLabel: UILabel) {
        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Width,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Height,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Right,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Top,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: rightLabel,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: leftLabel,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0))
    }

    /// Applies top-bottom constraints between labels
    private func applyTopBottomConstraintsForLabels(topLabel: UILabel, bottomLabel: UILabel) {
        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Width,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Height,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Left,
            multiplier: 1,
            constant: 0))

        addConstraint(NSLayoutConstraint(
            item: bottomLabel,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: topLabel,
            attribute: .Right,
            multiplier: 1,
            constant: 0))
    }
}
