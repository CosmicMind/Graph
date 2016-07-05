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

class RelationshipThreadTests : XCTestCase, GraphDelegate {
    var insertSaveExpectation: XCTestExpectation?
    var insertExpectation: XCTestExpectation?
    var insertPropertyExpectation: XCTestExpectation?
    var insertGroupExpectation: XCTestExpectation?
    var updateSaveExpectation: XCTestExpectation?
    var updatePropertyExpectation: XCTestExpectation?
    var deleteSaveExpectation: XCTestExpectation?
    var deleteExpectation: XCTestExpectation?
    var deletePropertyExpectation: XCTestExpectation?
    var deleteGroupExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAll() {
        insertSaveExpectation = expectationWithDescription("Test: Save did not pass.")
        insertExpectation = expectationWithDescription("Test: Insert did not pass.")
        insertPropertyExpectation = expectationWithDescription("Test: Insert property did not pass.")
        insertGroupExpectation = expectationWithDescription("Test: Insert group did not pass.")
        
        let q1 = dispatch_queue_create("io.cosmicmind.graph.thread.1", DISPATCH_QUEUE_SERIAL)
        let q2 = dispatch_queue_create("io.cosmicmind.graph.thread.2", DISPATCH_QUEUE_SERIAL)
        let q3 = dispatch_queue_create("io.cosmicmind.graph.thread.3", DISPATCH_QUEUE_SERIAL)
        
        let graph = Graph()
        graph.delegate = self
        graph.watchForRelationship(types: ["T"], groups: ["G"], properties: ["P"])
        
        let relationship = Relationship(type: "T")
        
        dispatch_async(q1) { [weak self] in
            relationship["P"] = 111
            relationship.addToGroup("G")
            
            graph.async { [weak self] (success: Bool, error: NSError?) in
                XCTAssertTrue(success, "\(error)")
                self?.insertSaveExpectation?.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        updateSaveExpectation = expectationWithDescription("Test: Save did not pass.")
        updatePropertyExpectation = expectationWithDescription("Test: Update did not pass.")
        
        dispatch_async(q2) { [weak self] in
            relationship["P"] = 222
            
            graph.async { [weak self] (success: Bool, error: NSError?) in
                XCTAssertTrue(success, "\(error)")
                self?.updateSaveExpectation?.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        deleteSaveExpectation = expectationWithDescription("Test: Save did not pass.")
        deleteExpectation = expectationWithDescription("Test: Delete did not pass.")
        deletePropertyExpectation = expectationWithDescription("Test: Delete property did not pass.")
        deleteGroupExpectation = expectationWithDescription("Test: Delete group did not pass.")
        
        dispatch_async(q3) { [weak self] in
            relationship.delete()
            
            graph.async { [weak self] (success: Bool, error: NSError?) in
                XCTAssertTrue(success, "\(error)")
                self?.deleteSaveExpectation?.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func graphDidInsertRelationship(graph: Graph, relationship: Relationship) {
        XCTAssertEqual("T", relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual(111, relationship["P"] as? Int)
        XCTAssertTrue(relationship.memberOfGroup("G"))
        
        insertExpectation?.fulfill()
    }
    
    func graphDidInsertRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject) {
        XCTAssertEqual("T", relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual(111, value as? Int)
        XCTAssertEqual(value as? Int, relationship[property] as? Int)
        
        insertPropertyExpectation?.fulfill()
    }
    
    func graphDidAddRelationshipToGroup(graph: Graph, relationship: Relationship, group: String) {
        XCTAssertEqual("T", relationship.type)
        XCTAssertEqual("G", group)
        XCTAssertTrue(relationship.memberOfGroup(group))
        
        insertGroupExpectation?.fulfill()
    }
    
    func graphDidUpdateRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject) {
        XCTAssertEqual("T", relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual(222, value as? Int)
        XCTAssertEqual(value as? Int, relationship[property] as? Int)
        
        updatePropertyExpectation?.fulfill()
    }
    
    func graphWillDeleteRelationship(graph: Graph, relationship: Relationship) {
        XCTAssertEqual("T", relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertNil(relationship["P"])
        XCTAssertFalse(relationship.memberOfGroup("G"))
        
        deleteExpectation?.fulfill()
    }
    
    func graphWillDeleteRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject) {
        XCTAssertEqual("T", relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("P", property)
        XCTAssertEqual(222, value as? Int)
        XCTAssertNil(relationship[property])
        
        deletePropertyExpectation?.fulfill()
    }
    
    func graphWillRemoveRelationshipFromGroup(graph: Graph, relationship: Relationship, group: String) {
        XCTAssertEqual("T", relationship.type)
        XCTAssertTrue(0 < relationship.id.characters.count)
        XCTAssertEqual("G", group)
        XCTAssertFalse(relationship.memberOfGroup("G"))
        
        deleteGroupExpectation?.fulfill()
    }
}
