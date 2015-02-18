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

class GKEntityMultiActionTests : XCTestCase, GKGraphDelegate {

    var u1InsertExpectation: XCTestExpectation?
	var u1DeleteExpectation: XCTestExpectation?

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

        // Let's watch the changes in the Graph for the following Entity types.
        graph.watch(Entity: "User")

        // Create a User Entity.
        let u1: GKEntity = GKEntity(type: "User")

        // Create a Read Action.
        let a1: GKAction = GKAction(type: "Read")

        // Set u1 as a Subject for a1.
        a1.addSubject(u1)

        // Create another Read Action.
        let a2: GKAction = GKAction(type: "Read")
        a2.addSubject(u1)

        // Add a bunch of Book Entity Objects.
        for i in 0..<100 {
            let b1: GKEntity = GKEntity(type: "Book")
			a1.addObject(b1)
            a2.addObject(b1)
        }
		
		// Set an Expectation for the insert watcher.
        u1InsertExpectation = expectationWithDescription("U1: Insert 'User' did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        // Cleanup
        for entity in a1.subjects {
            entity.delete()
        }
        for entity in a1.objects {
            entity.delete()
        }
        a1.delete()
        a2.delete()

        // Set an Expectation for the delete watcher.
        u1DeleteExpectation = expectationWithDescription("U1: Delete 'User' did not pass.")

        // Save the Graph.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }
		
        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)
    }

    func testPerformanceExample() {
        self.measureBlock() {}
    }

    func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
        if 2 == entity.actions.count {
            u1InsertExpectation?.fulfill()
		}
    }
	
	func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
		if 0 == entity.actions.count {
			u1DeleteExpectation?.fulfill()
		}
	}
}
