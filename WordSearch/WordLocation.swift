//
//  WordLocation.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

struct WordLocation {
    let word: String
    let coordinates: [Coordinate]

    /// Decodes `WordLocation` from json.
    static func decodeJson(json: AnyObject) -> [WordLocation]? {
        guard let dict: [String:String] = Dictionary.decodeJson({ String.decodeJson($0) }, { String.decodeJson($0) }, json) else {
            assertionFailure("json is not a [String:String]")
            return nil
        }

        var result: [WordLocation] = []
        for (key, value) in dict {
            guard let coordinates: [Coordinate] = Coordinate.decodeCsv(key) else {
                assertionFailure("coordinates not valid")
                return nil
            }
            result.append(WordLocation(word: value, coordinates: coordinates))
        }
        return result
    }
}

// MARK: - Equatable

extension WordLocation : Equatable {}
// comparison operator defined in global scope
func ==(lhs: WordLocation, rhs: WordLocation) -> Bool {
    return lhs.word == rhs.word && lhs.coordinates == rhs.coordinates
}

// MARK: - Hashable

extension WordLocation : Hashable {
    var hashValue: Int {
        // Shortcut. Using the word's hash because we shouldn't ever have the same word twice in a puzzle
        return word.hashValue
    }
}
