//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>.
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
import CoreData
@testable import GraphKit

class EntitySearchTests : XCTestCase, GraphDelegate {
	var graph: Graph!
	
	override func setUp() {
		super.setUp()
		graph = Graph()
	}
	
	override func tearDown() {
		graph = nil
		super.tearDown()
	}
	
	func testAll() {
		for var i: Int = 0; i < 50; ++i {
			let n: Entity = Entity(type: "T1")
			n["P1"] = 0 == i % 2 ? "V1" : 1
			n.addGroup("G1")
		}
		
		for var i: Int = 0; i < 100; ++i {
			let n: Entity = Entity(type: "T2")
			n["P2"] = "V2"
			n.addGroup("G2")
		}
		
		for var i: Int = 0; i < 200; ++i {
			let n: Entity = Entity(type: "T3")
			n["P3"] = "V3"
			n.addGroup("G3")
		}
		
		graph.save { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
		
		XCTAssertEqual(50, graph.search(entity: ["T1"]).count)
		XCTAssertEqual(50, graph.search(entity: ["T1"], groups: ["G1"]).count)
		XCTAssertEqual(50, graph.search(entity: ["T1"], properties: [("P1", nil)]).count)
		XCTAssertEqual(50, graph.search(entity: ["T1"], groups: ["G1"], properties: [("P1", nil)]).count)
		
		XCTAssertEqual(25, graph.search(entity: ["T1"], properties: [("P1", "V1")]).count)
		XCTAssertEqual(25, graph.search(entity: ["T1"], properties: [("P1", 1)]).count)
		
		XCTAssertEqual(100, graph.search(entity: ["T2"]).count)
		XCTAssertEqual(100, graph.search(entity: ["T2"], groups: ["G2"]).count)
		XCTAssertEqual(100, graph.search(entity: ["T2"], properties: [("P2", nil)]).count)
		XCTAssertEqual(100, graph.search(entity: ["T2"], groups: ["G2"], properties: [("P2", nil)]).count)
		
		XCTAssertEqual(200, graph.search(entity: ["T3"]).count)
		XCTAssertEqual(200, graph.search(entity: ["T3"], groups: ["G3"]).count)
		XCTAssertEqual(200, graph.search(entity: ["T3"], properties: [("P3", nil)]).count)
		XCTAssertEqual(200, graph.search(entity: ["T3"], groups: ["G3"], properties: [("P3", nil)]).count)
		
		for n in graph.search(entity: ["*"]) {
			n.delete()
		}
		graph.save { (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
