//
//  GKStressTests.swift
//  GKGraphKit
//
//  Created by Daniel Dahan on 2015-03-31.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import XCTest
import GKGraphKit

class GKStressTests : XCTestCase, GKGraphDelegate {
	
	var expectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testAll() {
		// Create a Graph instance.
		let graph: GKGraph = GKGraph()
		
		// Set the XCTest Class as the delegate.
		graph.delegate = self
		
		// Let's watch the changes in the Graph for the following Entity values.
		graph.watch(Entity: "E")
		
		let e1: GKEntity = GKEntity(type: "E")
		//		let e2: GKEntity = GKEntity(type: "E")
		//		let b1: GKBond = GKBond(type: "B")
		
		for i in 1...1000 {
			let prop: String = String(i)
			e1.addGroup("#" + prop)
			//			e1[prop] = i as Int
			//			e2.addGroup("#" + prop)
			//			e2[prop] = i as Int
			//			b1.addGroup("#" + prop)
			//			b1[prop] = i as Int
			//			b1.subject = e1
			//			b1.object = e2
		}
		
		for i in 1...500 {
			let prop: String = String(i)
			e1.removeGroup("#" + prop)
			//			e1[prop] = i as Int
			//			e2.addGroup("#" + prop)
			//			e2[prop] = i as Int
			//			b1.addGroup("#" + prop)
			//			b1[prop] = i as Int
			//			b1.subject = e1
			//			b1.object = e2
		}
		
		graph.save { (_, _) in }
		
		println(e1)
		println(e1.groups)
		//		println(e2)
		//		println(b1)
		
		e1.delete()
//		println(e1)
//		println(e1.groups)
		//		e2.delete()
		//		b1.delete()
		
		expectation = expectationWithDescription("Group: Insert did not pass.")
		
		// Save the Graph, which will execute the delegate handlers.
		graph.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		// Wait for the delegates to be executed.
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
	func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
		expectation?.fulfill()
	}
}
