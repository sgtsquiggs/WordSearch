//
//  CollectionType+Extensions.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/11/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

extension CollectionType {
    /// Similar to `filter`, but immediately returns the first result.
    func find(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Generator.Element? {
        return try indexOf(predicate).map({ self[$0] })
    }
}


