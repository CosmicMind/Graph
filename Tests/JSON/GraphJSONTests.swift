/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
    XCTAssertNil(GraphJSON.stringify(("unsupported top level object", "e.g tuple")))
    XCTAssertNil(GraphJSON.stringify([("unsupported top level object", "e.g tuple")]))
    XCTAssertEqual(GraphJSON.stringify([]), "[]")
    XCTAssertEqual(GraphJSON.stringify([:]), "{}")
    XCTAssertEqual(GraphJSON.stringify([1, 2, "3", nil, true, false]), "[1,2,\"3\",null,true,false]")
    XCTAssertEqual(GraphJSON.stringify(["user": "orkhan"]), "{\"user\":\"orkhan\"}")
    
    XCTAssertEqual(GraphJSON.stringify(NSNull()), "null")
    XCTAssertEqual(GraphJSON.stringify(1), "1")
    XCTAssertEqual(GraphJSON.stringify("string"), "string")
    XCTAssertEqual(GraphJSON.stringify(true), "true")
  }
  
  func testEquatableAndSequence() {
    let a = GraphJSON([1, true, "Graph", [:]])
    let b = GraphJSON([1, true, "Graph", [:]])
    XCTAssertEqual(a, b)
    
    for (left, right) in zip(a, b) {
      XCTAssertEqual(left, right)
    }
    
    XCTAssertEqual(GraphJSON.isNil, .isNil)
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
  
  func testWrite() {
    guard var json = GraphJSON.parse(testJSONString) else {
      XCTFail("testJSONString is not parsed successfully")
      return
    }
    
    /// String literal
    json.anything = "String literal"
    XCTAssertEqual(json.anything.asString, "String literal")
    
    /// Integer literal
    json.anything = 12345
    XCTAssertEqual(json.anything.asInt, 12345)
    
    /// Float literal
    json.anything = 1.2345
    XCTAssertEqual(json.anything.asDouble, 1.2345)
    
    /// Nil literal
    json.anything = nil
    XCTAssertEqual(json.anything, .isNil)
    
    /// Boolean literal
    json.anything = true
    XCTAssertEqual(json.anything.asBool, true)
    
    /// Dictionary literal
    json.anything = ["key": "value"]
    XCTAssert((json.anything.object as? NSDictionary)?.isEqual(["key": "value"]) == true)
    
    /// Array literal
    json.anything = [1, 2]
    XCTAssertEqual(json.anything.object as? [Int], [1, 2])
    
    /// Array index
    json.skills[0] = "javascript"
    XCTAssertEqual(json.skills[0].asString, "javascript")
    
    /// Deeply nested value
    json.anything = ["go": ["deep": ["and": ["set": "value"]]]]
    XCTAssertEqual(json.anything.go.deep.and.set.asString, "value")
    
    json.anything.go.deep.and.set = "new value"
    XCTAssertEqual(json.anything.go.deep.and.set.asString, "new value")
    
    json.anything.go.deep.newKey = "new value for key"
    XCTAssertEqual(json.anything.go.deep.newKey, "new value for key")
    
    /// GraphJSON
    json.anything = json.age
    XCTAssertEqual(json.anything.asInt, 20)
    XCTAssertEqual(json.anything, json.age)    
  }
}
