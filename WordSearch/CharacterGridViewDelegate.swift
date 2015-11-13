//
//  CharacterGridViewDelegate.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/13/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

// This can't be represented in objc because Highlight is a struct maybe. Can't make this IB-friendly.
protocol CharacterGridViewDelegate {
    func shouldHighlight(highlight: Highlight) -> Bool
    func didHighlight(highlight: Highlight)
}
