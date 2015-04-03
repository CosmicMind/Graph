//
//  GKStressTests.swift
//  GKGraphKit
//
//  Created by Daniel Dahan on 2015-03-31.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import XCTest
import GKGraphKit

class GKEntityStressTests : XCTestCase, GKGraphDelegate {
	
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
		
		// Let's watch the changes in the Graph for the following Entity values.
		graph?.watch(Entity: "E")
		
		var e1: GKEntity?
		
		dispatch_async(queue1) {
			e1 = GKEntity(type: "E")
			for i in 1...1000 {
				let prop: String = String(i)
				e1!.addGroup(prop)
				e1!.addGroup("test")
				e1!["test"] = "test"
				e1![prop] = i
			}
			dispatch_async(self.queue2) {
				for i in 1...500 {
					let prop: String = String(i)
					e1!.addGroup(prop)
					e1!.addGroup("test")
					e1!.removeGroup(prop)
					e1![prop] = i
					e1!["test"] = "test"
					e1![prop] = nil
				}
				dispatch_async(self.queue3) {
					for i in 1...1000 {
						let prop: String = String(i)
						e1!.addGroup(prop)
						e1!.addGroup("test")
						e1![prop] = i
						e1!["test"] = "test"
					}
					dispatch_async(self.queue4) {
						for i in 1...500 {
							let prop: String = String(i)
							e1!.addGroup(prop)
							e1!.addGroup("test")
							e1!.removeGroup(prop)
							e1![prop] = i
							e1!["test"] = "test"
							e1![prop] = nil
						}
						self.graph?.save{ (success: Bool, error: NSError?) in
							XCTAssertTrue(success, "Cannot save the Graph: \(error)")
						}
					}
				}
			}
		}

		expectation = expectationWithDescription("Entity: Insert did not pass.")

		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(120, handler: nil)
		
		expectation = expectationWithDescription("Entity: Delete did not pass.")
		
		e1!.delete()
		
		graph?.save(nil)

		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(120, handler: nil)
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
	
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
		if 501 == entity.groups.count && 501 == entity.properties.count {
			expectation?.fulfill()
		}
	}
	
	func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
		if 0 == entity.groups.count && 0 == entity.properties.count {
			expectation?.fulfill()
		}
	}
}
