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
*	*	Neither the name of GraphKit nor the names of its
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
@testable import GraphKit

class RelationshipIntTests : XCTestCase, GraphDelegate {
	var graph: Graph!
	
	var saveExpectation: XCTestExpectation?
	var insertExpectation: XCTestExpectation?
	var insertPropertyExpectation: XCTestExpectation?
	var insertGroupExpectation: XCTestExpectation?
	var updatePropertyExpectation: XCTestExpectation?
	var deleteExpectation: XCTestExpectation?
	var deletePropertyExpectation: XCTestExpectation?
	var deleteGroupExpectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
		graph = Graph()
		graph.delegate = self
	}
	
	override func tearDown() {
		graph = nil
		super.tearDown()
	}
	
	func testAll() {
		graph.clear()
		graph.watchForRelationship(types: ["T"], groups: ["G"], properties: ["P"])
		
		let n: Relationship = Relationship(type: "T")
		n["P"] = 111
		n.addGroup("G")
		
		n.subject = Entity(type: "S")
		n.object = Entity(type: "O")
		
		XCTAssertEqual(NodeClass.Relationship, n.nodeClass)
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		insertExpectation = expectationWithDescription("Test: Insert did not pass.")
		insertPropertyExpectation = expectationWithDescription("Test: Insert property did not pass.")
		insertGroupExpectation = expectationWithDescription("Test: Insert group did not pass.")
		
		graph.asyncSave { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		n["P"] = 222
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		updatePropertyExpectation = expectationWithDescription("Test: Update did not pass.")
		
		graph.asyncSave { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		n.delete()
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		deleteExpectation = expectationWithDescription("Test: Delete did not pass.")
		deletePropertyExpectation = expectationWithDescription("Test: Delete property did not pass.")
		deleteGroupExpectation = expectationWithDescription("Test: Delete group did not pass.")
		
		graph.asyncSave { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
	func graphDidInsertRelationship(graph: Graph, relationship: Relationship) {
		XCTAssertEqual("T", relationship.type)
		XCTAssertEqual(111, relationship["P"] as? Int)
		XCTAssertTrue(relationship.hasGroup("G"))
		XCTAssertEqual("S", relationship.subject?.type)
		XCTAssertEqual("O", relationship.object?.type)
		
		insertExpectation?.fulfill()
	}
	
	func graphDidInsertRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject) {
		XCTAssertEqual("T", relationship.type)
		XCTAssertEqual("P", property)
		XCTAssertEqual(111, value as? Int)
		XCTAssertEqual(relationship[property] as? Int, value as? Int)
		XCTAssertEqual("S", relationship.subject?.type)
		XCTAssertEqual("O", relationship.object?.type)
		
		insertPropertyExpectation?.fulfill()
	}
	
	func graphDidInsertRelationshipGroup(graph: Graph, relationship: Relationship, group: String) {
		XCTAssertEqual("T", relationship.type)
		XCTAssertEqual("G", group)
		XCTAssertEqual("S", relationship.subject?.type)
		XCTAssertEqual("O", relationship.object?.type)
		
		insertGroupExpectation?.fulfill()
	}
	
	func graphDidUpdateRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject) {
		XCTAssertEqual("T", relationship.type)
		XCTAssertEqual("P", property)
		XCTAssertEqual(222, value as? Int)
		XCTAssertEqual(relationship[property] as? Int, value as? Int)
		XCTAssertEqual("S", relationship.subject?.type)
		XCTAssertEqual("O", relationship.object?.type)
		
		updatePropertyExpectation?.fulfill()
	}
	
	func graphDidDeleteRelationship(graph: Graph, relationship: Relationship) {
		XCTAssertEqual("T", relationship.type)
		XCTAssertEqual("S", relationship.subject?.type)
		XCTAssertEqual("O", relationship.object?.type)
		
		deleteExpectation?.fulfill()
	}
	
	func graphDidDeleteRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject) {
		XCTAssertEqual("T", relationship.type)
		XCTAssertEqual("P", property)
		XCTAssertEqual(222, value as? Int)
		XCTAssertEqual("S", relationship.subject?.type)
		XCTAssertEqual("O", relationship.object?.type)
		
		deletePropertyExpectation?.fulfill()
	}
	
	func graphDidDeleteRelationshipGroup(graph: Graph, relationship: Relationship, group: String) {
		XCTAssertEqual("T", relationship.type)
		XCTAssertEqual("G", group)
		XCTAssertEqual("S", relationship.subject?.type)
		XCTAssertEqual("O", relationship.object?.type)
		
		deleteGroupExpectation?.fulfill()
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

