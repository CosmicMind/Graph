/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of GraphKit nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import XCTest
@testable import GraphKit

class SortedMultiSetTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let s: SortedMultiSet<Int> = SortedMultiSet<Int>()
		
		XCTAssert(0 == s.count, "Test failed, got \(s.count).")
		
		for var i: Int = 1000; i > 0; --i {
			s.insert(1)
			s.insert(2)
			s.insert(3)
		}
		
		XCTAssert(3000 == s.count, "Test failed.\(s)")
		XCTAssert(1 == s[0], "Test failed.")
		XCTAssert(2 == s[1000], "Test failed.")
		XCTAssert(3 == s[2000], "Test failed.")
		
		for var i: Int = 500; i > 0; --i {
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
	
	func testRemove() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 3, 4, 5, 5, 6, 7, 8, 9)
		s1.remove(1, 2, 3, 5)
		XCTAssert(5 == s1.count, "Test failed.")
	}
	
	func testIntersect() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 1, 2, 3, 4, 5, 5)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 1, 2, 5, 6, 7, 8, 9, 10)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 1, 2, 5, 5, 10, 11, 12, 13, 14, 15)
		
		XCTAssert(SortedMultiSet<Int>(elements: 1, 1, 2, 5) == s1.intersect(s2), "Test failed. \(s1.intersect(s2))")
		XCTAssert(SortedMultiSet<Int>(elements: 1, 1, 2, 5, 5) == s1.intersect(s3), "Test failed. \(s1.intersect(s3))")
	}
	
	func testIntersectInPlace() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 1, 2, 3, 4, 5)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 1, 2, 5, 6, 7, 8, 9, 10)
		
		s1.intersectInPlace(s2)
		XCTAssert(SortedMultiSet<Int>(elements: 1, 1, 2, 5) == s1, "Test failed. \(s1)")
		
		s1.insert(3, 4, 5, 5, 5)
		s2.insert(5)
		
		s1.intersectInPlace(s2)
		XCTAssert(SortedMultiSet<Int>(elements: 1, 1, 2, 5, 5) == s1, "Test failed. \(s1)")
	}
	
	func testIsDisjointWith() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 3, 4, 5)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 5, 6, 7)
		
		XCTAssertFalse(s1.isDisjointWith(s2), "Test failed.")
		XCTAssert(s1.isDisjointWith(s3), "Test failed.")
		XCTAssertFalse(s2.isDisjointWith(s3), "Test failed.")
	}
	
	func testSubtract() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 3, 3, 4, 5)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 4, 5, -1)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 3, 5, 0, -7)
		
		XCTAssert(SortedMultiSet<Int>(elements: 1, 2, 3, 3, 3) == s1.subtract(s2), "Test failed. \(s1.subtract(s2))")
		XCTAssert(SortedMultiSet<Int>(elements: 1, 2, 3, 3, 4) == s1.subtract(s3), "Test failed. \(s1.subtract(s3))")
	}
	
	func testSubtractInPlace() {
		var s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 3, 3, 4, 5)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 4, 5, -1)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 3, 5, 0, -7)
		
		s1.subtractInPlace(s2)
		XCTAssert(SortedMultiSet<Int>(elements: 1, 2, 3, 3, 3) == s1, "Test failed. \(s1)")
		s1 = SortedMultiSet<Int>(elements: 1, 2, 3, 3, 3, 4, 5)
		s1.subtractInPlace(s3)
		XCTAssert(SortedMultiSet<Int>(elements: 1, 2, 3, 3, 4) == s1, "Test failed. \(s1)")
	}
	
	func testUnion() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 0, 0, 1, 2, 3, 4, 7, 7, 5)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 5, -1, 6, 8, 7, 9, 9)

		XCTAssert(SortedMultiSet<Int>(elements: -1, 0, 0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 9) == s1.union(s2), "Test failed. \(s1.union(s2))")
	}
	
	func testUnionInPlace() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 0, 0, 1, 2, 3, 4, 7, 7, 5)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 5, -1, 0, 6, 8, 7, 9, 9)
		
		s1.unionInPlace(s2)
		XCTAssert(SortedMultiSet<Int>(elements: -1, 0, 0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 9) == s1, "Test failed. \(s1)")
	}
	
	func testIsSubsetOf() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 2, 3)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 2, 3, 4, 5)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 2, 2, 3, 4, 5)
		
		XCTAssert(s1 <= s1, "Test failed. \(s1.intersect(s2))")
		XCTAssert(s1 <= s2, "Test failed.")
		XCTAssertFalse(s1 <= s3, "Test failed.")
	}
	
	func testIsSupersetOf() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 5, 6, 7, 8)
		
		XCTAssert(s1 >= s1, "Test failed.")
		XCTAssert(s1 >= s2, "Test failed.")
		XCTAssertFalse(s1 >= s3, "Test failed.")
	}
	
	func testIsStrictSubsetOf() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 2, 3, 4, 5)
		
		XCTAssert(s1 < s2, "Test failed.")
		XCTAssertFalse(s1 < s3, "Test failed.")
	}
	
	func testIsStrictSupersetOf() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 5, 6, 7, 8)
		
		XCTAssert(s1 > s2, "Test failed.")
		XCTAssertFalse(s1 > s3, "Test failed.")
	}
	
	func testContains() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7)
		XCTAssert(s1.contains(1, 2, 3), "Test failed.")
		XCTAssertFalse(s1.contains(1, 2, 3, 10), "Test failed.")
	}
	
	func testExclusiveOr() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 2, 3, 4, 5, 6, 7)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 3, 4, 5)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 5, 6, 7, 8)
		
		XCTAssert(SortedMultiSet<Int>(elements: 6, 7) == s1.exclusiveOr(s2), "Test failed. \(s1.exclusiveOr(s2))")
		XCTAssert(SortedMultiSet<Int>(elements: 1, 2, 2, 3, 4, 8) == s1.exclusiveOr(s3), "Test failed. \(s1.exclusiveOr(s3))")
		XCTAssert(SortedMultiSet<Int>(elements: 1, 2, 3, 3, 4, 6, 7, 8) == s2.exclusiveOr(s3), "Test failed.")
	}
	
	func testExclusiveOrInPlace() {
		var s1: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 2, 3, 4, 5, 6, 7)
		let s2: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedMultiSet<Int> = SortedMultiSet<Int>(elements: 5, 6, 7, 8)
		
		s1.exclusiveOrInPlace(s2)
		XCTAssert(SortedMultiSet<Int>(elements: 6, 7) == s1, "Test failed.")
		
		s1 = SortedMultiSet<Int>(elements: 1, 2, 2, 3, 4, 5, 6, 7)
		s1.exclusiveOrInPlace(s3)
		XCTAssert(SortedMultiSet<Int>(elements: 1, 2, 2, 3, 4, 8) == s1, "Test failed. \(s1)")
		
		s2.exclusiveOrInPlace(s3)
		XCTAssert(SortedMultiSet<Int>(elements: 1, 2, 3, 4, 6, 7, 8) == s2, "Test failed. \(s2)")
	}
	
	func testIndexOf() {
		let s1: SortedMultiSet<Int> = SortedMultiSet<Int>()
		s1.insert(1, 2, 3, 4, 5, 5, 6, 7)
		
		XCTAssert(0 == s1.indexOf(1), "Test failed.")
		XCTAssert(6 == s1.indexOf(6), "Test failed.")
		XCTAssert(-1 == s1.indexOf(100), "Test failed.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
