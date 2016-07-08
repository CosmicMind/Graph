/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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

class ActionTests: XCTestCase, GraphDelegate {
    var saveException: XCTestExpectation?
    var delegateException: XCTestExpectation?
    var groupExpception: XCTestExpectation?
    var propertyExpception: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultGraph() {
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[ActionTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[ActionTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T")
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testNamedGraphSave() {
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[ActionTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[ActionTests Error: Property test failed.]")
        
        let graph = Graph(name: "ActionTests-testNamedGraphSave")
        
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T", graph: "ActionTests-testNamedGraphSave")
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testReferenceGraphSave() {
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[ActionTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[ActionTests Error: Property test failed.]")
        
        let graph = Graph(name: "ActionTests-testReferenceGraphSave")
        
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T", graph: graph)
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            graph.async { [weak self] (success: Bool, error: NSError?) in
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
                self?.saveException?.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testAsyncGraphSave() {
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[ActionTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[ActionTests Error: Property test failed.]")
        
        let graph = Graph(name: "ActionTests-testAsyncGraphSave")
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T", graph: graph)
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            graph.async { [weak self] (success: Bool, error: NSError?) in
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
                self?.saveException?.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testAsyncGraphDelete() {
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[ActionTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[ActionTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T")
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        action.delete()
        
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[ActionTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[ActionTests Error: Property test failed.]")
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testSubjects() {
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[ActionTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[ActionTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T")
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        
        action.addSubject(Entity(type: "T"))
        action.addSubject(Entity(type: "T"))
        action.addSubject(Entity(type: "T"))
        action.addSubject(Entity(type: "T"))
        
        XCTAssertEqual(4, action.subjects.count)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testObjects() {
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[ActionTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[ActionTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T")
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        saveException = expectationWithDescription("[ActionTests Error: Save test failed.]")
        
        action.addObject(Entity(type: "T"))
        action.addObject(Entity(type: "T"))
        action.addObject(Entity(type: "T"))
        action.addObject(Entity(type: "T"))
        
        XCTAssertEqual(4, action.objects.count)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func graphDidInsertAction(graph: Graph, action: Action, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("V", action["P"] as? String)
        XCTAssertTrue(action.memberOfGroup("G"))
        
        delegateException?.fulfill()
    }
    
    func graphWillDeleteAction(graph: Graph, action: Action, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertNil(action["P"])
        XCTAssertFalse(action.memberOfGroup("G"))
        
        delegateException?.fulfill()
    }
    
    func graphDidAddActionToGroup(graph: Graph, action: Action, group: String, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("G", group)
        XCTAssertTrue(action.memberOfGroup(group))
        
        groupExpception?.fulfill()
    }
    
    func graphWillRemoveActionFromGroup(graph: Graph, action: Action, group: String, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("G", group)
        XCTAssertFalse(action.memberOfGroup(group))
        
        groupExpception?.fulfill()
    }
    
    func graphDidInsertActionProperty(graph: Graph, action: Action, property: String, value: AnyObject, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, action[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graphDidUpdateActionProperty(graph: Graph, action: Action, property: String, value: AnyObject, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, action[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graphWillDeleteActionProperty(graph: Graph, action: Action, property: String, value: AnyObject, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertNil(action["P"])
        
        propertyExpception?.fulfill()
    }
}