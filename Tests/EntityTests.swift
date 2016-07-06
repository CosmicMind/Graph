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

class EntityTests: XCTestCase, GraphDelegate {
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
        saveException = expectationWithDescription("[EntityTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[EntityTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[EntityTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[EntityTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForEntity(types: ["T"], groups: ["G"], properties: ["P"])
        
        let entity = Entity(type: "T")
        entity["P"] = "V"
        entity.addToGroup("G")
        
        XCTAssertEqual("V", entity["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testNamedGraphSave() {
        saveException = expectationWithDescription("[EntityTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[EntityTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[EntityTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[EntityTests Error: Property test failed.]")
        
        let graph = Graph(name: "EntityTests-testNamedGraphSave")
        
        graph.delegate = self
        graph.watchForEntity(types: ["T"], groups: ["G"], properties: ["P"])
        
        let entity = Entity(type: "T", graph: "EntityTests-testNamedGraphSave")
        entity["P"] = "V"
        entity.addToGroup("G")
        
        XCTAssertEqual("V", entity["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testReferenceGraphSave() {
        saveException = expectationWithDescription("[EntityTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[EntityTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[EntityTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[EntityTests Error: Property test failed.]")
        
        let graph = Graph(name: "EntityTests-testReferenceGraphSave")
        
        graph.delegate = self
        graph.watchForEntity(types: ["T"], groups: ["G"], properties: ["P"])
        
        let entity = Entity(type: "T", graph: graph)
        entity["P"] = "V"
        entity.addToGroup("G")
        
        XCTAssertEqual("V", entity["P"] as? String)
        
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
        saveException = expectationWithDescription("[EntityTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[EntityTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[EntityTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[EntityTests Error: Property test failed.]")
        
        let graph = Graph(name: "EntityTests-testAsyncGraphSave")
        graph.delegate = self
        graph.watchForEntity(types: ["T"], groups: ["G"], properties: ["P"])
        
        let entity = Entity(type: "T", graph: graph)
        entity["P"] = "V"
        entity.addToGroup("G")
        
        XCTAssertEqual("V", entity["P"] as? String)
        
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
        saveException = expectationWithDescription("[EntityTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[EntityTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[EntityTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[EntityTests Error: Property test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForEntity(types: ["T"], groups: ["G"], properties: ["P"])
        
        let entity = Entity(type: "T")
        entity["P"] = "V"
        entity.addToGroup("G")
        
        XCTAssertEqual("V", entity["P"] as? String)
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        entity.delete()
        
        saveException = expectationWithDescription("[EntityTests Error: Save test failed.]")
        delegateException = expectationWithDescription("[EntityTests Error: Delegate test failed.]")
        groupExpception = expectationWithDescription("[EntityTests Error: Group test failed.]")
        propertyExpception = expectationWithDescription("[EntityTests Error: Property test failed.]")
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func graphDidInsertEntity(graph: Graph, entity: Entity) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("V", entity["P"] as? String)
        XCTAssertTrue(entity.memberOfGroup("G"))
        
        delegateException?.fulfill()
    }
    
    func graphWillDeleteEntity(graph: Graph, entity: Entity) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertNil(entity["P"])
        XCTAssertFalse(entity.memberOfGroup("G"))
        
        delegateException?.fulfill()
    }
    
    func graphDidAddEntityToGroup(graph: Graph, entity: Entity, group: String) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("G", group)
        XCTAssertTrue(entity.memberOfGroup(group))
        
        groupExpception?.fulfill()
    }
    
    func graphWillRemoveEntityFromGroup(graph: Graph, entity: Entity, group: String) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("G", group)
        XCTAssertFalse(entity.memberOfGroup(group))
        
        groupExpception?.fulfill()
    }
    
    func graphDidInsertEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, entity[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, entity[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graphWillDeleteEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertNil(entity["P"])
        
        propertyExpception?.fulfill()
    }
}