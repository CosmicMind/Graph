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
 *	*	Neither the name of CosmicMind nor the names of its
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

import CoreData
import XCTest
@testable import Graph

class CloudTests : XCTestCase {
    var cloudException: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testContext() {
        cloudException = expectation(withDescription: "[CloudTests Error: Async tests failed.]")
        
        let g1 = Graph(cloud: "marketing") { [weak self] (supported: Bool, error: NSError?) in
            XCTAssertFalse(supported)
            XCTAssertNotNil(error)
            self?.cloudException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
        
        XCTAssertTrue(g1.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("marketing", g1.name)
        XCTAssertEqual(GraphDefaults.type, g1.type)
        XCTAssertEqual("\(GraphDefaults.location)Cloud/\(g1.name)/Graph.sqlite", String(g1.location))
        
        cloudException = expectation(withDescription: "[CloudTests Error: Async tests failed.]")
        
        let g2 = Graph(cloud: "async") { [weak self] (supported: Bool, error: NSError?) in
            XCTAssertFalse(supported)
            XCTAssertNotNil(error)
            self?.cloudException?.fulfill()
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)

        XCTAssertTrue(g2.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("async", g2.name)
        XCTAssertEqual(GraphDefaults.type, g2.type)
        XCTAssertEqual("\(GraphDefaults.location)Cloud/\(g2.name)/Graph.sqlite", String(g2.location))

        cloudException = expectation(withDescription: "[CloudTests Error: Async tests failed.]")
        
        var g3: Graph!
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async { [weak self] in
            g3 = Graph(cloud: "test") { [weak self] (supported: Bool, error: NSError?) in
                XCTAssertFalse(supported)
                XCTAssertNotNil(error)
                self?.cloudException?.fulfill()
            }
        }
        
        waitForExpectations(withTimeout: 5, handler: nil)
        
        XCTAssertTrue(g3.managedObjectContext.isKind(of: NSManagedObjectContext.self))
        XCTAssertEqual("test", g3.name)
        XCTAssertEqual(GraphDefaults.type, g3.type)
        XCTAssertEqual("\(GraphDefaults.location)Cloud/\(g3.name)/Graph.sqlite", String(g3.location))
    }
}
