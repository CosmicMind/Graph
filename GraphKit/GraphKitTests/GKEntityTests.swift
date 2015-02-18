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

class GKEntityTests : XCTestCase, GKGraphDelegate {

    var userInsertExpectation: XCTestExpectation?
	var userDeleteExpectation: XCTestExpectation?
    var femaleInsertExpectation: XCTestExpectation?
    var femaleDeleteExpectation: XCTestExpectation?
    var nameInsertExpectation: XCTestExpectation?
    var nameUpdateExpectation: XCTestExpectation?
    var nameDeleteExpectation: XCTestExpectation?
    var ageInsertExpectation: XCTestExpectation?
    var ageUpdateExpectation: XCTestExpectation?
    var ageDeleteExpectation: XCTestExpectation?

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
        graph.watch(EntityGroup: "Female")
        graph.watch(EntityProperty: "name")
        graph.watch(EntityProperty: "age")

        // Create a User Entity.
        let user: GKEntity = GKEntity(type: "User")
        user["name"] = "Eve"
        user["age"] = 26
        user.addGroup("Female")

        // Set an Expectation for the insert watcher.
        userInsertExpectation = expectationWithDescription("User: Insert did not pass.")
        femaleInsertExpectation = expectationWithDescription("Female: Insert did not pass.")
        nameInsertExpectation = expectationWithDescription("Name: Insert did not pass.")
        ageInsertExpectation = expectationWithDescription("Age: Insert did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        user["name"] = "Daniel"
        user["age"] = 31

        // Set an Expectation for the update watcher.
        nameUpdateExpectation = expectationWithDescription("Name: Update did not pass.")
        ageUpdateExpectation = expectationWithDescription("Age: Update did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        user.delete()

        // Set an Expectation for the delete watcher.
        userDeleteExpectation = expectationWithDescription("User: Delete did not pass.")
        femaleDeleteExpectation = expectationWithDescription("Female: Delete did not pass.")
        nameDeleteExpectation = expectationWithDescription("Name: Delete did not pass.")
        ageDeleteExpectation = expectationWithDescription("Age: Delete did not pass.")

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

    func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
        if "User" == entity.type {
            userInsertExpectation?.fulfill()
		}
    }

    func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
        if "User" == entity.type {
            userDeleteExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!, group: String!) {
        if "Female" == group {
            femaleInsertExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!, group: String!) {
        if "Female" == group {
            femaleDeleteExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!, property: String!, value: AnyObject!) {
        if "name" == property && "Eve" == value as String {
            nameInsertExpectation?.fulfill()
        } else if "age" == property && 26 == value as Int {
            ageInsertExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!, property: String!, value: AnyObject!) {
        if "name" == property && "Daniel" == value as String {
            nameUpdateExpectation?.fulfill()
        } else if "age" == property && 31 == value as Int {
            ageUpdateExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!, property: String!, value: AnyObject!) {
        if "name" == property && "Daniel" == value as String {
            nameDeleteExpectation?.fulfill()
        } else if "age" == property && 31 == value as Int {
            ageDeleteExpectation?.fulfill()
        }
    }
}
