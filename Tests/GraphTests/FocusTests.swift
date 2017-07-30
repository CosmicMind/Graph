//
//  FocusTests.swift
//  FocusTests
//
//  Created by Daniel Dahan on 2017-07-16.
//  Copyright © 2017 Daniel Dahan. All rights reserved.
//

import XCTest
@testable import Focus

class FocusTests: XCTestCase {
    var focusExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLocal() {
        let g1 = Focus()
        XCTAssertTrue(g1.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual(FocusStoreDescription.name, g1.name)
        XCTAssertEqual(FocusStoreDescription.type, g1.type)
        
        let g2 = Focus(name: "marketing")
        XCTAssertTrue(g2.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("marketing", g2.name)
        XCTAssertEqual(FocusStoreDescription.type, g2.type)
        
        focusExpectation = expectation(description: "[FocusTests Error: Async tests failed.]")
        
        var g3: Focus!
        DispatchQueue.global(qos: .background).async { [weak self] in
            g3 = Focus(name: "async")
            XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
            XCTAssertEqual("async", g3.name)
            XCTAssertEqual(FocusStoreDescription.type, g3.type)
            self?.focusExpectation?.fulfill()
        }
        
       waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("async", g3.name)
        XCTAssertEqual(FocusStoreDescription.type, g3.type)
    }
    
    func testCloud() {
        focusExpectation = expectation(description: "[CloudTests Error: Async tests failed.]")
        
        let g1 = Focus(cloud: "marketing") { [weak self] (supported: Bool, error: Error?) in
            XCTAssertTrue(supported)
            XCTAssertNil(error)
            self?.focusExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g1.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("marketing", g1.name)
        XCTAssertEqual(FocusStoreDescription.type, g1.type)
        
        focusExpectation = expectation(description: "[CloudTests Error: Async tests failed.]")
        
        let g2 = Focus(cloud: "async") { [weak self] (supported: Bool, error: Error?) in
            XCTAssertTrue(supported)
            XCTAssertNil(error)
            self?.focusExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g2.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("async", g2.name)
        XCTAssertEqual(FocusStoreDescription.type, g2.type)
        
        focusExpectation = expectation(description: "[CloudTests Error: Async tests failed.]")
        
        var g3: Focus!
        DispatchQueue.global(qos: .background).async { [weak self] in
            g3 = Focus(cloud: "test") { [weak self] (supported: Bool, error: Error?) in
                XCTAssertTrue(supported)
                XCTAssertNil(error)
                self?.focusExpectation?.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("test", g3.name)
        XCTAssertEqual(FocusStoreDescription.type, g3.type)
    }
}
