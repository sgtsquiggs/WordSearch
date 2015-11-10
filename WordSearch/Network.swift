//
//  Request.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/8/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

let PuzzleURLString = "https://s3.amazonaws.com/duolingo-data/s3/js2/find_challenges.txt"

typealias PuzzleResult = Result<[Puzzle], NSError>

class Network {
    static func getPuzzles(completion: (result: PuzzleResult) -> Void) {
        Just.get(PuzzleURLString) { (r) in
            if r.ok {
                if let text = r.text {

                    let lines = text.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                    var puzzles: [Puzzle] = []
                    for line in lines {
                        if let json = decodeJson(line), puzzle = Puzzle.decodeJson(json) {
                            puzzles.append(puzzle)
                        }
                    }
                    completion(result: Result(value: puzzles))
                } else {
                    completion(result: Result(error: NSError(domain: "", code: 0, userInfo: nil)))
                }
            } else if let error = r.error {
                completion(result: Result(error: error))
            } else {
                completion(result: Result(error: NSError(domain: "", code: 0, userInfo: nil)))
            }
        }
    }

    static func decodeJson(json: String) -> AnyObject? {
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)!
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json
        } catch {
            return nil
        }
    }
}
