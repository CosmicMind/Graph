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
		
		let e1: GKEntity = GKEntity(type: "E")
		
		for i in 1...1000 {
			let prop: String = String(i)
			e1.addGroup(prop)
			e1[prop] = i
		}
		
		for i in 1...500 {
			let prop: String = String(i)
			e1.removeGroup(prop)
			e1[prop] = nil
		}
		
		expectation = expectationWithDescription("Entity: Insert did not pass.")
		
		graph.save { (_, _) in }
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
		
		e1.delete()
		
		expectation = expectationWithDescription("Entity: Delete did not pass.")
		
		graph.save { (_, _) in }
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
	
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
		if 500 == entity.groups.count && 500 == entity.properties.count {
			expectation?.fulfill()
		}
	}
	
	func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
		if 0 == entity.groups.count && 0 == entity.properties.count {
			expectation?.fulfill()
		}
	}
}
