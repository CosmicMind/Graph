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

class ActionStressTests : XCTestCase, GraphDelegate {
	var graph: Graph!
	
	var insertActionCount: Int = 0
	var insertPropertyCount: Int = 0
	var insertGroupCount: Int = 0
	var updatePropertyCount: Int = 0
	
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
		graph.watchForEntity(types: ["S", "O"])
		graph.watchForAction(types: ["T"], groups: ["G"], properties: ["P"])
		
		let subjects: SortedSet<Entity> = SortedSet<Entity>()
		for var i = 0; i < 5; ++i {
			subjects.insert(Entity(type: "S"))
		}
		
		let objects: SortedSet<Entity> = SortedSet<Entity>()
		for var i = 0; i < 5; ++i {
			objects.insert(Entity(type: "O"))
		}
		
		for var i: Int = 100; i > 0; --i {
			let n: Action = Action(type: "T")
			n["P"] = "A"
			n.addGroup("G")
			
			for s in subjects {
				n.addSubject(s)
			}
			
			for o in objects {
				n.addObject(o)
			}
		}
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		insertExpectation = expectationWithDescription("Test: Insert did not pass.")
		insertPropertyExpectation = expectationWithDescription("Test: Insert property did not pass.")
		insertGroupExpectation = expectationWithDescription("Test: Insert group did not pass.")
		
		graph.syncSave { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		for n in graph.searchForAction(types: ["T"]) {
			n["P"] = "B"
		}
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		updatePropertyExpectation = expectationWithDescription("Test: Update did not pass.")
		
		graph.syncSave { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		for n in graph.searchForAction(types: ["T"]) {
			n.delete()
		}
		
		for s in subjects {
			s.delete()
		}
		
		for o in objects {
			o.delete()
		}
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		deleteExpectation = expectationWithDescription("Test: Delete did not pass.")
		deletePropertyExpectation = expectationWithDescription("Test: Delete property did not pass.")
		deleteGroupExpectation = expectationWithDescription("Test: Delete group did not pass.")
		
		graph.syncSave { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
	func graphDidInsertAction(graph: Graph, action: Action) {
		XCTAssertEqual("T", action.type)
		XCTAssertEqual("A", action["P"] as? String)
		XCTAssertTrue(action.hasGroup("G"))
		XCTAssertTrue(5 == action.subjects.count)
		XCTAssertTrue(5 == action.objects.count)
		
		if 100 == ++insertActionCount {
			insertExpectation?.fulfill()
		}
	}
	
	func graphDidInsertActionProperty(graph: Graph, action: Action, property: String, value: AnyObject) {
		XCTAssertEqual("T", action.type)
		XCTAssertEqual("P", property)
		XCTAssertEqual("A", value as? String)
		XCTAssertEqual(action[property] as? String, value as? String)
		XCTAssertEqual(5, action.subjects.count)
		XCTAssertEqual(5, action.objects.count)
		
		if 100 == ++insertPropertyCount {
			insertPropertyExpectation?.fulfill()
		}
	}
	
	func graphDidInsertActionGroup(graph: Graph, action: Action, group: String) {
		XCTAssertEqual("T", action.type)
		XCTAssertEqual("G", group)
		XCTAssertEqual(5, action.subjects.count)
		XCTAssertEqual(5, action.objects.count)
		
		if 100 == ++insertGroupCount {
			insertGroupExpectation?.fulfill()
		}
	}
	
	func graphDidUpdateActionProperty(graph: Graph, action: Action, property: String, value: AnyObject) {
		XCTAssertEqual("T", action.type)
		XCTAssertEqual("P", property)
		XCTAssertEqual("B", value as? String)
		XCTAssertEqual(action[property] as? String, value as? String)
		XCTAssertEqual(5, action.subjects.count)
		XCTAssertEqual(5, action.objects.count)
		
		if 100 == ++updatePropertyCount {
			updatePropertyExpectation?.fulfill()
		}
	}
	
	func graphDidDeleteAction(graph: Graph, action: Action) {
		XCTAssertEqual("T", action.type)
		XCTAssertEqual(5, action.subjects.count)
		XCTAssertEqual(5, action.objects.count)
		
		if 0 == --insertActionCount {
			deleteExpectation?.fulfill()
		}
	}
	
	func graphDidDeleteActionProperty(graph: Graph, action: Action, property: String, value: AnyObject) {
		XCTAssertEqual("T", action.type)
		XCTAssertEqual("P", property)
		XCTAssertEqual("B", value as? String)
		XCTAssertEqual(5, action.subjects.count)
		XCTAssertEqual(5, action.objects.count)
		
		if 0 == --insertPropertyCount {
			deletePropertyExpectation?.fulfill()
		}
	}
	
	func graphDidDeleteActionGroup(graph: Graph, action: Action, group: String) {
		XCTAssertEqual("T", action.type)
		XCTAssertEqual("G", group)
		XCTAssertEqual(5, action.subjects.count)
		XCTAssertEqual(5, action.objects.count)
		
		if 0 == --insertGroupCount {
			deleteGroupExpectation?.fulfill()
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

