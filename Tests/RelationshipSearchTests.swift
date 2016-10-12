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

class RelationshipSearchTests : XCTestCase {
    var testExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func searchTest(search: Search<Relationship>, count: Int) {
        XCTAssertEqual(count, search.sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.sync { [weak self, count = count] (nodes) in
            XCTAssertEqual(count, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.async { [weak self, count = count] (nodes) in
            XCTAssertEqual(count, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAll() {
        let graph = Graph()
        graph.clear()
        
        for _ in 0..<100 {
            let n = Relationship(type: "T1")
            n["P1"] = "V2"
            n.add(tag: "Q1")
            n.add(to: "G1")
        }
        
        for _ in 0..<200 {
            let n = Relationship(type: "T2")
            n["P2"] = "V2"
            n.add(tag: "Q2")
            n.add(to: "G2")
        }
        
        for _ in 0..<300 {
            let n = Relationship(type: "T3")
            n["P3"] = "V3"
            n.add(tag: "Q3")
            n.add(to: "G3")
        }
        
        graph.sync { (success, error) in
            XCTAssertTrue(success, "\(error)")
        }
        
        let search = Search<Relationship>(graph: graph)
        
        searchTest(search: search.clear().for(types: []), count: 0)
        
        searchTest(search: search.clear().has(tags: [], with: .or), count: 0)
        searchTest(search: search.clear().has(tags: [], with: .and), count: 0)
        
        searchTest(search: search.clear().member(of: [], with: .or), count: 0)
        searchTest(search: search.clear().member(of: [], with: .and), count: 0)
        
        searchTest(search: search.clear().where(properties: [], with: .or), count: 0)
        searchTest(search: search.clear().where(properties: [], with: .and), count: 0)
        
        searchTest(search: search.clear().for(types: "NONE"), count: 0)
        searchTest(search: search.clear().for(types: "T1"), count: 100)
        searchTest(search: search.clear().for(types: "T1", "T2"), count: 300)
        searchTest(search: search.clear().for(types: "T1", "T2", "T3"), count: 600)
        searchTest(search: search.clear().for(types: "*"), count: 600)
        
        searchTest(search: search.clear().has(tags: ["NONE"], with: .or), count: 0)
        searchTest(search: search.clear().has(tags: ["NONE"], with: .and), count: 0)
        searchTest(search: search.clear().has(tags: ["Q1"], with: .or), count: 100)
        searchTest(search: search.clear().has(tags: ["Q1"], with: .and), count: 100)
        searchTest(search: search.clear().has(tags: ["Q1", "Q2"], with: .or), count: 300)
        searchTest(search: search.clear().has(tags: ["Q1", "Q2"], with: .and), count: 0)
        searchTest(search: search.clear().has(tags: ["Q1", "Q2", "Q3"], with: .or), count: 600)
        searchTest(search: search.clear().has(tags: ["Q1", "Q3", "Q3"], with: .and), count: 0)
        searchTest(search: search.clear().has(tags: ["*"], with: .or), count: 600)
        searchTest(search: search.clear().has(tags: ["*"], with: .and), count: 0)
        
        searchTest(search: search.clear().member(of: ["NONE"], with: .or), count: 0)
        searchTest(search: search.clear().member(of: ["NONE"], with: .and), count: 0)
        searchTest(search: search.clear().member(of: ["G1"], with: .or), count: 100)
        searchTest(search: search.clear().member(of: ["G1"], with: .and), count: 100)
        searchTest(search: search.clear().member(of: ["G1", "G2"], with: .or), count: 300)
        searchTest(search: search.clear().member(of: ["G1", "G2"], with: .and), count: 0)
        searchTest(search: search.clear().member(of: ["G1", "G2", "G3"], with: .or), count: 600)
        searchTest(search: search.clear().member(of: ["G1", "G3", "G3"], with: .and), count: 0)
        searchTest(search: search.clear().member(of: ["*"], with: .or), count: 600)
        searchTest(search: search.clear().member(of: ["*"], with: .and), count: 0)
        
        searchTest(search: search.clear().where(properties: ["NONE"], with: .or), count: 0)
        searchTest(search: search.clear().where(properties: ["NONE"], with: .and), count: 0)
        searchTest(search: search.clear().where(properties: ["P1"], with: .or), count: 100)
        searchTest(search: search.clear().where(properties: ["P1"], with: .and), count: 100)
        searchTest(search: search.clear().where(properties: ["P1", "P2"], with: .or), count: 300)
        searchTest(search: search.clear().where(properties: ["P1", "P2"], with: .and), count: 0)
        searchTest(search: search.clear().where(properties: ["P1", "P2", "P3"], with: .or), count: 600)
        searchTest(search: search.clear().where(properties: ["P1", "P3", "P3"], with: .and), count: 0)
        searchTest(search: search.clear().where(properties: ["*"], with: .or), count: 600)
        searchTest(search: search.clear().where(properties: ["*"], with: .and), count: 0)
        
        graph.clear()
    }
    
    func testPerformance() {
        let graph = Graph()
        graph.clear()
        
        for _ in 0..<1000 {
            let n1 = Relationship(type: "T1")
            n1["P1"] = 1
            n1.add(tag: "Q1")
            n1.add(to: "G1")
        }
        
        graph.sync { (success, error) in
            XCTAssertTrue(success, "\(error)")
        }
        
        let search = Search<Relationship>(graph: graph)
        
        //        measure { [search = search] in
        //            XCTAssertEqual(1000, search.clear().for(types: "T1").has(tags: "Q1").member(of: "G1").where(properties: ["P1": 1]).sync().count)
        //        }
        
        graph.clear()
    }
}
