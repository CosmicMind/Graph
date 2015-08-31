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

class Tests : XCTestCase, GraphDelegate {
	
	private var graph: Graph?
	
	override func setUp() {
		super.setUp()
		graph = Graph()
	}
	
	override func tearDown() {
		graph = nil
		super.tearDown()
	}
	
	func testAll() {
		// Set the XCTest Class as the delegate.
		graph?.delegate = self
		
		var user: Entity? = Entity(type: "User")
		var author: Bond? = Bond(type: "Author")
		var read: Action? = Action(type: "Read")
		var book1: Entity? = Entity(type: "Book")
		var book2: Entity? = Entity(type: "Book")
		
		read!.addSubject(user!)
		read!.addObject(book1!)
		read!.addObject(book2!)
		author!.subject = user
		author!.object = book1
		
		// Save the Graph, which will execute the delegate handlers.
		graph?.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		XCTAssertTrue(read!.subjects.count == 1, "Read: did not save User.")
		XCTAssertTrue(user!.actionsWhenSubject[0] == read!, "User: does not have access to Read when Subject.")
		XCTAssertTrue(0 == user!.actionsWhenObject.count, "User: should not have access to Read when Object.")
		XCTAssertTrue(user!.actions[0] == read!, "User: does not have access to Read.")
		XCTAssertTrue(user!.bondsWhenSubject[0] == author!, "User: does not have access to Author when Subject.")
		XCTAssertTrue(0 == user!.bondsWhenObject.count, "User: should not have access to Author when Object.")
		XCTAssertTrue(user == author!.subject && book1 == author!.object, "Author: Not correctly mapped.")
		XCTAssertTrue(read!.hasSubject(user!), "Read: Not correctly mapped.")
		XCTAssertTrue(read!.hasObject(book1!), "Read: Not correctly mapped.")
		XCTAssertTrue(read!.hasObject(book2!), "Read: Not correctly mapped.")
		
		book1!.delete()
		
		// Save the Graph, which will execute the delegate handlers.
		graph?.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		XCTAssertTrue(0 == graph?.search(Bond: "Author").count && 0 == user!.bonds.count, "Author: Not correctly deleted.")
		XCTAssertTrue(0 == graph?.search(Action: "Read").count, "Read: Not correctly searched.")
		
		book2!.delete()
		
		// Save the Graph, which will execute the delegate handlers.
		graph?.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}

		XCTAssertTrue(0 == graph?.search(Action: "Read").count, "Read: Not correctly deleted.")
		
		user!.delete()
		// Save the Graph, which will execute the delegate handlers.
		graph?.save() { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		XCTAssertTrue(0 == graph?.search(Action: "Read").count, "Read: Not correctly deleted.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

