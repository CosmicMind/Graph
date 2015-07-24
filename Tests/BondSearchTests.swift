//
//  BondSearchTests.swift
//  GraphKit
//
//  Created by Daniel Dahan on 2015-04-09.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import XCTest
import GraphKit

class BondSearchTests : XCTestCase, GraphDelegate {
	
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
		
		// Let's watch the changes in the Graph for the following Bond values.
		graph?.watch(Bond: "B")
		graph?.watch(BondProperty: "active")
		
		XCTAssertTrue(0 == graph?.search(BondProperty: "active").count, "Bond: Search did not pass.")
		
		var b1: Bond = Bond(type: "B")
		b1["active"] = true
		
		var b2: Bond? = graph?.search(BondProperty: "active").last?.value
		
		XCTAssertTrue(b1 == b2, "Bond: Search did not pass.")
		
		expectation = expectationWithDescription("Bond: Insert did not pass.")
		
		graph?.save{ (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func graph(graph: Graph, didInsertBond bond: Bond) {
		var b2: Bond? = graph.search(BondProperty: "active").last?.value
		if bond == b2 {
			expectation?.fulfill()
			
			b2?["active"] = false
			
			expectation = expectationWithDescription("Bond: Property Update did not pass.")
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
	
	func graph(graph: Graph, didDeleteBond bond: Bond) {
		var b2: Bond? = graph.search(BondProperty: "active").last?.value
		if nil == b2 {
			expectation?.fulfill()
			XCTAssertTrue(0 == graph.search(BondProperty: "active").count, "Bond: Search did not pass.")
		}
	}
	
	func graph(graph: Graph, didUpdateBond bond: Bond, property: String, value: AnyObject) {
		var b2: Bond? = graph.search(BondProperty: "active").last?.value
		if value as! Bool == bond["active"] as! Bool && false == value as! Bool {
			expectation?.fulfill()
			
			bond["active"] = nil
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
			
			XCTAssertTrue(0 == graph.search(BondProperty: "active").count, "Bond: Search did not pass.")
			
			expectation = expectationWithDescription("Bond: Delete did not pass.")
			
			bond.delete()
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

