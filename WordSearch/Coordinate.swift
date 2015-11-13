//
//  Coordinate.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

struct Coordinate {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    /// Decode array of coordinates from csv format "x1,y1,x2,y2,x3,y3,x4,y4".
    static func decodeCsv(csv: String) -> [Coordinate]? {
        let strings = csv.componentsSeparatedByString(",")
        if strings.count % 2 != 0 {
            return nil
        }

        let numbers = strings.flatMap({ Int($0) })
        if strings.count != numbers.count {
            return nil
        }

        var results: [Coordinate] = []
        for var index = 0; index < numbers.count; index+=2 {
            results.append(Coordinate(numbers[index], numbers[index+1]))
        }
        return results
    }

    func isCardinalToCoordinate(coordinate: Coordinate) -> Bool {
        let deltaX = self.x - coordinate.x
        let deltaY = self.y - coordinate.y
        let radians = atan2(Double(deltaX), Double(deltaY))
        let degrees = abs(radians * (180.0 / M_PI)) % 90
        guard degrees == 0 || degrees == 45 else {
            return false
        }
        return true
    }
}

// MARK: - Equatable

extension Coordinate : Equatable {}
// comparison operator defined in global scope
func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
