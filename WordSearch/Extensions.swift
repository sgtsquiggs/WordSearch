//
//  Extensions.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/11/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

extension CollectionType {
    /// Similar to `filter`, but immediately returns the first result.
    func find(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Generator.Element? {
        return try indexOf(predicate).map({ self[$0] })
    }
}

extension UIColor {
    static func random() -> UIColor {
        let hue = CGFloat(drand48())
        let saturation = CGFloat(drand48() + 0.5)
        let brightness = CGFloat(drand48() + 0.5)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
