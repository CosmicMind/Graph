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

class RelationshipTagTests: XCTestCase, GraphRelationshipDelegate {
    var saveException: XCTestExpectation?
    
    var tagAddExpception: XCTestExpectation?
    var tagUpdateExpception: XCTestExpectation?
    var tagRemoveExpception: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTagAdd() {
        saveException = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
        tagAddExpception = expectation(description: "[RelationshipTests Error: Tag add test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForRelationship(types: ["T"], tags: ["G1"])
        
        let relationship = Relationship(type: "T")
        relationship.add(tag: "G1")
        
        XCTAssertTrue(relationship.has(tag: "G1"))
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTagUpdate() {
        saveException = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
        
        let graph = Graph()
        
        let relationship = Relationship(type: "T")
        relationship.add(tag: "G2")
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        saveException = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
        tagAddExpception = expectation(description: "[RelationshipTests Error: Tag add test failed.]")
        tagRemoveExpception = expectation(description: "[RelationshipTests Error: Tag remove test failed.]")
        
        graph.delegate = self
        graph.watchForRelationship(tags: ["G1", "G2"])
        
        relationship.add(tag: "G1")
        relationship.remove(tag: "G2")
        
        XCTAssertTrue(relationship.has(tag: "G1"))
        XCTAssertFalse(relationship.has(tag: "G2"))
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTagDelete() {
        saveException = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
        
        let graph = Graph()
        
        let relationship = Relationship(type: "T")
        relationship.add(tag: "G2")
        
        XCTAssertTrue(relationship.has(tag: "G2"))
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        saveException = expectation(description: "[RelationshipTests Error: Graph save test failed.]")
        tagRemoveExpception = expectation(description: "[RelationshipTests Error: Tag remove test failed.]")
        
        graph.delegate = self
        graph.watchForRelationship(tags: ["G2"])
        
        relationship.remove(tag: "G2")
        
        XCTAssertFalse(relationship.has(tag: "G2"))
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func graph(graph: Graph, relationship: Relationship, added tag: String, cloud: Bool) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("G1", tag)
        XCTAssertTrue(relationship.has(tag: tag))
        XCTAssertEqual(1, relationship.tags.count)
        XCTAssertTrue(relationship.tags.contains(tag))
        
        tagAddExpception?.fulfill()
    }
    
    func graph(graph: Graph, relationship: Relationship, removed tag: String, cloud: Bool) {
        XCTAssertTrue("T" == relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("G2", tag)
        XCTAssertFalse(relationship.has(tag: tag))
        
        tagRemoveExpception?.fulfill()
    }
}
