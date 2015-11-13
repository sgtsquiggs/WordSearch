//
//  Puzzle.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

/// ASSUMPTION: `character_grid` will always be a square 2d array

struct Puzzle {
    let sourceLanguage: String
    let targetLanguage: String
    let word: String
    let characterGrid: [[String]]
    let wordLocations: [WordLocation]
    let rows: Int
    let columns: Int
}

// MARK: - JsonGen
// Based on swift-json-gen, the only sane was I found to load json into an immutable struct
// https://github.com/tomlokhorst/swift-json-gen

extension Puzzle {
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

        let rows = characterGrid.count
        let columns = characterGrid.first!.count
        
        return Puzzle(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, word: word, characterGrid: characterGrid, wordLocations: wordLocations, rows: rows, columns: columns)
    }
}
