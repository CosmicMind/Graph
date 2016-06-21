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

class EntityActionTests : XCTestCase, GraphDelegate {
	var graph: Graph!
	
	var insertActionExpectation: XCTestExpectation?
	var deleteActionExpectation: XCTestExpectation?
	
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
		graph.watchForAction(types: ["A"])
		
		let e1: Entity = Entity(type: "T1")
		let e2: Entity = Entity(type: "T2")
		
		let a1: Action = Action(type: "A")
		a1.addSubject(e1)
		a1.addObject(e2)
		
		XCTAssertEqual(1, e1.actions.count)
		XCTAssertEqual(1, e1.actionsWhenSubject.count)
		XCTAssertEqual(0, e1.actionsWhenObject.count)
		XCTAssertEqual(a1, e1.actionsWhenSubject.first)
		
		XCTAssertEqual(1, e2.actions.count)
		XCTAssertEqual(0, e2.actionsWhenSubject.count)
		XCTAssertEqual(1, e2.actionsWhenObject.count)
		XCTAssertEqual(a1, e2.actionsWhenObject.first)
		
		insertActionExpectation = expectationWithDescription("Test: Delete did not pass.")
		
		graph.asyncSave { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		XCTAssertEqual(1, e1.actions.count)
		XCTAssertEqual(1, e1.actionsWhenSubject.count)
		XCTAssertEqual(0, e1.actionsWhenObject.count)
		XCTAssertEqual(a1, e1.actionsWhenSubject.first)
		
		XCTAssertEqual(1, e2.actions.count)
		XCTAssertEqual(0, e2.actionsWhenSubject.count)
		XCTAssertEqual(1, e2.actionsWhenObject.count)
		XCTAssertEqual(a1, e2.actionsWhenObject.first)
		
		a1.delete()
		
		XCTAssertEqual(0, e1.actions.count)
		XCTAssertEqual(0, e1.actionsWhenSubject.count)
		XCTAssertEqual(0, e1.actionsWhenObject.count)
		XCTAssertNotEqual(a1, e1.actionsWhenSubject.first)
		
		XCTAssertEqual(0, e2.actions.count)
		XCTAssertEqual(0, e2.actionsWhenSubject.count)
		XCTAssertEqual(0, e2.actionsWhenObject.count)
		XCTAssertNotEqual(a1, e2.actionsWhenObject.first)
		
		deleteActionExpectation = expectationWithDescription("Test: Delete did not pass.")
		
		graph.asyncSave { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		XCTAssertEqual(0, e1.actions.count)
		XCTAssertEqual(0, e1.actionsWhenSubject.count)
		XCTAssertEqual(0, e1.actionsWhenObject.count)
		XCTAssertNotEqual(a1, e1.actionsWhenSubject.first)
		
		XCTAssertEqual(0, e2.actions.count)
		XCTAssertEqual(0, e2.actionsWhenSubject.count)
		XCTAssertEqual(0, e2.actionsWhenObject.count)
		XCTAssertNotEqual(a1, e2.actionsWhenObject.first)
		
		let a2: Action = Action(type: "A")
		a2.addSubject(e1)
		a2.addObject(e1)
		
		XCTAssertEqual(1, e1.actions.count)
		XCTAssertEqual(1, e1.actionsWhenSubject.count)
		XCTAssertEqual(1, e1.actionsWhenObject.count)
		XCTAssertEqual(a2, e1.actionsWhenSubject.first)
		XCTAssertEqual(a2, e1.actionsWhenObject.first)
		
		insertActionExpectation = expectationWithDescription("Test: Delete did not pass.")
		
		graph.asyncSave { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		XCTAssertEqual(1, e1.actions.count)
		XCTAssertEqual(1, e1.actionsWhenSubject.count)
		XCTAssertEqual(1, e1.actionsWhenObject.count)
		XCTAssertEqual(a2, e1.actionsWhenSubject.first)
		XCTAssertEqual(a2, e1.actionsWhenObject.first)
		
		a2.delete()
		
		XCTAssertEqual(0, e1.actions.count)
		XCTAssertEqual(0, e1.actionsWhenSubject.count)
		XCTAssertEqual(0, e1.actionsWhenObject.count)
		XCTAssertNotEqual(a2, e1.actionsWhenSubject.first)
		XCTAssertNotEqual(a2, e1.actionsWhenObject.first)
		
		deleteActionExpectation = expectationWithDescription("Test: Delete did not pass.")
		
		graph.asyncSave { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		XCTAssertEqual(0, e1.actions.count)
		XCTAssertEqual(0, e1.actionsWhenSubject.count)
		XCTAssertEqual(0, e1.actionsWhenObject.count)
		XCTAssertNotEqual(a2, e1.actionsWhenSubject.first)
		XCTAssertNotEqual(a2, e1.actionsWhenObject.first)
	}
	
	func graphDidInsertAction(graph: Graph, action: Action) {
		if action.subjects.first != action.objects.first {
			XCTAssertEqual("A", action.type)
			XCTAssertEqual("T1", action.subjects.first?.type)
			XCTAssertEqual("T2", action.objects.first?.type)
			
			XCTAssertEqual(1, action.subjects.first?.actions.count)
			XCTAssertEqual(1, action.subjects.first?.actionsWhenSubject.count)
			XCTAssertEqual(0, action.subjects.first?.actionsWhenObject.count)
			XCTAssertEqual(action, action.subjects.first?.actionsWhenSubject.first)
			
			XCTAssertEqual(1, action.objects.first?.actions.count)
			XCTAssertEqual(0, action.objects.first?.actionsWhenSubject.count)
			XCTAssertEqual(1, action.objects.first?.actionsWhenObject.count)
			XCTAssertEqual(action, action.objects.first?.actionsWhenObject.first)
			
			insertActionExpectation?.fulfill()
		} else if action.subjects.first == action.objects.first {
			XCTAssertEqual("A", action.type)
			XCTAssertEqual("T1", action.subjects.first?.type)
			XCTAssertEqual("T1", action.objects.first?.type)
			
			XCTAssertEqual(1, action.subjects.first?.actions.count)
			XCTAssertEqual(1, action.subjects.first?.actionsWhenSubject.count)
			XCTAssertEqual(1, action.subjects.first?.actionsWhenObject.count)
			XCTAssertEqual(action, action.subjects.first?.actionsWhenSubject.first)
			
			XCTAssertEqual(1, action.objects.first?.actions.count)
			XCTAssertEqual(1, action.objects.first?.actionsWhenSubject.count)
			XCTAssertEqual(1, action.objects.first?.actionsWhenObject.count)
			XCTAssertEqual(action, action.objects.first?.actionsWhenObject.first)
			
			insertActionExpectation?.fulfill()
		}
	}
	
	func graphDidDeleteAction(graph: Graph, action: Action) {
		if action.subjects.first != action.objects.first {
			XCTAssertEqual("A", action.type)
			XCTAssertEqual("T1", action.subjects.first?.type)
			XCTAssertEqual("T2", action.objects.first?.type)
			
			XCTAssertEqual(0, action.subjects.first?.actions.count)
			XCTAssertEqual(0, action.subjects.first?.actionsWhenSubject.count)
			XCTAssertEqual(0, action.subjects.first?.actionsWhenObject.count)
			XCTAssertNotEqual(action, action.subjects.first?.actionsWhenSubject.first)
			
			XCTAssertEqual(0, action.objects.first?.actions.count)
			XCTAssertEqual(0, action.objects.first?.actionsWhenSubject.count)
			XCTAssertEqual(0, action.objects.first?.actionsWhenObject.count)
			XCTAssertNotEqual(action, action.objects.first?.actionsWhenObject.first)
			
			deleteActionExpectation?.fulfill()
		} else if action.subjects.first == action.objects.first {
			XCTAssertEqual("A", action.type)
			XCTAssertEqual("T1", action.subjects.first?.type)
			XCTAssertEqual("T1", action.objects.first?.type)
			
			XCTAssertEqual(0, action.subjects.first?.actions.count)
			XCTAssertEqual(0, action.subjects.first?.actionsWhenSubject.count)
			XCTAssertEqual(0, action.subjects.first?.actionsWhenObject.count)
			XCTAssertNotEqual(action, action.subjects.first?.actionsWhenSubject.first)
			
			XCTAssertEqual(0, action.objects.first?.actions.count)
			XCTAssertEqual(0, action.objects.first?.actionsWhenSubject.count)
			XCTAssertEqual(0, action.objects.first?.actionsWhenObject.count)
			XCTAssertNotEqual(action, action.objects.first?.actionsWhenObject.first)
			
			deleteActionExpectation?.fulfill()
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

