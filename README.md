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
		graph.delegate = self
		graph.watch(Entity: "User")
		graph.watch(Entity: "Book")
		
		userInsertExpectation = expectationWithDescription("User Entity inserted. Delegate method was not called!")
		bookInsertExpectation = expectationWithDescription("Book Entity inserted. Delegate method was not called!")

		var user: GKEntity = GKEntity(type: "User")
		var book: GKEntity = GKEntity(type: "Book")
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)
		
		user.archive()
		book.archive()
		
		userArchiveExpectation = expectationWithDescription("User Entity archived. Delegate method was not called!")
		bookArchiveExpectation = expectationWithDescription("Book Entity archived. Delegate method was not called!")
		
		graph.save() {
			XCTAssertTrue($0, "Cannot save the graph: \($1)")
		}
		waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testPerformanceExample() {
        self.measureBlock() {}
    }
	
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
		if "User" == entity.type {
			userInsertExpectation?.fulfill()
		} else if "Book" == entity.type {
			bookInsertExpectation?.fulfill()
		}
	}
	
	func graph(graph: GKGraph!, didArchiveEntity entity: GKEntity!) {
		if "User" == entity.type {
			userArchiveExpectation?.fulfill()
		} else if "Book" == entity.type {
			bookArchiveExpectation?.fulfill()
		}
	}
}
```

##License

[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)

##Contributors

[Daniel Dahan](https://github.com/danieldahan)

