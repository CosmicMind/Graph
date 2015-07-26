//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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
import GraphKit

class BondSearchTests : XCTestCase, GraphDelegate {
	
	private var graph: Graph?
	
	var expectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
		graph = Graph()
	}
	
	override func tearDown() {
		graph = nil
		expectation = nil

		super.tearDown()
	}
	
	func testAll() {
		
		// Set the XCTest Class as the delegate.
		graph?.delegate = self
		
		// Let's watch the changes in the Graph for the following Bond values.
		graph?.watch(Bond: "B")
		graph?.watch(BondProperty: "active")
		
		XCTAssertTrue(0 == graph?.search(BondProperty: "active").count, "Test failed.")
		
		var b1: Bond = Bond(type: "B")
		b1["active"] = true
		
		var b2: Bond? = graph?.search(BondProperty: "active").last?.value
		
		XCTAssertTrue(b1 == b2, "Bond: Search did not pass.")
		
		expectation = expectationWithDescription("Bond: Insert did not pass.")
		
		graph?.save{ (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func graphDidInsertBond(graph: Graph, bond: Bond) {
		var b2: Bond? = graph.search(BondProperty: "active").last?.value
		if bond == b2 {
			expectation?.fulfill()
			
			b2?["active"] = false
			
			expectation = expectationWithDescription("Test failed.")
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
	
	func graphDidDeleteBond(graph: Graph, bond: Bond) {
		var b2: Bond? = graph.search(BondProperty: "active").last?.value
		if nil == b2 {
			expectation?.fulfill()
			XCTAssertTrue(0 == graph.search(BondProperty: "active").count, "Test failed.")
		}
	}
	
	func graphDidUpdateBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {
		var b2: Bond? = graph.search(BondProperty: "active").last?.value
		if value as! Bool == bond["active"] as! Bool && false == value as! Bool {
			expectation?.fulfill()
			
			bond["active"] = nil
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
			
			XCTAssertTrue(0 == graph.search(BondProperty: "active").count, "Test failed.")
			
			expectation = expectationWithDescription("Bond: Delete did not pass.")
			
			bond.delete()
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

