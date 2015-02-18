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

    var readInsertExpectation: XCTestExpectation?
    var readDeleteExpectation: XCTestExpectation?
    var holidayInsertExpectation: XCTestExpectation?
    var holidayDeleteExpectation: XCTestExpectation?
    var nameInsertExpectation: XCTestExpectation?
    var nameUpdateExpectation: XCTestExpectation?
    var nameDeleteExpectation: XCTestExpectation?
    var sessionInsertExpectation: XCTestExpectation?
    var sessionUpdateExpectation: XCTestExpectation?
    var sessionDeleteExpectation: XCTestExpectation?

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

        // Let's watch the changes in the Graph for the following Action types.
        graph.watch(Action: "Read")
        graph.watch(ActionGroup: "Holiday")
        graph.watch(ActionProperty: "name")
        graph.watch(ActionProperty: "session")

        // Create a Read Action.
        let read: GKAction = GKAction(type: "Read")
        read["name"] = "New Years"
        read["session"] = 123
        read.addGroup("Holiday")

        // Set an Expectation for the insert watcher.
        readInsertExpectation = expectationWithDescription("Read: Insert did not pass.")
        holidayInsertExpectation = expectationWithDescription("Holiday: Insert did not pass.")
        nameInsertExpectation = expectationWithDescription("Name: Insert did not pass.")
        sessionInsertExpectation = expectationWithDescription("Session: Insert did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        read["name"] = "Daniel"
        read["session"] = 31

        // Set an Expectation for the update watcher.
        nameUpdateExpectation = expectationWithDescription("Name: Update did not pass.")
        sessionUpdateExpectation = expectationWithDescription("Session: Update did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        read.delete()

        // Set an Expectation for the delete watcher.
        readDeleteExpectation = expectationWithDescription("Read: Delete did not pass.")
        holidayDeleteExpectation = expectationWithDescription("Holiday: Delete did not pass.")
        nameDeleteExpectation = expectationWithDescription("Name: Delete did not pass.")
        sessionDeleteExpectation = expectationWithDescription("Session: Delete did not pass.")

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

    func graph(graph: GKGraph!, didInsertAction entity: GKAction!) {
        if "Read" == entity.type {
            readInsertExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteAction entity: GKAction!) {
        if "Read" == entity.type {
            readDeleteExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didInsertAction entity: GKAction!, group: String!) {
        if "Holiday" == group {
            holidayInsertExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteAction entity: GKAction!, group: String!) {
        if "Holiday" == group {
            holidayDeleteExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didInsertAction entity: GKAction!, property: String!, value: AnyObject!) {
        if "name" == property && "New Years" == value as String {
            nameInsertExpectation?.fulfill()
        } else if "session" == property && 123 == value as Int {
            sessionInsertExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didUpdateAction entity: GKAction!, property: String!, value: AnyObject!) {
        if "name" == property && "Daniel" == value as String {
            nameUpdateExpectation?.fulfill()
        } else if "session" == property && 31 == value as Int {
            sessionUpdateExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteAction entity: GKAction!, property: String!, value: AnyObject!) {
        if "name" == property && "Daniel" == value as String {
            nameDeleteExpectation?.fulfill()
        } else if "session" == property && 31 == value as Int {
            sessionDeleteExpectation?.fulfill()
        }
    }
}
