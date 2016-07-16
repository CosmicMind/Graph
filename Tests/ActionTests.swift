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
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        delegateException = expectation(withDescription: "[ActionTests Error: Delegate test failed.]")
        groupExpception = expectation(withDescription: "[ActionTests Error: Group test failed.]")
        propertyExpception = expectation(withDescription: "[ActionTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T")
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
    }
    
    func testNamedGraphSave() {
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        delegateException = expectation(withDescription: "[ActionTests Error: Delegate test failed.]")
        groupExpception = expectation(withDescription: "[ActionTests Error: Group test failed.]")
        propertyExpception = expectation(withDescription: "[ActionTests Error: Property test failed.]")
        
        let graph = Graph(name: "ActionTests-testNamedGraphSave")
        
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T", graph: "ActionTests-testNamedGraphSave")
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
    }
    
    func testReferenceGraphSave() {
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        delegateException = expectation(withDescription: "[ActionTests Error: Delegate test failed.]")
        groupExpception = expectation(withDescription: "[ActionTests Error: Group test failed.]")
        propertyExpception = expectation(withDescription: "[ActionTests Error: Property test failed.]")
        
        let graph = Graph(name: "ActionTests-testReferenceGraphSave")
        
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T", graph: graph)
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async { [weak self] in
            graph.async { [weak self] (success: Bool, error: NSError?) in
                XCTAssertTrue(success)
                XCTAssertNil(error)
                self?.saveException?.fulfill()
            }
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
    }
    
    func testAsyncGraphSave() {
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        delegateException = expectation(withDescription: "[ActionTests Error: Delegate test failed.]")
        groupExpception = expectation(withDescription: "[ActionTests Error: Group test failed.]")
        propertyExpception = expectation(withDescription: "[ActionTests Error: Property test failed.]")
        
        let graph = Graph(name: "ActionTests-testAsyncGraphSave")
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T", graph: graph)
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async { [weak self] in
            graph.async { [weak self] (success: Bool, error: NSError?) in
                XCTAssertTrue(success)
                XCTAssertNil(error)
                self?.saveException?.fulfill()
            }
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
    }
    
    func testAsyncGraphDelete() {
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        delegateException = expectation(withDescription: "[ActionTests Error: Delegate test failed.]")
        groupExpception = expectation(withDescription: "[ActionTests Error: Group test failed.]")
        propertyExpception = expectation(withDescription: "[ActionTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T")
        action["P"] = "V"
        action.addToGroup("G")
        
        action.addSubject(Entity(type: "T"))
        action.addSubject(Entity(type: "T"))
        
        XCTAssertEqual(2, action.subjects.count)
        
        action.addObject(Entity(type: "T"))
        action.addObject(Entity(type: "T"))
        
        XCTAssertEqual(2, action.objects.count)
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
        
        action.delete()
        
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        delegateException = expectation(withDescription: "[ActionTests Error: Delegate test failed.]")
        groupExpception = expectation(withDescription: "[ActionTests Error: Group test failed.]")
        propertyExpception = expectation(withDescription: "[ActionTests Error: Property test failed.]")
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
    }
    
    func testSubjects() {
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        delegateException = expectation(withDescription: "[ActionTests Error: Delegate test failed.]")
        groupExpception = expectation(withDescription: "[ActionTests Error: Group test failed.]")
        propertyExpception = expectation(withDescription: "[ActionTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T")
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
        
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        
        action.addSubject(Entity(type: "T"))
        action.addSubject(Entity(type: "T"))
        action.addSubject(Entity(type: "T"))
        action.addSubject(Entity(type: "T"))
        
        XCTAssertEqual(4, action.subjects.count)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
    }
    
    func testObjects() {
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        delegateException = expectation(withDescription: "[ActionTests Error: Delegate test failed.]")
        groupExpception = expectation(withDescription: "[ActionTests Error: Group test failed.]")
        propertyExpception = expectation(withDescription: "[ActionTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
        
        let action = Action(type: "T")
        action["P"] = "V"
        action.addToGroup("G")
        
        XCTAssertEqual("V", action["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
        
        saveException = expectation(withDescription: "[ActionTests Error: Save test failed.]")
        
        action.addObject(Entity(type: "T"))
        action.addObject(Entity(type: "T"))
        action.addObject(Entity(type: "T"))
        action.addObject(Entity(type: "T"))
        
        XCTAssertEqual(4, action.objects.count)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
    }
    
    func graphDidInsertAction(_ graph: Graph, action: Action, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("V", action["P"] as? String)
        XCTAssertTrue(action.memberOfGroup("G"))
        
        delegateException?.fulfill()
    }
    
    func graphWillDeleteAction(_ graph: Graph, action: Action, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertNil(action["P"])
        XCTAssertFalse(action.memberOfGroup("G"))
        XCTAssertEqual(2, action.subjects.count)
        XCTAssertEqual(2, action.objects.count)
        XCTAssertEqual(1, action.subjects.first?.actionsWhenSubject.count)
        XCTAssertEqual(1, action.subjects.last?.actionsWhenSubject.count)
        XCTAssertEqual(1, action.objects.first?.actionsWhenObject.count)
        XCTAssertEqual(1, action.objects.last?.actionsWhenObject.count)
        
        delegateException?.fulfill()
    }
    
    func graphDidAddActionToGroup(_ graph: Graph, action: Action, group: String, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("G", group)
        XCTAssertTrue(action.memberOfGroup(group))
        
        groupExpception?.fulfill()
    }
    
    func graphWillRemoveActionFromGroup(_ graph: Graph, action: Action, group: String, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("G", group)
        XCTAssertFalse(action.memberOfGroup(group))
        
        groupExpception?.fulfill()
    }
    
    func graphDidInsertActionProperty(_ graph: Graph, action: Action, property: String, value: AnyObject, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, action[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graphDidUpdateActionProperty(_ graph: Graph, action: Action, property: String, value: AnyObject, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, action[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graphWillDeleteActionProperty(_ graph: Graph, action: Action, property: String, value: AnyObject, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertNil(action["P"])
        
        propertyExpception?.fulfill()
    }
}
