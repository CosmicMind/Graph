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

class ActionTests: XCTestCase, GraphDelegate {
    var saveException: XCTestExpectation?
    var delegateException: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultGraph() {
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"])
        graph.clear()
        
        let action = Action(type: "T")
        action["p"] = "v"
        action.addToGroup("g")
        
        XCTAssertTrue("v" == action["p"] as? String)
        
        saveException = expectationWithDescription("[ActionTests Error: Save Action test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate Action test failed.]")
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testNamedGraphSave() {
        let graph = Graph(name: "ActionTests-testNamedGraphSave")
        graph.clear()
        
        graph.watchForAction(types: ["T"])
        graph.delegate = self
        
        let action = Action(type: "T", graph: "ActionTests-testNamedGraphSave")
        action["p"] = "v"
        action.addToGroup("g")
        
        XCTAssertTrue("v" == action["p"] as? String)
        
        saveException = expectationWithDescription("[ActionTests Error: Save Action test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate Action test failed.]")
        
        graph.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testReferenceGraphSave() {
        let graph = Graph(name: "ActionTests-testReferenceGraphSave")
        graph.clear()
        
        graph.watchForAction(types: ["T"])
        graph.delegate = self
        
        let action = Action(type: "T", graph: graph)
        action["p"] = "v"
        action.addToGroup("g")
        
        XCTAssertTrue("v" == action["p"] as? String)
        
        saveException = expectationWithDescription("[ActionTests Error: Save Action test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate Action test failed.]")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            graph.save { [weak self] (success: Bool, error: NSError?) in
                self?.saveException?.fulfill()
                XCTAssertTrue(success)
            }
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testAsyncGraphSave() {
        saveException = expectationWithDescription("[ActionTests Error: Save Action test failed.]")
        delegateException = expectationWithDescription("[ActionTests Error: Delegate Action test failed.]")
        
        var graph: Graph!
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            graph = Graph(name: "ActionTests-testAsyncGraphSave")
            graph.clear()
            
            graph.watchForAction(types: ["T"])
            graph.delegate = self
            
            let action = Action(type: "T", graph: graph)
            action["p"] = "v"
            action.addToGroup("g3")
            
            XCTAssertTrue("v" == action["p"] as? String)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
                graph.save { [weak self] (success: Bool, error: NSError?) in
                    self?.saveException?.fulfill()
                    XCTAssertTrue(success)
                }
            }
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func graphDidInsertAction(graph: Graph, action: Action) {
        delegateException?.fulfill()
    }
}