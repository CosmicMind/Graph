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

class OrderedMultiTreeTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let s: OrderedMultiTree<Int, Int> = OrderedMultiTree<Int, Int>(nodes: (1, 1), (2, 2), (3, 3))
		
		XCTAssert(3 == s.count, "Test failed, got \(s.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			s.insert((1, 1), (2, 2), (3, 3))
		}
		
		XCTAssert(3003 == s.count, "Test failed.")
		XCTAssert(1 == s[0].value, "Test failed.")
		XCTAssert(1 == s[1].value, "Test failed.")
		XCTAssert(1 == s[2].value, "Test failed.")
		
		for (var i: Int = 500; i > 0; --i) {
			s.removeValueForKey(1)
			s.removeValueForKey(3)
		}
		
		XCTAssert(1001 == s.count, "Test failed.")
		XCTAssert(nil != s.removeValueForKey(2), "Test failed.")
		XCTAssert(nil == s.removeValueForKey(2), "Test failed.")
		XCTAssert(true == s.insert(2, value: 10), "Test failed.")
		XCTAssert(1 == s.count, "Test failed.")
		XCTAssert(10 == s.findValueForKey(2), "Test failed.")
		XCTAssert(10 == s[0].value!, "Test failed.")
		XCTAssert(true == (nil != s.removeValueForKey(2) && 0 == s.count), "Test failed.")
		
		s.insert(1, value: 1)
		s.insert(2, value: 2)
		s.insert(3, value: 3)
		s.insert(3, value: 3)
		s.updateValue(5, forKey: 3)
		
		let subs: OrderedMultiTree<Int, Int> = s.search(3)
		XCTAssert(2 == subs.count, "Test failed.")
		
		var generator = subs.generate()
		while let x = generator.next() {
			XCTAssert(5 == x.value, "Test failed.")
		}
		
		for (var i: Int = s.endIndex - 1; i >= s.startIndex; --i) {
			s[i] = (s[i].key, 100)
			XCTAssert(100 == s[i].value, "Test failed.")
		}
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testString() {
		let s: OrderedMultiTree<String, Array<Int>> = OrderedMultiTree<String, Array<Int>>()
		s.insert("friends", value: [1, 2, 3])
		s["menu"] = [11, 22, 33]
		
		XCTAssert(s["friends"]! == s[0].value!, "Test failed.")
		println(s["menu"])
		println(s)
		XCTAssert(s["menu"]! == s[1].value!, "Test failed.")
		XCTAssert(s["empty"] == nil, "Test failed.")
		s["menu"] = [22, 33, 44]
		XCTAssert(s["menu"]! == [22, 33, 44], "Test failed.")
		s["menu"] = nil
		XCTAssert(2 == s.count, "Test failed.")
	}
	
	func testMultisetSearch() {
		let mt1: OrderedMultiTree<Int, Int> = OrderedMultiTree<Int, Int>()
		XCTAssert(0 == mt1.count, "Test failed, got \(mt1.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			mt1.insert(1, value: 1)
			mt1.insert(2, value: 2)
			mt1.insert(3, value: 3)
		}
		
		XCTAssert(3000 == mt1.count, "Test failed.")
		
		let mt2: OrderedMultiTree<Int, Int> = mt1.search(1)
		XCTAssert(1000 == mt2.count, "Test failed, got \(mt2.count).")
		
		let mt3: OrderedMultiTree<Int, Int> = mt1.search(2)
		XCTAssert(1000 == mt3.count, "Test failed, got \(mt3.count).")
		
		let mt4: OrderedMultiTree<Int, Int> = mt1.search(3)
		XCTAssert(1000 == mt4.count, "Test failed, got \(mt4.count).")
	}
	
	func testConcat() {
		let mt1: OrderedMultiTree<Int, Int> = OrderedMultiTree<Int, Int>()
		mt1.insert(1, value: 1)
		mt1.insert(2, value: 2)
		mt1.insert(3, value: 3)
		
		let mt2: OrderedMultiTree<Int, Int> = OrderedMultiTree<Int, Int>()
		mt2.insert(4, value: 4)
		mt2.insert(5, value: 5)
		mt2.insert(6, value: 6)
		
		let mt3: OrderedMultiTree<Int, Int> = mt1 + mt2
		
		for var i: Int = mt1.count - 1; i >= 0; --i {
			XCTAssert(mt1[i].value == mt3.findValueForKey(mt1[i].value!), "Test failed.")
		}
		
		for var i: Int = mt2.count - 1; i >= 0; --i {
			XCTAssert(mt2[i].value == mt3.findValueForKey(mt2[i].value!), "Test failed.")
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
