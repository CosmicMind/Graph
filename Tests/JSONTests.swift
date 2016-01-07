/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of GraphKit nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

//
//import XCTest
//import Foundation
//@testable import GraphKit
//
//class JSONTests: XCTestCase {
//	
//	override func setUp() {
//		super.setUp()
//	}
//	
//	override func tearDown() {
//		super.tearDown()
//	}
//	
//	func testParse() {
//		let data: NSData? = JSON.serialize(["user": ["username": "daniel", "password": "abc123", "token": 123456789]])
//		XCTAssert(nil != data, "Test failed.")
//		
//		let j1: JSON? = JSON.parse(data!)
//		XCTAssert(nil != j1, "Test failed.")
//		
//		XCTAssert("daniel" == j1!["user"]?["username"]?.asString, "Test failed.")
//		XCTAssert("abc123" == j1!["user"]?["password"]?.asString, "Test failed.")
//		XCTAssert(123456789 == j1!["user"]?["token"]?.asInt, "Test failed.")
//	}
//	
//	func testStringify() {
//		let stringified: String? = JSON.stringify(["user": ["username": "daniel", "password": "abc123", "token": 123456789]])
//		let j1: JSON? = JSON.parse(stringified!)
//		XCTAssert(nil != j1, "Test failed.")
//		XCTAssert("{\"user\":{\"password\":\"abc123\",\"token\":123456789,\"username\":\"daniel\"}}" == stringified, "Test failed.")
//	}
//	
//	func testEquatable() {
//		let j1: JSON = JSON(["user": "username", "password": "password", "token": 123456789])
//		let j2: JSON = JSON(["password": "password", "token": 123456789, "user": "username"])
//		let j3: JSON = JSON(["email": "email", "age": 21])
//		
//		XCTAssert(j1 == j2, "Test failed.")
//		XCTAssert(j1 != j3, "Test failed.")
//	}
//	
//	func testManipulations() {
//		let j1: JSON = JSON(["user": ["username": "daniel", "password": "abc123", "token": 123456789]])
//		XCTAssert("daniel" == j1["user"]?["username"]?.asString, "Test failed.")
//		XCTAssert("abc123" == j1["user"]?["password"]?.asString, "Test failed.")
//		XCTAssert(123456789 == j1["user"]?["token"]?.asInt, "Test failed.")
//		j1["key1"] = 123
//		XCTAssert(j1["key1"]?.asInt == 123, "Test failed.")
//		
//		let j2: JSON = JSON([456, "Hello"])
//		XCTAssert(j2[0]?.asInt == 456, "Test failed.")
//		XCTAssert(j2[1]?.asString == "Hello", "Test failed.")
//		j2.asArray?.append(123)
//		j2[1] = "World"
//		XCTAssert(j2[1]?.asString == "World", "Test failed.")
//		j2[1] = nil
//		XCTAssert(j2[1]?.asString == nil, "Test failed.")
//	}
//	
//	func testPerformance() {
//		self.measureBlock() {}
//	}
//}
