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

    var userInsertExpectation: XCTestExpectation?
    var userDeleteExpectation: XCTestExpectation?
    var bookInsertExpectation: XCTestExpectation?
    var bookDeleteExpectation: XCTestExpectation?
    var magazineInsertExpectation: XCTestExpectation?
    var magazineDeleteExpectation: XCTestExpectation?
    var readInsertExpectation: XCTestExpectation?
    var readDeleteExpectation: XCTestExpectation?
    var holidayInsertExpectation: XCTestExpectation?
    var holidayDeleteExpectation: XCTestExpectation?
    var holidaySearchExpectation: XCTestExpectation?
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

        // Let's watch the changes in the Graph for the following Entity types.
        graph.watch(Entity: "User")
        graph.watch(Entity: "Book")
        graph.watch(Entity: "Magazine")

        // Create a Read Action.
        let read: GKAction = GKAction(type: "Read")
        read["name"] = "New Years"
        read["session"] = 123
        read.addGroup("Holiday")

        // Create a User Entity and a Book and Magazine Entity for the Read Action.
        let user: GKEntity = GKEntity(type: "User")
        let book: GKEntity = GKEntity(type: "Book")
        let magazine: GKEntity = GKEntity(type: "Magazine")

        // Create the relationship -- User Read a Book and Magazine.
        read.addSubject(user)
        read.addObject(book)
        read.addObject(magazine)

        // Set an Expectation for the insert watcher.
        userInsertExpectation = expectationWithDescription("User: Insert did not pass.")
        bookInsertExpectation = expectationWithDescription("Book: Insert did not pass.")
        magazineInsertExpectation = expectationWithDescription("Magazine: Insert did not pass.")
        readInsertExpectation = expectationWithDescription("Read: Insert did not pass.")
        holidayInsertExpectation = expectationWithDescription("Holiday: Insert did not pass.")
        holidaySearchExpectation = expectationWithDescription("Holiday: Search did not pass.")
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

        // Set Expectations for the update watcher.
        nameUpdateExpectation = expectationWithDescription("Name: Update did not pass.")
        sessionUpdateExpectation = expectationWithDescription("Session: Update did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        read.delete()
        user.delete()
        book.delete()
        magazine.delete()

        // Set Expectations for the delete watcher.
        userDeleteExpectation = expectationWithDescription("User: Delete did not pass.")
        bookDeleteExpectation = expectationWithDescription("Book: Delete did not pass.")
        magazineDeleteExpectation = expectationWithDescription("Magazine: Delete did not pass.")
        readDeleteExpectation = expectationWithDescription("Read: Delete did not pass.")
        holidayDeleteExpectation = expectationWithDescription("Holiday: Delete did not pass.")
        holidaySearchExpectation = expectationWithDescription("Holiday: Search did not pass.")
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

    func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
        if "User" == entity.type && 1 == entity.actionsWhenSubject.count {
            userInsertExpectation?.fulfill()
        } else if "Book" == entity.type && 1 == entity.actionsWhenObject.count {
            bookInsertExpectation?.fulfill()
        } else if "Magazine" == entity.type && 1 == entity.actionsWhenObject.count {
            magazineInsertExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
        if "User" == entity.type && 0 == entity.actions.count {
            userDeleteExpectation?.fulfill()
        } else if "Book" == entity.type && 0 == entity.actions.count {
            bookDeleteExpectation?.fulfill()
        } else if "Magazine" == entity.type && 0 == entity.actions.count {
            magazineDeleteExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didInsertAction action: GKAction!) {
        if "Read" == action.type && 1 == action.subjects.count && 2 == action.objects.count {
            readInsertExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteAction action: GKAction!) {
        if "Read" == action.type && 0 == action.subjects.count && 0 == action.objects.count {
            readDeleteExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didInsertAction action: GKAction!, group: String!) {
        if "Holiday" == group {
            holidayInsertExpectation?.fulfill()

            let graph: GKGraph = GKGraph()
            let nodes: Array<GKAction> = graph.search(ActionGroup: group);
            if 1 == nodes.count && action.id == nodes[0].id {
                holidaySearchExpectation?.fulfill()
            }
        }
    }

    func graph(graph: GKGraph!, didDeleteAction action: GKAction!, group: String!) {
        if "Holiday" == group {
            holidayDeleteExpectation?.fulfill()

            let graph: GKGraph = GKGraph()
            let nodes: Array<GKAction> = graph.search(ActionGroup: group);
            if 0 == nodes.count {
                holidaySearchExpectation?.fulfill()
            }
        }
    }

    func graph(graph: GKGraph!, didInsertAction action: GKAction!, property: String!, value: AnyObject!) {
        if "name" == property && "New Years" == value as String {
            nameInsertExpectation?.fulfill()
        } else if "session" == property && 123 == value as Int {
            sessionInsertExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didUpdateAction action: GKAction!, property: String!, value: AnyObject!) {
        if "name" == property && "Daniel" == value as String {
            nameUpdateExpectation?.fulfill()
        } else if "session" == property && 31 == value as Int {
            sessionUpdateExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteAction action: GKAction!, property: String!, value: AnyObject!) {
        if "name" == property && "Daniel" == value as String {
            nameDeleteExpectation?.fulfill()
        } else if "session" == property && 31 == value as Int {
            sessionDeleteExpectation?.fulfill()
        }
    }
}
