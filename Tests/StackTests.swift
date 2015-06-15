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

class StackTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
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
		s.clear()
		
		XCTAssert(0 == s.count, "Count incorrect, got \(s.count).")
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
