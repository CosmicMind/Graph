/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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

class RedBlackTreeTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let s: RedBlackTree<Int, Int> = RedBlackTree<Int, Int>(uniqueKeys: true)
		
		XCTAssert(0 == s.count, "Test failed, got \(s.count).")
		
		for var i: Int = 1000; 0 < i; --i {
			s.insert(1, value: 1)
			s.insert(2, value: 2)
			s.insert(3, value: 3)
		}
		
		XCTAssert(3 == s.count, "Test failed.\(s)")
		XCTAssert(1 == s[0].value, "Test failed.")
		XCTAssert(2 == s[1].value, "Test failed.")
		XCTAssert(3 == s[2].value, "Test failed.")
		
		for var i: Int = 500; 0 < i; --i {
			s.removeValueForKeys(1)
			s.removeValueForKeys(3)
		}
		
		XCTAssert(1 == s.count, "Test failed.")
		s.removeValueForKeys(2)
		
		XCTAssert(true == s.insert(2, value: 10), "Test failed.")
		XCTAssert(1 == s.count, "Test failed.")
		XCTAssert(10 == s.findValueForKey(2), "Test failed.")
		XCTAssert(10 == s[0].value, "Test failed.")
		
		s.removeValueForKeys(2)
		XCTAssert(0 == s.count, "Test failed.")
		
		s.insert(1, value: 1)
		s.insert(2, value: 2)
		s.insert(3, value: 3)
		
		for var i: Int = s.endIndex - 1; i >= s.startIndex; --i {
			s[i] = (s[i].key, 100)
			XCTAssert(100 == s[i].value, "Test failed.")
		}
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testPropertyKey() {
		let s: RedBlackTree<String, Array<Int>> = RedBlackTree<String, Array<Int>>(uniqueKeys: false)
		s.insert("friends", value: [1, 2, 3])
		s["menu"] = [11, 22, 33]
		
		XCTAssert(s["friends"]! == s[0].value!, "Test failed.")
		XCTAssert(s["menu"]! == s[1].value!, "Test failed.")
		XCTAssert(s["empty"] == nil, "Test failed.")
		s["menu"] = [22, 33, 44]
		XCTAssert(s["menu"]! == [22, 33, 44], "Test failed.")
		s["menu"] = nil
		XCTAssert(2 == s.count, "Test failed.")
	}
	
	func testValue() {
		let t1: RedBlackTree<Int, Int> = RedBlackTree<Int, Int>()
		t1.insert(1, value: 1)
		t1.insert(2, value: 2)
		t1.insert(3, value: 3)
		
		let t2: RedBlackTree<Int, Int> = RedBlackTree<Int, Int>()
		t2.insert(4, value: 4)
		t2.insert(5, value: 5)
		t2.insert(6, value: 6)
		
		let t3: RedBlackTree<Int, Int> = t1 + t2
		
		for var i: Int = t1.count - 1; 0 <= i; --i {
			XCTAssert(t1[i].value == t3.findValueForKey(t1[i].value!), "Test failed.")
		}
		
		for var i: Int = t2.count - 1; 0 <= i; --i {
			XCTAssert(t2[i].value == t3.findValueForKey(t2[i].value!), "Test failed.")
		}
	}
	
	func testIndexOfUniqueKeys() {
		let t1: RedBlackTree<Int, Int> = RedBlackTree<Int, Int>(uniqueKeys: true)
		t1.insert(1, value: 1)
		t1.insert(2, value: 2)
		t1.insert(3, value: 3)
		t1.insert(4, value: 4)
		t1.insert(5, value: 5)
		t1.insert(5, value: 5)
		t1.insert(6, value: 6)
		
		XCTAssert(0 == t1.indexOf(1), "Test failed.")
		XCTAssert(5 == t1.indexOf(6), "Test failed.")
		XCTAssert(-1 == t1.indexOf(100), "Test failed.")
	}

	func testIndexOfNonUniqueKeys() {
		let t1: RedBlackTree<Int, Int> = RedBlackTree<Int, Int>()
		t1.insert(1, value: 1)
		t1.insert(2, value: 2)
		t1.insert(3, value: 3)
		t1.insert(4, value: 4)
		t1.insert(5, value: 5)
		t1.insert(5, value: 5)
		t1.insert(6, value: 6)
		
		XCTAssert(0 == t1.indexOf(1), "Test failed.")
		XCTAssert(6 == t1.indexOf(6), "Test failed.")
		XCTAssert(-1 == t1.indexOf(100), "Test failed.")
	}
	
	func testOperands() {
		let t1: RedBlackTree<Int, Int> = RedBlackTree<Int, Int>(uniqueKeys: true)
		t1.insert((1, 1), (2, 2), (3, 3), (4, 4))
		XCTAssert(4 == t1.count, "Test failed.")
		
		let t2: RedBlackTree<Int, Int> = RedBlackTree<Int, Int>(uniqueKeys: true)
		t2.insert((5, 5), (6, 6), (7, 7), (8, 8))
		XCTAssert(4 == t2.count, "Test failed.")
		
		let t3: RedBlackTree<Int, Int> = t1 + t2
		XCTAssert(8 == t3.count, "Test failed.")
		
		XCTAssert(t1 != t2, "Test failed.")
		XCTAssert(t3 != t2, "Test failed.")
		XCTAssert(t3 == (t1 + t2), "Test failed.")
	}

	func testPerformance() {
		self.measureBlock() {}
	}
}
