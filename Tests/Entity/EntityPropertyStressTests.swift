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

class EntityPropertyStressTests: XCTestCase, GraphEntityDelegate {
  var saveExpectation: XCTestExpectation?
  
  var entityInsertExpectation: XCTestExpectation?
  var entityDeleteExpectation: XCTestExpectation?
  
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
    saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
    entityInsertExpectation = expectation(description: "[EntityPropertyStressTests Error: Entity insert test failed.]")
    
    let graph = Graph()
    let watch = Watch<Entity>(graph: graph).where(.type("T"))
    watch.delegate = self
    
    let entity = Entity("T")
    
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
      
      entity[property] = value
      
      XCTAssertEqual(value, entity[property] as? Int)
      
      saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
      propertyInsertExpception = expectation(description: "[EntityPropertyStressTests Error: Property insert test failed.]")
      
      graph.async { [weak self] (success, error) in
        XCTAssertTrue(success)
        XCTAssertNil(error)
        self?.saveExpectation?.fulfill()
      }
      
      waitForExpectations(timeout: 5, handler: nil)
      
      value += 1
      entity[property] = value
      
      XCTAssertEqual(value, entity[property] as? Int)
      
      saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
      propertyUpdateExpception = expectation(description: "[EntityPropertyStressTests Error: Property update test failed.]")
      
      graph.async { [weak self] (success, error) in
        XCTAssertTrue(success)
        XCTAssertNil(error)
        self?.saveExpectation?.fulfill()
      }
      
      waitForExpectations(timeout: 5, handler: nil)
      
      entity[property] = nil
      
      XCTAssertNil(entity[property])
      
      saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
      propertyDeleteExpception = expectation(description: "[EntityPropertyStressTests Error: Property delete test failed.]")
      
      graph.async { [weak self] (success, error) in
        self?.saveExpectation?.fulfill()
        XCTAssertTrue(success)
        XCTAssertNil(error)
      }
      
      waitForExpectations(timeout: 5, handler: nil)
    }
    
    saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
    entityDeleteExpectation = expectation(description: "[EntityPropertyStressTests Error: Entity delete test failed.]")
    
    entity.delete()
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, inserted entity: Entity, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual(0, entity.properties.count)
    
    entityInsertExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, deleted entity: Entity, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual(0, entity.properties.count)
    
    entityDeleteExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, entity: Entity, added property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    
    propertyInsertExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, entity: Entity, updated property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    
    propertyUpdateExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, entity: Entity, removed property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    
    propertyDeleteExpception?.fulfill()
  }
}
