import XCTest
import GraphKit

class GraphKitTests: XCTestCase, GKGraphDelegate {
	
	lazy var graph: GKGraph = GKGraph()
	
	var entityExpectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testEntity() {
		graph.delegate = self
		graph.watch(Entity: "User")
		entityExpectation = expectationWithDescription("User Entity inserted. Delegate method was not called!")
		
		var entity: GKEntity = GKEntity(type: "User")
		
		let saveExpectation: XCTestExpectation = expectationWithDescription("Failed to save the graph!")
		graph.save() {
			XCTAssertTrue($0, "Cannot save the graph: \($1)")
			saveExpectation.fulfill()
		}
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testPerformanceExample() {
		self.measureBlock() {}
	}
	
	// insertion delegate test
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
		if "User" == entity.type {
			entityExpectation?.fulfill()
		}
	}
}
