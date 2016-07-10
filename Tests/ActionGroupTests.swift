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

class ActionGroupTests: XCTestCase, GraphDelegate {
    var saveException: XCTestExpectation?
    
    var groupAddExpception: XCTestExpectation?
    var groupUpdateExpception: XCTestExpectation?
    var groupRemoveExpception: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGroupAdd() {
        saveException = expectationWithDescription("[ActionTests Error: Graph save test failed.]")
        groupAddExpception = expectationWithDescription("[ActionTests Error: Group add test failed.]")
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForAction(types: ["T"], groups: ["G1"])
        
        let action = Action(type: "T")
        action.addToGroup("G1")
        
        XCTAssertTrue(action.memberOfGroup("G1"))
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testGroupUpdate() {
        saveException = expectationWithDescription("[ActionTests Error: Graph save test failed.]")
        
        let graph = Graph()
        
        let action = Action(type: "T")
        action.addToGroup("G2")
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        saveException = expectationWithDescription("[ActionTests Error: Graph save test failed.]")
        groupAddExpception = expectationWithDescription("[ActionTests Error: Group add test failed.]")
        groupRemoveExpception = expectationWithDescription("[ActionTests Error: Group remove test failed.]")
        
        graph.delegate = self
        graph.watchForAction(groups: ["G1", "G2"])
        
        action.addToGroup("G1")
        action.removeFromGroup("G2")
        
        XCTAssertTrue(action.memberOfGroup("G1"))
        XCTAssertFalse(action.memberOfGroup("G2"))
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testGroupDelete() {
        saveException = expectationWithDescription("[ActionTests Error: Graph save test failed.]")
        
        let graph = Graph()
        
        let action = Action(type: "T")
        action.addToGroup("G2")
        
        XCTAssertTrue(action.memberOfGroup("G2"))
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        saveException = expectationWithDescription("[ActionTests Error: Graph save test failed.]")
        groupRemoveExpception = expectationWithDescription("[ActionTests Error: Group remove test failed.]")
        
        graph.delegate = self
        graph.watchForAction(groups: ["G2"])
        
        action.removeFromGroup("G2")
        
        XCTAssertFalse(action.memberOfGroup("G2"))
        
        graph.async { [weak self] (success: Bool, error: NSError?) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            self?.saveException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func graphDidAddActionToGroup(graph: Graph, action: Action, group: String, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("G1", group)
        XCTAssertTrue(action.memberOfGroup(group))
        XCTAssertEqual(1, action.groups.count)
        XCTAssertTrue(action.groups.contains(group))
        
        groupAddExpception?.fulfill()
    }
    
    func graphWillRemoveActionFromGroup(graph: Graph, action: Action, group: String, fromCloud: Bool) {
        XCTAssertTrue("T" == action.type)
        XCTAssertTrue(0 < action.id.characters.count)
        XCTAssertEqual("G2", group)
        XCTAssertFalse(action.memberOfGroup(group))
        
        groupRemoveExpception?.fulfill()
    }
}