//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import XCTest
import GraphKit

class EntityTests : XCTestCase, GraphDelegate {

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

	private var graph: Graph?
	
	var expectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
		graph = Graph()
	}
	
	override func tearDown() {
		graph = nil
		userInsertExpectation = nil
		userDeleteExpectation = nil
		groupInsertExpectation = nil
		groupSearchExpectation = nil
		nameInsertExpectation = nil
		nameUpdateExpectation = nil
		nameSearchExpectation = nil
		ageInsertExpectation = nil
		ageUpdateExpectation = nil
		ageSearchExpectation = nil
		super.tearDown()
	}

    func testAll() {
        // Set the XCTest Class as the delegate.
        graph!.delegate = self

        // Let's watch the changes in the Graph for the following Entity values.
        graph!.watch(entity: "User")
        graph!.watch(entityGroup: "Female")
        graph!.watch(entityProperty: "name")
        graph!.watch(entityProperty: "age")

        // Create a User Entity.
        let user: Entity = Entity(type: "User")
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
        graph!.save { (success: Bool, error: NSError?) in
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
        graph!.save { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

        user.delete()

        // Set an Expectation for the delete watcher.
        userDeleteExpectation = expectationWithDescription("User: Delete did not pass.")
        
        // Save the Graph, which will execute the delegate handlers.
        graph!.save { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)
    }

    func graphDidInsertEntity(graph: Graph, entity: Entity) {
        if "User" == entity.type {
            userInsertExpectation?.fulfill()
		}
    }

    func graphDidDeleteEntity(graph: Graph, entity: Entity) {
        if "User" == entity.type {
            userDeleteExpectation?.fulfill()
        }
    }

    func graphDidInsertEntityGroup(graph: Graph, entity: Entity, group: String) {
        if "Female" == group {
            groupInsertExpectation?.fulfill()
            let nodes: OrderedSet<Entity> = graph.search(entityGroup: group)
            if entity.id == nodes.first?.id {
                groupSearchExpectation?.fulfill()
            }
        }
    }

    func graphDidInsertEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
        if "name" == property && "Eve" == value as! String {
            nameInsertExpectation?.fulfill()
            let n: OrderedSet<Entity> = graph.search(entityProperty: property)
			if n.first?[property] as! String == value as! String {
				let m: OrderedSet<Entity> = graph.search(entityProperty: property, value: value as! String)
				if m.first?[property] as! String == value as! String {
                    nameSearchExpectation?.fulfill()
                }
            }

        } else if "age" == property && 26 == value as! Int {
            ageInsertExpectation?.fulfill()
            let n: OrderedSet<Entity> = graph.search(entityProperty: property)
			if  n.first?[property] as! Int == value as! Int {
				let m: OrderedSet<Entity> = graph.search(entityProperty: property, value: value as! Int)
				if m.first?[property] as! Int == value as! Int {
                    ageSearchExpectation?.fulfill()
                }
            }
        }
    }

    func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {
        if "name" == property && "Daniel" == value as! String {
            nameUpdateExpectation?.fulfill()
			let n: OrderedSet<Entity> = graph.search(entityProperty: property)
			if n.first?[property] as! String == value as! String {
				let m: OrderedSet<Entity> = graph.search(entityProperty: property, value: value as! String)
				if m.first?[property] as! String == value as! String {
					nameSearchExpectation?.fulfill()
				}
			}
        } else if "age" == property && 31 == value as! Int {
            ageUpdateExpectation?.fulfill()
			let n: OrderedSet<Entity> = graph.search(entityProperty: property)
			if n.first?[property] as! Int == value as! Int {
				let m: OrderedSet<Entity> = graph.search(entityProperty: property, value: value as! Int)
				if m.first?[property] as! Int == value as! Int {
					ageSearchExpectation?.fulfill()
				}
			}
        }
    }
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
