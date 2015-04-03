//
//  GKActionStressTests.swift
//  GKGraphKit
//
//  Created by Daniel Dahan on 2015-03-31.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import XCTest
import GKGraphKit

class GKActionStressTests : XCTestCase, GKGraphDelegate {
	
	lazy var graph: GKGraph = GKGraph()
	
	var expectation: XCTestExpectation?
	
	// queue for drawing images
	private var queua1: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.ActionStressTests.1" as NSString).UTF8String, nil)
	}()
	
	private var queue2: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.ActionStressTests.2" as NSString).UTF8String, nil)
	}()
	
	private var queue3: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.ActionStressTests.3" as NSString).UTF8String, nil)
	}()
	
	private var queue4: dispatch_queue_t = {
		return dispatch_queue_create(("io.graphkit.ActionStressTests.4" as NSString).UTF8String, nil)
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
		
		// Let's watch the changes in the Graph for the following Action values.
		graph.watch(Action: "A")
		
		var a1: GKAction?
		
		dispatch_async(queua1) {
			a1 = GKAction(type: "A")
			for i in 1...1000 {
				let prop: String = String(i)
				a1!.addGroup(prop)
				a1!.addGroup("test")
				a1!.removeGroup("test")
				a1![prop] = i
			}
			
			dispatch_async(self.queue2) {
				for i in 1...500 {
					let prop: String = String(i)
					a1!.removeGroup(prop)
					a1!.addGroup("test")
					a1!.removeGroup("test")
					a1![prop] = nil
				}
				dispatch_async(self.queue3) {
					for i in 1...1000 {
						let prop: String = String(i)
						a1!.addGroup(prop)
						a1!.addGroup("test")
						a1!.removeGroup("test")
						a1![prop] = i
					}
					
					dispatch_async(self.queue4) {
						for i in 1...500 {
							let prop: String = String(i)
							a1!.removeGroup(prop)
							a1!.addGroup("test")
							a1!.removeGroup("test")
							a1![prop] = nil
						}
						self.graph.save { (_, _) in }
					}
				}
			}
		}
		
		
		expectation = expectationWithDescription("Action: Insert did not pass.")
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(30, handler: nil)
		
		a1!.delete()
		
		expectation = expectationWithDescription("Action: Delete did not pass.")
		
		graph.save { (_, _) in }
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(30, handler: nil)
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
	
	func graph(graph: GKGraph!, didInsertAction action: GKAction!) {
		if 500 == action.groups.count && 500 == action.properties.count {
			expectation?.fulfill()
		}
	}
	
	func graph(graph: GKGraph!, didDeleteAction action: GKAction!) {
		if 0 == action.groups.count && 0 == action.properties.count {
			expectation?.fulfill()
		}
	}
}
