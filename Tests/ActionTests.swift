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

class ActionTests: XCTestCase, WatchActionDelegate {
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
        let watch = Watch<Action>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let action = Action(type: "T")
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
        let watch = Watch<Action>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let action = Action(type: "T", graph: "ActionTests-testNamedGraphSave")
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
        let watch = Watch<Action>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let action = Action(type: "T", graph: graph)
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
        let watch = Watch<Action>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let action = Action(type: "T", graph: graph)
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
        let watch = Watch<Action>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let action = Action(type: "T")
        action.add(subjects: Entity(type: "T"), Entity(type: "T"))
        action.add(objects: Entity(type: "T"), Entity(type: "T"))
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
        let watch = Watch<Action>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let action = Action(type: "T")
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
        
        action.add(subjects: [Entity(type: "T"), Entity(type: "T"), Entity(type: "T"), Entity(type: "T")])
        
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
        let watch = Watch<Action>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let action = Action(type: "T")
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
        
        action.add(objects: [Entity(type: "T"), Entity(type: "T"), Entity(type: "T"), Entity(type: "T")])
        
        XCTAssertEqual(4, action.objects.count)
        
        graph.async { [weak self] (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func watch(graph: Graph, inserted action: Action, source: GraphSource) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.count)
        XCTAssertEqual("V", action["P"] as? String)
        XCTAssertTrue(action.has(tags: "G"))
        
        delegateExpectation?.fulfill()
    }
    
    func watch(graph: Graph, deleted action: Action, source: GraphSource) {
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
    
    func watch(graph: Graph, action: Action, added tag: String, source: GraphSource) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.count)
        XCTAssertEqual("G", tag)
        XCTAssertTrue(action.has(tags: tag))
        
        tagExpception?.fulfill()
    }
    
    func watch(graph: Graph, action: Action, removed tag: String, source: GraphSource) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.count)
        XCTAssertEqual("G", tag)
        XCTAssertFalse(action.has(tags: tag))
        
        tagExpception?.fulfill()
    }
    
    func watch(graph: Graph, action: Action, added property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, action[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func watch(graph: Graph, action: Action, updated property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, action[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func watch(graph: Graph, action: Action, removed property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertNil(action["P"])
        
        propertyExpception?.fulfill()
    }
}
