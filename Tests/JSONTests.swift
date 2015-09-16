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
		let data: NSData? = JSON.serialize(["user": ["username": "daniel", "password": "abc123", "token": 123456789]])
		XCTAssert(nil != data, "Test failed.")
		
		let j1: JSON? = JSON.parse(data!)
		XCTAssert(nil != j1, "Test failed.")
		
		XCTAssert("daniel" == j1!["user"]?["username"]?.string, "Test failed.")
		XCTAssert("abc123" == j1!["user"]?["password"]?.string, "Test failed.")
		XCTAssert(123456789 == j1!["user"]?["token"]?.int, "Test failed.")
	}
	
	func testStringify() {
		let stringified: String? = JSON.stringify(["user": ["username": "daniel", "password": "abc123", "token": 123456789]])
		let j1: JSON? = JSON.parse(stringified!)
		XCTAssert(nil != j1, "Test failed.")
		XCTAssert("{\"user\":{\"password\":\"abc123\",\"token\":123456789,\"username\":\"daniel\"}}" == stringified, "Test failed.")
	}
	
	func testEquatable() {
		let j1: JSON = JSON(object: ["user": "username", "password": "password", "token": 123456789])
		let j2: JSON = JSON(object: ["password": "password", "token": 123456789, "user": "username"])
		let j3: JSON = JSON(object: ["email": "email", "age": 21])
		
		XCTAssert(j1 == j2, "Test failed.")
		XCTAssert(j1 != j3, "Test failed.")
	}
	
	func testManipulations() {
		let j1: JSON = JSON(object: ["user": ["username": "daniel", "password": "abc123", "token": 123456789]])
		XCTAssert("daniel" == j1["user"]?["username"]?.string, "Test failed.")
		XCTAssert("abc123" == j1["user"]?["password"]?.string, "Test failed.")
		XCTAssert(123456789 == j1["user"]?["token"]?.int, "Test failed.")
		j1["key1"] = JSON(object: 123)
		XCTAssert(j1["key1"]?.int == 123, "Test failed.")
		
		let j2: JSON = JSON(object: [456, "Daniel"])
		XCTAssert(j2[0]?.int == 456, "Test failed.")
		XCTAssert(j2[1]?.string == "Daniel", "Test failed.")
		j2.append("Hello")
		XCTAssert(j2[2]?.string == "Hello", "Test failed.")
		j2[2] = JSON(object: "World")
		XCTAssert(j2[2]?.string == "World", "Test failed.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
