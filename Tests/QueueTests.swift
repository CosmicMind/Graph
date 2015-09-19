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

class QueueTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let q: Queue<Int> = Queue<Int>()
		
		q.enqueue(1)
		q.enqueue(2)
		q.enqueue(3)
		
		XCTAssert(3 == q.count, "Count incorrect, got \(q.count).")
		XCTAssert(1 == q.peek, "Peek incorrect, got \(q.peek)")
		
		q.enqueue(5)
		q.enqueue(6)
		q.enqueue(7)
		
		XCTAssert(6 == q.count, "Count incorrect, got \(q.count).")
		XCTAssert(1 == q.peek, "Peek incorrect, got \(q.peek)")
		
		XCTAssert(1 == q.dequeue() && 5 == q.count && 2 == q.peek, "Dequeue incorrect")
		XCTAssert(2 == q.dequeue() && 4 == q.count && 3 == q.peek, "Dequeue incorrect")
		XCTAssert(3 == q.dequeue() && 3 == q.count && 5 == q.peek, "Dequeue incorrect")
		XCTAssert(5 == q.dequeue() && 2 == q.count && 6 == q.peek, "Dequeue incorrect")
		XCTAssert(6 == q.dequeue() && 1 == q.count && 7 == q.peek, "Dequeue incorrect")
		XCTAssert(7 == q.dequeue() && 0 == q.count && nil == q.peek, "Dequeue incorrect")
		
		q.enqueue(1)
		q.enqueue(2)
		q.enqueue(3)
		q.removeAll()
		
		XCTAssert(0 == q.count, "Count incorrect, got \(q.count).")
		
		q.enqueue(1)
		q.enqueue(2)
		q.enqueue(3)
	}
	
	func testConcat() {
		let q1: Queue<Int> = Queue<Int>()
		q1.enqueue(1)
		q1.enqueue(2)
		q1.enqueue(3)
		
		let q2: Queue<Int> = Queue<Int>()
		q2.enqueue(4)
		q2.enqueue(5)
		q2.enqueue(6)
		
		let q3: Queue<Int> = q1 + q2
		
		for x in q1 {
			XCTAssert(x == q3.dequeue(), "Concat incorrect.")
		}
		
		for x in q2 {
			XCTAssert(x == q3.dequeue(), "Concat incorrect.")
		}
		
		q3.removeAll()
		let q4: Queue<Int> = q1 + q2 + q3
		for x in q4 {
			XCTAssert(x == q4.dequeue(), "Concat incorrect.")
		}
	}

	func testPerformance() {
		self.measureBlock() {}
	}
}
