//
//  GKTests.swift
//  GKGraphKit
//
//  Created by Daniel Dahan on 2015-04-01.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import XCTest
import GKGraphKit

class GKTests : XCTestCase, GKGraphDelegate {
	
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
		
		var user: GKEntity? = GKEntity(type: "User")
		var author: GKBond? = GKBond(type: "Author")
		var read: GKAction? = GKAction(type: "Read")
		var book1: GKEntity? = GKEntity(type: "Book")
		var book2: GKEntity? = GKEntity(type: "Book")
		
		read!.addSubject(user)
		read!.addObject(book1)
		read!.addObject(book2)
		author!.subject = user
		author!.object = book1
		
		// Save the Graph, which will execute the delegate handlers.
		graph.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		XCTAssertTrue(read!.subjects.count == 1, "Read: did not save User.")
		XCTAssertTrue(user!.actionsWhenSubject[0] == read, "User: does not have access to Read when Subject.")
		XCTAssertTrue(0 == user!.actionsWhenObject.count, "User: should not have access to Read when Object.")
		XCTAssertTrue(user!.actions[0] == read, "User: does not have access to Read.")
		XCTAssertTrue(user!.bondsWhenSubject[0] == author, "User: does not have access to Author when Subject.")
		XCTAssertTrue(0 == user!.bondsWhenObject.count, "User: should not have access to Author when Object.")
		XCTAssertTrue(user == author!.subject && book1 == author!.object, "Author: Not correctly mapped.")
		XCTAssertTrue(read!.hasSubject(user), "Read: Not correctly mapped.")
		XCTAssertTrue(read!.hasObject(book1), "Read: Not correctly mapped.")
		XCTAssertTrue(read!.hasObject(book2), "Read: Not correctly mapped.")
		
		book1!.delete()
		
		// Save the Graph, which will execute the delegate handlers.
		graph.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		XCTAssertTrue(0 == graph.search(Bond: "Author").count && 0 == user!.bonds.count, "Author: Not correctly deleted.")
		XCTAssertTrue(1 == graph.search(Action: "Read").count, "Read: Not correctly searched.")
		
		book2!.delete()
		
		// Save the Graph, which will execute the delegate handlers.
		graph.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}

		XCTAssertTrue(1 == graph.search(Action: "Read").count, "Read: Not correctly deleted.")
		
		user!.delete()
		// Save the Graph, which will execute the delegate handlers.
		graph.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		XCTAssertTrue(read == graph.search(Action: "Read").last, "Read: Not correctly searched.")
		XCTAssertTrue(0 == read!.subjects.count && 0 == read!.objects.count, "Read: Not correctly mapped.")
		
		read!.delete()
		
		// Save the Graph, which will execute the delegate handlers.
		graph.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		XCTAssertTrue(0 == graph.search(Action: "Read").count, "Read: Not correctly deleted.")
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
}

