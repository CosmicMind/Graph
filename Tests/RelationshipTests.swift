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

class RelationshipTests: XCTestCase, WatchRelationshipDelegate {
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
        let watch = Watch<Relationship>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let relationship = Relationship(type: "T")
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
        let watch = Watch<Relationship>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let relationship = Relationship(type: "T", graph: "RelationshipTests-testNamedGraphSave")
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
        let watch = Watch<Relationship>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let relationship = Relationship(type: "T", graph: graph)
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
        let watch = Watch<Relationship>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let relationship = Relationship(type: "T", graph: graph)
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
        let watch = Watch<Relationship>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let subject = Entity(type: "S")
        let object = Entity(type: "O")
        
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
        let watch = Watch<Relationship>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let relationship = Relationship(type: "T")
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
        
        let subject = Entity(type: "T")
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
        let watch = Watch<Relationship>(graph: graph).for(types: "T").has(tags: "G").where(properties: "P")
        watch.delegate = self
        
        let relationship = Relationship(type: "T")
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
        
        let object = Entity(type: "T")
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
    
    func watch(graph: Graph, inserted relationship: Relationship, source: GraphSource) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.count)
        XCTAssertEqual("V", relationship["P"] as? String)
        XCTAssertTrue(relationship.has(tags: "G"))
        
        delegateExpectation?.fulfill()
    }
    
    func watch(graph: Graph, updated relationship: Relationship, source: GraphSource) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.count)
        XCTAssertEqual("V", relationship["P"] as? String)
        XCTAssertTrue(relationship.has(tags: "G"))
        
        delegateExpectation?.fulfill()
    }
    
    func watch(graph: Graph, deleted relationship: Relationship, source: GraphSource) {
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
    
    func watch(graph: Graph, relationship: Relationship, added tag: String, source: GraphSource) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.count)
        XCTAssertEqual("G", tag)
        XCTAssertTrue(relationship.has(tags: tag))
        
        tagExpception?.fulfill()
    }
    
    func watch(graph: Graph, relationship: Relationship, removed tag: String, source: GraphSource) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.count)
        XCTAssertEqual("G", tag)
        XCTAssertFalse(relationship.has(tags: tag))
        
        tagExpception?.fulfill()
    }
    
    func watch(graph: Graph, relationship: Relationship, added property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, relationship[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func watch(graph: Graph, relationship: Relationship, updated property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertEqual(value as? String, relationship[property] as? String)
        
        propertyExpception?.fulfill()
    }
    
    func watch(graph: Graph, relationship: Relationship, removed property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual("V", value as? String)
        XCTAssertNil(relationship["P"])
        
        propertyExpception?.fulfill()
    }
}
