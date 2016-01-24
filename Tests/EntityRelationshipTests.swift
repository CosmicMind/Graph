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
*	*	Neither the name of Graph nor the names of its
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

class EntityRelationshipTests : XCTestCase, GraphDelegate {
	var graph: Graph!
	
	var insertRelationshipExpectation: XCTestExpectation?
	var deleteRelationshipExpectation: XCTestExpectation?
	
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
		graph.watchForEntity(types: ["T1", "T2"])
		graph.watchForRelationship(types: ["R"])
		
		let e1: Entity = Entity(type: "T1")
		let e2: Entity = Entity(type: "T2")
		
		let r1: Relationship = Relationship(type: "R")
		r1.subject = e1
		r1.object = e2
		
		XCTAssertEqual(1, e1.relationships.count)
		XCTAssertEqual(1, e1.relationshipsWhenSubject.count)
		XCTAssertEqual(0, e1.relationshipsWhenObject.count)
		XCTAssertEqual(r1, e1.relationshipsWhenSubject.first)
		
		XCTAssertEqual(1, e2.relationships.count)
		XCTAssertEqual(0, e2.relationshipsWhenSubject.count)
		XCTAssertEqual(1, e2.relationshipsWhenObject.count)
		XCTAssertEqual(r1, e2.relationshipsWhenObject.first)
		
		insertRelationshipExpectation = expectationWithDescription("Test: Delete did not pass.")
		
