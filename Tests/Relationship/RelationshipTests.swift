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

class RelationshipTests: XCTestCase, GraphRelationshipDelegate {
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
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[RelationshipTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[RelationshipTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Relationship>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let relationship = Relationship("T")
    relationship["P"] = "V"
    relationship.add(tags: "G")
    
    XCTAssertEqual("V", relationship["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testNamedGraphSave() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[RelationshipTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[RelationshipTests Error: Property test failed.]")
    
    let graph = Graph(name: "RelationshipTests-testNamedGraphSave")
    let watch = Watch<Relationship>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let relationship = Relationship("T", graph: "RelationshipTests-testNamedGraphSave")
    relationship["P"] = "V"
    relationship.add(tags: "G")
    
    XCTAssertEqual("V", relationship["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testReferenceGraphSave() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[RelationshipTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[RelationshipTests Error: Property test failed.]")
    
    let graph = Graph(name: "RelationshipTests-testReferenceGraphSave")
    let watch = Watch<Relationship>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let relationship = Relationship("T", graph: graph)
    relationship["P"] = "V"
    relationship.add(tags: "G")
    
    XCTAssertEqual("V", relationship["P"] as? String)
    
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
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[RelationshipTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[RelationshipTests Error: Property test failed.]")
    
    let graph = Graph(name: "RelationshipTests-testAsyncGraphSave")
    let watch = Watch<Relationship>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let relationship = Relationship("T", graph: graph)
    relationship["P"] = "V"
    relationship.add(tags: "G")
    
    XCTAssertEqual("V", relationship["P"] as? String)
    
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
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[RelationshipTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[RelationshipTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Relationship>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let subject = Entity("S")
    let object = Entity("O")
    
    let relationship = subject.is(relationship: "T").of(object)
    relationship["P"] = "V"
    relationship.add(tags: "G")
    
    XCTAssertEqual("V", relationship["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      XCTAssertNotNil(relationship.subject)
      XCTAssertNotNil(relationship.object)
      XCTAssertNotNil(relationship.subject)
      XCTAssertNotNil(relationship.object)
      XCTAssertEqual(subject, relationship.subject)
      XCTAssertEqual(1, relationship.subject?.relationships.count)
      XCTAssertEqual(object, relationship.object)
      XCTAssertEqual(1, relationship.object?.relationships.count)
      
      self?.saveExpectation?.fulfill()
    }
    
    XCTAssertNotNil(relationship.subject)
    XCTAssertNotNil(relationship.object)
    XCTAssertEqual(subject, relationship.subject)
    XCTAssertEqual(1, relationship.subject?.relationships.count)
    XCTAssertEqual(object, relationship.object)
    XCTAssertEqual(1, relationship.object?.relationships.count)
    
    waitForExpectations(timeout: 5, handler: nil)
    
    relationship.delete()
    
    XCTAssertNil(relationship.subject)
    XCTAssertNil(relationship.subject?.relationships.count)
    XCTAssertNil(relationship.object)
    XCTAssertNil(relationship.object?.relationships.count)
    
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[RelationshipTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[RelationshipTests Error: Property test failed.]")
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(relationship.subject)
      XCTAssertNil(relationship.object)
      XCTAssertNotEqual(subject, relationship.subject)
      XCTAssertNotEqual(object, relationship.object)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testSubject() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[RelationshipTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[RelationshipTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Relationship>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let relationship = Relationship("T")
    relationship["P"] = "V"
    relationship.add(tags: "G")
    
    XCTAssertEqual("V", relationship["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    
    let subject = Entity("T")
    relationship.subject = subject
    
    XCTAssertEqual(subject, relationship.subject)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    XCTAssertEqual(subject, relationship.subject)
    XCTAssertEqual(1, relationship.subject?.relationships.count)
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testObject() {
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[RelationshipTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[RelationshipTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Relationship>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let relationship = Relationship("T")
    relationship["P"] = "V"
    relationship.add(tags: "G")
    
    XCTAssertEqual("V", relationship["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[RelationshipTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[RelationshipTests Error: Delegate test failed.]")
    
    let object = Entity("T")
    relationship.object = object
    
    XCTAssertEqual(object, relationship.object)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    XCTAssertEqual(object, relationship.object)
    XCTAssertEqual(1, relationship.object?.relationships.count)
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, inserted relationship: Relationship, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual("V", relationship["P"] as? String)
    XCTAssertTrue(relationship.has(tags: "G"))
    
    delegateExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, updated relationship: Relationship, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual("V", relationship["P"] as? String)
    XCTAssertTrue(relationship.has(tags: "G"))
    
    delegateExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, deleted relationship: Relationship, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertNil(relationship["P"])
    XCTAssertFalse(relationship.has(tags: "G"))
    XCTAssertNil(relationship.subject)
    XCTAssertNil(relationship.subject?.relationships.count)
    XCTAssertNil(relationship.object)
    XCTAssertNil(relationship.object?.relationships.count)
    
    delegateExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, added tag: String, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual("G", tag)
    XCTAssertTrue(relationship.has(tags: tag))
    
    tagExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, removed tag: String, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual("G", tag)
    XCTAssertFalse(relationship.has(tags: tag))
    
    tagExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, added property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual("V", value as? String)
    XCTAssertEqual(value as? String, relationship[property] as? String)
    
    propertyExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, updated property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual("V", value as? String)
    XCTAssertEqual(value as? String, relationship[property] as? String)
    
    propertyExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, relationship: Relationship, removed property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == relationship.type)
    XCTAssertTrue(0 < relationship.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual("V", value as? String)
    XCTAssertNil(relationship["P"])
    
    propertyExpception?.fulfill()
  }
}
