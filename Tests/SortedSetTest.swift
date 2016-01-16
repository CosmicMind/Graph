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

class SortedSetTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let s: SortedSet<Int> = SortedSet<Int>()
		
		XCTAssert(0 == s.count, "Test failed, got \(s.count).")
		
		for var i: Int = 1000; i > 0; --i {
			s.insert(1)
			s.insert(2)
			s.insert(3)
		}
		
		XCTAssert(3 == s.count, "Test failed.\(s)")
		XCTAssert(1 == s[0], "Test failed.")
		XCTAssert(2 == s[1], "Test failed.")
		XCTAssert(3 == s[2], "Test failed.")
		
		for var i: Int = 500; i > 0; --i {
			s.remove(1)
			s.remove(3)
		}
		
		XCTAssert(1 == s.count, "Test failed.")
		
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
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 22, 23, 1, 2, 3, 4, 5)
		s1.remove(1, 2, 3)
		XCTAssert(4 == s1.count, "Test failed.")
	}
	
	func testIntersect() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 22, 23, 1, 2, 3, 4, 5)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 22, 23, 5, 6, 7, 8, 9, 10)

		XCTAssert(SortedSet<Int>(elements: 22, 23, 5) == s1.intersect(s2), "Test failed. \(s1.intersect(s2))")
		
		XCTAssert(SortedSet<Int>() == s1.intersect(SortedSet<Int>()), "Test failed. \(s1)")
		
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 9, 9, 9)
		let s4: SortedSet<Int> = SortedSet<Int>(elements: 11, 9, 7, 3, 8, 100, 99, 88, 77)
		XCTAssert(SortedSet<Int>(elements: 9, 3, 7, 8) == s3.intersect(s4), "Test failed.")
	}
	
	func testIntersectInPlace() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 22, 23, 1, 2, 3, 4, 5)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 22, 23, 5, 6, 7, 8, 9, 10)
		
		s1.intersectInPlace(s2)
		XCTAssert(SortedSet<Int>(elements: 22, 23, 5) == s1, "Test failed. \(s1)")
		
		s1.intersectInPlace(SortedSet<Int>())
		XCTAssert(SortedSet<Int>() == s1, "Test failed. \(s1)")
		
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 9, 9, 9)
		let s4: SortedSet<Int> = SortedSet<Int>(elements: 11, 9, 7, 3, 8, 100, 99, 88, 77)
		s3.intersectInPlace(s4)
		XCTAssert(SortedSet<Int>(elements: 9, 3, 7, 8) == s3, "Test failed.")
	}
	
	func testSubtract() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 7, 8, 9, 10)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 4, 5, 6, 7)
		
		XCTAssert(SortedSet<Int>(elements: 1, 2, 3, 8, 9, 10) == s1.subtract(s2), "Test failed. \(s1.subtract(s2))")
		
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 0, -1, -2, -7, 99, 100)
		let s4: SortedSet<Int> = SortedSet<Int>(elements: -3, -5, -7, 99)
		XCTAssert(SortedSet<Int>(elements: 0, -1, -2, 100) == s3.subtract(s4), "Test failed. \(s3.subtract(s4))")
	}
	
	func testSubtractInPlace() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 7, 8, 9, 10)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 4, 5, 6, 7)
		
		s1.subtractInPlace(s2)
		XCTAssert(SortedSet<Int>(elements: 1, 2, 3, 8, 9, 10) == s1, "Test failed. \(s1)")
		
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 0, -1, -2, -7, 99, 100)
		let s4: SortedSet<Int> = SortedSet<Int>(elements: -3, -5, -7, 99)
		s3.subtractInPlace(s4)
		XCTAssert(SortedSet<Int>(elements: 0, -1, -2, 100) == s3, "Test failed. \(s3)")
	}
	
	func testUnion() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 5, 6, 7, 8, 9)
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7, 8, 9)
		
		XCTAssert(s3 == s1.union(s2), "Test failed.")
	}
	
	func testUnionInPlace() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 5, 6, 7, 8, 9)
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7, 8, 9)
		
		s1.unionInPlace(s2)
		XCTAssert(s3 == s1, "Test failed.")
	}
	
	func testExclusiveOr() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 5, 6, 7, 8)
		
		XCTAssert(SortedSet<Int>(elements: 6, 7) == s1.exclusiveOr(s2), "Test failed. \(s1.exclusiveOr(s2))")
		XCTAssert(SortedSet<Int>(elements: 1, 2, 3, 4, 8) == s1.exclusiveOr(s3), "Test failed.")
		XCTAssert(SortedSet<Int>(elements: 1, 2, 3, 4, 6, 7, 8) == s2.exclusiveOr(s3), "Test failed.")
	}
	
	func testExclusiveOrInPlace() {
		var s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 5, 6, 7, 8)
		
		s1.exclusiveOrInPlace(s2)
		XCTAssert(SortedSet<Int>(elements: 6, 7) == s1, "Test failed. \(s1)")
		
		s1 = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7)
		s1.exclusiveOrInPlace(s3)
		XCTAssert(SortedSet<Int>(elements: 1, 2, 3, 4, 8) == s1, "Test failed. \(s1)")
		
		s2.exclusiveOrInPlace(s3)
		XCTAssert(SortedSet<Int>(elements: 1, 2, 3, 4, 6, 7, 8) == s2, "Test failed. \(s2)")
	}
	
	func testIsDisjointWith() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 3, 4, 5)
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 5, 6, 7)
		
		XCTAssertFalse(s1.isDisjointWith(s2), "Test failed. \(s1.isDisjointWith(s2))")
		XCTAssert(s1.isDisjointWith(s3), "Test failed.")
		XCTAssertFalse(s2.isDisjointWith(s3), "Test failed.")
	}
	
	func testIsSubsetOf() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 2, 3, 4, 5)
		
		XCTAssert(s1 <= s1, "Test failed.")
		XCTAssert(s1 <= s2, "Test failed.")
		XCTAssertFalse(s1 <= s3, "Test failed.")
	}
	
	func testIsSupersetOf() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 5, 6, 7, 8)
		
		XCTAssert(s1 >= s1, "Test failed.")
		XCTAssert(s1 >= s2, "Test failed.")
		XCTAssertFalse(s1 >= s3, "Test failed.")
	}
	
	func testIsStrictSubsetOf() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 2, 3, 4, 5)
		
		XCTAssert(s1 < s2, "Test failed.")
		XCTAssertFalse(s1 < s3, "Test failed.")
	}
	
	func testIsStrictSupersetOf() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7)
		let s2: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5)
		let s3: SortedSet<Int> = SortedSet<Int>(elements: 5, 6, 7, 8)
		
		XCTAssert(s1 > s2, "Test failed.")
		XCTAssertFalse(s1 > s3, "Test failed.")
	}
	
	func testContains() {
		let s1: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6, 7)
		XCTAssert(s1.contains(1, 2, 3), "Test failed.")
		XCTAssertFalse(s1.contains(1, 2, 3, 10), "Test failed.")
	}
	
	func testIndexOf() {
		let s1: SortedSet<Int> = SortedSet<Int>()
		s1.insert(1, 2, 3, 4, 5, 6, 7)
		
		XCTAssert(0 == s1.indexOf(1), "Test failed.")
		XCTAssert(5 == s1.indexOf(6), "Test failed.")
		XCTAssert(-1 == s1.indexOf(100), "Test failed.")
	}
	
	func testEntityIntersection() {
		let graph: Graph = Graph()
		graph.clear()
		
		let e1: Entity = Entity(type: "User")
		let e2: Entity = Entity(type: "User")
		let e3: Entity = Entity(type: "User")
		let e4: Entity = Entity(type: "User")
		
		let s1: SortedSet<Entity> = SortedSet<Entity>()
		s1.insert(e1)
		s1.insert(e2)
		s1.insert(e3)
		
		let s2: SortedSet<Entity> = SortedSet<Entity>()
		s2.insert(e2)
		s2.insert(e3)
		s2.insert(e4)
		
		XCTAssertTrue(SortedSet<Entity>(elements: e2, e3) == s1.intersect(s2), "Test failed.")
		
		s1.intersectInPlace(s2)
		XCTAssertTrue(SortedSet<Entity>(elements: e2, e3) == s1, "Test failed.")
		
		e1.delete()
		e2.delete()
		e3.delete()
		e4.delete()
		
		graph.syncSave { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Text failed.")
		}
	}
	
	func testExample() {
		let setA: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3) // Sorted: [1, 2, 3]
		let setB: SortedSet<Int> = SortedSet<Int>(elements: 4, 3, 6) // Sorted: [3, 4, 6]
		
		let setC: SortedSet<Int> = SortedSet<Int>(elements: 7, 1, 2) // Sorted: [1, 2, 7]
		let setD: SortedSet<Int> = SortedSet<Int>(elements: 1, 7) // Sorted: [1, 7]
		
		let setE: SortedSet<Int> = SortedSet<Int>(elements: 1, 6, 7) // Sorted: [1, 6, 7]
		
		// Union.
		print((setA + setB).count) // Output: 5
		print(setA.union(setB).count) // Output: 5
		
		// Intersect.
		print(setC.intersect(setD).count) // Output: 2
		
		// Subset.
		print(setD < setC) // true
		print(setD.isSubsetOf(setC)) // true
		
		// Superset.
		print(setD > setC) // false
		print(setD.isSupersetOf(setC)) // false
		
		// Contains.
		print(setE.contains(setA.first!)) // true
		
		// Probability.
		print(setE.probabilityOf(setA.first!, setA.last!)) // 0.333333333333333
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
