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

class EntityPropertyStressTests: XCTestCase, WatchEntityDelegate {
    var saveExpectation: XCTestExpectation?
    
    var entityInsertExpectation: XCTestExpectation?
    var entityDeleteExpectation: XCTestExpectation?
    
    var propertyInsertExpception: XCTestExpectation?
    var propertyUpdateExpception: XCTestExpectation?
    var propertyDeleteExpception: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPropertyStress() {
        saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
        entityInsertExpectation = expectation(description: "[EntityPropertyStressTests Error: Entity insert test failed.]")
        
        let graph = Graph()
        let watch = Watch<Entity>(graph: graph).for(types: "T")
        watch.delegate = self
        
        let entity = Entity(type: "T")
        
        graph.async { [weak self] (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        var properties : [String] = []
        for i in 0..<100 {
            properties.append("P\(i)")
        }
        watch.where(properties: properties)
        
        for i in 0..<100 {
            let property = "P\(i)"
            var value = i
            
            entity[property] = value
            
            XCTAssertEqual(value, entity[property] as? Int)
            
            saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
            propertyInsertExpception = expectation(description: "[EntityPropertyStressTests Error: Property insert test failed.]")
            
            graph.async { [weak self] (success, error) in
                XCTAssertTrue(success)
                XCTAssertNil(error)
                self?.saveExpectation?.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
            
            value += 1
            entity[property] = value
            
            XCTAssertEqual(value, entity[property] as? Int)
            
            saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
            propertyUpdateExpception = expectation(description: "[EntityPropertyStressTests Error: Property update test failed.]")
            
            graph.async { [weak self] (success, error) in
                XCTAssertTrue(success)
                XCTAssertNil(error)
                self?.saveExpectation?.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
            
            entity[property] = nil
            
            XCTAssertNil(entity[property])
            
            saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
            propertyDeleteExpception = expectation(description: "[EntityPropertyStressTests Error: Property delete test failed.]")
            
            graph.async { [weak self] (success, error) in
                self?.saveExpectation?.fulfill()
                XCTAssertTrue(success)
                XCTAssertNil(error)
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
        
        saveExpectation = expectation(description: "[EntityPropertyStressTests Error: Graph save test failed.]")
        entityDeleteExpectation = expectation(description: "[EntityPropertyStressTests Error: Entity delete test failed.]")
        
        entity.delete()
        
        graph.async { [weak self] (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func watch(graph: Graph, inserted entity: Entity, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.count)
        XCTAssertEqual(0, entity.properties.count)
        
        entityInsertExpectation?.fulfill()
    }
    
    func watch(graph: Graph, deleted entity: Entity, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.count)
        XCTAssertEqual(0, entity.properties.count)
        
        entityDeleteExpectation?.fulfill()
    }
    
    func watch(graph: Graph, entity: Entity, added property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.count)
        
        propertyInsertExpception?.fulfill()
    }
    
    func watch(graph: Graph, entity: Entity, updated property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.count)
        
        propertyUpdateExpception?.fulfill()
    }
    
    func watch(graph: Graph, entity: Entity, removed property: String, with value: Any, source: GraphSource) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.count)
        
        propertyDeleteExpception?.fulfill()
    }
}
