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
    
    func testAll() {
        let graph = Graph()
        graph.clear()
        
        for i in 0..<100 {
            let n = Relationship(type: "T1")
            n["P1"] = 0 == i % 2 ? "V1" : 1
            n["P2"] = "V2"
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
        
        XCTAssertEqual(0, search.clear().for(types: []).sync().count)
        XCTAssertEqual(0, search.clear().has(tags: []).sync().count)
        XCTAssertEqual(0, search.clear().member(of: []).sync().count)
        XCTAssertEqual(0, search.clear().where(properties: []).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: []).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: []).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: []).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: []).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: []).async { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: []).async { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: []).async { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: []).async { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(100, search.clear().for(types: ["T1"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).sync { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).async { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(300, search.clear().for(types: "T1", "T2").sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").sync { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").async { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().for(types: ["T1", "T2", "T3"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1", "T2", "T3"]).sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1", "T2", "T3"]).async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().for(types: ["*"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["*"]).sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["*"]).async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(0, search.clear().has(tags: ["NONE"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["NONE"]).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["NONE"]).async { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(100, search.clear().has(tags: ["Q1"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["Q1"]).sync { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["Q1"]).async { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(300, search.clear().has(tags: ["Q1", "Q2"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["Q1", "Q2"]).sync { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["Q1", "Q2"]).async { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().has(tags: ["Q1", "Q2", "Q3"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["Q1", "Q2", "Q3"]).sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["Q1", "Q2", "Q3"]).async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().has(tags: ["*"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["*"]).sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().has(tags: ["*"]).async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(100, search.clear().for(types: ["T1"]).has(tags: ["Q1"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).has(tags: ["Q1"]).sync { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).has(tags: ["Q1"]).async { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(300, search.clear().for(types: ["T1"]).has(tags: ["Q1", "Q2"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).has(tags: ["Q1", "Q2"]).sync { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).has(tags: ["Q1", "Q2"]).async { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().for(types: ["T1"]).has(tags: ["Q1", "Q2", "Q3"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).has(tags: ["Q1", "Q2", "Q3"]).sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).has(tags: ["Q1", "Q2", "Q3"]).async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(300, search.clear().for(types: "T1", "T2").has(tags: ["Q1"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").has(tags: ["Q1"]).sync { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").has(tags: ["Q1"]).async { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(300, search.clear().for(types: "T1", "T2").has(tags: ["Q1", "Q2"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").has(tags: ["Q1", "Q2"]).sync { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").has(tags: ["Q1", "Q2"]).async { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().for(types: ["T1", "T2", "T3"]).has(tags: ["Q1", "Q2", "Q3"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1", "T2", "T3"]).has(tags: ["Q1", "Q2", "Q3"]).sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1", "T2", "T3"]).has(tags: ["Q1", "Q2", "Q3"]).async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().for(types: ["*"]).has(tags: ["Q1", "Q2", "Q3"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["*"]).has(tags: ["Q1", "Q2", "Q3"]).sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["*"]).has(tags: ["Q1", "Q2", "Q3"]).async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(0, search.clear().member(of: ["NONE"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: ["NONE"]).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: ["NONE"]).async { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(100, search.clear().member(of: ["G1"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: ["G1"]).sync { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: ["G1"]).async { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(300, search.clear().member(of: ["G1", "G2"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: ["G1", "G2"]).sync { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: ["G1", "G2"]).async { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().member(of: "G1", "G2", "G3").sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: "G1", "G2", "G3").sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: "G1", "G2", "G3").async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().member(of: ["*"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: ["*"]).sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().member(of: ["*"]).async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(100, search.clear().for(types: ["T1"]).member(of: ["G1"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).member(of: ["G1"]).sync { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).member(of: ["G1"]).async { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(300, search.clear().for(types: ["T1"]).member(of: ["G1", "G2"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).member(of: ["G1", "G2"]).sync { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).member(of: ["G1", "G2"]).async { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().for(types: ["T1"]).member(of: "G1", "G2", "G3").sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).member(of: "G1", "G2", "G3").sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1"]).member(of: "G1", "G2", "G3").async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(300, search.clear().for(types: "T1", "T2").member(of: ["G1"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").member(of: ["G1"]).sync { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").member(of: ["G1"]).async { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(300, search.clear().for(types: "T1", "T2").member(of: ["G1", "G2"]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").member(of: ["G1", "G2"]).sync { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: "T1", "T2").member(of: ["G1", "G2"]).async { [weak self] (nodes) in
            XCTAssertEqual(300, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().for(types: ["T1", "T2", "T3"]).member(of: "G1", "G2", "G3").sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1", "T2", "T3"]).member(of: "G1", "G2", "G3").sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["T1", "T2", "T3"]).member(of: "G1", "G2", "G3").async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(600, search.clear().for(types: ["*"]).member(of: "G1", "G2", "G3").sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["*"]).member(of: "G1", "G2", "G3").sync { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().for(types: ["*"]).member(of: "G1", "G2", "G3").async { [weak self] (nodes) in
            XCTAssertEqual(600, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(0, search.clear().where(properties: ["NONE": nil]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: ["NONE": nil]).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: ["NONE": nil]).async { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(100, search.clear().where(properties: ["P1": nil]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: ["P1": nil]).sync { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: ["P1": nil]).async { [weak self] (nodes) in
            XCTAssertEqual(100, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(50, search.clear().where(properties: ["P1": 1]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: ["P1": 1]).sync { [weak self] (nodes) in
            XCTAssertEqual(50, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: ["P1": 1]).async { [weak self] (nodes) in
            XCTAssertEqual(50, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(50, search.clear().where(properties: [("P1", 1), ("P1", 2)]).sync().count)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: [("P1", 1), ("P1", 2)]).sync { [weak self] (nodes) in
            XCTAssertEqual(50, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        testExpectation = expectation(description: "[RelationshipSearchTests Error: Test failed.]")
        
        search.clear().where(properties: [("P1", 1), ("P1", 2)]).async { [weak self] (nodes) in
            XCTAssertEqual(50, nodes.count)
            self?.testExpectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        graph.clear()
    }
    
    func testPerformance() {
        let graph = Graph()
        graph.clear()
        
        for i in 0..<1000 {
            let n = Relationship(type: "T1")
            n["P1"] = 0 == i % 2 ? "V1" : 1
            n["P2"] = "V2"
            n.add(tag: "Q1")
            n.add(to: "G1")
        }
        
        graph.sync { (success, error) in
            XCTAssertTrue(success, "\(error)")
        }
        
        let search = Search<Relationship>(graph: graph)
        
        measure { [search = search] in
            XCTAssertEqual(1000, search.clear().for(types: "T1").has(tags: "Q1").member(of: "G1").where(properties: ["P1": nil, "P2": nil]).sync().count)
        }
        
        graph.clear()
    }
}
