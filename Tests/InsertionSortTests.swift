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

class InsertionSortTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testIntegerSorting() {
		var integers: Array<Int> = [5, 4, 3, 2, 1, 6, 8, 7, 9]
		Sort.insertion(&integers)
		XCTAssert([1, 2, 3, 4, 5, 6, 7, 8, 9] == integers, "Test failed.")
	}
	
	func testStringSorting() {
		var strings: Array<String> = ["c", "d", "a", "b", "t", "r", "x", "aa", "gg"]
		Sort.insertion(&strings)
		XCTAssert(["a", "aa", "b", "c", "d", "gg", "r", "t", "x"] == strings, "Test failed.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
