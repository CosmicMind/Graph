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

class MultiTreeTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testMultisetInt() {
		let s: MultiTree<Int, Int> = MultiTree<Int, Int>()
		
		XCTAssert(0 == s.count, "Test failed, got \(s.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			s.insert(1, value: 1)
			s.insert(2, value: 2)
			s.insert(3, value: 3)
		}
		
		XCTAssert(3000 == s.count, "Test failed.")
		XCTAssert(1 == s[0]!, "Test failed.")
		XCTAssert(1 == s[1]!, "Test failed.")
		XCTAssert(1 == s[2]!, "Test failed.")
		
		for (var i: Int = 500; i > 0; --i) {
			s.remove(1)
			s.remove(3)
		}
		
		XCTAssert(1000 == s.count, "Test failed.")
		XCTAssert(true == s.remove(2), "Test failed.")
		XCTAssert(false == s.remove(2), "Test failed.")
		XCTAssert(true == s.insert(2, value: 10), "Test failed.")
		XCTAssert(1 == s.count, "Test failed.")
		XCTAssert(10 == s.find(2)!, "Test failed.")
		XCTAssert(10 == s[0]!, "Test failed.")
		XCTAssert(true == (s.remove(2) && 0 == s.count), "Test failed.")
		
		s.insert(1, value: 1)
		s.insert(2, value: 2)
		s.insert(3, value: 3)
		s.insert(3, value: 3)
		
		s.update(3, value: 5)
		let subs: MultiTree = s.search(3)
		XCTAssert(2 == subs.count, "Test failed.")
		
		var generator = subs.generate()
		while let x = generator.next() {
			XCTAssert(5 == x, "Test failed.")
		}
		
		s.clear()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testMultisetString() {
		let s: MultiTree<String, Array<Int>> = MultiTree<String, Array<Int>>()
		s.insert("friends", value: [1, 2, 3])
		s["menu"] = [11, 22, 33]
		
		XCTAssert(s["friends"]! == s[0]!, "Test failed.")
		XCTAssert(s["menu"]! == s[1]!, "Test failed.")
		XCTAssert(s["empty"] == nil, "Test failed.")
		s["menu"] = [22, 33, 44]
		XCTAssert(s["menu"]! == [22, 33, 44], "Test failed.")
		s["menu"] = nil
		XCTAssert(2 == s.count, "Test failed.")
	}
	
	func testMultisetSearch() {
		let s1: MultiTree<Int, Int> = MultiTree<Int, Int>()
		XCTAssert(0 == s1.count, "Test failed, got \(s1.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			s1.insert(1, value: 1)
			s1.insert(2, value: 2)
			s1.insert(3, value: 3)
		}
		
		XCTAssert(3000 == s1.count, "Test failed.")
		
		let s2: MultiTree<Int, Int> = s1.search(1)
		XCTAssert(1000 == s2.count, "Test failed, got \(s2.count).")
		
		let s3: MultiTree<Int, Int> = s1.search(2)
		XCTAssert(1000 == s3.count, "Test failed, got \(s3.count).")
		
		let s4: MultiTree<Int, Int> = s1.search(3)
		XCTAssert(1000 == s4.count, "Test failed, got \(s4.count).")
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
