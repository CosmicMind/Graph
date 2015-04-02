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
	
	lazy var graph: GKGraph = GKGraph()
	
	var expectation: XCTestExpectation?
	
	// queue for drawing images
	private var queue1: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.EntityStressTests.1" as NSString).UTF8String, nil)
	}()
	
	private var queue2: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.EntityStressTests.2" as NSString).UTF8String, nil)
	}()
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testAll() {

		// Set the XCTest Class as the delegate.
		graph.delegate = self
		
		// Let's watch the changes in the Graph for the following Entity values.
		graph.watch(Entity: "E")
		
		var e1: GKEntity?
		
		dispatch_async(queue1) {
			e1 = GKEntity(type: "E")
			for i in 1...1000 {
				let prop: String = String(i)
				e1!.addGroup(prop)
				e1!.addGroup("test")
				e1!.removeGroup("test")
				e1![prop] = i
			}
			
			dispatch_async(self.queue2) {
				for i in 1...500 {
					let prop: String = String(i)
					e1!.removeGroup(prop)
					e1!.addGroup("test")
					e1!.removeGroup("test")
					e1![prop] = nil
				}
				self.graph.save { (_, _) in }
			}
		}
		
		dispatch_async(queue2) {
			e1 = GKEntity(type: "E")
			for i in 1...1000 {
				let prop: String = String(i)
				e1!.addGroup(prop)
				e1!.addGroup("test")
				e1!.removeGroup("test")
				e1![prop] = i
			}
			
			dispatch_async(self.queue1) {
				for i in 1...500 {
					let prop: String = String(i)
					e1!.removeGroup(prop)
					e1!.addGroup("test")
					e1!.removeGroup("test")
					e1![prop] = nil
				}
				self.graph.save { (_, _) in }
			}
		}
		
		expectation = expectationWithDescription("Entity: Insert did not pass.")
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(30, handler: nil)
		
		e1!.delete()
		
		expectation = expectationWithDescription("Entity: Delete did not pass.")
		
		graph.save { (_, _) in }
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(30, handler: nil)
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
	
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
//		if 500 == entity.groups.count && 500 == entity.properties.count {
			expectation?.fulfill()
//		}
	}
	
	func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
		if 0 == entity.groups.count && 0 == entity.properties.count {
			expectation?.fulfill()
		}
	}
}
