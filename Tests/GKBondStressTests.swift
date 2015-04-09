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
import GKGraphKit

class GKBondStressTests : XCTestCase, GKGraphDelegate {
	
	var expectation: XCTestExpectation?
	
	// queue for drawing images
	private var queub1: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.BondStressTests.1" as NSString).UTF8String, nil)
	}()
	
	private var queue2: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.BondStressTests.2" as NSString).UTF8String, nil)
	}()
	
	private var queue3: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.BondStressTests.3" as NSString).UTF8String, nil)
	}()
	
	private var queue4: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.BondStressTests.4" as NSString).UTF8String, nil)
	}()
	
	private var graph: GKGraph?
	
	override func setUp() {
		super.setUp()
		graph = GKGraph()
	}
	
	override func tearDown() {
		super.tearDown()
		graph = nil
	}
	
	func testExternalThread() {
		
		// Set the XCTest Class as the delegate.
		graph?.delegate = self
		
		// Let's watch the changes in the Graph for the following Bond values.
		graph?.watch(Bond: "B")
		
		var b1: GKBond?
		
		dispatch_async(queub1) {
			b1 = GKBond(type: "B")
			for i in 1...1000 {
				let prop: String = String(i)
				b1!.addGroup(prop)
				b1!.addGroup("test")
				b1!["test"] = "test"
				b1![prop] = i
			}
			dispatch_async(self.queue2) {
				for i in 1...500 {
					let prop: String = String(i)
					b1!.addGroup(prop)
					b1!.addGroup("test")
					b1!.removeGroup(prop)
					b1![prop] = i
					b1!["test"] = "test"
					b1![prop] = nil
				}
				dispatch_async(self.queue3) {
					for i in 1...1000 {
						let prop: String = String(i)
						b1!.addGroup(prop)
						b1!.addGroup("test")
						b1![prop] = i
						b1!["test"] = "test"
					}
					dispatch_async(self.queue4) {
						for i in 1...500 {
							let prop: String = String(i)
							b1!.addGroup(prop)
							b1!.addGroup("test")
							b1!.removeGroup(prop)
							b1![prop] = i
							b1!["test"] = "test"
							b1![prop] = nil
						}
						self.graph?.save() { (success: Bool, error: NSError?) in
							XCTAssertTrue(success, "Cannot save the Graph: \(error)")
						}

					}
				}
			}
		}
		
		expectation = expectationWithDescription("Bond: Insert did not pass.")
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(120, handler: nil)
		
		expectation = expectationWithDescription("Bond: Delete did not pass.")
		
		b1!.delete()
		
		graph?.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(120, handler: nil)
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
	
	func graph(graph: GKGraph!, didInsertBond bond: GKBond!) {
		if 501 == bond.groups.count && 501 == bond.properties.count {
			expectation?.fulfill()
		}
	}
	
	func graph(graph: GKGraph!, didDeleteBond bond: GKBond!) {
		if 0 == bond.groups.count && 0 == bond.properties.count {
			expectation?.fulfill()
		}
	}
}
