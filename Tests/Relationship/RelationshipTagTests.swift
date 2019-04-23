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

class RelationshipTagTests: XCTestCase, GraphRelationshipDelegate {
  var saveExpectation: XCTestExpectation?
  
  var tagAddExpception: XCTestExpectation?
  var tagUpdateExpception: XCTestExpectation?
  var tagRemoveExpception: XCTestExpectation?
  
  func testHasTagsUsingCondition() {
    let relationship = Relationship("T")
    relationship.add(tags: "T1", "T2", "T3")
    
    /// .and condition
    XCTAssertTrue(relationship.has(tags: ["T1", "T2", "T3"], using: .and))
    XCTAssertFalse(relationship.has(tags: ["T1", "T2", "T3", "T4"], using: .and))
    
    /// .or condition
    XCTAssertTrue(relationship.has(tags: ["T3", "T4", "T5", "T6"], using: .or))
    XCTAssertFalse(relationship.has(tags: ["T4", "T5", "T6", "T7"], using: .or))
    
    relationship.delete()
  }
  
  func testTagAdd() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    tagAddExpception = expectation(description: "[RelationshipTests Error: Tag add test failed.]")
    
    let graph = Graph()
    let watch = Watch<Relationship>(graph: graph).where(.type("T") || .has(tags: "G1"))
    watch.delegate = self
    
    let relationship = Relationship("T")
    relationship.add(tags: "G1")
    
    XCTAssertTrue(relationship.has(tags: "G1"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testTagUpdate() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    
    let graph = Graph()
    
    let relationship = Relationship("T")
    relationship.add(tags: "G2")
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    tagAddExpception = expectation(description: "[RelationshipTests Error: Tag add test failed.]")
    tagRemoveExpception = expectation(description: "[RelationshipTests Error: Tag remove test failed.]")
    
    let watch = Watch<Relationship>(graph: graph).where(.has(tags: ["G1", "G2"]))
    watch.delegate = self
    
    relationship.toggle(tags: "G1", "G2")
    
    XCTAssertTrue(relationship.has(tags: "G1"))
    XCTAssertFalse(relationship.has(tags: "G2"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testTagDelete() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    
    let graph = Graph()
    
    let relationship = Relationship("T")
    relationship.add(tags: "G2")
    
    XCTAssertTrue(relationship.has(tags: "G2"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    tagRemoveExpception = expectation(description: "[RelationshipTests Error: Tag remove test failed.]")
    
    let watch = Watch<Relationship>(graph: graph).where(.has(tags: ["G2"]))
    watch.delegate = self
    
    relationship.remove(tags: "G2")
    
    XCTAssertFalse(relationship.has(tags: "G2"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, relationship: Relationship, added tag: String, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual("G1", tag)
    XCTAssertTrue(relationship.has(tags: tag))
    XCTAssertEqual(1, relationship.tags.count)
    XCTAssertTrue(relationship.tags.contains(tag))
    
    tagAddExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, removed tag: String, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual("G2", tag)
    XCTAssertFalse(relationship.has(tags: tag))
    
    tagRemoveExpception?.fulfill()
  }
}
