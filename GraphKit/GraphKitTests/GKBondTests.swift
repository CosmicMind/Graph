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
* along with this program located at the root of the software packinteger
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import XCTest
import GraphKit

class GKBondTests : XCTestCase, GKGraphDelegate {

	let graph: GKGraph = GKGraph()
	
	var familyInsertExpectation: XCTestExpectation?
	var ownerInsertExpectation: XCTestExpectation?

    var familyUpdateExpectation: XCTestExpectation?
    var ownerUpdateExpectation: XCTestExpectation?

	var familyArchiveExpectation: XCTestExpectation?
	var ownerArchiveExpectation: XCTestExpectation?
	
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBond() {
		// Set the test Class as the delegate.
		graph.delegate = self
		
		// Watch changes in the Graph.
		graph.watch(Bond: "Family")
		graph.watch(Bond: "Owner")
		
		// Some Exception testing.
		familyInsertExpectation = expectationWithDescription("Insert Test: Watch 'Family' did not pass.")
		ownerInsertExpectation = expectationWithDescription("Insert Test: Watch 'Owner' did not pass.")

		// Create a Family Bond.
		var family: GKBond = GKBond(type: "Family")
		family["string"] = "String"
		family["integer"] = 26
		
		// Create a Owner Bond.
		var owner: GKBond = GKBond(type: "Owner")
		owner["title"] = "Learning GraphKit"
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the Graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)

        family["update"] = "Update"
        owner["update"] = "Update"

        familyUpdateExpectation = expectationWithDescription("Update Test: Watch 'Family' did not pass.")
        ownerUpdateExpectation = expectationWithDescription("Update Test: Watch 'Owner' did not pass.")

        graph.save() {
            XCTAssertTrue($0, "Cannot save the Graph: \($1)")
        }
        waitForExpectationsWithTimeout(5, handler: nil)
		
		family.archive()
		owner.archive()
		
		familyArchiveExpectation = expectationWithDescription("Archive Test: Watch 'Family' did not pass.")
		ownerArchiveExpectation = expectationWithDescription("Archive Test: Watch 'Owner' did not pass.")
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the Graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testPerformanceExample() {
        self.measureBlock() {}
    }
	
	func graph(graph: GKGraph!, didInsertBond action: GKBond!) {
		if "Family" == action.type && "String" == action["string"]? as String && 26 == action["integer"]? as Int {
			familyInsertExpectation?.fulfill()
		} else if "Owner" == action.type && "Learning GraphKit" == action["title"]? as String {
			ownerInsertExpectation?.fulfill()
		}
	}

    func graph(graph: GKGraph!, didUpdateBond action: GKBond!) {
        if "Family" == action.type && "Update" == action["update"]? as String {
            familyUpdateExpectation?.fulfill()
        } else if "Owner" == action.type && "Update" == action["update"]? as String {
            ownerUpdateExpectation?.fulfill()
        }
    }
	
	func graph(graph: GKGraph!, didArchiveBond action: GKBond!) {
		if "Family" == action.type && "String" == action["string"]? as String && 26 == action["integer"]? as Int {
			familyArchiveExpectation?.fulfill()
		} else if "Owner" == action.type && "Learning GraphKit" == action["title"]? as String {
			ownerArchiveExpectation?.fulfill()
		}
	}
}
