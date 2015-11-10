//
//  Puzzle.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

struct Puzzle {
    let sourceLanguage: String
    let targetLanguage: String
    let word: String
    let characterGrid: [[String]]
    let wordLocations: [WordLocation]

    static func decodeJson(json: AnyObject) -> Puzzle? {
        guard let dict = json as? [String:AnyObject] else {
            assertionFailure("json is not a dictionary")
            return nil
        }

        guard let sourceLanguage_field: AnyObject = dict["source_language"] else {
            assertionFailure("field 'source_language' is mising")
            return nil
        }
        guard let sourceLanguage: String = String.decodeJson(sourceLanguage_field) else {
            assertionFailure("field 'source_language' is not a String")
            return nil
        }

        guard let targetLanguage_field: AnyObject = dict["target_language"] else {
            assertionFailure("field 'target_language' is mising")
            return nil
        }
        guard let targetLanguage: String = String.decodeJson(targetLanguage_field) else {
            assertionFailure("field 'target_language' is not a String")
            return nil
        }

        guard let word_field: AnyObject = dict["word"] else {
            assertionFailure("field 'word_field' is mising")
            return nil
        }
        guard let word: String = String.decodeJson(word_field) else {
            assertionFailure("field 'word_field' is not a String")
            return nil
        }

        guard let characterGrid_field: AnyObject = dict["character_grid"] else {
            assertionFailure("field 'character_grid' is missing")
            return nil
        }
        guard let characterGrid: [[String]] = Array.decodeJson({ Array.decodeJson({ String.decodeJson($0) }, $0) }, characterGrid_field) else {
            assertionFailure("field 'character_grid' is not a [[String]]")
            return nil
        }

        guard let wordLocations_field: AnyObject = dict["word_locations"] else {
            assertionFailure("field 'word_locations' is missing")
            return nil
        }
        guard let wordLocations: [WordLocation] = WordLocation.decodeJson(wordLocations_field) else {
            assertionFailure("field word_locations is not word locations")
            return nil
        }
        
        return Puzzle(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, word: word, characterGrid: characterGrid, wordLocations: wordLocations)
    }
}
