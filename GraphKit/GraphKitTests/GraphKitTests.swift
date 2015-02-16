/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software packnumeric
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import XCTest
import GraphKit

class GKActionTests : XCTestCase, GKGraphDelegate {

    var u1Expectation: XCTestExpectation?
    var b1Expectation: XCTestExpectation?
	var b2Expectation: XCTestExpectation?
    var a1Expectation: XCTestExpectation?
	
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAction() {
		// Create a Graph instance.
        let graph: GKGraph = GKGraph()

		// Set the XCTest Class as the delegate.
		graph.delegate = self
		
		// Let's watch the changes in the Graph for the following Entity and Action types.
		graph.watch(Entity: "User")
        graph.watch(Entity: "Book")
        graph.watch(Action: "Read")

        // Create a User Entity.
        let u1: GKEntity = GKEntity(type: "User")

        // Give u1 some properties.
        u1["name"] = "Eve"
        u1["age"] = 26

        // Add u1 to a group. This creates a subset in the Graph named 'Female'.
        u1.addGroup("Female")

        // Create some book Entity Nodes.
        let b1: GKEntity = GKEntity(type: "Book")
        b1["title"] = "Deep C Secrets"
        b1.addGroup("Thriller")

        let b2: GKEntity = GKEntity(type: "Book")
        b2["title"] = "Mastering Swift"
        b2.addGroup("Suspense")
        b2.addGroup("Favourite")

        // Create a Read Action.
        let a1: GKAction = GKAction(type: "Read")

        // Record the session the Action occurred in.
        a1["session"] = 123
        a1.addGroup("XCTest")

        // Add u1 to the Subjects Set for the Action.
        a1.addSubject(u1)

        // Add b1 and b2 to the Objects Set for the Action.
        a1.addObject(b1)
        a1.addObject(b2)

        // For this example, set some XCTestExpectation Objects that will be handled in the delegates.
		u1Expectation = expectationWithDescription("U1: Watch 'User' did not pass.")
		b1Expectation = expectationWithDescription("B1: Watch 'Book' did not pass.")
		b2Expectation = expectationWithDescription("B2: Watch 'Book' did not pass.")
		a1Expectation = expectationWithDescription("A1: Watch 'Read' did not pass.")

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

    func graph(graph: GKGraph!, didInsertAction action: GKAction!) {
        if "Read" == action.type && 123 == action["session"]? as Int && action.hasGroup("XCTest") && 1 == action.subjects.count && 2 == action.objects.count {
            a1Expectation?.fulfill()
        }
    }

	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
        if "User" == entity.type && "Eve" == entity["name"]? as String && 26 == entity["age"]? as Int && entity.hasGroup("Female") {
            u1Expectation?.fulfill()
        } else if "Book" == entity.type && "Deep C Secrets" == entity["title"]? as String && entity.hasGroup("Thriller") {
            b1Expectation?.fulfill()
        } else if "Book" == entity.type && "Mastering Swift" == entity["title"]? as String && entity.hasGroup("Suspense") && entity.hasGroup("Favourite") {
            b2Expectation?.fulfill()
        }
	}
}
