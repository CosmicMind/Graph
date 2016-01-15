/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of GraphKit nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import XCTest
@testable import GraphKit

class ProbabilityTests: XCTestCase {
	var graph: Graph!
	
	var saveExpectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
		graph = Graph()
		graph.clear()
	}
	
	override func tearDown() {
		graph = nil
		super.tearDown()
	}
	
	func testSortedSet() {
		let s: SortedSet<Int> = SortedSet<Int>()
		XCTAssertEqual(0, s.probabilityOf({ _ -> Bool in return true}))
		
		s.insert(1, 2, 3, 3)
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssertEqual(ev1, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (element: Int) -> Bool in
			return 2 == element || 3 == element
		}
		
		XCTAssertEqual(ev2, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testSortedMultiSet() {
		let s: SortedSet<Int> = SortedSet<Int>()
		XCTAssertEqual(0, s.probabilityOf({ _ -> Bool in return true}))
		
		s.insert(1, 2, 3, 3)
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssertEqual(ev1, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (element: Int) -> Bool in
			return 2 == element || 3 == element
		}
		
		XCTAssertEqual(ev2, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testSortedDictionary() {
		let s: SortedDictionary<Int, Int> = SortedDictionary<Int, Int>()
		XCTAssertEqual(0, s.probabilityOf({ _ -> Bool in return true}))
		
		s.insert((1, 1))
		s.insert((2, 2))
		s.insert((3, 3))
		s.insert((3, 3))
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssertEqual(ev1, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (key: Int, value: Int?) -> Bool in
			return 2 == value || 3 == value
		}
		
		XCTAssertEqual(ev2, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testSortedMultiDictionary() {
		let s: SortedMultiDictionary<Int, Int> = SortedMultiDictionary<Int, Int>()
		XCTAssertEqual(0, s.probabilityOf({ _ -> Bool in return true}))
		
		s.insert((1, 1))
		s.insert((2, 2))
		s.insert((3, 3))
		s.insert((3, 3))
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssertEqual(ev1, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (key: Int, value: Int?) -> Bool in
			return 2 == value || 3 == value
		}
		
		XCTAssertEqual(ev2, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testArray() {
		var s: Array<Int> = Array<Int>()
		XCTAssertEqual(0, s.probabilityOf({ _ -> Bool in return true}))
		
		s.append(1)
		s.append(2)
		s.append(3)
		s.append(4)
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssertEqual(ev1, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (element: Int) -> Bool in
			return 2 == element || 3 == element
		}
		
		XCTAssertEqual(ev2, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testSet() {
		var s: Set<Int> = Set<Int>()
		XCTAssertEqual(0, s.probabilityOf({ _ -> Bool in return true}))
		
		s.insert(1)
		s.insert(2)
		s.insert(3)
		s.insert(4)
		
		let ev1: Double = 16 * s.probabilityOf(2, 3)
		
		XCTAssertEqual(ev1, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		let ev2: Double = 16 * s.probabilityOf { (element: Int) -> Bool in
			return 2 == element || 3 == element
		}
		
		XCTAssertEqual(ev2, s.expectedValueOf(16, elements: 2, 3), "Test failed.")
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testEntity() {
		graph.clear()
		
		let target: Entity = Entity(type: "T")
		
		for _ in 0..<99 {
			let _: Entity = Entity(type: "T")
		}
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		
		graph.asyncSave { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		let s: Array<Entity> = graph.searchForEntity(types: ["T"])
		XCTAssertEqual(0.01, s.probabilityOf(target), "Test failed.")
		
		graph.clear()
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
	func testAction() {
		graph.clear()
		
		let target: Action = Action(type: "T")
		
		for i in 0..<99 {
			let a: Action = Action(type: "T")
			if 0 == i % 2 {
				let n: Entity = Entity(type: "Book")
				n.addGroup("Physics")
				a.addObject(n)
			}
		}
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		
		graph.asyncSave { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		let s: Array<Action> = graph.searchForAction(types: ["T"])
		XCTAssertEqual(0.01, s.probabilityOf(target), "Test failed.")
		
		XCTAssertEqual(0.5, s.probabilityOf { (action: Action) in
			if let book: Entity = action.objects.first {
				if "Book" == book.type {
					return book.hasGroup("Physics")
				}
			}
			return false
		}, "Test failed.")
		
		graph.clear()
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
	func testRelationship() {
		graph.clear()
		
		let target: Relationship = Relationship(type: "T")
		
		for _ in 0..<99 {
			let _: Relationship = Relationship(type: "T")
		}
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		
		graph.asyncSave { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		let s: Array<Relationship> = graph.searchForRelationship(types: ["T"])
		XCTAssertEqual(0.01, s.probabilityOf(target), "Test failed.")
		
		graph.clear()
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}

	func testPerformance() {
		self.measureBlock() {}
	}
}
