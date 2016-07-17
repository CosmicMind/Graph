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

import XCTest
@testable import Graph

class EntitySearchTests : XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAll() {
        let graph = Graph()
        graph.clear()
        
        for i in 0..<100 {
            let n: Entity = Entity(type: "T1")
            n["P1"] = 0 == i % 2 ? "V1" : 1
            n["P2"] = "V2"
            n.add(tag: "G1")
            n.add(tag: "G2")
        }
        
        for _ in 0..<200 {
            let n: Entity = Entity(type: "T2")
            n["P2"] = "V2"
            n.add(tag: "G2")
        }
        
        for _ in 0..<300 {
            let n: Entity = Entity(type: "T3")
            n["P3"] = "V3"
            n.add(tag: "G3")
        }
        
        graph.sync { (success: Bool, error: NSError?) in
            XCTAssertTrue(success, "\(error)")
        }
        
        let users = graph.search(forEntity: ["User"], tags: [])
        print(users)
        
        XCTAssertEqual(0, graph.search(forEntity: []).count)
        
        XCTAssertEqual(100, graph.search(forEntity: ["T1"]).count)
        XCTAssertEqual(300, graph.search(forEntity: ["T1", "T2"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["T1", "T2", "T3"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["*"]).count)
        
        XCTAssertEqual(0, graph.search(forEntity: [], tags: ["NONE"]).count)
        XCTAssertEqual(100, graph.search(forEntity: [], tags: ["G1"]).count)
        XCTAssertEqual(300, graph.search(forEntity: [], tags: ["G1", "G2"]).count)
        XCTAssertEqual(600, graph.search(forEntity: [], tags: ["G1", "G2", "G3"]).count)
        XCTAssertEqual(600, graph.search(forEntity: [], tags: ["*"]).count)
        
        XCTAssertEqual(100, graph.search(forEntity: ["T1"], tags: ["G1"]).count)
        XCTAssertEqual(300, graph.search(forEntity: ["T1"], tags: ["G1", "G2"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["T1"], tags: ["G1", "G2", "G3"]).count)
        XCTAssertEqual(300, graph.search(forEntity: ["T1", "T2"], tags: ["G1"]).count)
        XCTAssertEqual(300, graph.search(forEntity: ["T1", "T2"], tags: ["G1", "G2"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["T1", "T2"], tags: ["G1", "G2", "G3"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["T1", "T2", "T3"], tags: ["G1"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["T1", "T2", "T3"], tags: ["G1", "G2"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["T1", "T2", "T3"], tags: ["G1", "G2", "G3"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["*"], tags: ["G1"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["*"], tags: ["G1", "G2"]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["*"], tags: ["G1", "G2", "G3"]).count)
        
        XCTAssertEqual(100, graph.search(forEntity:[], where: [("P1", nil)]).count)
        XCTAssertEqual(50, graph.search(forEntity:[], where: [("P1", "V1")]).count)
        XCTAssertEqual(50, graph.search(forEntity:[], where: [("P1", 1)]).count)
        XCTAssertEqual(50, graph.search(forEntity:[], where: [("*", "V1")]).count)
        XCTAssertEqual(50, graph.search(forEntity:[], where: [("*", 1)]).count)
        XCTAssertEqual(100, graph.search(forEntity:[], where: [("P1", "V1"), ("P1", 1)]).count)
        XCTAssertEqual(300, graph.search(forEntity:[], where: [("P1", nil), ("P2", "V2")]).count)
        XCTAssertEqual(600, graph.search(forEntity:[], where: [("P1", nil), ("P2", "V2"), ("P3", "V3")]).count)
        XCTAssertEqual(600, graph.search(forEntity:[], where: [("P1", nil), ("P2", nil), ("P3", nil)]).count)
        XCTAssertEqual(600, graph.search(forEntity:[], where: [("*", nil)]).count)
        
        XCTAssertEqual(300, graph.search(forEntity: ["T1"], where: [("P1", nil), ("P2", nil)]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["T1"], tags: ["G3"], where: [("P1", nil), ("P2", nil)]).count)
        XCTAssertEqual(600, graph.search(forEntity: ["*"], tags: ["*"], where: [("*", nil)]).count)
        
        graph.clear()
    }
}
