/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributorq.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more detailq.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import XCTest
import GraphKit

class QueueTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the clasq.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the clasq.
		super.tearDown()
	}
	
	func testListInt() {
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
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
