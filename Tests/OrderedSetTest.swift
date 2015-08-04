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
import GraphKit

class OrderedSetTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let s: OrderedSet<Int> = OrderedSet<Int>()
		
		XCTAssert(0 == s.count, "Test failed, got \(s.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			s.insert(1)
			s.insert(2)
			s.insert(3)
		}
		
		XCTAssert(3 == s.count, "Test failed.\(s)")
		XCTAssert(1 == s[0], "Test failed.")
		XCTAssert(2 == s[1], "Test failed.")
		XCTAssert(3 == s[2], "Test failed.")
		
		for (var i: Int = 500; i > 0; --i) {
			s.remove(1)
			s.remove(3)
		}
		
		XCTAssert(1 == s.count, "Test failed.")
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
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 22, 23, 1, 2, 3, 4, 5)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 22, 23, 5, 6, 7, 8, 9, 10)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 22, 23, 10, 11, 12, 13, 14, 15)
		let s4: OrderedSet<Int> = OrderedSet<Int>(members: 22, 23)
		
		XCTAssert(s4 == s1.intersect(s2, s3), "Test failed.")
	}
	
	func testIntersectInPlace() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 22, 23, 1, 2, 3, 4, 5)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 22, 23, 5, 6, 7, 8, 9, 10)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 22, 23, 10, 11, 12, 13, 14, 15)
		let s4: OrderedSet<Int> = OrderedSet<Int>(members: 22, 23)
		
		s1.intersectInPlace(s2, s3)
		XCTAssert(s4 == s1, "Test failed.")
	}
	
	func testIsDisjointWith() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 3, 4, 5)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 5, 6, 7)
		
		XCTAssertFalse(s1.isDisjointWith(s2), "Test failed.")
		XCTAssert(s1.isDisjointWith(s3), "Test failed.")
		XCTAssertFalse(s2.isDisjointWith(s3), "Test failed.")
	}
	
	func testSubtract() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5, 7, 8, 9 , 10)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 4, 5, 6, 7)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 7, 8, 9)
		let s4: OrderedSet<Int> = s1.subtract(s2, s3)
		
		XCTAssertFalse(s1.isDisjointWith(s4), "Test failed.")
	}
	
	func testSubtractInPlace() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5, 7, 8, 9 , 10)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 4, 5, 6, 7)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 7, 8, 9)
		let s4: OrderedSet<Int> = s1.subtract(s2, s3)
		
		s1.subtractInPlace(s2, s3)
		XCTAssert(s4 == s1, "Test failed.")
	}
	
	func testUnion() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 5, 6, 7, 8, 9)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5, 6, 7, 8, 9)
		
		XCTAssert(s3 == s1.union(s2), "Test failed.")
	}
	
	func testUnionInPlace() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 5, 6, 7, 8, 9)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5, 6, 7, 8, 9)
		
		s1.unionInPlace(s2)
		XCTAssert(s3 == s1, "Test failed.")
	}
	
	func testIsSubsetOf() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 2, 3, 4, 5)
		
		XCTAssert(s1 <= s1, "Test failed.")
		XCTAssert(s1 <= s2, "Test failed.")
		XCTAssertFalse(s1 <= s3, "Test failed.")
	}
	
	func testIsSupersetOf() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5, 6, 7)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 5, 6, 7, 8)
		
		XCTAssert(s1 >= s1, "Test failed.")
		XCTAssert(s1 >= s2, "Test failed.")
		XCTAssertFalse(s1 >= s3, "Test failed.")
	}
	
	func testIsStrictSubsetOf() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 2, 3, 4, 5)
		
		XCTAssert(s1 < s2, "Test failed.")
		XCTAssertFalse(s1 < s3, "Test failed.")
	}
	
	func testIsStrictSupersetOf() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5, 6, 7)
		let s2: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5)
		let s3: OrderedSet<Int> = OrderedSet<Int>(members: 5, 6, 7, 8)
		
		XCTAssert(s1 > s2, "Test failed.")
		XCTAssertFalse(s1 > s3, "Test failed.")
	}
	
	func testContains() {
		let s1: OrderedSet<Int> = OrderedSet<Int>(members: 1, 2, 3, 4, 5, 6, 7)
		XCTAssert(s1.contains(1, 2, 3), "Test failed.")
		XCTAssertFalse(s1.contains(1, 2, 3, 10), "Test failed.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
