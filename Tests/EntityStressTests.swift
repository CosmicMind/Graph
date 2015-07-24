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

class EntityStressTests : XCTestCase, GraphDelegate {
	
	var expectation: XCTestExpectation?
	
	// queue for drawing images
	private var queue1: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.EntityStressTests.1" as NSString).UTF8String, nil)
	}()
	
	private var queue2: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.EntityStressTests.2" as NSString).UTF8String, nil)
	}()
	
	private var queue3: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.EntityStressTests.3" as NSString).UTF8String, nil)
	}()
	
	private var queue4: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.EntityStressTests.4" as NSString).UTF8String, nil)
	}()
	
	private var graph: Graph?
	
	override func setUp() {
		super.setUp()
		graph = Graph()
	}
	
	override func tearDown() {
		graph = nil
		expectation = nil
		super.tearDown()
	}
	
	func testExternalThread() {

		// Set the XCTest Class as the delegate.
		graph?.delegate = self
		
		// Let's watch the changes in the Graph for the following Entity values.
		graph?.watch(Entity: "E")
		
		var e1: Entity?
		
		dispatch_async(queue1) {
			e1 = Entity(type: "E")
			for i in 1...100 {
				let prop: String = String(i)
				e1!.addGroup(prop)
				e1!.addGroup("test")
				e1!["test"] = "test"
				e1![prop] = i
			}
			dispatch_async(self.queue2) {
				for i in 1...50 {
					let prop: String = String(i)
					e1!.addGroup(prop)
					e1!.addGroup("test")
					e1!.removeGroup(prop)
					e1![prop] = i
					e1!["test"] = "test"
					e1![prop] = nil
				}
				dispatch_async(self.queue3) {
					for i in 1...100 {
						let prop: String = String(i)
						e1!.addGroup(prop)
						e1!.addGroup("test")
						e1![prop] = i
						e1!["test"] = "test"
					}
					dispatch_async(self.queue4) {
						for i in 1...50 {
							let prop: String = String(i)
							e1!.addGroup(prop)
							e1!.addGroup("test")
							e1!.removeGroup(prop)
							e1![prop] = i
							e1!["test"] = "test"
							e1![prop] = nil
						}
						self.graph?.save { (success: Bool, error: NSError?) in
							XCTAssertTrue(success, "Cannot save the Graph: \(error)")
						}
					}
				}
			}
		}

		expectation = expectationWithDescription("Entity: Insert did not pass.")

		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
		
		expectation = expectationWithDescription("Entity: Delete did not pass.")
		
		e1!.delete()
		
		graph?.save(nil)

		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func graph(graph: Graph, didInsertEntity entity: Entity) {
		if 51 == entity.groups.count && 51 == entity.properties.count {
			expectation?.fulfill()
		}
	}
	
	func graph(graph: Graph, didDeleteEntity entity: Entity) {
		if 0 == entity.groups.count && 0 == entity.properties.count {
			expectation?.fulfill()
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
