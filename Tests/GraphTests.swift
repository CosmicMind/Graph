//
//  GraphTests.swift
//  GraphTests
//
//  Created by Daniel Dahan on 2016-07-16.
//  Copyright © 2016 Daniel Dahan. All rights reserved.
//

import XCTest
@testable import Graph

class GraphTests: XCTestCase {
    var graphException: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLocal() {
        let g1 = Graph()
        XCTAssertTrue(g1.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual(GraphStoreDescription.name, g1.name)
        XCTAssertEqual(GraphStoreDescription.type, g1.type)
        
        let g2 = Graph(name: "marketing")
        XCTAssertTrue(g2.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("marketing", g2.name)
        XCTAssertEqual(GraphStoreDescription.type, g2.type)
        
        graphException = expectation(description: "[GraphTests Error: Async tests failed.]")
        
        var g3: Graph!
        DispatchQueue.global(qos: .default).async { [weak self] in
            g3 = Graph(name: "async")
            XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
            XCTAssertEqual("async", g3.name)
            XCTAssertEqual(GraphStoreDescription.type, g3.type)
            self?.graphException?.fulfill()
        }
        
       waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("async", g3.name)
        XCTAssertEqual(GraphStoreDescription.type, g3.type)
    }
    
    func testCloud() {
        graphException = expectation(description: "[CloudTests Error: Async tests failed.]")
        
        let g1 = Graph(cloud: "marketing") { [weak self] (supported: Bool, error: Error?) in
            XCTAssertTrue(supported)
            XCTAssertNil(error)
            self?.graphException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g1.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("marketing", g1.name)
        XCTAssertEqual(GraphStoreDescription.type, g1.type)
        
        graphException = expectation(description: "[CloudTests Error: Async tests failed.]")
        
        let g2 = Graph(cloud: "async") { [weak self] (supported: Bool, error: Error?) in
            XCTAssertTrue(supported)
            XCTAssertNil(error)
            self?.graphException?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g2.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("async", g2.name)
        XCTAssertEqual(GraphStoreDescription.type, g2.type)
        
        graphException = expectation(description: "[CloudTests Error: Async tests failed.]")
        
        var g3: Graph!
        DispatchQueue.global(qos: .default).async { [weak self] in
            g3 = Graph(cloud: "test") { [weak self] (supported: Bool, error: Error?) in
                XCTAssertTrue(supported)
                XCTAssertNil(error)
                self?.graphException?.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("test", g3.name)
        XCTAssertEqual(GraphStoreDescription.type, g3.type)
    }
}
