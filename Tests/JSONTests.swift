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
import Foundation
import GraphKit

class JSONTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testParse() {
		var error: NSError?
		
		let dict: Dictionary<String, AnyObject> = ["user": "username", "password": "password", "token": 123456789]
		
		var data: NSData? = JSON.serialize(dict, error: &error)
		XCTAssert(nil == error, "Test failed.")
		
		var json: JSON? = JSON.parse(data!, error: &error)
		XCTAssert(nil == error, "Test failed.")
		
		XCTAssert(nil != json, "Test failed.")
		XCTAssert("username" == json!["user"]?.stringValue, "Test failed.")
		XCTAssert("password" == json!["password"]?.stringValue, "Test failed.")
		XCTAssert(123456789 == json!["token"]?.integerValue, "Test failed.")
		
		var stringified: String? = JSON.stringify(dict, error: &error)
		XCTAssert(nil == error, "Test failed.")
		
		println(JSON.parse(stringified!, error: &error))
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock() {
			// Put the code you want to measure the time of here.
		}
	}
	
}
