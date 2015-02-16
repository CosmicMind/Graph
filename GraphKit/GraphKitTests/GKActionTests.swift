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

	let graph: GKGraph = GKGraph()
	
	var clickInsertExpectation: XCTestExpectation?
	var readInsertExpectation: XCTestExpectation?

    var clickUpdateExpectation: XCTestExpectation?
    var readUpdateExpectation: XCTestExpectation?

	var clickArchiveExpectation: XCTestExpectation?
	var readArchiveExpectation: XCTestExpectation?
	
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAction() {
		// Set the test Class as the delegate.
		graph.delegate = self
		
		// Watch changes in the Graph.
		graph.watch(Action: "Click")
		graph.watch(Action: "Read")
		
		// Some Exception testing.
		clickInsertExpectation = expectationWithDescription("Insert Test: Watch 'Click' did not pass.")
		readInsertExpectation = expectationWithDescription("Insert Test: Watch 'Read' did not pass.")

		// Create a Click Action.
		var click: GKAction = GKAction(type: "Click")
		click["string"] = "String"
		click["numeric"] = 26

        var button: GKEntity = GKEntity(type: "Button")
		button["name"] = "Home Button"
        click.addSubject(button)

		// Create a Read Action.
		var read: GKAction = GKAction(type: "Read")
		read["title"] = "Learning GraphKit"
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the Graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)

        click["update"] = "Update"
        read["update"] = "Update"

        clickUpdateExpectation = expectationWithDescription("Update Test: Watch 'Click' did not pass.")
        readUpdateExpectation = expectationWithDescription("Update Test: Watch 'Read' did not pass.")

        graph.save() {
            XCTAssertTrue($0, "Cannot save the Graph: \($1)")
        }
        waitForExpectationsWithTimeout(5, handler: nil)
		
		click.archive()
		read.archive()
		
		clickArchiveExpectation = expectationWithDescription("Archive Test: Watch 'Click' did not pass.")
		readArchiveExpectation = expectationWithDescription("Archive Test: Watch 'Read' did not pass.")
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the Graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testPerformanceExample() {
        self.measureBlock() {}
    }
	
	func graph(graph: GKGraph!, didInsertAction action: GKAction!) {
		if "Click" == action.type && "String" == action["string"]? as String && 26 == action["numeric"]? as Int {
            clickInsertExpectation?.fulfill()
		} else if "Read" == action.type && "Learning GraphKit" == action["title"]? as String {
			readInsertExpectation?.fulfill()
		}
	}

    func graph(graph: GKGraph!, didUpdateAction action: GKAction!) {
        if "Click" == action.type && "Update" == action["update"]? as String {
            clickUpdateExpectation?.fulfill()
        } else if "Read" == action.type && "Update" == action["update"]? as String {
            readUpdateExpectation?.fulfill()
        }
    }
	
	func graph(graph: GKGraph!, didArchiveAction action: GKAction!) {
		if "Click" == action.type && "String" == action["string"]? as String && 26 == action["numeric"]? as Int {
			clickArchiveExpectation?.fulfill()
		} else if "Read" == action.type && "Learning GraphKit" == action["title"]? as String {
			readArchiveExpectation?.fulfill()
		}
	}
}
