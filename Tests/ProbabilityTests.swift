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

class ProbabilityTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testOrderedSetInt() {
		let s: OrderedSet<Int> = OrderedSet<Int>()
		
		s.insert(1, 2, 3, 3)
		
		var ev: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testOrderedMultiSetInt() {
		let s: OrderedSet<Int> = OrderedSet<Int>()
		
		s.insert(1, 2, 3, 3)
		
		var ev: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testTreeInt() {
		let s: Tree<Int, Int> = Tree<Int, Int>()
		
		s.insert(1, value: 1)
		s.insert(2, value: 2)
		s.insert(3, value: 3)
		s.insert(3, value: 3)
		
		var ev: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testMultiTreeInt() {
		let s: MultiTree<Int, Int> = MultiTree<Int, Int>()
		
		s.insert(1, value: 1)
		s.insert(2, value: 2)
		s.insert(3, value: 3)
		s.insert(3, value: 3)
		
		var ev: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
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