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

class ActionTests: XCTestCase, GraphActionDelegate {
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
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[ActionTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[ActionTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[ActionTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Action>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let action = Action("T")
    action["P"] = "V"
    action.add(tags: "G")
    
    XCTAssertEqual("V", action["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testNamedGraphSave() {
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[ActionTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[ActionTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[ActionTests Error: Property test failed.]")
    
    let graph = Graph(name: "ActionTests-testNamedGraphSave")
    let watch = Watch<Action>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let action = Action("T", graph: "ActionTests-testNamedGraphSave")
    action["P"] = "V"
    action.add(tags: "G")
    
    XCTAssertEqual("V", action["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testReferenceGraphSave() {
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[ActionTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[ActionTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[ActionTests Error: Property test failed.]")
    
    let graph = Graph(name: "ActionTests-testReferenceGraphSave")
    let watch = Watch<Action>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let action = Action("T", graph: graph)
    action["P"] = "V"
    action.add(tags: "G")
    
    XCTAssertEqual("V", action["P"] as? String)
    
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
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[ActionTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[ActionTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[ActionTests Error: Property test failed.]")
    
    let graph = Graph(name: "ActionTests-testAsyncGraphSave")
    let watch = Watch<Action>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let action = Action("T", graph: graph)
    action["P"] = "V"
    action.add(tags: "G")
    
    XCTAssertEqual("V", action["P"] as? String)
    
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
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[ActionTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[ActionTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[ActionTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Action>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let action = Action("T")
    action.add(subjects: Entity("T"), Entity("T"))
    action.add(objects: Entity("T"), Entity("T"))
    action["P"] = "V"
    action.add(tags: "G")
    
    XCTAssertEqual(2, action.subjects.count)
    XCTAssertEqual(2, action.objects.count)
    
    XCTAssertEqual("V", action["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    action.delete()
    
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[ActionTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[ActionTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[ActionTests Error: Property test failed.]")
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testSubjects() {
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[ActionTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[ActionTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[ActionTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Action>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let action = Action("T")
    action["P"] = "V"
    action.add(tags: "G")
    
    XCTAssertEqual("V", action["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    
    action.add(subjects: [Entity("T"), Entity("T"), Entity("T"), Entity("T")])
    
    XCTAssertEqual(4, action.subjects.count)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testObjects() {
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    delegateExpectation = expectation(description: "[ActionTests Error: Delegate test failed.]")
    tagExpception = expectation(description: "[ActionTests Error: Tag test failed.]")
    propertyExpception = expectation(description: "[ActionTests Error: Property test failed.]")
    
    let graph = Graph()
    let watch = Watch<Action>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let action = Action("T")
    action["P"] = "V"
    action.add(tags: "G")
    
    XCTAssertEqual("V", action["P"] as? String)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[ActionTests Error: Save test failed.]")
    
    action.add(objects: [Entity("T"), Entity("T"), Entity("T"), Entity("T")])
    
    XCTAssertEqual(4, action.objects.count)
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, inserted action: Action, source: GraphSource) {
    XCTAssertTrue("T" == action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("V", action["P"] as? String)
    XCTAssertTrue(action.has(tags: "G"))
    
    delegateExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, deleted action: Action, source: GraphSource) {
    XCTAssertTrue("T" == action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertNil(action["P"])
    XCTAssertFalse(action.has(tags: "G"))
    XCTAssertEqual(2, action.subjects.count)
    XCTAssertEqual(2, action.objects.count)
    XCTAssertEqual(1, action.subjects.first?.actionsWhenSubject.count)
    XCTAssertEqual(1, action.subjects.last?.actionsWhenSubject.count)
    XCTAssertEqual(1, action.objects.first?.actionsWhenObject.count)
    XCTAssertEqual(1, action.objects.last?.actionsWhenObject.count)
    
    delegateExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, added tag: String, source: GraphSource) {
    XCTAssertTrue("T" == action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("G", tag)
    XCTAssertTrue(action.has(tags: tag))
    
    tagExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, removed tag: String, source: GraphSource) {
    XCTAssertTrue("T" == action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("G", tag)
    XCTAssertFalse(action.has(tags: tag))
    
    tagExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, added property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual("V", value as? String)
    XCTAssertEqual(value as? String, action[property] as? String)
    
    propertyExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, updated property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual("V", value as? String)
    XCTAssertEqual(value as? String, action[property] as? String)
    
    propertyExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, removed property: String, with value: Any, source: GraphSource) {
    XCTAssertTrue("T" == action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual("V", value as? String)
    XCTAssertNil(action["P"])
    
    propertyExpception?.fulfill()
  }
}
