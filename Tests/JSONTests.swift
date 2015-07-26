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
		
		var j1: JSON? = JSON.parse(data, error: &error)
		XCTAssert(nil == error, "Test failed.")
		
		XCTAssert(nil != j1, "Test failed.")
		XCTAssert("username" == j1!["user"]?.stringValue, "Test failed.")
		XCTAssert("password" == j1!["password"]?.stringValue, "Test failed.")
		XCTAssert(123456789 == j1!["token"]?.integerValue, "Test failed.")
	}
	
	func testStringify() {
		var error: NSError?
		let dict: Dictionary<String, AnyObject> = ["user": "username", "password": "password", "token": 123456789]
		var stringified: String? = JSON.stringify(dict, error: &error)
		
		var j1: JSON? = JSON.parse(stringified, error: &error)
		XCTAssert(nil == error, "Test failed.")
		XCTAssert(nil != j1, "Test failed.")
		XCTAssert("username" == j1!["user"]?.stringValue, "Test failed.")
		XCTAssert("password" == j1!["password"]?.stringValue, "Test failed.")
		XCTAssert(123456789 == j1!["token"]?.integerValue, "Test failed.")
		
		XCTAssert("{\"token\":123456789,\"user\":\"username\",\"password\":\"password\"}" == stringified, "Test failed. \(j1)")
	}
	
	func testEquatable() {
		let v1: Dictionary<String, AnyObject> = ["user": "username", "password": "password", "token": 123456789]
		let v2: Dictionary<String, AnyObject> = ["email": "email", "age": 21]
		
		var j1: JSON = JSON(value: v1)
		var j2: JSON = JSON(value: v1)
		var j3: JSON = JSON(value: v2)
		
		XCTAssert(j1 == j2, "Test failed.")
		XCTAssert(j1 != j3, "Test failed.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
