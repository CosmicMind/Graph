//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import XCTest
@testable import GraphKit

class StackTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let s: Stack<Int> = Stack<Int>()
		
		s.push(1)
		s.push(2)
		s.push(3)
		
		XCTAssert(3 == s.count, "Count incorrect, got \(s.count).")
		XCTAssert(3 == s.top, "Top incorrect, got \(s.top)")
		
		s.push(5)
		s.push(6)
		s.push(7)
		
		XCTAssert(6 == s.count, "Count incorrect, got \(s.count).")
		XCTAssert(7 == s.top, "Top incorrect, got \(s.top)")
		
		XCTAssert(7 == s.pop() && 5 == s.count && 6 == s.top, "Pop incorrect")
		XCTAssert(6 == s.pop() && 4 == s.count && 5 == s.top, "Pop incorrect")
		XCTAssert(5 == s.pop() && 3 == s.count && 3 == s.top, "Pop incorrect")
		XCTAssert(3 == s.pop() && 2 == s.count && 2 == s.top, "Pop incorrect")
		XCTAssert(2 == s.pop() && 1 == s.count && 1 == s.top, "Pop incorrect")
		XCTAssert(1 == s.pop() && 0 == s.count && nil == s.top, "Pop incorrect")
		
		s.push(1)
		s.push(2)
		s.push(3)
		s.removeAll()
		
		XCTAssert(0 == s.count, "Count incorrect, got \(s.count).")
	}
	
	func testConcat() {
		let s1: Stack<Int> = Stack<Int>()
		s1.push(1)
		s1.push(2)
		s1.push(3)
		
		let s2: Stack<Int> = Stack<Int>()
		s2.push(4)
		s2.push(5)
		s2.push(6)
		
		let s3: Stack<Int> = s1 + s2
		XCTAssert(6 == s3.count, "Concat incorrect.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
