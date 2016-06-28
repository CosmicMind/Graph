/*
 * Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>.
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

class EntityPropertyStressTests: XCTestCase, GraphDelegate {
    var saveException: XCTestExpectation?
    
    var entityInsertException: XCTestExpectation?
    var entityDeleteException: XCTestExpectation?
    
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
        saveException = expectationWithDescription("[EntityPropertyStressTests Error: Graph save test failed.]")
        entityInsertException = expectationWithDescription("[EntityPropertyStressTests Error: Entity insert test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForEntity(types: ["T"])
        
        let entity = Entity(type: "T")
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        for i in 0..<100 {
            let property = "P\(i)"
            var value = i
            
            graph.watchForEntity(properties: [property])
            
            entity[property] = value
            
            XCTAssertEqual(value, entity[property] as? Int)
            
            saveException = expectationWithDescription("[EntityPropertyStressTests Error: Graph save test failed.]")
            propertyInsertExpception = expectationWithDescription("[EntityPropertyStressTests Error: Property insert test failed.]")
            
            graph.async { [weak self] (success: Bool, error: NSError?) in
                self?.saveException?.fulfill()
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
            }
            
            waitForExpectationsWithTimeout(5, handler: nil)
            
            value += 1
            entity[property] = value
            
            XCTAssertEqual(value, entity[property] as? Int)
            
            saveException = expectationWithDescription("[EntityPropertyStressTests Error: Graph save test failed.]")
            propertyUpdateExpception = expectationWithDescription("[EntityPropertyStressTests Error: Property update test failed.]")
            
            graph.async { [weak self] (success: Bool, error: NSError?) in
                self?.saveException?.fulfill()
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
            }
            
            waitForExpectationsWithTimeout(5, handler: nil)
            
            entity[property] = nil
            
            XCTAssertNil(entity[property])
            
            saveException = expectationWithDescription("[EntityPropertyStressTests Error: Graph save test failed.]")
            propertyDeleteExpception = expectationWithDescription("[EntityPropertyStressTests Error: Property delete test failed.]")
            
            graph.async { [weak self] (success: Bool, error: NSError?) in
                self?.saveException?.fulfill()
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
            }
            
            waitForExpectationsWithTimeout(5, handler: nil)
        }
        
        saveException = expectationWithDescription("[EntityPropertyStressTests Error: Graph save test failed.]")
        entityDeleteException = expectationWithDescription("[EntityPropertyStressTests Error: Entity delete test failed.]")
        
        entity.delete()
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        graph.clear()
    }
    
    func graphDidInsertEntity(graph: Graph, entity: Entity) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual(0, entity.properties.count)
        
        entityInsertException?.fulfill()
    }
    
    func graphDidDeleteEntity(graph: Graph, entity: Entity) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        XCTAssertEqual(0, entity.properties.count)
        
        entityDeleteException?.fulfill()
    }
    
    func graphDidInsertEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        
        propertyInsertExpception?.fulfill()
    }
    
    func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        
        propertyUpdateExpception?.fulfill()
    }
    
    func graphDidDeleteEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
        XCTAssertTrue("T" == entity.type)
        XCTAssertTrue(0 < entity.id.characters.count)
        
        propertyDeleteExpception?.fulfill()
    }
}