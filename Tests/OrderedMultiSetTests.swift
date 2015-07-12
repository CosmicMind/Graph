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

class OrderedMultiSetTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testInt() {
		let s: OrderedMultiSet<Int> = OrderedMultiSet<Int>()
		
		XCTAssert(0 == s.count, "Test failed, got \(s.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			s.insert(1)
			s.insert(2)
			s.insert(3)
		}
		
		XCTAssert(3000 == s.count, "Test failed.\(s)")
		XCTAssert(1 == s[0], "Test failed.")
		XCTAssert(2 == s[1000], "Test failed.")
		XCTAssert(3 == s[2000], "Test failed.")
		
		for (var i: Int = 500; i > 0; --i) {
			s.remove(1)
			s.remove(3)
		}
		
		XCTAssert(1000 == s.count, "Test failed.")
		s.remove(2)
		s.remove(2)
		s.insert(10)
		XCTAssert(1 == s.count, "Test failed.")
		
		s.remove(10)
		XCTAssert(0 == s.count, "Test failed.")
		
		s.insert(1)
		s.insert(2)
		s.insert(3)
		
		s.remove(1, 2)
		XCTAssert(1 == s.count, "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testIntersect() {
		let s1: OrderedMultiSet<Int> = OrderedMultiSet<Int>()
		s1.insert(22, 23, 1, 2, 3, 4, 5)
		
		let s2: OrderedMultiSet<Int> = OrderedMultiSet<Int>()
		s2.insert(22, 23, 5, 6, 7, 8, 9, 10)
		
		let s3: OrderedMultiSet<Int> = OrderedMultiSet<Int>()
		s3.insert(22, 23, 10, 11, 12, 13, 14, 15)
		
		let s4: OrderedMultiSet<Int> = OrderedMultiSet<Int>()
		s4.insert(22, 23)
		
		XCTAssert(s4 == s1.intersect(s2, s3), "Test failed.")
	}
	
	func testIntersectInPlace() {
		let s1: OrderedMultiSet<Int> = OrderedMultiSet<Int>()
		s1.insert(22, 23, 1, 2, 3, 4, 5)
		
		let s2: OrderedMultiSet<Int> = OrderedMultiSet<Int>()
		s2.insert(22, 23, 5, 6, 7, 8, 9, 10)
		
		let s3: OrderedMultiSet<Int> = OrderedMultiSet<Int>()
		s3.insert(22, 23, 10, 11, 12, 13, 14, 15)
		
		let s4: OrderedMultiSet<Int> = OrderedMultiSet<Int>()
		s4.insert(22, 23)
		
		s1.intersectInPlace(s2, s3)
		XCTAssert(s4 == s1, "Test failed.")
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
