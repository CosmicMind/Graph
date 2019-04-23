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
import Foundation
@testable import Graph

class RelationshipCodableTests: XCTestCase {
  let array: [Any] = [-1, "2", [3, "4"], Decimal(12.34)]
  
  func testEncoder() {
    let relationship = Relationship("User", graph: "CodableGraph")
    relationship.name = "Orkhan"
    relationship.age = 20
    relationship.url = URL(string: "http://cosmicmind.com")!
    relationship.array = array
    relationship.dictionary = ["key": array]
    
    relationship.add(tags: ["Swift", "iOS"])
    relationship.add(to: ["Programming", "Religion"])
    
    guard let data = try? JSONEncoder().encode(relationship) else {
      XCTFail("[EntityCodableTests Error: Encoder failed to encode.]")
      return
    }
    
    guard let json = GraphJSON.parse(data) else {
      XCTFail("[EntityCodableTests Error: Failed to create GraphJSON.]")
      return
    }
    
    XCTAssertEqual(json.type.asString, "User")
    XCTAssertEqual((json.tags.object as? [String]).map { Set($0) }, Set(["Swift", "iOS"]))
    XCTAssertEqual((json.groups.object as? [String]).map { Set($0) }, Set(["Programming", "Religion"]))
    XCTAssertEqual(json.properties.name.asString, "Orkhan")
    XCTAssertEqual(json.properties.age.asInt, 20)
    XCTAssertEqual(json.properties.url.asString, "http://cosmicmind.com")
    XCTAssert((json.properties.array.object as? NSArray)?.isEqual(to: array) == true)
    XCTAssert((json.properties.dictionary.object as? NSDictionary)?.isEqual(to: ["key": array]) == true)
  }
  
  func testDecoder() {
    let json = """
      {
        "type" : "User",
        "groups" : [
          "Programming",
          "Religion"
        ],
        "tags" : [
          "Swift",
          "iOS"
        ],
        "properties" : {
          "age" : 20,
          "name" : "Orkhan",
          "array": [-1, "2", [3, "4"], 12.34],
          "dictionary": { "key": [-1, "2", [3, "4"], 12.34] }
        }
      }
      """
    
    guard let data = json.data(using: .utf8) else {
      XCTFail("[EntityCodableTests Error: Failed to create Data from json string.]")
      return
    }
    let decoder = JSONDecoder()
    decoder.userInfo[.graph] = "CodableGraph"
    guard let relationship = try? decoder.decode(Relationship.self, from: data) else {
      XCTFail("[EntityCodableTests Error: Decoder failed to decode.]")
      return
    }
    
    XCTAssertEqual(relationship.type, "User")
    XCTAssertTrue(relationship.has(tags: ["iOS", "Swift"]))
    XCTAssertTrue(relationship.member(of: ["Programming", "Religion"]))
    XCTAssertEqual(relationship.name as? String, "Orkhan")
    XCTAssertEqual(relationship.age as? Int, 20)
    XCTAssert((relationship.array as? NSArray)?.isEqual(to: array) == true)
    XCTAssert((relationship.dictionary as? NSDictionary)?.isEqual(to: ["key": array]) == true)
  }
}
