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
		graph.watch(EntityGroup: "Female")
        graph.watch(Entity: "User")

        // Create a User Entity.
        let u1: GKEntity = GKEntity(type: "User")
        u1["name"] = "Eve"
        u1.addGroup("Female")
		
        u1InsertExpectation = expectationWithDescription("U1: Insert 'User' did not pass.")

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }
        waitForExpectationsWithTimeout(5, handler: nil)

//		u1.removeGroup("Female")
        u1.delete()

        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        u1DeleteExpectation = expectationWithDescription("U1: Update 'User' did not pass.")

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)

//        u1.removeGroup("Female")


        // Save the Graph, which will execute the delegate handlers.
//        graph.save() { (success: Bool, error: NSError?) in
//            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
//        }

        // Wait for the delegates to be executed.
//        waitForExpectationsWithTimeout(5, handler: nil)
    }

    func testPerformanceExample() {
        self.measureBlock() {}
    }

	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
//        if "User" == entity.type && nil != entity["name"] {
            u1InsertExpectation?.fulfill()
//        }
        NSLog("INSERTED ENTITY %@", entity)
	}

    func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!, group: String!) {
//        if "User" == entity.type && nil != entity["name"] {
//            u1InsertExpectation?.fulfill()
//        }
        NSLog("INSERTED GROUP %@", entity)
    }

    func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!) {
        NSLog("UPDATED ENTITY %@", entity)
    }

    func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!, group: String!) {
        if "User" == entity.type {
            u1UpdateExpectation?.fulfill()
        }

        NSLog("UPDATED GROUP %@", entity)
    }

    func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
        NSLog("DELETED ENTITY %@", entity)
        if "User" == entity.type {
            u1DeleteExpectation?.fulfill()
        }
    }

    func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!, group: String!) {
        if "User" == entity.type {
            NSLog("DELETED GROUP NOW %@", entity)
        }
    }
}
