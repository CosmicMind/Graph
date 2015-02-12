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
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import XCTest
import GraphKit

class GraphKitTests: XCTestCase, GKGraphDelegate {

	let graph: GKGraph = GKGraph()
	
	var userInsertExpectation: XCTestExpectation?
	var bookInsertExpectation: XCTestExpectation?
	
	var userArchiveExpectation: XCTestExpectation?
	var bookArchiveExpectation: XCTestExpectation?
	
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEntity() {
		graph.delegate = self
		graph.watch(Entity: "User")
		graph.watch(Entity: "Book")
		
		userInsertExpectation = expectationWithDescription("User Entity inserted. Delegate method was not called!")
		bookInsertExpectation = expectationWithDescription("Book Entity inserted. Delegate method was not called!")

		var user: GKEntity = GKEntity(type: "User")
		var book: GKEntity = GKEntity(type: "Book")
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)
		
		user.archive()
		book.archive()
		
		userArchiveExpectation = expectationWithDescription("User Entity archived. Delegate method was not called!")
		bookArchiveExpectation = expectationWithDescription("Book Entity archived. Delegate method was not called!")
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testPerformanceExample() {
        self.measureBlock() {}
    }
	
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
		NSLog("INSERTED")
		if "User" == entity.type {
			userInsertExpectation?.fulfill()
		} else if "Book" == entity.type {
			bookInsertExpectation?.fulfill()
		}
	}
	
	func graph(graph: GKGraph!, didArchiveEntity entity: GKEntity!) {
		NSLog("ARCHIVED")
		if "User" == entity.type {
			userArchiveExpectation?.fulfill()
		} else if "Book" == entity.type {
			bookArchiveExpectation?.fulfill()
		}
	}
}
