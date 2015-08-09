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
		
		for (var i: Int = 1000; i > 0; --i) {
			s.insert(1, value: 1)
			s.insert(2, value: 2)
			s.insert(3, value: 3)
		}
		
		XCTAssert(3 == s.count, "Test failed.\(s)")
		XCTAssert(1 == s[0].value, "Test failed.")
		XCTAssert(2 == s[1].value, "Test failed.")
		XCTAssert(3 == s[2].value, "Test failed.")
		
		for (var i: Int = 500; i > 0; --i) {
			s.removeValueForKeys(1)
			s.removeValueForKeys(3)
		}
		
		XCTAssert(1 == s.count, "Test failed.")
		XCTAssert(nil != s.removeValueForKeys(2), "Test failed.")
		XCTAssert(nil == s.removeValueForKeys(2), "Test failed.")
		XCTAssert(true == s.insert(2, value: 10), "Test failed.")
		XCTAssert(1 == s.count, "Test failed.")
		XCTAssert(10 == s.findValueForKey(2), "Test failed.")
		XCTAssert(10 == s[0].value, "Test failed.")
		XCTAssert(true == (nil != s.removeValueForKeys(2) && 0 == s.count), "Test failed.")
		
		s.insert(1, value: 1)
		s.insert(2, value: 2)
		s.insert(3, value: 3)
		
		for (var i: Int = s.endIndex - 1; i >= s.startIndex; --i) {
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
		
		let o1: RedBlackTree<Int, Int>.OrderedIndex = RedBlackTree<Int, Int>(uniqueKeys: true)
		o1.insert(1, value: 0)
		o1.insert(3, value: 2)
		o1.insert(5, value: 5)
		o1.insert(5, value: 4)
		o1.insert(10, value: nil)
		o1.insert(11, value: nil)
		
		XCTAssert(o1 == t1.indexOf(1, 11, 3, 5, 10), "Test failed.")
		
		t1.insert(11, value: 11)
		t1.insert(10, value: 10)
		
		o1.updateValue(11, forKey: 11)
		o1.updateValue(10, forKey: 10)
		
		XCTAssert(o1 == t1.indexOf(1, 11, 3, 5, 10), "Test failed.")
		
		var n: Int = 1000
		while 0 < n-- {
			o1.insert(7, value: n)
			t1.insert(7, value: n)
			o1.insert(3, value: n)
			t1.insert(3, value: n)
		}
		XCTAssert(o1 == t1.indexOf(1, 11, 3, 5, 10, 7), "Test failed.")
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
		
		let o1: RedBlackTree<Int, Int>.OrderedIndex = RedBlackTree<Int, Int>(uniqueKeys: false)
		o1.insert(1, value: 0)
		o1.insert(3, value: 2)
		o1.insert(5, value: 5)
		o1.insert(5, value: 4)
		o1.insert(10, value: nil)
		o1.insert(11, value: nil)
		
		XCTAssert(o1 == t1.indexOf(1, 11, 3, 5, 10), "Test failed.")
		
		t1.insert(11, value: 11)
		t1.insert(10, value: 10)
		
		o1.updateValue(11, forKey: 11)
		o1.updateValue(10, forKey: 10)
		
		XCTAssert(o1 == t1.indexOf(1, 11, 3, 5, 10), "Test failed.")
		
		var n: Int = 1000
		while 0 < n-- {
			o1.insert(7, value: n)
			t1.insert(7, value: n)
			o1.insert(3, value: n)
			t1.insert(3, value: n)
		}
		XCTAssert(o1 == t1.indexOf(1, 11, 3, 5, 10, 7), "Test failed.")
	}

	func testPerformance() {
		self.measureBlock() {}
	}
}
