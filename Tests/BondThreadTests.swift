//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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

class BondThreadTests : XCTestCase, GraphDelegate {
	var graph: Graph!
	
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
		graph = Graph()
		graph.delegate = self
		graph.watchForBond(types: ["T"], groups: ["G"], properties: ["P"])
	}
	
	override func tearDown() {
		graph = nil
		super.tearDown()
	}
	
	func testAll() {
		let q1: dispatch_queue_t = dispatch_queue_create("io.graphkit.BondThreadTests1", DISPATCH_QUEUE_SERIAL)
		let q2: dispatch_queue_t = dispatch_queue_create("io.graphkit.BondThreadTests2", DISPATCH_QUEUE_SERIAL)
		let q3: dispatch_queue_t = dispatch_queue_create("io.graphkit.BondThreadTests3", DISPATCH_QUEUE_SERIAL)
		
		insertSaveExpectation = expectationWithDescription("Test: Save did not pass.")
		insertExpectation = expectationWithDescription("Test: Insert did not pass.")
		insertPropertyExpectation = expectationWithDescription("Test: Insert property did not pass.")
		insertGroupExpectation = expectationWithDescription("Test: Insert group did not pass.")
		
		updateSaveExpectation = expectationWithDescription("Test: Save did not pass.")
		updatePropertyExpectation = expectationWithDescription("Test: Update did not pass.")
		
		deleteSaveExpectation = expectationWithDescription("Test: Save did not pass.")
		deleteExpectation = expectationWithDescription("Test: Delete did not pass.")
		deletePropertyExpectation = expectationWithDescription("Test: Delete property did not pass.")
		deleteGroupExpectation = expectationWithDescription("Test: Delete group did not pass.")
		
		dispatch_async(q1) {
			let n: Bond = Bond(type: "T")
			n["P"] = 111
			n.addGroup("G")
			
			self.graph.save { [unowned self] (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
				self.insertSaveExpectation?.fulfill()
			}
			
			dispatch_async(q2) {
				n["P"] = 222
				
				self.graph.save { [unowned self] (success: Bool, error: NSError?) in
					XCTAssertTrue(success, "Cannot save the Graph: \(error)")
					self.updateSaveExpectation?.fulfill()
				}
				
				dispatch_async(q3) {
					n.delete()
					
					self.graph.save { [unowned self] (success: Bool, error: NSError?) in
						XCTAssertTrue(success, "Cannot save the Graph: \(error)")
						self.deleteSaveExpectation?.fulfill()
					}
				}
			}
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
	func graphDidInsertBond(graph: Graph, bond: Bond) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue(bond["P"] as? Int == 111)
		XCTAssertTrue(bond.hasGroup("G"))
		insertExpectation?.fulfill()
	}
	
	func graphDidInsertBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("P" == property)
		XCTAssertTrue(111 == value as? Int)
		XCTAssertTrue(bond[property] as? Int == value as? Int)
		insertPropertyExpectation?.fulfill()
	}
	
	func graphDidInsertBondGroup(graph: Graph, bond: Bond, group: String) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("G" == group)
		insertGroupExpectation?.fulfill()
	}
	
	func graphDidUpdateBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("P" == property)
		XCTAssertTrue(222 == value as? Int)
		XCTAssertTrue(bond[property] as? Int == value as? Int)
		updatePropertyExpectation?.fulfill()
	}
	
	func graphDidDeleteBond(graph: Graph, bond: Bond) {
		XCTAssertTrue("T" == bond.type)
		deleteExpectation?.fulfill()
	}
	
	func graphDidDeleteBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("P" == property)
		XCTAssertTrue(222 == value as? Int)
		deletePropertyExpectation?.fulfill()
	}
	
	func graphDidDeleteBondGroup(graph: Graph, bond: Bond, group: String) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("G" == group)
		deleteGroupExpectation?.fulfill()
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

