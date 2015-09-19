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

class BondTests : XCTestCase, GraphDelegate {

    var u1InsertExpectation: XCTestExpectation?
    var u2InsertExpectation: XCTestExpectation?
    var friendInsertExpectation: XCTestExpectation?
	var friendDeleteExpectation: XCTestExpectation?
    var groupInsertExpectation: XCTestExpectation?
    var groupDeleteExpectation: XCTestExpectation?
    var groupSearchExpectation: XCTestExpectation?
    var permissionInsertExpectation: XCTestExpectation?
    var permissionUpdateExpectation: XCTestExpectation?
    var permissionDeleteExpectation: XCTestExpectation?
    var permissionSearchExpectation: XCTestExpectation?
    var yearInsertExpectation: XCTestExpectation?
    var yearUpdateExpectation: XCTestExpectation?
    var yearDeleteExpectation: XCTestExpectation?
    var yearSearchExpectation: XCTestExpectation?

	private var graph: Graph!
	
	override func setUp() {
		super.setUp()
		graph = Graph()
	}
	
	override func tearDown() {
		graph = nil
		u1InsertExpectation = nil
		u2InsertExpectation = nil
		friendInsertExpectation = nil
		friendDeleteExpectation = nil
		groupInsertExpectation = nil
		groupDeleteExpectation = nil
		groupSearchExpectation = nil
		permissionInsertExpectation = nil
		permissionUpdateExpectation = nil
		permissionDeleteExpectation = nil
		permissionSearchExpectation = nil
		yearInsertExpectation = nil
		yearUpdateExpectation = nil
		yearDeleteExpectation = nil
		yearSearchExpectation = nil
		super.tearDown()
	}
	
	func testJSON() {
		let author: Bond = Bond(type: "Author")
		author["genre"] = "Physics"
		author["pages"] = 101
		author["date"] = NSDate(timeIntervalSince1970: NSTimeInterval(1))
		
		let user: Entity = Entity(type: "User")
		user["name"] = "Eve"
		user["age"] = 26
		user["date"] = NSDate(timeIntervalSince1970: NSTimeInterval(1))
		user.addGroup("Female")
		
		let book: Entity = Entity(type: "Book")
		book["title"] = "Holographic Universe"
		book.addGroup("Physics")
		book.addGroup("Featured")
		
		author.subject = user
		author.object = book
		
		graph!.save()
		
		XCTAssert(author.json["properties"]?["genre"]?.string == "Physics", "Test failed.")
		XCTAssert(author.json["properties"]?["pages"]?.int == 101, "Test failed.")
		XCTAssert(author.json["properties"]?["date"]?.string == String(stringInterpolationSegment: NSDate(timeIntervalSince1970: NSTimeInterval(1))), "Test failed.")
		XCTAssert(author.subject?.json == user.json, "Test failed.")
		XCTAssert(author.object?.json == book.json, "Test failed.")
		
		author.delete()
		user.delete()
		book.delete()
		graph!.save()
	}

    func testAll() {
        // Set the XCTest Class as the delegate.
        graph.delegate = self

        // Let's watch the changes in the Graph for the following Bond values.
		graph.watch(bond: "Friend", group: ["Close"], property: ["permission", "year"])

        // Let's watch the User Entity values to test reverse Bond indices.
        graph.watch(entity: "User")

        // Let's create two User Entity Objects.
        let u1: Entity = Entity(type: "User")
        u1["name"] = "Eve"

        let u2: Entity = Entity(type: "User")
        u2["name"] = "Daniel"

        // Create a Friend Bond.
        let friend: Bond = Bond(type: "Friend")
        friend["permission"] = "edit"
        friend["year"] = 1998
        friend.addGroup("Close")

        // Set the relationship between the users.
        friend.subject = u1
        friend.object = u2

        // Set an Expectation for the insert watcher.
        u1InsertExpectation = expectationWithDescription("User 1: Insert did not pass.")
        u2InsertExpectation = expectationWithDescription("User 2: Insert did not pass.")
        friendInsertExpectation = expectationWithDescription("Friend: Insert did not pass.")
        groupInsertExpectation = expectationWithDescription("Group: Insert did not pass.")
        groupSearchExpectation = expectationWithDescription("Group: Search did not pass.")
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

        u1.delete()
        u2.delete()

        // Set an Expectation for the delete watcher.
        friendDeleteExpectation = expectationWithDescription("Friend: Delete did not pass.")
		
        // Save the Graph, which will execute the delegate handlers.
        graph.save() { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "Cannot save the Graph: \(error)")
        }

