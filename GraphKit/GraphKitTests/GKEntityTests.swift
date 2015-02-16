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

	let graph: GKGraph = GKGraph()
	
	var userInsertExpectation: XCTestExpectation?
	var bookInsertExpectation: XCTestExpectation?

    var userUpdateExpectation: XCTestExpectation?
    var bookUpdateExpectation: XCTestExpectation?
    
	var userArchiveExpectation: XCTestExpectation?
	var bookArchiveExpectation: XCTestExpectation?
	
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEntity() {
		// Set the test Class as the delegate.
		graph.delegate = self
		
		// Watch changes in the Graph.
		graph.watch(Entity: "User")
		graph.watch(Entity: "Book")
		
		// Some Exception testing.
		userInsertExpectation = expectationWithDescription("Insert Test: Watch 'User' did not pass.")
		bookInsertExpectation = expectationWithDescription("Insert Test: Watch 'Book' did not pass.")

		// Create a User Entity.
		var user: GKEntity = GKEntity(type: "User")
		user["string"] = "String"
		user["numeric"] = 26
        user.addGroup("female")
        user.addGroup("admin")
		
		// Create a Book Entity.
		var book: GKEntity = GKEntity(type: "Book")
		book["title"] = "Learning GraphKit"
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the Graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)

        user["update"] = "Update"
        book["update"] = "Update"
		user.removeGroup("admin")

        userUpdateExpectation = expectationWithDescription("Update Test: Watch 'User' did not pass.")
        bookUpdateExpectation = expectationWithDescription("Update Test: Watch 'Book' did not pass.")

        graph.save() {
            XCTAssertTrue($0, "Cannot save the Graph: \($1)")
        }
        waitForExpectationsWithTimeout(5, handler: nil)
        
		user.archive()
		book.archive()
		
		userArchiveExpectation = expectationWithDescription("Archive Test: Watch 'User' did not pass.")
		bookArchiveExpectation = expectationWithDescription("Archive Test: Watch 'Book' did not pass.")
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the Graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testPerformanceExample() {
        self.measureBlock() {}
    }
	
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
		if "User" == entity.type &&
            "String" == entity["string"]? as String &&
            26 == entity["numeric"]? as Int &&
            entity.hasGroup("female") &&
            entity.hasGroup("admin") {
			userInsertExpectation?.fulfill()
		} else if "Book" == entity.type && "Learning GraphKit" == entity["title"]? as String {
			bookInsertExpectation?.fulfill()
		}
	}

    func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!) {
        if "User" == entity.type && "Update" == entity["update"]? as String && !entity.hasGroup("admin") {
            userUpdateExpectation?.fulfill()
        } else if "Book" == entity.type && "Update" == entity["update"]? as String {
            bookUpdateExpectation?.fulfill()
        }
    }
    
	func graph(graph: GKGraph!, didArchiveEntity entity: GKEntity!) {
		if "User" == entity.type && "String" == entity["string"]? as String && 26 == entity["numeric"]? as Int {
			userArchiveExpectation?.fulfill()
		} else if "Book" == entity.type && "Learning GraphKit" == entity["title"]? as String {
			bookArchiveExpectation?.fulfill()
		}
	}
}
