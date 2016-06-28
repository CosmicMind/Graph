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
    var asyncException: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testContext() {
        let c1 = Cloud()
        XCTAssertTrue(c1.managedObjectContext.isKindOfClass(NSManagedObjectContext))
        XCTAssertEqual(Storage.name, c1.name)
        XCTAssertEqual(Storage.type, c1.type)
        XCTAssertEqual(Storage.location, c1.location)
        
        let c2 = Cloud(name: "marketing")
        XCTAssertTrue(c2.managedObjectContext.isKindOfClass(NSManagedObjectContext))
        XCTAssertEqual("marketing", c2.name)
        XCTAssertEqual(Storage.type, c2.type)
        XCTAssertEqual(Storage.location, c2.location)
        
        asyncException = expectationWithDescription("[CloudTests Error: Async tests failed.]")
        
        var c3: Cloud!
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            c3 = Cloud(name: "async")
            XCTAssertTrue(c3.managedObjectContext.isKindOfClass(NSManagedObjectContext))
            XCTAssertEqual("async", c3.name)
            XCTAssertEqual(Storage.type, c3.type)
            XCTAssertEqual(Storage.location, c3.location)
            self?.asyncException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        XCTAssertTrue(c3.managedObjectContext.isKindOfClass(NSManagedObjectContext))
        XCTAssertEqual("async", c3.name)
        XCTAssertEqual(Storage.type, c3.type)
        XCTAssertEqual(Storage.location, c3.location)
    }
}