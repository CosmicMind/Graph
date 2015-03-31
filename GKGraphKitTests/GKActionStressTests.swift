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
		graph.watch(Action: "E")
		
		let a1: GKAction = GKAction(type: "E")
		
		for i in 1...1000 {
			let prop: String = String(i)
			a1.addGroup(prop)
			a1[prop] = i
		}
		
		for i in 1...500 {
			let prop: String = String(i)
			a1.removeGroup(prop)
			a1[prop] = nil
		}
		
		expectation = expectationWithDescription("Action: Insert did not pass.")
		
		graph.save { (_, _) in }
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
		
		a1.delete()
		
		expectation = expectationWithDescription("Action: Delete did not pass.")
		
		graph.save { (_, _) in }
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
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
