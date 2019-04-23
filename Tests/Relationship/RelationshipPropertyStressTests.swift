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

class RelationshipPropertyStressTests: XCTestCase, GraphRelationshipDelegate {
  var saveExpectation: XCTestExpectation?
  
  var relationshipInsertExpectation: XCTestExpectation?
  var relationshipDeleteExpectation: XCTestExpectation?
  
  var propertyInsertExpception: XCTestExpectation?
  var propertyUpdateExpception: XCTestExpectation?
  var propertyDeleteExpception: XCTestExpectation?
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testPropertyStress() {
    saveExpectation = expectation(description: "[RelationshipPropertyStressTests Error: Graph save test failed.]")
    relationshipInsertExpectation = expectation(description: "[RelationshipPropertyStressTests Error: Relationship insert test failed.]")
    
    let graph = Graph()
    let watch = Watch<Relationship>(graph: graph).where(.type("T"))
    watch.delegate = self
    
    let relationship = Relationship("T")
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    var properties : [String] = []
    for i in 0..<100 {
      properties.append("P\(i)")
    }
    watch.where(.exists(properties))
    
    for i in 0..<100 {
      let property = "P\(i)"
      var value = i
      
      relationship[property] = value
      
      XCTAssertEqual(value, relationship[property] as? Int)
      
      saveExpectation = expectation(description: "[RelationshipPropertyStressTests Error: Graph save test failed.]")
      propertyInsertExpception = expectation(description: "[RelationshipPropertyStressTests Error: Property insert test failed.]")
      
      graph.async { [weak self] (success, error) in
        XCTAssertTrue(success)
        XCTAssertNil(error)
        self?.saveExpectation?.fulfill()
      }
      
      waitForExpectations(timeout: 5, handler: nil)
      
      value += 1
      relationship[property] = value
      
      XCTAssertEqual(value, relationship[property] as? Int)
      
      saveExpectation = expectation(description: "[RelationshipPropertyStressTests Error: Graph save test failed.]")
      propertyUpdateExpception = expectation(description: "[RelationshipPropertyStressTests Error: Property update test failed.]")
      
      graph.async { [weak self] (success, error) in
        XCTAssertTrue(success)
        XCTAssertNil(error)
        self?.saveExpectation?.fulfill()
      }
      
      waitForExpectations(timeout: 5, handler: nil)
      
      relationship[property] = nil
      
      XCTAssertNil(relationship[property])
      
      saveExpectation = expectation(description: "[RelationshipPropertyStressTests Error: Graph save test failed.]")
      propertyDeleteExpception = expectation(description: "[RelationshipPropertyStressTests Error: Property delete test failed.]")
      
      graph.async { [weak self] (success, error) in
        self?.saveExpectation?.fulfill()
        XCTAssertTrue(success)
        XCTAssertNil(error)
      }
      
      waitForExpectations(timeout: 5, handler: nil)
    }
    
    saveExpectation = expectation(description: "[RelationshipPropertyStressTests Error: Graph save test failed.]")
    relationshipDeleteExpectation = expectation(description: "[RelationshipPropertyStressTests Error: Relationship delete test failed.]")
    
    relationship.delete()
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, inserted relationship: Relationship, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual(0, relationship.properties.count)
    
    relationshipInsertExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, deleted relationship: Relationship, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual(0, relationship.properties.count)
    
    relationshipDeleteExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, added property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    
    propertyInsertExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, updated property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    
    propertyUpdateExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, removed property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    
    propertyDeleteExpception?.fulfill()
  }
}
