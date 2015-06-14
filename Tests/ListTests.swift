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
		
		l.insertAtFront(1)
		l.insertAtFront(2)
		l.insertAtFront(3)
		
		XCTAssert(3 == l.count, "Count incorrect, got \(l.count).")
		
		XCTAssert(3 == l.front, "Front incorrect, got \(l.front)")
		XCTAssert(1 == l.back, "Back incorrect, got \(l.back)")
		
		l.insertAtBack(5)
		l.insertAtBack(6)
		l.insertAtBack(7)
		
		l.cursorToFront()
		while !l.cursorAtEnd {
			l.next
		}

		l.cursorToBack()
		while !l.cursorAtEnd {
			l.previous
		}

		XCTAssert(6 == l.count, "Count incorrect, got \(l.count).")
		
		XCTAssert(3 == l.front, "Front incorrect, got \(l.front)")
		XCTAssert(7 == l.back, "Back incorrect, got \(l.back)")

		l.cursorToFront()
		XCTAssert(3 == l.front && l.front == l.cursor, "Current incorrect, got \(l.cursor)")
		XCTAssert(2 == l.next, "Next incorrect, got \(l.cursor)")
		XCTAssert(1 == l.next, "Next incorrect, got \(l.cursor)")
		XCTAssert(5 == l.next, "Next incorrect, got \(l.cursor)")
		XCTAssert(6 == l.next, "Next incorrect, got \(l.cursor)")
		XCTAssert(7 == l.next, "Next incorrect, got \(l.cursor)")

		l.cursorToBack()
		XCTAssert(7 == l.back && l.back == l.cursor, "Current incorrect, got \(l.cursor)")
		XCTAssert(6 == l.previous, "Previous incorrect, got \(l.cursor)")
		XCTAssert(5 == l.previous, "Previous incorrect, got \(l.cursor)")
		XCTAssert(1 == l.previous, "Previous incorrect, got \(l.cursor)")
		XCTAssert(2 == l.previous, "Previous incorrect, got \(l.cursor)")
		XCTAssert(3 == l.previous, "Previous incorrect, got \(l.cursor)")

		l.cursorToFront()
		XCTAssert(3 == l.removeAtFront() && 5 == l.count, "RemoveAtFront incorrect")
		XCTAssert(2 == l.removeAtFront() && 4 == l.count, "RemoveAtFront incorrect")
		XCTAssert(1 == l.removeAtFront() && 3 == l.count, "RemoveAtFront incorrect")
		
		l.cursorToBack()
		XCTAssert(7 == l.removeAtBack() && 2 == l.count, "RemoveAtBack incorrect")
		XCTAssert(6 == l.removeAtBack() && 1 == l.count, "RemoveAtBack incorrect")
		XCTAssert(5 == l.removeAtBack() && 0 == l.count, "RemoveAtBack incorrect")
		
		l.cursorToFront()
		l.insertBeforeCursor(1)
		XCTAssert(1 == l.front && 1 == l.count && nil == l.cursor, "Cursor failed, got Front \(l.front) Cursor \(l.cursor)")
		l.cursorToFront()
		XCTAssert(l.cursor == l.removeAtFront() && 0 == l.count, "Cursor failed, got \(l.cursor)")
		
		l.cursorToFront()
		l.insertAfterCursor(1)
		XCTAssert(1 == l.front && 1 == l.count && nil == l.cursor, "Cursor failed, got Front \(l.front) Cursor \(l.cursor)")
		l.cursorToFront()
		XCTAssert(l.cursor == l.removeAtFront() && 0 == l.count, "Cursor failed, got \(l.cursor)")
		
		l.cursorToBack()
		l.insertBeforeCursor(1)
		XCTAssert(1 == l.back && 1 == l.count && nil == l.cursor, "Cursor failed, got Front \(l.front) Cursor \(l.cursor)")
		l.cursorToBack()
		XCTAssert(l.cursor == l.removeAtBack() && 0 == l.count, "Cursor failed, got \(l.cursor)")
		
		l.cursorToBack()
		l.insertAfterCursor(1)
		XCTAssert(1 == l.back && 1 == l.count && nil == l.cursor, "Cursor failed, got Front \(l.front) Cursor \(l.cursor)")
		l.cursorToBack()
		XCTAssert(l.cursor == l.removeAtBack() && 0 == l.count, "Cursor failed, got \(l.cursor)")
		
		l.clear()
		XCTAssert(l.front == l.back && 0 == l.count, "Cursor failed, got Front \(l.front) Back \(l.back)")
		
		l.cursorToFront()
		l.insertBeforeCursor(1)
		XCTAssert(1 == l.front && nil == l.cursor && 1 == l.count, "Cursor failed, got Front \(l.front) Cursor \(l.cursor)")
		
		l.insertAfterCursor(2)
		XCTAssert(2 == l.back && nil == l.cursor && 2 == l.count, "Cursor failed, got Back \(l.back) Cursor \(l.cursor)")

		l.insertAfterCursor(3)
		XCTAssert(3 == l.back && nil == l.cursor && 3 == l.count, "Cursor failed, got Back \(l.back) Cursor \(l.cursor)")

		l.insertBeforeCursor(4)
		XCTAssert(4 == l.front && nil == l.cursor && 4 == l.count, "Cursor failed, got Front \(l.front) Cursor \(l.cursor)")

		l.cursorToFront()
		XCTAssert(1 == l.next && 1 == l.cursor && 4 == l.count, "Cursor failed, got Cursor \(l.cursor)")
		
		l.insertBeforeCursor(5)
//		XCTAssert(1 == l.cursor && 5 == l.previous && 5 == l.cursor && 5 == l.count, "Cursor failed, got Cursor \(l.cursor)")
//
//		l.insertAfterCursor(3)
//		XCTAssert(5 == l.cursor && 6 == l.count && 4 == l.front, "After cursor incorrect, got Front \(l.front) Cursor \(l.cursor)")
		
		
		println("Front", l, l.count)
		l.cursorToFront()
		while !l.cursorAtEnd {
			println(l.cursor)
			l.next
		}
		
		
		println("Back", l, l.count)
		l.cursorToBack()
		while !l.cursorAtEnd {
			println(l.cursor)
			l.previous
		}
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
