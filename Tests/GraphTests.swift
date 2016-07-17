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
        XCTAssertEqual(GraphDefaults.name, g1.name)
        XCTAssertEqual(GraphDefaults.type, g1.type)
        XCTAssertEqual("\(GraphDefaults.location)Local/\(g1.name)/Graph.sqlite", String(g1.location))
        
        let g2 = Graph(name: "marketing")
        XCTAssertTrue(g2.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("marketing", g2.name)
        XCTAssertEqual(GraphDefaults.type, g2.type)
        XCTAssertEqual("\(GraphDefaults.location)Local/\(g2.name)/Graph.sqlite", String(g2.location))
        
        graphException = expectation(withDescription: "[GraphTests Error: Async tests failed.]")
        
        var g3: Graph!
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async { [weak self] in
            g3 = Graph(name: "async")
            XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
            XCTAssertEqual("async", g3.name)
            XCTAssertEqual(GraphDefaults.type, g3.type)
            XCTAssertEqual("\(GraphDefaults.location)Local/\(g3.name)/Graph.sqlite", String(g3.location))
            self?.graphException?.fulfill()
        }
        
       waitForExpectations(withTimeout: 5, handler: nil)
        
        XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("async", g3.name)
        XCTAssertEqual(GraphDefaults.type, g3.type)
        XCTAssertEqual("\(GraphDefaults.location)Local/\(g3.name)/Graph.sqlite", String(g3.location))
    }
    
    func testCloud() {
        graphException = expectation(withDescription: "[CloudTests Error: Async tests failed.]")
        
        let g1 = Graph(cloud: "marketing") { [weak self] (supported: Bool, error: NSError?) in
            XCTAssertFalse(supported)
            XCTAssertNotNil(error)
            self?.graphException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
        
        XCTAssertTrue(g1.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("marketing", g1.name)
        XCTAssertEqual(GraphDefaults.type, g1.type)
        XCTAssertEqual("\(GraphDefaults.location)Cloud/\(g1.name)/Graph.sqlite", String(g1.location))
        
        graphException = expectation(withDescription: "[CloudTests Error: Async tests failed.]")
        
        let g2 = Graph(cloud: "async") { [weak self] (supported: Bool, error: NSError?) in
            XCTAssertFalse(supported)
            XCTAssertNotNil(error)
            self?.graphException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
        
        XCTAssertTrue(g2.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("async", g2.name)
        XCTAssertEqual(GraphDefaults.type, g2.type)
        XCTAssertEqual("\(GraphDefaults.location)Cloud/\(g2.name)/Graph.sqlite", String(g2.location))
        
        graphException = expectation(withDescription: "[CloudTests Error: Async tests failed.]")
        
        var g3: Graph!
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async { [weak self] in
            g3 = Graph(cloud: "test") { [weak self] (supported: Bool, error: NSError?) in
                XCTAssertFalse(supported)
                XCTAssertNotNil(error)
                self?.graphException?.fulfill()
            }
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
        
        XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("test", g3.name)
        XCTAssertEqual(GraphDefaults.type, g3.type)
        XCTAssertEqual("\(GraphDefaults.location)Cloud/\(g3.name)/Graph.sqlite", String(g3.location))
    }
}
