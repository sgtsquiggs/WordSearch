//
//  NavigationController.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/13/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Portrait
        } else {
            return .All
        }
    }
}