        // Wait for the delegates to be executed.
        waitForExpectationsWithTimeout(5, handler: nil)
    }

    func graphDidInsertEntity(graph: Graph, entity: Entity) {
        if "Eve" == entity["name"] as! String && 1 == entity.bondsWhenSubject.count {
            u1InsertExpectation?.fulfill()
        } else if "Daniel" == entity["name"] as! String && 1 == entity.bondsWhenObject.count {
            u2InsertExpectation?.fulfill()
        }
    }

    func graphDidInsertBond(graph: Graph, bond: Bond) {
        if "Friend" == bond.type && "User" == bond.subject?.type && "User" == bond.object?.type {
            friendInsertExpectation?.fulfill()
		}
    }

    func graphDidDeleteBond(graph: Graph, bond: Bond){
        if "Friend" == bond.type && nil == bond.subject && nil == bond.object {
            friendDeleteExpectation?.fulfill()
        }
    }

    func graphDidInsertBondGroup(graph: Graph, bond: Bond, group: String) {
        if "Close" == group {
            groupInsertExpectation?.fulfill()
			let n: OrderedSet<Bond> = graph.search(bond: "*", group: [group])
            if bond.id == n.first?.id {
                groupSearchExpectation?.fulfill()
            }
        }
    }

    func graphDidInsertBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject){
        if "permission" == property && "edit" == value as! String {
            permissionInsertExpectation?.fulfill()
			let n: OrderedSet<Bond> = graph.search(bond: "*", property: [(property, nil)])
            if n.first?[property] as! String == value as! String {
                let m: OrderedSet<Bond> = graph.search(bond: "*", property: [(property, value)])
                if m.first?[property] as! String == value as! String {
                    permissionSearchExpectation?.fulfill()
                }
            }

        } else if "year" == property && 1998 == value as! Int {
            yearInsertExpectation?.fulfill()
            let n: OrderedSet<Bond> = graph.search(bond: "*", property: [(property, nil)])
            if n.first?[property] as! Int == value as! Int {
                let m: OrderedSet<Bond> = graph.search(bond: "*", property: [(property, value)])
                if m.first?[property] as! Int == value as! Int {
                    yearSearchExpectation?.fulfill()
                }
            }
        }
    }

    func graphDidUpdateBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {
        if "permission" == property && "read" == value as! String {
            permissionUpdateExpectation?.fulfill()
            let n: OrderedSet<Bond> = graph.search(bond: "*", property: [(property, nil)])
            if n.first?[property] as! String == value as! String {
                let m: OrderedSet<Bond> = graph.search(bond: "*", property: [(property, value)])
                if m.first?[property] as! String == value as! String {
                    permissionSearchExpectation?.fulfill()
                }
            }
        } else if "year" == property && 2001 == value as! Int {
            yearUpdateExpectation?.fulfill()
            let n: OrderedSet<Bond> = graph.search(bond: "*", property: [(property, nil)])
            if n.first?[property] as! Int == value as! Int {
                let m: OrderedSet<Bond> = graph.search(bond: "*", property: [(property, value)])
                if m.first?[property] as! Int == value as! Int {
                    yearSearchExpectation?.fulfill()
                }
            }
        }
    }
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
