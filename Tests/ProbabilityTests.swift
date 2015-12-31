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
@testable import GraphKit

class ProbabilityTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testSortedSet() {
		let s: SortedSet<Int> = SortedSet<Int>()
		
		s.insert(1, 2, 3, 3)
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev1 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (element: Int) -> Bool in
			return 2 == element || 3 == element
		}
		
		XCTAssert(ev2 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testSortedMultiSet() {
		let s: SortedSet<Int> = SortedSet<Int>()
		
		s.insert(1, 2, 3, 3)
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev1 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (element: Int) -> Bool in
			return 2 == element || 3 == element
		}
		
		XCTAssert(ev2 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testSortedDictionary() {
		let s: SortedDictionary<Int, Int> = SortedDictionary<Int, Int>()
		
		s.insert((1, 1))
		s.insert((2, 2))
		s.insert((3, 3))
		s.insert((3, 3))
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev1 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (key: Int, value: Int?) -> Bool in
			return 2 == value || 3 == value
		}
		
		XCTAssert(ev2 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testSortedMultiDictionary() {
		let s: SortedMultiDictionary<Int, Int> = SortedMultiDictionary<Int, Int>()
		
		s.insert((1, 1))
		s.insert((2, 2))
		s.insert((3, 3))
		s.insert((3, 3))
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev1 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (key: Int, value: Int?) -> Bool in
			return 2 == value || 3 == value
		}
		
		XCTAssert(ev2 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testArray() {
		var s: Array<Int> = Array<Int>()
		
		s.append(1)
		s.append(2)
		s.append(3)
		s.append(4)
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev1 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (element: Int) -> Bool in
			return 2 == element || 3 == element
		}
		
		XCTAssert(ev2 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testSet() {
		var s: Set<Int> = Set<Int>()
		
		s.insert(1)
		s.insert(2)
		s.insert(3)
		s.insert(4)
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssert(ev1 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (element: Int) -> Bool in
			return 2 == element || 3 == element
		}
		
		XCTAssert(ev2 == s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testEntity() {
		let graph: Graph = Graph()
		let target: Entity = Entity(type: "ProbTest")
		for _ in 0..<99 {
			let _: Entity = Entity(type: "ProbTest")
		}
		graph.save()
		
		let entities: Array<Entity> = graph.searchForEntity(types: ["ProbTest"])
		XCTAssert(0.01 == entities.probabilityOf(target), "Test failed.")
		
		for e in entities {
			e.delete()
		}
		graph.save()
	}
	
	func testAction() {
		let graph: Graph = Graph()
		let target: Action = Action(type: "ProbTest")
		for _ in 0..<99 {
			let _: Action = Action(type: "ProbTest")
		}
		graph.save()
		
		let entities: Array<Action> = graph.searchForAction(types: ["ProbTest"])
		XCTAssert(0.01 == entities.probabilityOf(target), "Test failed.")
		
		for e in entities {
			e.delete()
		}
		graph.save()
	}
	
	func testBond() {
		let graph: Graph = Graph()
		let target: Bond = Bond(type: "ProbTest")
		for _ in 0..<99 {
			let _: Bond = Bond(type: "ProbTest")
		}
		graph.save()
		
		let entities: Array<Bond> = graph.searchForBond(types: ["ProbTest"])
		XCTAssert(0.01 == entities.probabilityOf(target), "Test failed.")
		
		for e in entities {
			e.delete()
		}
		graph.save()
	}

	func testPerformance() {
		self.measureBlock() {}
	}
}
