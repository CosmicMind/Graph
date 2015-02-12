# graphkit-ios
Native iOS Graph Framework

```swift
import XCTest
import GraphKit

class GraphKitTests: XCTestCase, GKGraphDelegate {

	let graph: GKGraph = GKGraph()
	
	var userInsertExpectation: XCTestExpectation?
	var bookInsertExpectation: XCTestExpectation?
	
	var userArchiveExpectation: XCTestExpectation?
	var bookArchiveExpectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
	}
    
	override func tearDown() {
		super.tearDown()
	}
    
	func testEntity() {
		// Set the test Class as the delegate.
		graph.delegate = self
		
		// Watch changes in the Graph.
		graph.watch(Entity: "User")
		graph.watch(Entity: "Book")
		
		// Some Exception testing.
		userInsertExpectation = expectationWithDescription("Insert Test: Watch 'User' did not pass.")
		bookInsertExpectation = expectationWithDescription("Insert Test: Watch 'Book' did not pass.")

		// Create a User Entity.
		var user: GKEntity = GKEntity(type: "User")
		user["name"] = "Eve"
		user["age"] = 26
		
		// Create a Book Entity.
		var book: GKEntity = GKEntity(type: "Book")
		book["title"] = "Learning GraphKit"
		
		//
		graph.save() {
			XCTAssertTrue($0, "Cannot save the Graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)
		
		user.archive()
		book.archive()
		
		userArchiveExpectation = expectationWithDescription("Archive Test: Watch 'User' did not pass.")
		bookArchiveExpectation = expectationWithDescription("Archive Test: Watch 'Book' did not pass.")
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the Graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)
	}
    
	func testPerformanceExample() {
        	self.measureBlock() {}
	}
	
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
		if "User" == entity.type && "Eve" == entity["name"]? as String && 26 == entity["age"]? as Int {
			userInsertExpectation?.fulfill()
		} else if "Book" == entity.type && "Learning GraphKit" == entity["title"]? as String {
			bookInsertExpectation?.fulfill()
		}
	}
	
	func graph(graph: GKGraph!, didArchiveEntity entity: GKEntity!) {
		if "User" == entity.type && "Eve" == entity["name"]? as String && 26 == entity["age"]? as Int {
			userArchiveExpectation?.fulfill()
		} else if "Book" == entity.type && "Learning GraphKit" == entity["title"]? as String {
			bookArchiveExpectation?.fulfill()
		}
	}
}
```

##License

[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)

##Contributors

[Daniel Dahan](https://github.com/danieldahan)

