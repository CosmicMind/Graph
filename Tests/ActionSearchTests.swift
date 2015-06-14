//
//  ActionSearchTests.swift
//  GraphKit
//
//  Created by Daniel Dahan on 2015-04-09.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import XCTest
import GraphKit

class ActionSearchTests : XCTestCase, GraphDelegate {
	
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
		
		// Let's watch the changes in the Graph for the following Action values.
		graph?.watch(Action: "A")
		graph?.watch(ActionProperty: "active")
		
		XCTAssertTrue(0 == graph?.search(ActionProperty: "active").count, "Action: Search did not pass.")
		
		var a1: Action = Action(type: "A")
		a1["active"] = true
		
		var a2: Action? = graph?.search(ActionProperty: "active").last
		
		XCTAssertTrue(a1 == a2, "Action: Search did not pass.")
		
		expectation = expectationWithDescription("Action: Insert did not pass.")
		
		graph?.save{ (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
	
	func graph(graph: Graph, didInsertAction action: Action) {
		var a2: Action? = graph.search(ActionProperty: "active").last
		if action == a2 {
			expectation?.fulfill()
			
			a2?["active"] = false
			
			expectation = expectationWithDescription("Action: Property Update did not pass.")
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
	
	func graph(graph: Graph, didDeleteAction action: Action) {
		var a2: Action? = graph.search(ActionProperty: "active").last
		if nil == a2 {
			expectation?.fulfill()
			XCTAssertTrue(0 == graph.search(ActionProperty: "active").count, "Action: Search did not pass.")
		}
	}
	
	func graph(graph: Graph,didUpdateAction action: Action,property: String,value: AnyObject){
		var a2: Action? = graph.search(ActionProperty: "active").last
		if value as! Bool == action["active"] as! Bool && false == value as! Bool {
			expectation?.fulfill()
			
			action["active"] = nil
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
			
			XCTAssertTrue(0 == graph.search(ActionProperty: "active").count, "Action: Search did not pass.")
			
			expectation = expectationWithDescription("Action: Delete did not pass.")
			
			action.delete()
			
			graph.save{ (success: Bool, error: NSError?) in
				XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			}
		}
	}
}

