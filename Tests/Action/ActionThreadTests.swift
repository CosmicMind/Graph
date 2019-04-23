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

class ActionThreadTests : XCTestCase, GraphActionDelegate {
  var insertSaveExpectation: XCTestExpectation?
  var insertExpectation: XCTestExpectation?
  var insertPropertyExpectation: XCTestExpectation?
  var insertTagExpectation: XCTestExpectation?
  var updateSaveExpectation: XCTestExpectation?
  var updatePropertyExpectation: XCTestExpectation?
  var deleteSaveExpectation: XCTestExpectation?
  var deleteExpectation: XCTestExpectation?
  var deletePropertyExpectation: XCTestExpectation?
  var deleteTagExpectation: XCTestExpectation?
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testAll() {
    insertSaveExpectation = expectation(description: "Test: Save did not pass.")
    insertExpectation = expectation(description: "Test: Insert did not pass.")
    insertPropertyExpectation = expectation(description: "Test: Insert property did not pass.")
    insertTagExpectation = expectation(description: "Test: Insert tag did not pass.")
    
    let q1 = DispatchQueue(label: "com.cosmicmind.graph.thread.1", attributes: .concurrent)
    let q2 = DispatchQueue(label: "com.cosmicmind.graph.thread.2", attributes: .concurrent)
    let q3 = DispatchQueue(label: "com.cosmicmind.graph.thread.3", attributes: .concurrent)
    
    let graph = Graph()
    let watch = Watch<Action>(graph: graph).where(.type("T") || .has(tags: "G") || .exists("P"))
    watch.delegate = self
    
    let action = Action("T")
    
    q1.async { [weak self] in
      action["P"] = 111
      action.add(tags: "G")
      
      graph.async { [weak self] (success, error) in
        XCTAssertTrue(success, "\(String(describing: error))")
        self?.insertSaveExpectation?.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    updateSaveExpectation = expectation(description: "Test: Save did not pass.")
    updatePropertyExpectation = expectation(description: "Test: Update did not pass.")
    
    q2.async { [weak self] in
      action["P"] = 222
      
      graph.async { [weak self] (success, error) in
        XCTAssertTrue(success, "\(String(describing: error))")
        self?.updateSaveExpectation?.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    deleteSaveExpectation = expectation(description: "Test: Save did not pass.")
    deleteExpectation = expectation(description: "Test: Delete did not pass.")
    deletePropertyExpectation = expectation(description: "Test: Delete property did not pass.")
    deleteTagExpectation = expectation(description: "Test: Delete tag did not pass.")
    
    q3.async { [weak self] in
      action.delete()
      
      graph.async { [weak self] (success, error) in
        XCTAssertTrue(success, "\(String(describing: error))")
        self?.deleteSaveExpectation?.fulfill()
      }
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, inserted action: Action, source: GraphSource) {
    XCTAssertEqual("T", action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual(111, action["P"] as? Int)
    XCTAssertTrue(action.has(tags: "G"))
    
    insertExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, deleted action: Action, source: GraphSource) {
    XCTAssertEqual("T", action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertNil(action["P"])
    XCTAssertFalse(action.has(tags: "G"))
    
    deleteExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, added tag: String, source: GraphSource) {
    XCTAssertEqual("T", action.type)
    XCTAssertEqual("G", tag)
    XCTAssertTrue(action.has(tags: tag))
    
    insertTagExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, removed tag: String, source: GraphSource) {
    XCTAssertEqual("T", action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("G", tag)
    XCTAssertFalse(action.has(tags: "G"))
    
    deleteTagExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, added property: String, with value: Any, source: GraphSource) {
    XCTAssertEqual("T", action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual(111, value as? Int)
    XCTAssertEqual(value as? Int, action[property] as? Int)
    
    insertPropertyExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, updated property: String, with value: Any, source: GraphSource) {
    XCTAssertEqual("T", action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual(222, value as? Int)
    XCTAssertEqual(value as? Int, action[property] as? Int)
    
    updatePropertyExpectation?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, removed property: String, with value: Any, source: GraphSource) {
    XCTAssertEqual("T", action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("P", property)
    XCTAssertEqual(222, value as? Int)
    XCTAssertNil(action[property])
    
    deletePropertyExpectation?.fulfill()
  }
}
