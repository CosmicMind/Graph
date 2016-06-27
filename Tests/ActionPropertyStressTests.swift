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

class ActionPropertyStressTests: XCTestCase, GraphDelegate {
    var saveException: XCTestExpectation?
    
    var actionInsertException: XCTestExpectation?
    var actionDeleteException: XCTestExpectation?
    
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
        saveException = expectationWithDescription("[ActionPropertyStressTests Error: Graph save test failed.]")
        actionInsertException = expectationWithDescription("[ActionPropertyStressTests Error: Action insert test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"])
        
        let action = Action(type: "T")
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        for i in 0..<100 {
            let property = "P\(i)"
            var value = i
            
            graph.watchForAction(properties: [property])
            
            action[property] = value
            
            XCTAssertEqual(value, action[property] as? Int)
            
            saveException = expectationWithDescription("[ActionPropertyStressTests Error: Graph save test failed.]")
            propertyInsertExpception = expectationWithDescription("[ActionPropertyStressTests Error: Property insert test failed.]")
            
            graph.save { [weak self] (success: Bool, error: NSError?) in
                self?.saveException?.fulfill()
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
            }
            
            waitForExpectationsWithTimeout(5, handler: nil)
            
            value += 1
            action[property] = value
            
            XCTAssertEqual(value, action[property] as? Int)
            
            saveException = expectationWithDescription("[ActionPropertyStressTests Error: Graph save test failed.]")
            propertyUpdateExpception = expectationWithDescription("[ActionPropertyStressTests Error: Property update test failed.]")
            
            graph.save { [weak self] (success: Bool, error: NSError?) in
                self?.saveException?.fulfill()
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
            }
            
            waitForExpectationsWithTimeout(5, handler: nil)
            
            action[property] = nil
            
            XCTAssertNil(action[property])
            
            saveException = expectationWithDescription("[ActionPropertyStressTests Error: Graph save test failed.]")
            propertyDeleteExpception = expectationWithDescription("[ActionPropertyStressTests Error: Property delete test failed.]")
            
            graph.save { [weak self] (success: Bool, error: NSError?) in
                self?.saveException?.fulfill()
                XCTAssertTrue(success)
                XCTAssertEqual(nil, error)
            }
            
            waitForExpectationsWithTimeout(5, handler: nil)
        }
        
        saveException = expectationWithDescription("[ActionPropertyStressTests Error: Graph save test failed.]")
        actionDeleteException = expectationWithDescription("[ActionPropertyStressTests Error: Action delete test failed.]")
        
        action.delete()
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
            XCTAssertEqual(nil, error)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func graphDidInsertAction(graph: Graph, action: Action) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual(0, action.properties.count)
        
        actionInsertException?.fulfill()
    }
    
    func graphDidDeleteAction(graph: Graph, action: Action) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual(0, action.properties.count)
        
        actionDeleteException?.fulfill()
    }
    
    func graphDidInsertActionProperty(graph: Graph, action: Action, property: String, value: AnyObject) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        
        propertyInsertExpception?.fulfill()
    }
    
    func graphDidUpdateActionProperty(graph: Graph, action: Action, property: String, value: AnyObject) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        
        propertyUpdateExpception?.fulfill()
    }
    
    func graphDidDeleteActionProperty(graph: Graph, action: Action, property: String, value: AnyObject) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        
        propertyDeleteExpception?.fulfill()
    }
}