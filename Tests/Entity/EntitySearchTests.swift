/*
 * Copyright (C) 2015 - 2019, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
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
 *	*	Neither the name of CosmicMind nor the names of its
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

import XCTest
@testable import Graph

class EntitySearchTests : XCTestCase {
  var testExpectation: XCTestExpectation?
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func searchTest(search: Search<Entity>, count: Int) {
    XCTAssertEqual(count, search.sync().count)
    
    testExpectation = expectation(description: "[EntitySearchTests Error: Test failed.]")
    
    search.sync {
      XCTAssertEqual(count, $0.count)
      self.testExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    testExpectation = expectation(description: "[EntitySearchTests Error: Test failed.]")
    
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
      let n = Entity("T1")
      n["P1"] = "V2"
      n.add(tags: "Q1")
      n.add(to: "G1")
    }
    
    for _ in 0..<200 {
      let n = Entity("T2")
      n["P2"] = "V2"
      n.add(tags: "Q2")
      n.add(to: "G2")
    }
    
    for _ in 0..<300 {
      let n = Entity("T3")
      n["P3"] = "V3"
      n.add(tags: "Q3")
      n.add(to: "G3")
    }
    
    graph.sync { (success, error) in
      XCTAssertTrue(success, "\(String(describing: error))")
    }
    
    let search = Search<Entity>(graph: graph)
    
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
      let n1 = Entity("T1")
      n1["P1"] = 1
      n1.add(tags: "Q1")
      n1.add(to: "G1")
    }
    
    graph.sync { (success, error) in
      XCTAssertTrue(success, "\(String(describing: error))")
    }
    
    let search = Search<Entity>(graph: graph)
    measure { [search = search] in
      XCTAssertEqual(1000, search.clear().where(.type("T1") && .has(tags: "Q1") && .member(of: "G1") && .exists("P1")).sync().count)
    }
    
    graph.clear()
  }
}
