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

class EntityTests: XCTestCase, GraphEntityDelegate {
  var saveExpectation: XCTestExpectation?
  var delegateExpectation: XCTestExpectation?
  var tagExpception: XCTestExpectation?
  var propertyExpception: XCTestExpectation?
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testDefaultGraph() {
    saveExpectation = expectation(description: "[EntityTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[EntityTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[EntityTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[EntityTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Entity>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let entity = Entity("T")
    entity["P"] = "V"
    entity.add(tags: "G")
    
    XCTAssertEqual("V", entity["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testNamedGraphSave() {
    saveExpectation = expectation(description: "[EntityTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[EntityTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[EntityTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[EntityTests Error: Property test failed.]")
    
    let graph = Graph(name: "EntityTests-testNamedGraphSave")
    let watch = Watch<Entity>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let entity = Entity("T", graph: "EntityTests-testNamedGraphSave")
    entity["P"] = "V"
    entity.add(tags: "G")
    
    XCTAssertEqual("V", entity["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testReferenceGraphSave() {
    saveExpectation = expectation(description: "[EntityTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[EntityTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[EntityTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[EntityTests Error: Property test failed.]")
    
    let graph = Graph(name: "EntityTests-testReferenceGraphSave")
    let watch = Watch<Entity>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let entity = Entity("T", graph: graph)
    entity["P"] = "V"
    entity.add(tags: "G")
    
    XCTAssertEqual("V", entity["P"] as? String)
    
    DispatchQueue.global(qos: .background).async { [weak self] in
      graph.async { [weak self] (success, error) in
        XCTAssertTrue(success)
        XCTAssertNil(error)
        self?.saveExpectation?.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testAsyncGraphSave() {
    saveExpectation = expectation(description: "[EntityTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[EntityTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[EntityTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[EntityTests Error: Property test failed.]")
    
    let graph = Graph(name: "EntityTests-testAsyncGraphSave")
    let watch = Watch<Entity>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let entity = Entity("T", graph: graph)
    entity["P"] = "V"
    entity.add(tags: "G")
    
    XCTAssertEqual("V", entity["P"] as? String)
    
    DispatchQueue.global(qos: .background).async { [weak self] in
      graph.async { [weak self] (success, error) in
        XCTAssertTrue(success)
        XCTAssertNil(error)
        self?.saveExpectation?.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testAsyncGraphDelete() {
    saveExpectation = expectation(description: "[EntityTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[EntityTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[EntityTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[EntityTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Entity>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let entity = Entity("T")
    entity["P"] = "V"
    entity.add(tags: "G")
    
    XCTAssertEqual("V", entity["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    entity.delete()
    
    saveExpectation = expectation(description: "[EntityTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[EntityTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[EntityTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[EntityTests Error: Property test failed.]")
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, inserted entity: Entity, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual("V", entity["P"] as? String)
    XCTAssertTrue(entity.has(tags: "G"))
    
    delegateExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, deleted entity: Entity, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertNil(entity["P"])
    XCTAssertFalse(entity.has(tags: "G"))
    
    delegateExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, entity: Entity, added tag: String, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual("G", tag)
    XCTAssertTrue(entity.has(tags: tag))
    
    tagExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, entity: Entity, removed tag: String, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual("G", tag)
    XCTAssertFalse(entity.has(tags: tag))
    
    tagExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, entity: Entity, added property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual("V", value as? String)
    XCTAssertEqual(value as? String, entity[property] as? String)
    
    propertyExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, entity: Entity, updated property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual("V", value as? String)
    XCTAssertEqual(value as? String, entity[property] as? String)
    
    propertyExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, entity: Entity, removed property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == entity.type)
    XCTAssertTrue(0 < entity.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual("V", value as? String)
    XCTAssertNil(entity["P"])
    
    propertyExpception?.fulfill()
  }
}
