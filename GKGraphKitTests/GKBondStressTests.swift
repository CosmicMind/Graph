//
//  GKBondStressTests.swift
//  GKGraphKit
//
//  Created by Daniel Dahan on 2015-03-31.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import XCTest
import GKGraphKit

class GKBondStressTests : XCTestCase, GKGraphDelegate {
	
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
		
		// Let's watch the changes in the Graph for the following Bond values.
		graph.watch(Bond: "E")
		
		let b1: GKBond = GKBond(type: "E")
		
		for i in 1...1000 {
			let prop: String = String(i)
			b1.addGroup(prop)
			b1[prop] = i
		}
		
		for i in 1...500 {
			let prop: String = String(i)
			b1.removeGroup(prop)
			b1[prop] = nil
		}
		
		expectation = expectationWithDescription("Bond: Insert did not pass.")
		
		graph.save { (_, _) in }
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
		
		b1.delete()
		
		expectation = expectationWithDescription("Bond: Delete did not pass.")
		
		graph.save { (_, _) in }
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
	
	func graph(graph: GKGraph!, didInsertBond bond: GKBond!) {
		if 500 == bond.groups.count && 500 == bond.properties.count {
			expectation?.fulfill()
		}
	}
	
	func graph(graph: GKGraph!, didDeleteBond bond: GKBond!) {
		if 0 == bond.groups.count && 0 == bond.properties.count {
			expectation?.fulfill()
		}
	}
}
