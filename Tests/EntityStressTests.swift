//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import XCTest
@testable import GraphKit

class EntityStressTests : XCTestCase, GraphDelegate {
	
	private var graph: Graph!
	
	var insertEntityCount: Int = 0
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
		graph.watch(entity: ["T"], group: ["G"], property: ["P"])
	}
	
	override func tearDown() {
		graph = nil
		super.tearDown()
	}
	
	func testAll() {
		for var i: Int = 1000; i > 0; --i {
			let n: Entity = Entity(type: "T")
			n["P"] = "A"
			n.addGroup("G")
		}
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		insertExpectation = expectationWithDescription("Test: Insert did not pass.")
		insertPropertyExpectation = expectationWithDescription("Test: Insert property did not pass.")
		insertGroupExpectation = expectationWithDescription("Test: Insert group did not pass.")
		
		graph.save { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		for n in graph.search(entity: ["T"]) {
			n["P"] = "B"
		}
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		updatePropertyExpectation = expectationWithDescription("Test: Update did not pass.")
		
		graph.save { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		for n in graph.search(entity: ["T"]) {
			n.delete()
		}
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		deleteExpectation = expectationWithDescription("Test: Delete did not pass.")
		deletePropertyExpectation = expectationWithDescription("Test: Delete property did not pass.")
		deleteGroupExpectation = expectationWithDescription("Test: Delete group did not pass.")
		
		graph.save { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
	func graphDidInsertEntity(graph: Graph, entity: Entity) {
		XCTAssertTrue("T" == entity.type)
		XCTAssertTrue(entity["P"] as? String == "A")
		XCTAssertTrue(entity.hasGroup("G"))
		if 1000 == ++insertEntityCount {
			insertExpectation?.fulfill()
		}
	}
	
	func graphDidInsertEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
		XCTAssertTrue("T" == entity.type)
		XCTAssertTrue("P" == property)
		XCTAssertTrue("A" == value as? String)
		XCTAssertTrue(entity[property] as? String == value as? String)
		if 1000 == ++insertPropertyCount {
			insertPropertyExpectation?.fulfill()
		}
	}
	
	func graphDidInsertEntityGroup(graph: Graph, entity: Entity, group: String) {
		XCTAssertTrue("T" == entity.type)
		XCTAssertTrue("G" == group)
		if 1000 == ++insertGroupCount {
			insertGroupExpectation?.fulfill()
		}
	}
	
	func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
		XCTAssertTrue("T" == entity.type)
		XCTAssertTrue("P" == property)
		XCTAssertTrue("B" == value as? String)
		XCTAssertTrue(entity[property] as? String == value as? String)
		if 1000 == ++updatePropertyCount {
			updatePropertyExpectation?.fulfill()
		}
	}
	
	func graphDidDeleteEntity(graph: Graph, entity: Entity) {
		XCTAssertTrue("T" == entity.type)
		if 0 == --insertEntityCount {
			deleteExpectation?.fulfill()
		}
	}
	
	func graphDidDeleteEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
		XCTAssertTrue("T" == entity.type)
		XCTAssertTrue("P" == property)
		XCTAssertTrue("B" == value as? String)
		if 0 == --insertPropertyCount {
			deletePropertyExpectation?.fulfill()
		}
	}
	
	func graphDidDeleteEntityGroup(graph: Graph, entity: Entity, group: String) {
		XCTAssertTrue("T" == entity.type)
		XCTAssertTrue("G" == group)
		if 0 == --insertGroupCount {
			deleteGroupExpectation?.fulfill()
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

