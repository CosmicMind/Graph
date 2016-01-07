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

class BondIntTests : XCTestCase, GraphDelegate {
	var graph: Graph!
	
	var saveExpectation: XCTestExpectation?
	var insertExpectation: XCTestExpectation?
	var insertPropertyExpectation: XCTestExpectation?
	var insertGroupExpectation: XCTestExpectation?
	var updatePropertyExpectation: XCTestExpectation?
	var deleteExpectation: XCTestExpectation?
	var deletePropertyExpectation: XCTestExpectation?
	var deleteGroupExpectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
		graph = Graph()
		graph.delegate = self
		graph.watchForBond(types: ["T"], groups: ["G"], properties: ["P"])
	}
	
	override func tearDown() {
		graph = nil
		super.tearDown()
	}
	
	func testAll() {
		let n: Bond = Bond(type: "T")
		n["P"] = 111
		n.addGroup("G")
		
		XCTAssertEqual(NodeClass.Bond, n.nodeClass)
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		insertExpectation = expectationWithDescription("Test: Insert did not pass.")
		insertPropertyExpectation = expectationWithDescription("Test: Insert property did not pass.")
		insertGroupExpectation = expectationWithDescription("Test: Insert group did not pass.")
		
		graph.save { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		n["P"] = 222
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		updatePropertyExpectation = expectationWithDescription("Test: Update did not pass.")
		
		graph.save { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
		
		n.delete()
		
		saveExpectation = expectationWithDescription("Test: Save did not pass.")
		deleteExpectation = expectationWithDescription("Test: Delete did not pass.")
		deletePropertyExpectation = expectationWithDescription("Test: Delete property did not pass.")
		deleteGroupExpectation = expectationWithDescription("Test: Delete group did not pass.")
		
		graph.save { [unowned self] (success: Bool, error: NSError?) in
			XCTAssertTrue(success, "Cannot save the Graph: \(error)")
			self.saveExpectation?.fulfill()
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
	func graphDidInsertBond(graph: Graph, bond: Bond) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue(bond["P"] as? Int == 111)
		XCTAssertTrue(bond.hasGroup("G"))
		insertExpectation?.fulfill()
	}
	
	func graphDidInsertBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("P" == property)
		XCTAssertTrue(111 == value as? Int)
		XCTAssertTrue(bond[property] as? Int == value as? Int)
		insertPropertyExpectation?.fulfill()
	}
	
	func graphDidInsertBondGroup(graph: Graph, bond: Bond, group: String) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("G" == group)
		insertGroupExpectation?.fulfill()
	}
	
	func graphDidUpdateBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("P" == property)
		XCTAssertTrue(222 == value as? Int)
		XCTAssertTrue(bond[property] as? Int == value as? Int)
		updatePropertyExpectation?.fulfill()
	}
	
	func graphDidDeleteBond(graph: Graph, bond: Bond) {
		XCTAssertTrue("T" == bond.type)
		deleteExpectation?.fulfill()
	}
	
	func graphDidDeleteBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("P" == property)
		XCTAssertTrue(222 == value as? Int)
		deletePropertyExpectation?.fulfill()
	}
	
	func graphDidDeleteBondGroup(graph: Graph, bond: Bond, group: String) {
		XCTAssertTrue("T" == bond.type)
		XCTAssertTrue("G" == group)
		deleteGroupExpectation?.fulfill()
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}

