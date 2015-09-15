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
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testParse() {
		let dict: Dictionary<String, AnyObject> = ["user": ["username": "daniel", "password": "abc123", "token": 123456789]]
		
		let data: NSData? = try? JSON.serialize(dict)
		XCTAssert(nil != data, "Test failed.")
		
		let j1: JSON? = try? JSON.parse(data!)
		XCTAssert(nil != j1, "Test failed.")
		
		XCTAssert("daniel" == j1!["user"]?["username"]?.stringValue, "Test failed.")
		XCTAssert("abc123" == j1!["user"]?["password"]?.stringValue, "Test failed.")
		XCTAssert(123456789 == j1!["user"]?["token"]?.integerValue, "Test failed.")
	}
	
	func testStringify() {
		let dict: Dictionary<String, AnyObject> = ["user": ["username": "daniel", "password": "abc123", "token": 123456789]]
		
		let stringified: String? = try? JSON.stringify(dict)
		let j1: JSON? = try? JSON.parse(stringified!)
		XCTAssert(nil != j1, "Test failed.")
		
		XCTAssert("{\"user\":{\"password\":\"abc123\",\"token\":123456789,\"username\":\"daniel\"}}" == stringified, "Test failed.")
	}
	
	func testEquatable() {
		let v1: Dictionary<String, AnyObject> = ["user": "username", "password": "password", "token": 123456789]
		let v2: Dictionary<String, AnyObject> = ["email": "email", "age": 21]
		
		let j1: JSON = JSON(value: v1)
		let j2: JSON = JSON(value: v1)
		let j3: JSON = JSON(value: v2)
		
		XCTAssert(j1 == j2, "Test failed.")
		XCTAssert(j1 != j3, "Test failed.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
