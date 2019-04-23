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

class EntityGroupTests: XCTestCase, GraphEntityDelegate {
  var saveExpectation: XCTestExpectation?
  
  var tagAddExpception: XCTestExpectation?
  var tagUpdateExpception: XCTestExpectation?
  var tagRemoveExpception: XCTestExpectation?
  
  func testMemberOfUsingCondition() {
    let entity = Entity("G")
    entity.add(to: "G1", "G2", "G3")
    
    /// .and condition
    XCTAssertTrue(entity.member(of: ["G1", "G2", "G3"], using: .and))
    XCTAssertFalse(entity.member(of: ["G1", "G2", "G3", "G4"], using: .and))
    
    /// .or condition
    XCTAssertTrue(entity.member(of: ["G3", "G4", "G5", "G6"], using: .or))
    XCTAssertFalse(entity.member(of: ["G4", "G5", "G6", "G7"], using: .or))
  }
  
  func testGroupAdd() {
    saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
    tagAddExpception = expectation(description: "[EntityTests Error: Group add test failed.]")
    
    let graph = Graph()
    let watch = Watch<Entity>(graph: graph).where(.type("T") || .member(of: "G1"))
    watch.delegate = self
    
    let entity = Entity("T")
    entity.add(to: "G1")
    
    XCTAssertTrue(entity.member(of: "G1"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testGroupUpdate() {
    saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
    
    let graph = Graph()
    
    let entity = Entity("T")
    entity.add(to: "G2")
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
    tagAddExpception = expectation(description: "[EntityTests Error: Group add test failed.]")
    tagRemoveExpception = expectation(description: "[EntityTests Error: Group remove test failed.]")
    
    let watch = Watch<Entity>(graph: graph).where(.member(of: "G1", "G2"))
    watch.delegate = self
    
    entity.toggle(groups: "G1", "G2")
    
    XCTAssertTrue(entity.member(of: "G1"))
    XCTAssertFalse(entity.member(of: "G2"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testGroupDelete() {
    saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
    
    let graph = Graph()
    
    let entity = Entity("T")
    entity.add(to: "G2")
    
    XCTAssertTrue(entity.member(of: "G2"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
    tagRemoveExpception = expectation(description: "[EntityTests Error: Group remove test failed.]")
    
    let watch = Watch<Entity>(graph: graph).where(.member(of: "G2"))
    watch.delegate = self
    
    entity.remove(from: "G2")
    
    XCTAssertFalse(entity.member(of: "G2"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, entity: Entity, addedTo group: String, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual("G1", group)
    XCTAssertTrue(entity.member(of: ["asd", group], using: .or))
    XCTAssertEqual(1, entity.groups.count)
    XCTAssertTrue(entity.groups.contains(group))
    
    tagAddExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, entity: Entity, removedFrom group: String, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual("G2", group)
    XCTAssertFalse(entity.member(of: group))
    
    tagRemoveExpception?.fulfill()
  }
}
