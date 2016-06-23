/*
 * Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>.
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

class EntityTests: XCTestCase, GraphDelegate {
    var saveException: XCTestExpectation?
    var delegateException: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSave() {
//        let g1 = Graph()
//        g1.watchForEntity(types: ["T"])
//        g1.delegate = self
//        
//        let e1 = Entity("T")
//        e1["p"] = "v"
//        e1.addToGroup("g")
//        
//        XCTAssertTrue("v" == e1["p"] as? String)
//        
//        saveException = expectationWithDescription("[EntityTests Error: Save Etity test failed.]")
//        delegateException = expectationWithDescription("[EntityTests Error: Delegate Etity test failed.]")
//        
//        g1.save { [weak self] (success: Bool, error: NSError?) in
//            self?.saveException?.fulfill()
//            XCTAssertTrue(success)
//        }
//        
//        waitForExpectationsWithTimeout(5, handler: nil)
        
        let g2 = Graph("g2")
        g2.watchForEntity(types: ["T"])
        g2.delegate = self
        
        let e2 = Entity("T", graph: "g2")
        e2["p"] = "v"
        e2.addToGroup("g")
        
        XCTAssertTrue("v" == e2["p"] as? String)
        
        saveException = expectationWithDescription("[EntityTests Error: Save Etity test failed.]")
        delegateException = expectationWithDescription("[EntityTests Error: Delegate Etity test failed.]")
        
        g2.save { [weak self] (success: Bool, error: NSError?) in
            self?.saveException?.fulfill()
            XCTAssertTrue(success)
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
//        let g3 = Graph("g3")
//        g3.watchForEntity(types: ["T"])
//        g3.delegate = self
//        
//        let e3 = Entity("T", graph: g3)
//        e3["p"] = "v"
//        e3.addToGroup("g3")
//    
//        XCTAssertTrue("v" == e3["p"] as? String)
//        
//        saveException = expectationWithDescription("[EntityTests Error: Save Etity test failed.]")
//        delegateException = expectationWithDescription("[EntityTests Error: Delegate Etity test failed.]")
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
//            g3.save { [weak self] (success: Bool, error: NSError?) in
//                self?.saveException?.fulfill()
//                XCTAssertTrue(success)
//            }
//        }
//        
//        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func graphDidInsertEntity(graph: Graph, entity: Entity) {
//        print(graph.searchForEntity(types: ["T"]))
        delegateException?.fulfill()
    }
}