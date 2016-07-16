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
    var containerExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        containerExpectation = expectation(withDescription: "[GraphTests Error: Container tests failed.]")
        
        let graph = Graph()
        graph.clear()
        
        let e1 = Entity(type: "User")
        e1["name"] = "Joe"
        e1.add("Human")
        if e1.tagged("Human") {
            e1.remove("Human")
        }
        
        let e2 = Entity(type: "Book")
        e2["name"] = "Hologram"
        e2.add("Physics")
        
        graph.async()
        
        print(graph.search(forEntity: ["Book"], tagged: ["Physics2"]))
//        print(graph.search(forEntity: ["*"]))
        containerExpectation?.fulfill()
        waitForExpectations(withTimeout: 5, handler: nil)
    }
}
