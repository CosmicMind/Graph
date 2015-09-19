//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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

class DequeTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let d: Deque<Int> = Deque<Int>()
		
		d.insertAtFront(1)
		d.insertAtFront(2)
		d.insertAtFront(3)
		
		XCTAssert(3 == d.count, "Count incorrect, got \(d.count).")
		
		XCTAssert(3 == d.front, "Front incorrect, got \(d.front)")
		XCTAssert(1 == d.back, "Back incorrect, got \(d.back)")
		
		d.insertAtBack(5)
		d.insertAtBack(6)
		d.insertAtBack(7)
		
		XCTAssert(6 == d.count, "Count incorrect, got \(d.count).")
		
		XCTAssert(3 == d.front, "Front incorrect, got \(d.front)")
		XCTAssert(7 == d.back, "Back incorrect, got \(d.back)")
		
		XCTAssert(3 == d.removeAtFront() && 5 == d.count && 2 == d.front, "RemoveAtFront incorrect")
		XCTAssert(2 == d.removeAtFront() && 4 == d.count && 1 == d.front, "RemoveAtFront incorrect")
		XCTAssert(1 == d.removeAtFront() && 3 == d.count && 5 == d.front, "RemoveAtFront incorrect")
		
		XCTAssert(7 == d.removeAtBack() && 2 == d.count && 6 == d.back, "RemoveAtBack incorrect")
		XCTAssert(6 == d.removeAtBack() && 1 == d.count && 5 == d.back, "RemoveAtBack incorrect")
		XCTAssert(5 == d.removeAtBack() && 0 == d.count && nil == d.back, "RemoveAtBack incorrect")
		
		d.insertAtFront(1)
		d.insertAtFront(2)
		d.insertAtFront(3)
		d.removeAll()
		
		XCTAssert(0 == d.count, "Count incorrect, got \(d.count).")
	}
	
	func testConcat() {
		let d1: Deque<Int> = Deque<Int>()
		d1.insertAtBack(1)
		d1.insertAtBack(2)
		d1.insertAtBack(3)
		
		let d2: Deque<Int> = Deque<Int>()
		d2.insertAtBack(4)
		d2.insertAtBack(5)
		d2.insertAtBack(6)
		
		let d3: Deque<Int> = d1 + d2
		
		for x in d1 {
			XCTAssert(x == d3.removeAtFront(), "Concat incorrect.")
		}
		
		for x in d2 {
			XCTAssert(x == d3.removeAtFront(), "Concat incorrect.")
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
