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
import Foundation
import GraphKit

class GroupTests: XCTestCase {
	private var graph: Graph?
	override func setUp() {
		super.setUp()
		graph = Graph()
	}
	
	override func tearDown() {
		graph = nil
		super.tearDown()
	}
	
	func testSimple() {
		
		for i in 0..<100 {
			let item: Entity = Entity(type: "Item")
			if i == 5 {
				item.addGroup("Action")
			}
			if 0 == i % 5 {
				item.addGroup("#target")
			} else {
				item.addGroup("#miss")
			}
		}
		graph!.save()
		
		let items = graph!.search(entity: "*", group: ["#*"])
		
		XCTAssert(100 == items.count, "Test failed.")
		
		let pofx: Double = items.probabilityOf(items.first!)
		XCTAssert(0.01 == pofx, "Test failed. \(pofx)")
		
		for x in items {
			x.delete()
		}
		items.removeAll()
		graph!.save()
		
		XCTAssert(0 == items.count , "Test failed.")
	}
	
	func testMap() {
		
		for i in 0..<100 {
			let item: Entity = Entity(type: "Item")
			if i == 5 {
				item.addGroup("Action")
			}
			if 0 == i % 5 {
				item.addGroup("#target")
			} else {
				item.addGroup("#miss")
			}
		}
		graph!.save()
		
		let items = graph!.search(EntityGroupMap: "#*")
		XCTAssert(2 == items.count , "Test failed.\(items.count)")
		
		for (_, set) in items {
			for y in set! {
				y.delete()
			}
		}
		items.removeAll()
		graph!.save()
		
		XCTAssert(0 == items.count , "Test failed.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
