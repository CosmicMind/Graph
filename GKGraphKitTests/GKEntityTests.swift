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
import GKGraphKit

class GKEntityTests : XCTestCase, GKGraphDelegate {

    var userInsertExpectation: XCTestExpectation?
	var userDeleteExpectation: XCTestExpectation?
    var groupInsertExpectation: XCTestExpectation?
    var groupSearchExpectation: XCTestExpectation?
    var nameInsertExpectation: XCTestExpectation?
    var nameUpdateExpectation: XCTestExpectation?
    var nameSearchExpectation: XCTestExpectation?
    var ageInsertExpectation: XCTestExpectation?
    var ageUpdateExpectation: XCTestExpectation?
    var ageSearchExpectation: XCTestExpectation?

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
        groupInsertExpectation = expectationWithDescription("Group: Insert did not pass.")
        groupSearchExpectation = expectationWithDescription("Group: Search did not pass.")
        nameInsertExpectation = expectationWithDescription("Name: Insert did not pass.")
        nameSearchExpectation = expectationWithDescription("Name: Search did not pass.")
        ageInsertExpectation = expectationWithDescription("Age: Insert did not pass.")
        ageSearchExpectation = expectationWithDescription("Age: Search did not pass.")

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
        nameSearchExpectation = expectationWithDescription("Name: Search did not pass.")
        ageUpdateExpectation = expectationWithDescription("Age: Update did not pass.")
        ageSearchExpectation = expectationWithDescription("Age: Search did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        user.delete()

        // Set an Expectation for the delete watcher.
        userDeleteExpectation = expectationWithDescription("User: Delete did not pass.")
        
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
            groupInsertExpectation?.fulfill()
            let nodes: Array<GKEntity> = graph.search(EntityGroup: group)
            if 1 == nodes.count && entity.objectID == nodes[0].objectID {
                groupSearchExpectation?.fulfill()
            }
        }
    }

    func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!, property: String!, value: AnyObject!) {
        if "name" == property && "Eve" == value as String {
            nameInsertExpectation?.fulfill()
            var nodes: Array<GKEntity> = graph.search(EntityProperty: property)
            if 1 == nodes.count && nodes[0][property] as String == value as String {
                var nodes: Array<GKEntity> = graph.search(EntityProperty: property, value: value as String)
                if 1 == nodes.count && nodes[0][property] as String == value as String {
                    nameSearchExpectation?.fulfill()
                }
            }

        } else if "age" == property && 26 == value as Int {
            ageInsertExpectation?.fulfill()
            var nodes: Array<GKEntity> = graph.search(EntityProperty: property)
            if 1 == nodes.count && nodes[0][property] as Int == value as Int {
                var nodes: Array<GKEntity> = graph.search(EntityProperty: property, value: value as Int)
                if 1 == nodes.count && nodes[0][property] as Int == value as Int {
                    ageSearchExpectation?.fulfill()
                }
            }
        }
    }

    func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!, property: String!, value: AnyObject!) {
        if "name" == property && "Daniel" == value as String {
            nameUpdateExpectation?.fulfill()
            var nodes: Array<GKEntity> = graph.search(EntityProperty: property)
            if 1 == nodes.count && nodes[0][property] as String == value as String {
                var nodes: Array<GKEntity> = graph.search(EntityProperty: property, value: value as String)
                if 1 == nodes.count && nodes[0][property] as String == value as String {
                    nameSearchExpectation?.fulfill()
                }
            }
        } else if "age" == property && 31 == value as Int {
            ageUpdateExpectation?.fulfill()
            var nodes: Array<GKEntity> = graph.search(EntityProperty: property)
            if 1 == nodes.count && nodes[0][property] as Int == value as Int {
                var nodes: Array<GKEntity> = graph.search(EntityProperty: property, value: value as Int)
                if 1 == nodes.count && nodes[0][property] as Int == value as Int {
                    ageSearchExpectation?.fulfill()
                }
            }
        }
    }
}
