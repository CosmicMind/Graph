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

class ActionSearchTests : XCTestCase, GraphDelegate {
	
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
		
		// Let's watch the changes in the Graph for the following Action values.
		graph?.watch(Action: "A")
		graph?.watch(ActionProperty: "active")
		
		XCTAssertTrue(0 == graph?.search(ActionProperty: "active").count, "Test failed.")
		
		var a1: Action = Action(type: "A")
		a1["active"] = true
		
		var a2: Action? = graph?.search(ActionProperty: "active").last?.value
		
		XCTAssertTrue(a1 == a2, "Test failed.")
		
		expectation = expectationWithDescription("Action: Insert did not pass.")
		
		graph?.save{ (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func graphDidInsertAction(graph: Graph, action: Action) {
		var a2: Action? = graph.search(ActionProperty: "active").last?.value
		if action == a2 {
			expectation?.fulfill()
			
			a2?["active"] = false
			
			expectation = expectationWithDescription("Test failed.")
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
	
	func graphDidDeleteAction(graph: Graph, action: Action) {
		var a2: Action? = graph.search(ActionProperty: "active").last?.value
		if nil == a2 {
			expectation?.fulfill()
			XCTAssertTrue(0 == graph.search(ActionProperty: "active").count, "Test failed.")
		}
	}
	
	func graphDidUpdateActionProperty(graph: Graph, action: Action,property: String,value: AnyObject){
		var a2: Action? = graph.search(ActionProperty: "active").last?.value
		if value as! Bool == action["active"] as! Bool && false == value as! Bool {
			expectation?.fulfill()
			
			action["active"] = nil
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
			
			XCTAssertTrue(0 == graph.search(ActionProperty: "active").count, "Test failed.")
			
			expectation = expectationWithDescription("Action: Delete did not pass.")
			
			action.delete()
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

