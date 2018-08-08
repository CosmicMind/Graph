/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *    * Redistributions of source code must retain the above copyright notice, this
 *      list of conditions and the following disclaimer.
 *
 *    * Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 *
 *    * Neither the name of CosmicMind nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
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

import XCTest
@testable import Graph


class GraphJSONTests: XCTestCase {
  let testJSONString = """
{
  "name": "orkhan",
  "age": 20,
  "number": 12.3e-3,
  "skills": [
    "swift",
    "ios",
    "programming"
  ],
  "isMale": true,
  "children": null,
  "emoji": "\\u263A"
}
"""
  
  let dictionary: [AnyHashable : Any] = [
    "name": "orkhan",
    "age": 20,
    "number": 0.0123,
    "skills": [
      "swift",
      "ios",
      "programming"
    ],
    "isMale": true,
    "children": Optional<Int>.none as Any,
    "emoji": "☺"
  ]
  
  func testParse() {
    XCTAssertNil(GraphJSON.parse("bad data"))
    XCTAssertNotNil(GraphJSON.parse("{}"))
    XCTAssertEqual(GraphJSON.parse("[1, 2]")?.object as? [Int], [1, 2])
    XCTAssertEqual(GraphJSON.parse("{\"user\": \"orkhan\"}")?.object as? [String: String], ["user": "orkhan"])
    
    let parsed = GraphJSON.parse(testJSONString)?.object as? NSDictionary
    XCTAssert(parsed?.isEqual(to: dictionary) == true)
  }

  func testStringify() {
    XCTAssertNil(GraphJSON.stringify(object: "unsupported top level object"))
    XCTAssertEqual(GraphJSON.stringify(object: []), "[]")
    XCTAssertEqual(GraphJSON.stringify(object: [:]), "{}")
    XCTAssertEqual(GraphJSON.stringify(object: [1, 2, "3", nil, true, false]), "[1,2,\"3\",null,true,false]")
    XCTAssertEqual(GraphJSON.stringify(object: ["user": "orkhan"]), "{\"user\":\"orkhan\"}")
  }
  
  func testEquatable() {
    XCTAssertEqual(GraphJSON.isNil, .isNil)
    XCTAssertEqual(GraphJSON([1, true, "Graph", [:]]), GraphJSON([1, true, "Graph", [:]]))
    XCTAssertEqual(GraphJSON(dictionary), GraphJSON(dictionary))
  }
  
  func testAccess() {
    guard let json = GraphJSON.parse(testJSONString) else {
      XCTFail("testJSONString is not parsed successfully")
      return
    }
    
    XCTAssert((json.asDictionary as NSDictionary?)?.isEqual(to: dictionary) == true)
    
    /// Dictionary style access
    XCTAssertEqual(json["nonExistentObject"], .isNil)
    XCTAssertEqual(json["name"].asString, "orkhan")
    XCTAssertEqual(json["age"].asInt, 20)
    XCTAssertEqual(json["number"].asDouble, 0.0123)
    XCTAssertEqual(json["children"], .isNil)
    XCTAssertEqual(json["isMale"].asBool, true)
    XCTAssertEqual(json["skills"].asArray as? [String], ["swift", "ios", "programming"])

    /// Dynamic member access
    XCTAssertEqual(json.nonExistentObject, .isNil)
    XCTAssertEqual(json.name.asString, "orkhan")
    XCTAssertEqual(json.age.asInt, 20)
    XCTAssertEqual(json.number.asDouble, 0.0123)
    XCTAssertEqual(json.children, .isNil)
    XCTAssertEqual(json.isMale.asBool, true)
    XCTAssertEqual(json.skills.asArray as? [String], ["swift", "ios", "programming"])
    
    /// Array style access
    XCTAssertEqual(json.skills[0].asString, "swift")
    XCTAssertEqual(json.skills[1].asString, "ios")
    XCTAssertEqual(json.skills[2].asString, "programming")
    XCTAssertEqual(json.skills[99], .isNil)
  }
}
