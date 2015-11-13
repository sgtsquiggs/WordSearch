//
//  Request.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/8/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

let PuzzleURLString = "https://s3.amazonaws.com/duolingo-data/s3/js2/find_challenges.txt"

typealias PuzzleResult = Result<[Puzzle], NetworkError>

class Network {
    /// Request puzzles
    static func requestPuzzles(completionHandler: (result: PuzzleResult) -> Void) {
        Just.get(PuzzleURLString) { (r) in
            var result: PuzzleResult
            var puzzles: [Puzzle]?
            var error: NSError?
            // Defered results are much cleaner when you have many possible exit points
            defer {
                if let puzzles = puzzles {
                    completionHandler(result: Result(value: puzzles))
                } else if let error = error {
                    completionHandler(result: Result(error: NetworkError(error.localizedDescription)))
                } else {
                    completionHandler(result: Result(error: NetworkError("Unable to load puzzles")))
                }
            }
            // Check for error
            guard r.ok else {
                error = r.error
                assertionFailure("http request returned error")
                return
            }
            // Decode lsj (line separated json)
            if let text = r.text {
                let lines = text.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                puzzles = []
                for line in lines {
                    if let json = decodeJsonString(line), puzzle = Puzzle.decodeJson(json) {
                        puzzles!.append(puzzle)
                    }
                }
            }
        }
    }

    /// Decodes `AnyObject` from json string.
    static func decodeJsonString(json: String) -> AnyObject? {
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)!
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json
        } catch {
            return nil
        }
    }
}

struct NetworkError: ErrorType {
    let message: String
    let error: NSError?

    init(_ message: String) {
        self.message = message
        self.error = nil
    }

    init(_ message: String, error: NSError?) {
        self.message = message
        self.error = error
    }
}