		graph.asyncSave { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		XCTAssertEqual(1, e1.relationships.count)
		XCTAssertEqual(1, e1.relationshipsWhenSubject.count)
		XCTAssertEqual(0, e1.relationshipsWhenObject.count)
		XCTAssertEqual(r1, e1.relationshipsWhenSubject.first)
		
		XCTAssertEqual(1, e2.relationships.count)
		XCTAssertEqual(0, e2.relationshipsWhenSubject.count)
		XCTAssertEqual(1, e2.relationshipsWhenObject.count)
		XCTAssertEqual(r1, e2.relationshipsWhenObject.first)
		
		r1.delete()
		
		XCTAssertEqual(0, e1.relationships.count)
		XCTAssertEqual(0, e1.relationshipsWhenSubject.count)
		XCTAssertEqual(0, e1.relationshipsWhenObject.count)
		XCTAssertNotEqual(r1, e1.relationshipsWhenSubject.first)
		
		XCTAssertEqual(0, e2.relationships.count)
		XCTAssertEqual(0, e2.relationshipsWhenSubject.count)
		XCTAssertEqual(0, e2.relationshipsWhenObject.count)
		XCTAssertNotEqual(r1, e2.relationshipsWhenObject.first)
		
		deleteRelationshipExpectation = expectationWithDescription("Test: Delete did not pass.")
		
		graph.asyncSave { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		XCTAssertEqual(0, e1.relationships.count)
		XCTAssertEqual(0, e1.relationshipsWhenSubject.count)
		XCTAssertEqual(0, e1.relationshipsWhenObject.count)
		XCTAssertNotEqual(r1, e1.relationshipsWhenSubject.first)
		
		XCTAssertEqual(0, e2.relationships.count)
		XCTAssertEqual(0, e2.relationshipsWhenSubject.count)
		XCTAssertEqual(0, e2.relationshipsWhenObject.count)
		XCTAssertNotEqual(r1, e2.relationshipsWhenObject.first)
		
		let r2: Relationship = Relationship(type: "R")
		r2.subject = e1
		r2.object = e1
		
		XCTAssertEqual(1, e1.relationships.count)
		XCTAssertEqual(1, e1.relationshipsWhenSubject.count)
		XCTAssertEqual(1, e1.relationshipsWhenObject.count)
		XCTAssertEqual(r2, e1.relationshipsWhenSubject.first)
		XCTAssertEqual(r2, e1.relationshipsWhenObject.first)
		
		insertRelationshipExpectation = expectationWithDescription("Test: Delete did not pass.")
		
		graph.asyncSave { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		XCTAssertEqual(1, e1.relationships.count)
		XCTAssertEqual(1, e1.relationshipsWhenSubject.count)
		XCTAssertEqual(1, e1.relationshipsWhenObject.count)
		XCTAssertEqual(r2, e1.relationshipsWhenSubject.first)
		XCTAssertEqual(r2, e1.relationshipsWhenObject.first)
		
		r2.delete()
		
		XCTAssertEqual(0, e1.relationships.count)
		XCTAssertEqual(0, e1.relationshipsWhenSubject.count)
		XCTAssertEqual(0, e1.relationshipsWhenObject.count)
		XCTAssertNotEqual(r2, e1.relationshipsWhenSubject.first)
		XCTAssertNotEqual(r2, e1.relationshipsWhenObject.first)
		
		deleteRelationshipExpectation = expectationWithDescription("Test: Delete did not pass.")
		
		graph.asyncSave { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		XCTAssertEqual(0, e1.relationships.count)
		XCTAssertEqual(0, e1.relationshipsWhenSubject.count)
		XCTAssertEqual(0, e1.relationshipsWhenObject.count)
		XCTAssertNotEqual(r2, e1.relationshipsWhenSubject.first)
		XCTAssertNotEqual(r2, e1.relationshipsWhenObject.first)
	}
	
	func graphDidInsertRelationship(graph: Graph, relationship: Relationship) {
		if relationship.subject != relationship.object {
			XCTAssertEqual("R", relationship.type)
			XCTAssertEqual("T1", relationship.subject?.type)
			XCTAssertEqual("T2", relationship.object?.type)
			
			XCTAssertEqual(1, relationship.subject?.relationships.count)
			XCTAssertEqual(1, relationship.subject?.relationshipsWhenSubject.count)
			XCTAssertEqual(0, relationship.subject?.relationshipsWhenObject.count)
			XCTAssertEqual(relationship, relationship.subject?.relationshipsWhenSubject.first)
			
			XCTAssertEqual(1, relationship.object?.relationships.count)
			XCTAssertEqual(0, relationship.object?.relationshipsWhenSubject.count)
			XCTAssertEqual(1, relationship.object?.relationshipsWhenObject.count)
			XCTAssertEqual(relationship, relationship.object?.relationshipsWhenObject.first)
			
			insertRelationshipExpectation?.fulfill()
		} else if relationship.subject == relationship.object {
			XCTAssertEqual("R", relationship.type)
			XCTAssertEqual("T1", relationship.subject?.type)
			XCTAssertEqual("T1", relationship.object?.type)
			
			XCTAssertEqual(1, relationship.subject?.relationships.count)
			XCTAssertEqual(1, relationship.subject?.relationshipsWhenSubject.count)
			XCTAssertEqual(1, relationship.subject?.relationshipsWhenObject.count)
			XCTAssertEqual(relationship, relationship.subject?.relationshipsWhenSubject.first)
			
			XCTAssertEqual(1, relationship.object?.relationships.count)
			XCTAssertEqual(1, relationship.object?.relationshipsWhenSubject.count)
			XCTAssertEqual(1, relationship.object?.relationshipsWhenObject.count)
			XCTAssertEqual(relationship, relationship.object?.relationshipsWhenObject.first)
			
			insertRelationshipExpectation?.fulfill()
		}
	}
	
	func graphDidDeleteRelationship(graph: Graph, relationship: Relationship) {
		if relationship.subject != relationship.object {
			XCTAssertEqual("R", relationship.type)
			XCTAssertEqual("T1", relationship.subject?.type)
			XCTAssertEqual("T2", relationship.object?.type)
			
			XCTAssertEqual(0, relationship.subject?.relationships.count)
			XCTAssertEqual(0, relationship.subject?.relationshipsWhenSubject.count)
			XCTAssertEqual(0, relationship.subject?.relationshipsWhenObject.count)
			XCTAssertNotEqual(relationship, relationship.subject?.relationshipsWhenSubject.first)
			
			XCTAssertEqual(0, relationship.object?.relationships.count)
			XCTAssertEqual(0, relationship.object?.relationshipsWhenSubject.count)
			XCTAssertEqual(0, relationship.object?.relationshipsWhenObject.count)
			XCTAssertNotEqual(relationship, relationship.object?.relationshipsWhenObject.first)
			
			deleteRelationshipExpectation?.fulfill()
		} else if relationship.subject == relationship.object {
			XCTAssertEqual("R", relationship.type)
			XCTAssertEqual("T1", relationship.subject?.type)
			XCTAssertEqual("T1", relationship.object?.type)
			
			XCTAssertEqual(0, relationship.subject?.relationships.count)
			XCTAssertEqual(0, relationship.subject?.relationshipsWhenSubject.count)
			XCTAssertEqual(0, relationship.subject?.relationshipsWhenObject.count)
			XCTAssertNotEqual(relationship, relationship.subject?.relationshipsWhenSubject.first)
			
			XCTAssertEqual(0, relationship.object?.relationships.count)
			XCTAssertEqual(0, relationship.object?.relationshipsWhenSubject.count)
			XCTAssertEqual(0, relationship.object?.relationshipsWhenObject.count)
			XCTAssertNotEqual(relationship, relationship.object?.relationshipsWhenObject.first)
			
			deleteRelationshipExpectation?.fulfill()
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

