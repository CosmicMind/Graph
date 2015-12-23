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

class EntityTests : XCTestCase, GraphDelegate {
	
	private var graph: Graph!
	
	var saveExpectation: XCTestExpectation?
	var insertExpectation: XCTestExpectation?
	var updateExpectation: XCTestExpectation?
	var deleteExpectation: XCTestExpectation?
	var deletePropertyExpectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
		graph = Graph()
		graph.delegate = self
		graph.watch(entity: ["T"], property: ["name"])
	}
	
	override func tearDown() {
		graph = nil
		super.tearDown()
	}
	
	func testGeneral() {
		let n1: Entity = Entity(type: "T")
		n1["name"] = "Daniel"
		
		saveExpectation = expectationWithDescription("Concurrency: Save did not pass.")
		insertExpectation = expectationWithDescription("Concurrency: Insert did not pass.")
		
		graph?.save { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
	
		n1["name"] = "Eve"

		saveExpectation = expectationWithDescription("Concurrency: Save did not pass.")
		updateExpectation = expectationWithDescription("Concurrency: Update did not pass.")
		
		graph?.save { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		n1.delete()
		
		saveExpectation = expectationWithDescription("Concurrency: Save did not pass.")
		deleteExpectation = expectationWithDescription("Concurrency: Delete did not pass.")
		deletePropertyExpectation = expectationWithDescription("Concurrency: Delete property did not pass.")
		
		graph?.save { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
	func graphDidInsertEntity(graph: Graph, entity: Entity) {
		XCTAssertTrue(entity["name"] as? String == "Daniel")
		insertExpectation?.fulfill()
	}
	
	func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
		XCTAssertTrue(entity[property] as? String == value as? String)
		updateExpectation?.fulfill()
	}
	
	func graphDidDeleteEntity(graph: Graph, entity: Entity) {
		deleteExpectation?.fulfill()
	}
	
	func graphDidDeleteEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
		XCTAssertTrue("T" == entity.type)
		XCTAssertTrue("name" == property)
		XCTAssertTrue("Eve" == value as? String)
		deletePropertyExpectation?.fulfill()
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

