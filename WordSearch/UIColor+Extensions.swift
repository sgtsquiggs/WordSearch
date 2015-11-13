//
//  UIColor+Extensions.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/13/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        let hue = CGFloat(drand48())
        let saturation = CGFloat(drand48() + 0.5)
        let brightness = CGFloat(drand48() + 0.5)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
