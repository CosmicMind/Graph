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

class OrderedDictionaryTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let s: OrderedDictionary<Int, Int> = OrderedDictionary<Int, Int>()
		
		XCTAssert(0 == s.count, "Test failed, got \(s.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			s.insert((1, 1))
			s.insert((2, 2))
			s.insert((3, 3))
		}
		
		XCTAssert(3 == s.count, "Test failed.")
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
		
		s.insert((2, 10))
		XCTAssert(1 == s.count, "Test failed.")
		XCTAssert(10 == s.findValueForKey(2), "Test failed.")
		XCTAssert(10 == s[0].value!, "Test failed.")
		XCTAssert(true == (nil != s.removeValueForKeys(2) && 0 == s.count), "Test failed.")
		
		s.insert((1, 1))
		s.insert((2, 2))
		s.insert((3, 3))
		s.insert((3, 3))
		s.updateValue(5, forKey: 3)
		
		let subs: OrderedDictionary<Int, Int>.OrderedSearch = s.search(3)
		XCTAssert(1 == subs.count, "Test failed.")
		
		let generator: OrderedDictionary<Int, Int>.Generator = subs.generate()
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
	
	func testIndexOf() {
		let d1: OrderedDictionary<Int, Int> = OrderedDictionary<Int, Int>()
		d1.insert(1, value: 1)
		d1.insert(2, value: 2)
		d1.insert(3, value: 3)
		d1.insert(4, value: 4)
		d1.insert(5, value: 5)
		d1.insert(5, value: 5)
		d1.insert(6, value: 6)
		
		XCTAssert(0 == d1.indexOf(1), "Test failed.")
		XCTAssert(5 == d1.indexOf(6), "Test failed.")
		XCTAssert(-1 == d1.indexOf(100), "Test failed.")
	}
	
	func testKeys() {
		let s: OrderedDictionary<String, Int> = OrderedDictionary<String, Int>(elements: ("adam", 1), ("daniel", 2), ("mike", 3), ("natalie", 4))
		let keys: OrderedDictionary<String, Int>.OrderedKey = OrderedDictionary<String, Int>.OrderedKey(elements: "adam", "daniel", "mike", "natalie")
		XCTAssert(keys == s.keys, "Test failed.")
	}
	
	func testValues() {
		let s: OrderedDictionary<String, Int> = OrderedDictionary<String, Int>(elements: ("adam", 1), ("daniel", 2), ("mike", 3), ("natalie", 4))
		let values: OrderedDictionary<String, Int>.OrderedValue = [1, 2, 3, 4]
		XCTAssert(values == s.values, "Test failed.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
