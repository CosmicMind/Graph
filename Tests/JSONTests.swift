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
		let dict: Dictionary<String, AnyObject> = ["user": "username", "password": "password", "token": 123456789]
		
		var data: NSData?
		do {
			 data = try JSON.serialize(dict)
		} catch {}
		XCTAssert(nil != data, "Test failed.")
		
		var j1: JSON?
		do {
			j1 = try JSON.parse(data!)
		} catch {}
		XCTAssert(nil != j1, "Test failed.")
		
		XCTAssert(nil != j1, "Test failed.")
		XCTAssert("username" == j1!["user"]?.stringValue, "Test failed.")
		XCTAssert("password" == j1!["password"]?.stringValue, "Test failed.")
		XCTAssert(123456789 == j1!["token"]?.integerValue, "Test failed.")
	}
	
	func testStringify() {
		let dict: Dictionary<String, AnyObject> = ["user": "username", "password": "password", "token": 123456789]
		
		var stringified: String?
		do {
			stringified = try JSON.stringify(dict)
		} catch {
			XCTAssert(false, "Test failed.")
		}
		
		var j1: JSON?
		do {
			j1 = try JSON.parse(stringified!)
		} catch {}
		
		XCTAssert(nil != j1, "Test failed.")
		XCTAssert("username" == j1!["user"]?.stringValue, "Test failed.")
		XCTAssert("password" == j1!["password"]?.stringValue, "Test failed.")
		XCTAssert(123456789 == j1!["token"]?.integerValue, "Test failed.")
		
		XCTAssert("{\"token\":123456789,\"user\":\"username\",\"password\":\"password\"}" == stringified, "Test failed.")
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
