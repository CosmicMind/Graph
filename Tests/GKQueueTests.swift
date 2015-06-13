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

class GKQueueTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testQueueInt() {
		let s: GKQueue<Int, Int> = GKQueue<Int, Int>()
		
		XCTAssert(0 == s.count, "Set count incorrect, got \(s.count).")
		
//		for (var i: Int = 1000; i > 0; --i) {
			s.insert(1, data: 1)
			s.insert(2, data: 2)
			s.insert(5, data: 5)
			s.insert(3, data: 3)
			s.insert(4, data: 4)
//		}
		
//		s.remove(1)
		
		println("Max \(s.max)")
		
		XCTAssert(5 == s.count, "Test failed.\(s)")
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
