/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

class ActionTagTests: XCTestCase, GraphActionDelegate {
  var saveExpectation: XCTestExpectation?
  
  var tagAddExpception: XCTestExpectation?
  var tagUpdateExpception: XCTestExpectation?
  var tagRemoveExpception: XCTestExpectation?
  
  func testHasTagsUsingCondition() {
    let entity = Entity("T")
    entity.add(tags: "T1", "T2", "T3")
    
    /// .and condition
    XCTAssertTrue(entity.has(tags: ["T1", "T2", "T3"], using: .and))
    XCTAssertFalse(entity.has(tags: ["T1", "T2", "T3", "T4"], using: .and))
    
    /// .or condition
    XCTAssertTrue(entity.has(tags: ["T3", "T4", "T5", "T6"], using: .or))
    XCTAssertFalse(entity.has(tags: ["T4", "T5", "T6", "T7"], using: .or))
  }

  
  func testTagAdd() {
    saveExpectation = expectation(description: "[ActionTests Error: Graph save test failed.]")
    tagAddExpception = expectation(description: "[ActionTests Error: Tag add test failed.]")
    
    let graph = Graph()
    let watch = Watch<Action>(graph: graph).where(.types("T") || .has(tags: ["G1"]))
    watch.delegate = self
    
    let action = Action("T")
    action.add(tags: "G1")
    
    XCTAssertTrue(action.has(tags: "G1"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testTagUpdate() {
    saveExpectation = expectation(description: "[ActionTests Error: Graph save test failed.]")
    
    let graph = Graph()
    
    let action = Action("T")
    action.add(tags: "G2")
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[ActionTests Error: Graph save test failed.]")
    tagAddExpception = expectation(description: "[ActionTests Error: Tag add test failed.]")
    tagRemoveExpception = expectation(description: "[ActionTests Error: Tag remove test failed.]")
    
    let watch = Watch<Action>(graph: graph).where(.has(tags: ["G1", "G2"]))
    watch.delegate = self
    
    action.toggle(tags: "G1", "G2")
    
    XCTAssertTrue(action.has(tags: "G1"))
    XCTAssertFalse(action.has(tags: "G2"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testTagDelete() {
    saveExpectation = expectation(description: "[ActionTests Error: Graph save test failed.]")
    
    let graph = Graph()
    
    let action = Action("T")
    action.add(tags: "G2")
    
    XCTAssertTrue(action.has(tags: "G2"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    saveExpectation = expectation(description: "[ActionTests Error: Graph save test failed.]")
    tagRemoveExpception = expectation(description: "[ActionTests Error: Tag remove test failed.]")
    
    let watch = Watch<Action>(graph: graph).where(.has(tags: ["G2"]))
    watch.delegate = self
    
    
    action.remove(tags: "G2")
    
    XCTAssertFalse(action.has(tags: "G2"))
    
    graph.async { [weak self] (success, error) in
      XCTAssertTrue(success)
      XCTAssertNil(error)
      self?.saveExpectation?.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func graph(_ graph: Graph, action: Action, added tag: String, source: GraphSource) {
    XCTAssertTrue("T" == action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("G1", tag)
    XCTAssertTrue(action.has(tags: tag))
    XCTAssertEqual(1, action.tags.count)
    XCTAssertTrue(action.tags.contains(tag))
    
    tagAddExpception?.fulfill()
  }
  
  func graph(_ graph: Graph, action: Action, removed tag: String, source: GraphSource) {
    XCTAssertTrue("T" == action.type)
    XCTAssertTrue(0 < action.id.count)
    XCTAssertEqual("G2", tag)
    XCTAssertFalse(action.has(tags: tag))
    
    tagRemoveExpception?.fulfill()
  }
}
