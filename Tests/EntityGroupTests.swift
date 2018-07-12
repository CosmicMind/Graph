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

class EntityGroupTests: XCTestCase, WatchEntityDelegate {
    var saveExpectation: XCTestExpectation?
    
    var tagAddExpception: XCTestExpectation?
    var tagUpdateExpception: XCTestExpectation?
    var tagRemoveExpception: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGroupAdd() {
        saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
        tagAddExpception = expectation(description: "[EntityTests Error: Group add test failed.]")
        
        let graph = Graph()
        let watch = Watch<Entity>(graph: graph).for(types: "T").member(of: "G1")
        watch.delegate = self
        
        let entity = Entity(type: "T")
        entity.add(to: "G1")
        
        XCTAssertTrue(entity.member(of: "G1"))
        
        graph.async { [weak self] (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGroupUpdate() {
        saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
        
        let graph = Graph()
        
        let entity = Entity(type: "T")
        entity.add(to: "G2")
        
        graph.async { [weak self] (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
        tagAddExpception = expectation(description: "[EntityTests Error: Group add test failed.]")
        tagRemoveExpception = expectation(description: "[EntityTests Error: Group remove test failed.]")
        
        let watch = Watch<Entity>(graph: graph).member(of: "G1", "G2")
        watch.delegate = self
        
        entity.toggle(groups: "G1", "G2")
        
        XCTAssertTrue(entity.member(of: "G1"))
        XCTAssertFalse(entity.member(of: "G2"))
        
        graph.async { [weak self] (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGroupDelete() {
        saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
        
        let graph = Graph()
        
        let entity = Entity(type: "T")
        entity.add(to: "G2")
        
        XCTAssertTrue(entity.member(of: "G2"))
        
        graph.async { [weak self] (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        saveExpectation = expectation(description: "[EntityTests Error: Graph save test failed.]")
        tagRemoveExpception = expectation(description: "[EntityTests Error: Group remove test failed.]")
        
        let watch = Watch<Entity>(graph: graph).member(of: "G2")
        watch.delegate = self
        
        entity.remove(from: "G2")
        
        XCTAssertFalse(entity.member(of: "G2"))
        
        graph.async { [weak self] (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func watch(graph: Graph, entity: Entity, addedTo group: String, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.count)
        XCTAssertEqual("G1", group)
        XCTAssertTrue(entity.member(of: group))
        XCTAssertEqual(1, entity.groups.count)
        XCTAssertTrue(entity.groups.contains(group))
        
        tagAddExpception?.fulfill()
    }
    
    func watch(graph: Graph, entity: Entity, removedFrom group: String, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.count)
        XCTAssertEqual("G2", group)
        XCTAssertFalse(entity.member(of: group))
        
        tagRemoveExpception?.fulfill()
    }
}
