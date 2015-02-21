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

class GKBondTests : XCTestCase, GKGraphDelegate {

    var friendInsertExpectation: XCTestExpectation?
	var friendDeleteExpectation: XCTestExpectation?
    var closeInsertExpectation: XCTestExpectation?
    var closeDeleteExpectation: XCTestExpectation?
    var closeSearchExpectation: XCTestExpectation?
    var permissionInsertExpectation: XCTestExpectation?
    var permissionUpdateExpectation: XCTestExpectation?
    var permissionDeleteExpectation: XCTestExpectation?
    var permissionSearchExpectation: XCTestExpectation?
    var yearInsertExpectation: XCTestExpectation?
    var yearUpdateExpectation: XCTestExpectation?
    var yearDeleteExpectation: XCTestExpectation?
    var yearSearchExpectation: XCTestExpectation?

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

        // Let's watch the changes in the Graph for the following Bond values.
        graph.watch(Bond: "Friend")
        graph.watch(BondGroup: "Close")
        graph.watch(BondProperty: "permission")
        graph.watch(BondProperty: "year")

        // Let's create two User Entity Objects.
        let u1: GKEntity = GKEntity(type: "User")
        let u2: GKEntity = GKEntity(type: "User")

        // Create a Friend Bond.
        let friend: GKBond = GKBond(type: "Friend")
        friend["permission"] = "edit"
        friend["year"] = 1998
        friend.addGroup("Close")

        // Set the relationship between the users.
        friend.subject = u1
        friend.object = u2

        // Set an Expectation for the insert watcher.
        friendInsertExpectation = expectationWithDescription("Friend: Insert did not pass.")
        closeInsertExpectation = expectationWithDescription("Close: Insert did not pass.")
        closeSearchExpectation = expectationWithDescription("Close: Search did not pass.")
        permissionInsertExpectation = expectationWithDescription("Permission: Insert did not pass.")
        permissionSearchExpectation = expectationWithDescription("Permission: Search did not pass.")
        yearInsertExpectation = expectationWithDescription("Age: Insert did not pass.")
        yearSearchExpectation = expectationWithDescription("Age: Search did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        friend["permission"] = "read"
        friend["year"] = 2001

        // Set an Expectation for the update watcher.
        permissionUpdateExpectation = expectationWithDescription("Permission: Update did not pass.")
        permissionSearchExpectation = expectationWithDescription("Permission: Search did not pass.")
        yearUpdateExpectation = expectationWithDescription("Age: Update did not pass.")
        yearSearchExpectation = expectationWithDescription("Age: Search did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        friend.delete()

        // Set an Expectation for the delete watcher.
        friendDeleteExpectation = expectationWithDescription("Friend: Delete did not pass.")
        closeDeleteExpectation = expectationWithDescription("Close: Delete did not pass.")
        closeSearchExpectation = expectationWithDescription("Close: Search did not pass.")
        permissionDeleteExpectation = expectationWithDescription("Permission: Delete did not pass.")
        permissionSearchExpectation = expectationWithDescription("Permission: Search did not pass.")
        yearDeleteExpectation = expectationWithDescription("Age: Delete did not pass.")
        yearSearchExpectation = expectationWithDescription("Age: Search did not pass.")

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

    func graph(graph: GKGraph!, didInsertBond bond: GKBond!) {
        if "Friend" == bond.type && "User" == bond.subject?.type && "User" == bond.object?.type {
            friendInsertExpectation?.fulfill()
		}
    }

    func graph(graph: GKGraph!, didDeleteBond bond: GKBond!) {
        if "Friend" == bond.type && nil == bond.subject && nil == bond.object {
            friendDeleteExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didInsertBond bond: GKBond!, group: String!) {
        if "Close" == group {
            closeInsertExpectation?.fulfill()
            let nodes: Array<GKBond> = graph.search(BondGroup: group);
            if 1 == nodes.count && bond.id == nodes[0].id {
                closeSearchExpectation?.fulfill()
            }
        }
    }

    func graph(graph: GKGraph!, didDeleteBond bond: GKBond!, group: String!) {
        if "Close" == group {
            closeDeleteExpectation?.fulfill()
            let nodes: Array<GKBond> = graph.search(BondGroup: group);
            if 0 == nodes.count {
                closeSearchExpectation?.fulfill()
            }
        }
    }

    func graph(graph: GKGraph!, didInsertBond bond: GKBond!, property: String!, value: AnyObject!) {
        if "permission" == property && "edit" == value as String {
            permissionInsertExpectation?.fulfill()
            var nodes: Array<GKBond> = graph.search(BondProperty: property);
            if 1 == nodes.count && nodes[0][property] as String == value as String {
                var nodes: Array<GKBond> = graph.search(BondProperty: property, value: value as String);
                if 1 == nodes.count && nodes[0][property] as String == value as String {
                    permissionSearchExpectation?.fulfill()
                }
            }

        } else if "year" == property && 1998 == value as Int {
            yearInsertExpectation?.fulfill()
            var nodes: Array<GKBond> = graph.search(BondProperty: property);
            if 1 == nodes.count && nodes[0][property] as Int == value as Int {
                var nodes: Array<GKBond> = graph.search(BondProperty: property, value: value as Int);
                if 1 == nodes.count && nodes[0][property] as Int == value as Int {
                    yearSearchExpectation?.fulfill()
                }
            }
        }
    }

    func graph(graph: GKGraph!, didUpdateBond bond: GKBond!, property: String!, value: AnyObject!) {
        if "permission" == property && "read" == value as String {
            permissionUpdateExpectation?.fulfill()
            var nodes: Array<GKBond> = graph.search(BondProperty: property);
            if 1 == nodes.count && nodes[0][property] as String == value as String {
                var nodes: Array<GKBond> = graph.search(BondProperty: property, value: value as String);
                if 1 == nodes.count && nodes[0][property] as String == value as String {
                    permissionSearchExpectation?.fulfill()
                }
            }
        } else if "year" == property && 2001 == value as Int {
            yearUpdateExpectation?.fulfill()
            var nodes: Array<GKBond> = graph.search(BondProperty: property);
            if 1 == nodes.count && nodes[0][property] as Int == value as Int {
                var nodes: Array<GKBond> = graph.search(BondProperty: property, value: value as Int);
                if 1 == nodes.count && nodes[0][property] as Int == value as Int {
                    yearSearchExpectation?.fulfill()
                }
            }
        }
    }

    func graph(graph: GKGraph!, didDeleteBond bond: GKBond!, property: String!, value: AnyObject!) {
        if "permission" == property && "read" == value as String {
            permissionDeleteExpectation?.fulfill()
            var nodes: Array<GKBond> = graph.search(BondProperty: property);
            if 0 == nodes.count {
                var nodes: Array<GKBond> = graph.search(BondProperty: property, value: value as String);
                if 0 == nodes.count {
                    permissionSearchExpectation?.fulfill()
                }
            }
        } else if "year" == property && 2001 == value as Int {
            yearDeleteExpectation?.fulfill()
            var nodes: Array<GKBond> = graph.search(BondProperty: property);
            if 0 == nodes.count {
                var nodes: Array<GKBond> = graph.search(BondProperty: property, value: value as Int);
                if 0 == nodes.count {
                    yearSearchExpectation?.fulfill()
                }
            }
        }
    }
}
