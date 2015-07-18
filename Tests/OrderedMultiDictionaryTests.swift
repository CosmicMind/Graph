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

class OrderedMultiDictionaryTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testInt() {
		let s: OrderedMultiDictionary<Int, Int> = OrderedMultiDictionary<Int, Int>()
		
		XCTAssert(0 == s.count, "Test failed, got \(s.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			s.insert((1, 1))
			s.insert((2, 2))
			s.insert((3, 3))
		}
		
		XCTAssert(3000 == s.count, "Test failed.")
		XCTAssert(1 == s[0].value, "Test failed.")
		XCTAssert(1 == s[1].value, "Test failed.")
		XCTAssert(1 == s[2].value, "Test failed.")
		
		for (var i: Int = 500; i > 0; --i) {
			s.removeValueForKey(1)
			s.removeValueForKey(3)
		}
		
		XCTAssert(1000 == s.count, "Test failed.")
		XCTAssert(nil != s.removeValueForKey(2), "Test failed.")
		XCTAssert(nil == s.removeValueForKey(2), "Test failed.")
		
		s.insert((2, 10))
		XCTAssert(1 == s.count, "Test failed.")
		XCTAssert(10 == s.findValueForKey(2), "Test failed.")
		XCTAssert(10 == s[0].value!, "Test failed.")
		XCTAssert(true == (nil != s.removeValueForKey(2) && 0 == s.count), "Test failed.")
		
		s.insert((1, 1))
		s.insert((2, 2))
		s.insert((3, 3))
		s.insert((3, 3))
		s.updateValue(5, forKey: 3)
		
		let subs: OrderedMultiDictionary<Int, Int> = s.search(3)
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
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
