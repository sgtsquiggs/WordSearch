//
//  Coordinate.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

struct Coordinate {
	let x: Int16
	let y: Int16

	static func decodeCsv(csv: String) -> [Coordinate]? {
		let strings = csv.componentsSeparatedByString(",")
		if strings.count % 2 != 0 {
			return nil
		}

		let numbers = strings.flatMap({ Int16($0) })
		if strings.count != numbers.count {
			return nil
		}

		var results: [Coordinate] = []
		for var index = 0; index < numbers.count; index+=2 {
			results.append(Coordinate(x: numbers[index], y: numbers[index+1]))
		}
		return results
	}
}

extension Coordinate : Equatable {}
// comparison operator defined in global scope
func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y
}
