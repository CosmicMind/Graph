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

class RelationshipPropertyTests: XCTestCase, GraphRelationshipDelegate {
  var saveExpectation: XCTestExpectation?
  
  var propertyInsertExpception: XCTestExpectation?
  var propertyUpdateExpception: XCTestExpectation?
  var propertyDeleteExpception: XCTestExpectation?
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testPropertyInsert() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    propertyInsertExpception = expectation(description: "[RelationshipTests Error: Property insert test failed.]")
    
    let graph = Graph()
    let watch = Watch<Relationship>(graph: graph).where(.exists("P1"))
    watch.delegate = self
    
    let relationship = Relationship("T")
    relationship["P1"] = "V1"
    
    XCTAssertEqual("V1", relationship["P1"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testPropertyUpdate() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    
    let graph = Graph()
    
    let relationship = Relationship("T")
    relationship["P1"] = "V1"
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    propertyUpdateExpception = expectation(description: "[RelationshipTests Error: Property update test failed.]")
    
    let watch = Watch<Relationship>(graph: graph).where(.exists("P1"))
    watch.delegate = self
    
    relationship["P1"] = "V2"
    
    XCTAssertEqual("V2", relationship["P1"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testPropertyDelete() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    
    let graph = Graph()
    
    let relationship = Relationship("T")
    relationship["P1"] = "V1"
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
    propertyDeleteExpception = expectation(description: "[RelationshipTests Error: Property delete test failed.]")
    
    let watch = Watch<Relationship>(graph: graph).where(.exists("P1"))
    watch.delegate = self
    
    relationship["P1"] = nil
    
    XCTAssertNil(relationship["P1"])
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, relationship: Relationship, added property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    
    XCTAssertEqual("P1", property)
    XCTAssertEqual("V1", value as? String)
    XCTAssertEqual(value as? String, relationship[property] as? String)
    
    propertyInsertExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, updated property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    
    XCTAssertEqual("P1", property)
    XCTAssertEqual("V2", value as? String)
    XCTAssertEqual(value as? String, relationship[property] as? String)
    
    propertyUpdateExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, removed property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    
    XCTAssertEqual("P1", property)
    XCTAssertEqual("V1", value as? String)
    XCTAssertNil(relationship[property])
    
    propertyDeleteExpception?.fulfill()
  }
}
