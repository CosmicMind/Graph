/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software packnumeric
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import XCTest
import GraphKit

class EntitySearchTests : XCTestCase, GraphDelegate {
	
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
		
		// Let's watch the changes in the Graph for the following Entity values.
		graph?.watch(Entity: "E")
		graph?.watch(EntityProperty: "active")
		
		XCTAssertTrue(0 == graph?.search(EntityProperty: "active").count, "Entity: Search did not pass.")
		
		var e1: Entity = Entity(type: "E")
		e1["active"] = true
		
		var e2: Entity? = graph?.search(EntityProperty: "active").last?.value
		
		XCTAssertTrue(e1 == e2, "Entity: Search did not pass.")
		
		expectation = expectationWithDescription("Entity: Insert did not pass.")
		
		graph?.save{ (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func graph(graph: Graph, didInsertEntity entity: Entity) {
		var e2: Entity? = graph.search(EntityProperty: "active").last?.value
		if entity == e2 {
			expectation?.fulfill()
			
			e2?["active"] = false
			
			expectation = expectationWithDescription("Entity: Property Update did not pass.")
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
	
	func graph(graph: Graph, didDeleteEntity entity: Entity) {
		var e2: Entity? = graph.search(EntityProperty: "active").last?.value
		if nil == e2 {
			expectation?.fulfill()
			XCTAssertTrue(0 == graph.search(EntityProperty: "active").count, "Entity: Search did not pass.")
		}
	}
	
	func graph(graph: Graph, didUpdateEntity entity: Entity, property: String, value: AnyObject) {
		var e2: Entity? = graph.search(EntityProperty: "active").last?.value
		if value as! Bool == entity["active"] as! Bool && false == value as! Bool {
			expectation?.fulfill()
			
			entity["active"] = nil
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
			
			XCTAssertTrue(0 == graph.search(EntityProperty: "active").count, "Entity: Search did not pass.")
			
			expectation = expectationWithDescription("Entity: Delete did not pass.")
			
			entity.delete()
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
}
