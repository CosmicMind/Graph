/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *    * Redistributions of source code must retain the above copyright notice, this
 *      list of conditions and the following disclaimer.
 *
 *    * Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 *
 *    * Neither the name of CosmicMind nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
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
@testable import Graph

class GraphTests: XCTestCase {
    var graphExpectation: XCTestExpectation?
    
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
        
        graphExpectation = expectation(description: "[GraphTests Error: Async tests failed.]")
        
        var g3: Graph!
        DispatchQueue.global(qos: .background).async { [weak self] in
            g3 = Graph(name: "async")
            XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
            XCTAssertEqual("async", g3.name)
            XCTAssertEqual(GraphStoreDescription.type, g3.type)
            self?.graphExpectation?.fulfill()
        }
        
       waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("async", g3.name)
        XCTAssertEqual(GraphStoreDescription.type, g3.type)
    }
    
    func testCloud() {
        graphExpectation = expectation(description: "[CloudTests Error: Async tests failed.]")
        
        let g1 = Graph(cloud: "marketing") { [weak self] (supported: Bool, error: Error?) in
            XCTAssertTrue(supported)
            XCTAssertNil(error)
            self?.graphExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g1.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("marketing", g1.name)
        XCTAssertEqual(GraphStoreDescription.type, g1.type)
        
        graphExpectation = expectation(description: "[CloudTests Error: Async tests failed.]")
        
        let g2 = Graph(cloud: "async") { [weak self] (supported: Bool, error: Error?) in
            XCTAssertTrue(supported)
            XCTAssertNil(error)
            self?.graphExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g2.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("async", g2.name)
        XCTAssertEqual(GraphStoreDescription.type, g2.type)
        
        graphExpectation = expectation(description: "[CloudTests Error: Async tests failed.]")
        
        var g3: Graph!
        DispatchQueue.global(qos: .background).async { [weak self] in
            g3 = Graph(cloud: "test") { [weak self] (supported: Bool, error: Error?) in
                XCTAssertTrue(supported)
                XCTAssertNil(error)
                self?.graphExpectation?.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("test", g3.name)
        XCTAssertEqual(GraphStoreDescription.type, g3.type)
    }
}
