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

class EntityTagTests: XCTestCase, GraphEntityDelegate {
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
        saveException = expectation(description: "[EntityTests Error: Graph save test failed.]")
        tagAddExpception = expectation(description: "[EntityTests Error: Tag add test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForEntity(types: ["T"], tags: ["G1"])
        
        let entity = Entity(type: "T")
        entity.add(tag: "G1")
        
        XCTAssertTrue(entity.has(tag: "G1"))
        
        graph.async { [weak self] (success: Bool, error: Error?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTagUpdate() {
        saveException = expectation(description: "[EntityTests Error: Graph save test failed.]")
        
        let graph = Graph()
        
        let entity = Entity(type: "T")
        entity.add(tag: "G2")
        
        graph.async { [weak self] (success: Bool, error: Error?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        saveException = expectation(description: "[EntityTests Error: Graph save test failed.]")
        tagAddExpception = expectation(description: "[EntityTests Error: Tag add test failed.]")
        tagRemoveExpception = expectation(description: "[EntityTests Error: Tag remove test failed.]")
        
        graph.delegate = self
        graph.watchForEntity(tags: ["G1", "G2"])
        
        entity.add(tag: "G1")
        entity.remove(tag: "G2")
        
        XCTAssertTrue(entity.has(tag: "G1"))
        XCTAssertFalse(entity.has(tag: "G2"))
        
        graph.async { [weak self] (success: Bool, error: Error?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTagDelete() {
        saveException = expectation(description: "[EntityTests Error: Graph save test failed.]")
        
        let graph = Graph()
        
        let entity = Entity(type: "T")
        entity.add(tag: "G2")
        
        XCTAssertTrue(entity.has(tag: "G2"))
        
        graph.async { [weak self] (success: Bool, error: Error?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        saveException = expectation(description: "[EntityTests Error: Graph save test failed.]")
        tagRemoveExpception = expectation(description: "[EntityTests Error: Tag remove test failed.]")
        
        graph.delegate = self
        graph.watchForEntity(tags: ["G2"])
        
        entity.remove(tag: "G2")
        
        XCTAssertFalse(entity.has(tag: "G2"))
        
        graph.async { [weak self] (success: Bool, error: Error?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func graph(graph: Graph, entity: Entity, added tag: String, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("G1", tag)
        XCTAssertTrue(entity.has(tag: tag))
        XCTAssertEqual(1, entity.tags.count)
        XCTAssertTrue(entity.tags.contains(tag))
        
        tagAddExpception?.fulfill()
    }
    
    func graph(graph: Graph, entity: Entity, removed tag: String, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual("G2", tag)
        XCTAssertFalse(entity.has(tag: tag))
        
        tagRemoveExpception?.fulfill()
    }
}
