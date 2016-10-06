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
        graph.delegate = self
        graph.watch(for: .entity).for(types: ["T"]).has(tags: ["G"]).where(properties: ["P"])
        
        let entity = Entity(type: "T")
        entity["P"] = "V"
        entity.add(tag: "G")
        
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
        
        graph.delegate = self
        graph.watch(for: .entity).for(types: ["T"]).has(tags: ["G"]).where(properties: ["P"])
        
        let entity = Entity(type: "T", graph: "EntityTests-testNamedGraphSave")
        entity["P"] = "V"
        entity.add(tag: "G")
        
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
        
        graph.delegate = self
        graph.watch(for: .entity).for(types: ["T"]).has(tags: ["G"]).where(properties: ["P"])
        
        let entity = Entity(type: "T", graph: graph)
        entity["P"] = "V"
        entity.add(tag: "G")
        
        XCTAssertEqual("V", entity["P"] as? String)
        
        DispatchQueue.global(qos: .default).async { [weak self] in
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
        graph.delegate = self
        graph.watch(for: .entity).for(types: ["T"]).has(tags: ["G"]).where(properties: ["P"])
        
        let entity = Entity(type: "T", graph: graph)
        entity["P"] = "V"
        entity.add(tag: "G")
        
        XCTAssertEqual("V", entity["P"] as? String)
        
        DispatchQueue.global(qos: .default).async { [weak self] in
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
        graph.delegate = self
        graph.watch(for: .entity).for(types: ["T"]).has(tags: ["G"]).where(properties: ["P"])
        
        let entity = Entity(type: "T")
        entity["P"] = "V"
        entity.add(tag: "G")
        
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
    
    func graph(graph: Graph, inserted entity: Entity, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("V", entity["P"] as? String)
        XCTAssertTrue(entity.has(tag: "G"))
        
        delegateExpectation?.fulfill()
    }
    
    func graph(graph: Graph, deleted entity: Entity, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertNil(entity["P"])
        XCTAssertFalse(entity.has(tag: "G"))
        
        delegateExpectation?.fulfill()
    }
    
    func graph(graph: Graph, entity: Entity, added tag: String, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("G", tag)
        XCTAssertTrue(entity.has(tag: tag))
        
        tagExpception?.fulfill()
    }
    
    func graph(graph: Graph, entity: Entity, removed tag: String, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("G", tag)
        XCTAssertFalse(entity.has(tag: tag))
        
        tagExpception?.fulfill()
    }
    
    func graph(graph: Graph, entity: Entity, added property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, entity[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graph(graph: Graph, entity: Entity, updated property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, entity[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func graph(graph: Graph, entity: Entity, removed property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertNil(entity["P"])
        
        propertyExpception?.fulfill()
    }
}
