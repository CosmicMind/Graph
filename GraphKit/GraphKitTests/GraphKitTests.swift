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

class GraphKitTests : XCTestCase, GKGraphDelegate {

    var u1InsertExpectation: XCTestExpectation?
	var u1UpdateExpectation: XCTestExpectation?
	var u1DeleteExpectation: XCTestExpectation?
    var b1InsertExpectation: XCTestExpectation?
    var b1UpdateExpectation: XCTestExpectation?
	var b1DeleteExpectation: XCTestExpectation?
	var b2InsertExpectation: XCTestExpectation?
    var b2UpdateExpectation: XCTestExpectation?
	var b2DeleteExpectation: XCTestExpectation?
    var a1InsertExpectation: XCTestExpectation?
    var a1UpdateExpectation: XCTestExpectation?
    var a1DeleteExpectation: XCTestExpectation?

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
        XCTAssertTrue(u1.addGroup("Female"), "Did not add 'Female' Group.")

        // Create some book Entity Nodes.
        let b1: GKEntity = GKEntity(type: "Book")
        b1["title"] = "Deep C Secrets"
        XCTAssertTrue(b1.addGroup("Thriller"), "Did not add 'Thriller' Group.")

        let b2: GKEntity = GKEntity(type: "Book")
        b2["title"] = "Mastering Swift"
        XCTAssertTrue(b2.addGroup("Suspense"), "Did not add 'Suspense' Group.")
        XCTAssertTrue(b2.addGroup("Favourite"), "Did not add 'Favourite' Group.")

        // Create a Read Action.
        let a1: GKAction = GKAction(type: "Read")

        // Record the session the Action occurred in.
        a1["session"] = 123
        XCTAssertTrue(a1.addGroup("XCTest"), "Did not add 'XCTest' Group.")

        // Add u1 to the Subject Set for the Action.
        XCTAssertTrue(a1.addSubject(u1), "Did not add U1 Object.")

        // Add b1 and b2 to the Object Set for the Action.
        XCTAssertTrue(a1.addObject(b1), "Did not add B1 Object.")
        XCTAssertTrue(a1.addObject(b2), "Did not add B2 Object.")

        // For this example, set some XCTestExpectation Objects that will be handled in the delegates.
		u1InsertExpectation = expectationWithDescription("U1: Insert 'User' did not pass.")
		b1InsertExpectation = expectationWithDescription("B1: Insert 'Book' did not pass.")
		b2InsertExpectation = expectationWithDescription("B2: Insert 'Book' did not pass.")
		a1InsertExpectation = expectationWithDescription("A1: Insert 'Read' did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        // Remove b1 from the Object Set.
        XCTAssertTrue(a1.removeSubject(u1), "Did not remove U1 Subject.")
        XCTAssertTrue(a1.removeObject(b1), "Did not remove B1 Object.")
        XCTAssertTrue(a1.removeGroup("XCTest"), "Did not remove 'XCTest' Group.")

        // Remove u1, b1, and b2 from Groups.
        XCTAssertTrue(u1.removeGroup("Female"), "Did not remove 'Female' Group.")
        XCTAssertTrue(b1.removeGroup("Thriller"), "Did not remove 'Thriller' Group.")
        XCTAssertTrue(b2.removeGroup("Suspense"), "Did not remove 'Suspense' Group.")
        XCTAssertTrue(b2.removeGroup("Favourite"), "Did not remove 'Favourite' Group.")

        // Set another Expectation for the update watcher.
        u1UpdateExpectation = expectationWithDescription("U1: Update 'User' did not pass.")
        b1UpdateExpectation = expectationWithDescription("B1: Update 'Book' did not pass.")
        b2UpdateExpectation = expectationWithDescription("B2: Update 'Book' did not pass.")
        a1UpdateExpectation = expectationWithDescription("A1: Update 'Read' did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        // Mark the Entity and Action for deletion.
        u1.delete()
		b1.delete()
		b2.delete()
		a1.delete()

        // Set another Expectation for the update watcher.
        u1DeleteExpectation = expectationWithDescription("U1: Delete 'User' did not pass.")
        b1DeleteExpectation = expectationWithDescription("B1: Delete 'Book' did not pass.")
        b2DeleteExpectation = expectationWithDescription("B2: Delete 'Book' did not pass.")
        a1DeleteExpectation = expectationWithDescription("A1: Delete 'Read' did not pass.")

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
            a1InsertExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didUpdateAction action: GKAction!) {
        if "Read" == action.type && 123 == action["session"]? as Int && 0 == action.subjects.count && 1 == action.objects.count {
            a1UpdateExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteAction action: GKAction!) {
        if "Read" == action.type && 123 == action["session"]? as Int && 0 == action.subjects.count && 1 == action.objects.count {
            a1DeleteExpectation?.fulfill()
        }
    }

	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
        if "User" == entity.type && "Eve" == entity["name"]? as String && 26 == entity["age"]? as Int && entity.hasGroup("Female") {
            u1InsertExpectation?.fulfill()
        } else if "Book" == entity.type && "Deep C Secrets" == entity["title"]? as String && entity.hasGroup("Thriller") {
            b1InsertExpectation?.fulfill()
        } else if "Book" == entity.type && "Mastering Swift" == entity["title"]? as String && entity.hasGroup("Suspense") && entity.hasGroup("Favourite") {
            b2InsertExpectation?.fulfill()
        }
	}

    func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!) {
        if "User" == entity.type && "Eve" == entity["name"]? as String && 26 == entity["age"]? as Int && !entity.hasGroup("Female") {
            u1UpdateExpectation?.fulfill()
        } else if "Book" == entity.type && "Deep C Secrets" == entity["title"]? as String && !entity.hasGroup("Thriller") {
            b1UpdateExpectation?.fulfill()
        } else if "Book" == entity.type && "Mastering Swift" == entity["title"]? as String && !entity.hasGroup("Suspense") && !entity.hasGroup("Favourite") {
            b2UpdateExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
        if "User" == entity.type && "Eve" == entity["name"]? as String && 26 == entity["age"]? as Int {
            u1DeleteExpectation?.fulfill()
        } else if "Book" == entity.type && "Deep C Secrets" == entity["title"]? as String {
            b1DeleteExpectation?.fulfill()
        } else if "Book" == entity.type && "Mastering Swift" == entity["title"]? as String {
            b2DeleteExpectation?.fulfill()
        }
    }
}
