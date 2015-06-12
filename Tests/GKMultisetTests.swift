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
import GKGraphKit

class GKMultisetTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testMultisetInt() {
		let s: GKMultiset<Int, Int> = GKMultiset<Int, Int>()
		
		XCTAssert(0 == s.count, "Set count incorrect, got \(s.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			s.insert(1, data: 1)
			s.insert(2, data: 2)
			s.insert(3, data: 3)
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
		XCTAssert(true == s.insert(2, data: 10), "Test failed.")
		XCTAssert(1 == s.count, "Test failed.")
		XCTAssert(10 == s.find(2)!, "Test failed.")
		XCTAssert(10 == s[0]!, "Test failed.")
		XCTAssert(true == (s.remove(2) && 0 == s.count), "Test failed.")
	}
	
	func testMultisetString() {
		let s: GKMultiset<String, Array<Int>> = GKMultiset<String, Array<Int>>()
		s.insert("friends", data: [1, 2, 3])
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
		let s1: GKMultiset<Int, Int> = GKMultiset<Int, Int>()
		XCTAssert(0 == s1.count, "Set count incorrect, got \(s1.count).")
		
		for (var i: Int = 1000; i > 0; --i) {
			s1.insert(1, data: 1)
			s1.insert(2, data: 2)
			s1.insert(3, data: 3)
		}
		
		XCTAssert(3000 == s1.count, "Test failed.")
		
		let s2: GKMultiset<Int, Int> = s1.search(1)
		XCTAssert(1000 == s2.count, "Set count incorrect, got \(s2.count).")
		
		let s3: GKMultiset<Int, Int> = s1.search(2)
		XCTAssert(1000 == s3.count, "Set count incorrect, got \(s3.count).")
		
		let s4: GKMultiset<Int, Int> = s1.search(3)
		XCTAssert(1000 == s4.count, "Set count incorrect, got \(s4.count).")
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
