//
//  Request.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/8/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

class Network {

    static let PuzzleURLString = "https://s3.amazonaws.com/duolingo-data/s3/js2/find_challenges.txt"

    /// Request puzzles
    class func requestPuzzles(completionHandler: (puzzles: [Puzzle]?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string:PuzzleURLString)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            var puzzles: [Puzzle]?
            defer {
                if let puzzles = puzzles {
                    completionHandler(puzzles: puzzles, error: nil)
                } else if let error = error {
                    completionHandler(puzzles: nil, error: error)
                } else {
                    let error = NSError(
                        domain: "com.matthewcrenshaw.WordSearch.network",
                        code: 100,
                        userInfo: [NSLocalizedDescriptionKey: "Unable to load puzzles"])
                    completionHandler(puzzles: nil, error: error)
                }
            }
            guard error == nil else {
                assertionFailure("http request returned error")
                return
            }
            // Decode lsj (line separated json)
            if let data = data, text = NSString(data: data, encoding: NSUTF8StringEncoding) {
                let lines = text.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                puzzles = []
                for line in lines {
                    if let json = decodeJsonString(line), puzzle = Puzzle.decodeJson(json) {
                        puzzles!.append(puzzle)
                    }
                }
            }
        }
        task.resume()
    }

    /// Decodes `AnyObject` from json string.
    private class func decodeJsonString(json: String) -> AnyObject? {
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)!
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json
        } catch {
            return nil
        }
    }
}
