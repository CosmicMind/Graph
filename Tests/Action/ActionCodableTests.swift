/*
 * Copyright (C) 2015 - 2019, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  * Neither the name of CosmicMind nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
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
import Foundation
@testable import Graph

class ActionCodableTests: XCTestCase {
  let array: [Any] = [-1, "2", [3, "4"], Decimal(12.34)]
  
  func testEncoder() {
    let action = Action("User", graph: "CodableGraph")
    action.name = "Orkhan"
    action.age = 20
    action.url = URL(string: "http://cosmicmind.com")!
    action.array = array
    action.dictionary = ["key": array]
    
    action.add(tags: ["Swift", "iOS"])
    action.add(to: ["Programming", "Religion"])
    
    guard let data = try? JSONEncoder().encode(action) else {
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
    guard let action = try? decoder.decode(Action.self, from: data) else {
      XCTFail("[EntityCodableTests Error: Decoder failed to decode.]")
      return
    }
    
    XCTAssertEqual(action.type, "User")
    XCTAssertTrue(action.has(tags: ["iOS", "Swift"]))
    XCTAssertTrue(action.member(of: ["Programming", "Religion"]))
    XCTAssertEqual(action.name as? String, "Orkhan")
    XCTAssertEqual(action.age as? Int, 20)
    XCTAssert((action.array as? NSArray)?.isEqual(to: array) == true)
    XCTAssert((action.dictionary as? NSDictionary)?.isEqual(to: ["key": array]) == true)
  }
}
