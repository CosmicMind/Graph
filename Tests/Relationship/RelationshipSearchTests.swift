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

class RelationshipSearchTests : XCTestCase {
  var testExpectation: XCTestExpectation?
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func searchTest(search: Search<Relationship>, count: Int) {
    XCTAssertEqual(count, search.sync().count)
    
    testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
    
    search.sync { [weak self, count = count] in
      XCTAssertEqual(count, $0.count)
      self?.testExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
    
    search.async { [weak self, count = count] in
      XCTAssertEqual(count, $0.count)
      self?.testExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testAll() {
    let graph = Graph()
    graph.clear()
    
    for _ in 0..<100 {
      let n = Relationship("T1")
      n["P1"] = "V2"
      n.add(tags: "Q1")
      n.add(to: "G1")
    }
    
    for _ in 0..<200 {
      let n = Relationship("T2")
      n["P2"] = "V2"
      n.add(tags: "Q2")
      n.add(to: "G2")
    }
    
    for _ in 0..<300 {
      let n = Relationship("T3")
      n["P3"] = "V3"
      n.add(tags: "Q3")
      n.add(to: "G3")
    }
    
    graph.sync { (success, error) in
      XCTAssertTrue(success, "\(String(describing: error))")
    }
    
    let search = Search<Relationship>(graph: graph)
    
    searchTest(search: search.clear().where(.type([])), count: 0)
    searchTest(search: search.clear().where(.type([], using: ||)), count: 0)
    searchTest(search: search.clear().where(.type([], using: &&)), count: 0)
    searchTest(search: search.clear().where(.has(tags: [])), count: 0)
    searchTest(search: search.clear().where(.has(tags: [], using: ||)), count: 0)
    searchTest(search: search.clear().where(.has(tags: [], using: &&)), count: 0)
    searchTest(search: search.clear().where(.member(of: [])), count: 0)
    searchTest(search: search.clear().where(.member(of: [], using: ||)), count: 0)
    searchTest(search: search.clear().where(.member(of: [], using: &&)), count: 0)
    searchTest(search: search.clear().where(.exists("")), count: 0)
    searchTest(search: search.clear().where(.exists("", using: ||)), count: 0)
    searchTest(search: search.clear().where(.exists("", using: &&)), count: 0)
    
    searchTest(search: search.clear().where(.type(["NONE"])), count: 0)
    searchTest(search: search.clear().where(.type("T1")), count: 100)
    searchTest(search: search.clear().where(.type("T1", "T2")), count: 300)
    searchTest(search: search.clear().where(.type("T1", "T2", using: ||)), count: 300)
    searchTest(search: search.clear().where(.type("T1", "T2", using: &&)), count: 0)
    searchTest(search: search.clear().where(.type("T1" || "T2" || "T3")), count: 600)
    searchTest(search: search.clear().where(.type("T1" && "T2" && "T3")), count: 0)
    searchTest(search: search.clear().where(.type("*")), count: 600)
    
    searchTest(search: search.clear().where(.has(tags: "NONE")), count: 0)
    searchTest(search: search.clear().where(.has(tags: "Q1")), count: 100)
    searchTest(search: search.clear().where(.has(tags: "Q1", "Q2")), count: 300)
    searchTest(search: search.clear().where(.has(tags: "Q1", "Q2", using: ||)), count: 300)
    searchTest(search: search.clear().where(.has(tags: "Q1", "Q2", using: &&)), count: 0)
    searchTest(search: search.clear().where(.has(tags: "Q1" || "Q2" || "Q3")), count: 600)
    searchTest(search: search.clear().where(.has(tags: "Q1" && "Q3" && "Q3")), count: 0)
    searchTest(search: search.clear().where(.has(tags: "*")), count: 600)
    
    searchTest(search: search.clear().where(.member(of: "NONE")), count: 0)
    searchTest(search: search.clear().where(.member(of: "G1")), count: 100)
    searchTest(search: search.clear().where(.member(of: "G1", "G2")), count: 300)
    searchTest(search: search.clear().where(.member(of: "G1", "G2", using: ||)), count: 300)
    searchTest(search: search.clear().where(.member(of: "G1", "G2", using: &&)), count: 0)
    searchTest(search: search.clear().where(.member(of: "G1" || "G2" || "G3")), count: 600)
    searchTest(search: search.clear().where(.member(of: "G1" && "G3" && "G3")), count: 0)
    searchTest(search: search.clear().where(.member(of: "*")), count: 600)
    
    searchTest(search: search.clear().where(.exists("NONE")), count: 0)
    searchTest(search: search.clear().where(.exists("P1")), count: 100)
    searchTest(search: search.clear().where(.exists("P1", "P2")), count: 300)
    searchTest(search: search.clear().where(.exists("P1", "P2", using: ||)), count: 300)
    searchTest(search: search.clear().where(.exists("P1", "P2", using: &&)), count: 0)
    searchTest(search: search.clear().where(.exists("P1" || "P2" || "P3")), count: 600)
    searchTest(search: search.clear().where(.exists("P1" && "P3" && "P3")), count: 0)
    searchTest(search: search.clear().where(.exists("*")), count: 600)
    
    graph.clear()
  }
  
  func testPerformance() {
    let graph = Graph()
    graph.clear()
    
    for _ in 0..<1000 {
      let n1 = Relationship("T1")
      n1["P1"] = 1
      n1.add(tags: "Q1")
      n1.add(to: "G1")
    }
    
    graph.sync { (success, error) in
      XCTAssertTrue(success, "\(String(describing: error))")
    }
    
    let search = Search<Relationship>(graph: graph)
    
    measure { [search = search] in
      XCTAssertEqual(1000, search.clear().where(.type("T1") && .has(tags: "Q1") && .member(of: "G1") && .exists("P1")).sync().count)
    }
    
    graph.clear()
  }
}
