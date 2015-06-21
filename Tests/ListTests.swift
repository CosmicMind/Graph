/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import XCTest
import GraphKit

class ListTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testInt() {
		let l: List<Int> = List<Int>()
		
		l.insertFront(1)
		l.insertFront(2)
		l.insertFront(3)
		
		XCTAssert(3 == l.count, "Count incorrect, got \(l.count).")
		
		XCTAssert(3 == l.front, "Front incorrect, got \(l.front)")
		XCTAssert(1 == l.back, "Back incorrect, got \(l.back)")
		
		l.insertBack(5)
		l.insertBack(6)
		l.insertBack(7)
		
		l.cursorToFront()
		while !l.cursorBack {
			l.next
		}

		l.cursorToBack()
		while !l.cursorFront {
			l.previous
		}

		XCTAssert(6 == l.count, "Count incorrect, got \(l.count).")
		
		XCTAssert(3 == l.front, "Front incorrect, got \(l.front)")
		XCTAssert(7 == l.back, "Back incorrect, got \(l.back)")

		l.cursorToFront()
		XCTAssert(3 == l.front && l.front == l.cursor, "Current incorrect, got \(l.cursor)")
		XCTAssert(2 == l.next, "Test failed, got \(l.cursor)")
		XCTAssert(1 == l.next, "Test failed, got \(l.cursor)")
		XCTAssert(5 == l.next, "Test failed, got \(l.cursor)")
		XCTAssert(6 == l.next, "Test failed, got \(l.cursor)")
		XCTAssert(7 == l.next, "Test failed, got \(l.cursor)")

		l.cursorToBack()
		XCTAssert(7 == l.back && l.back == l.cursor, "Current incorrect, got \(l.cursor)")
		XCTAssert(6 == l.previous, "Test failed, got \(l.cursor)")
		XCTAssert(5 == l.previous, "Test failed, got \(l.cursor)")
		XCTAssert(1 == l.previous, "Test failed, got \(l.cursor)")
		XCTAssert(2 == l.previous, "Test failed, got \(l.cursor)")
		XCTAssert(3 == l.previous, "Test failed, got \(l.cursor)")

		l.cursorToFront()
		XCTAssert(3 == l.removeFront() && 5 == l.count, "Test failed.")
		XCTAssert(2 == l.removeFront() && 4 == l.count, "Test failed.")
		XCTAssert(1 == l.removeFront() && 3 == l.count, "Test failed.")
		
		l.cursorToBack()
		XCTAssert(7 == l.removeBack() && 2 == l.count, "Test failed.")
		XCTAssert(6 == l.removeBack() && 1 == l.count, "Test failed.")
		XCTAssert(5 == l.removeBack() && 0 == l.count, "Test failed.")
		
		l.removeAll()
		l.cursorToFront()
		XCTAssert(nil == l.cursor && 0 == l.count, "Test failed, got \(l.cursor)")
		l.insertBeforeCursor(1)
		XCTAssert(1 == l.cursor && 1 == l.count, "Test failed, got \(l.cursor)")
		
		l.removeAll()
		l.cursorToBack()
		XCTAssert(nil == l.cursor && 0 == l.count, "Test failed, got \(l.cursor)")
		l.insertAfterCursor(1)
		XCTAssert(1 == l.cursor && 1 == l.count, "Test failed, got \(l.cursor)")
		
		l.removeAll()
		l.insertBack(1)
		XCTAssert(1 == l.cursor && 1 == l.count, "Test failed, got \(l.cursor)")
		l.insertAfterCursor(2)
		l.insertAfterCursor(6)
		l.next
		XCTAssert(6 == l.cursor && 3 == l.count, "Test failed, got \(l.cursor)")
		l.insertBeforeCursor(3)
		l.insertBeforeCursor(5)
		l.previous
		XCTAssert(5 == l.cursor && 5 == l.count, "Test failed, got \(l.cursor)")
		l.insertBack(4)
		l.previous
		l.removeCursor()
		XCTAssert(5 == l.cursor && 5 == l.count, "Test failed, got \(l.cursor)")
		l.removeCursor()
		XCTAssert(6 == l.cursor && 4 == l.count, "Test failed, got \(l.cursor)")
		l.removeCursor()
		XCTAssert(2 == l.cursor && 3 == l.count, "Test failed, got \(l.cursor)")
		l.removeCursor()
		XCTAssert(1 == l.previous && 2 == l.count, "Test failed, got \(l.cursor)")
		l.removeCursor()
		XCTAssert(l.front == l.cursor && l.back == l.cursor && 1 == l.count, "Test failed, got \(l.cursor)")
		l.removeCursor()
		XCTAssert(nil == l.cursor && 0 == l.count, "Test failed, got \(l.cursor)")
		
		l.insertFront(1)
		l.insertBack(2)
		l.insertFront(3)
		
		for x in l {
			println(x)
		}
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
