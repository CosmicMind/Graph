/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
