/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  * Neither the name of CosmicMind nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
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

class ApiTests: XCTestCase {
  
  func testCompoundString() {
    let t1String = "VALUE == \"T1\""
    let t2String = "VALUE == \"T2\""
    
    assertCompoundString("T1", t1String)
    assertCompoundString(!"T1", "NOT \(t1String)")
    assertCompoundString("T1" || "T2", "\(t1String) OR \(t2String)")
    assertCompoundString("T1" && "T2", "\(t1String) AND \(t2String)")
    assertCompoundString(!"T1" && !"T2", "(NOT \(t1String)) AND (NOT \(t2String))")
    
    assertCompoundString(!"T1" && !("T2" || "T3") && "T4", "(NOT \(t1String)) AND (NOT (\(t2String) OR VALUE == \"T3\")) AND VALUE == \"T4\"")
  }
  
  func testTypePredicate() {
    assertPredicate(.type("User"), "type LIKE[cd] \"User\"")
    assertPredicate(.type("T1", "T2"), "type LIKE[cd] \"T1\" OR type LIKE[cd] \"T2\"")
    assertPredicate(.type("T1", "T2", using: ||), "type LIKE[cd] \"T1\" OR type LIKE[cd] \"T2\"")
    assertPredicate(.type("T1", "T2", using: &&), "type LIKE[cd] \"T1\" AND type LIKE[cd] \"T2\"")
    
    /// Making sure it accepts CompoundString
    let t: CompoundString = "T1" || "T2"
    assertPredicate(.type(t), "type LIKE[cd] \"T1\" OR type LIKE[cd] \"T2\"")
    assertPredicate(.type("T1" || "T2"), "type LIKE[cd] \"T1\" OR type LIKE[cd] \"T2\"")
  }
  
  func testHasTagsPredicate() {
    assertPredicate(.has(tags: "User"), "ANY tagSet.name LIKE[cd] \"User\"")
    assertPredicate(.has(tags: "T1", "T2"), "ANY tagSet.name LIKE[cd] \"T1\" OR ANY tagSet.name LIKE[cd] \"T2\"")
    assertPredicate(.has(tags: "T1", "T2", using: ||), "ANY tagSet.name LIKE[cd] \"T1\" OR ANY tagSet.name LIKE[cd] \"T2\"")
    assertPredicate(.has(tags: "T1", "T2", using: &&), "ANY tagSet.name LIKE[cd] \"T1\" AND ANY tagSet.name LIKE[cd] \"T2\"")
    /// Making sure it accepts CompoundString
    let t: CompoundString = "T1" || "T2"
    assertPredicate(.has(tags: t), "ANY tagSet.name LIKE[cd] \"T1\" OR ANY tagSet.name LIKE[cd] \"T2\"")
    assertPredicate(.has(tags: "T1" || "T2"), "ANY tagSet.name LIKE[cd] \"T1\" OR ANY tagSet.name LIKE[cd] \"T2\"")
  }
  
  func testMemberOfPredicate() {
    assertPredicate(.member(of: "User"), "ANY groupSet.name LIKE[cd] \"User\"")
    assertPredicate(.member(of: "T1", "T2"), "ANY groupSet.name LIKE[cd] \"T1\" OR ANY groupSet.name LIKE[cd] \"T2\"")
    assertPredicate(.member(of: "T1", "T2", using: ||), "ANY groupSet.name LIKE[cd] \"T1\" OR ANY groupSet.name LIKE[cd] \"T2\"")
    assertPredicate(.member(of: "T1", "T2", using: &&), "ANY groupSet.name LIKE[cd] \"T1\" AND ANY groupSet.name LIKE[cd] \"T2\"")
    
    /// Making sure it accepts CompoundString
    let t: CompoundString = "T1" || "T2"
    assertPredicate(.member(of: t), "ANY groupSet.name LIKE[cd] \"T1\" OR ANY groupSet.name LIKE[cd] \"T2\"")
    assertPredicate(.member(of: "T1" || "T2"), "ANY groupSet.name LIKE[cd] \"T1\" OR ANY groupSet.name LIKE[cd] \"T2\"")
  }
  
  func testExistsPredicate() {
    assertPredicate(.exists("User"), "ANY propertySet.name LIKE[cd] \"User\"")
    assertPredicate(.exists("T1", "T2"), "ANY propertySet.name LIKE[cd] \"T1\" OR ANY propertySet.name LIKE[cd] \"T2\"")
    assertPredicate(.exists("T1", "T2", using: ||), "ANY propertySet.name LIKE[cd] \"T1\" OR ANY propertySet.name LIKE[cd] \"T2\"")
    assertPredicate(.exists("T1", "T2", using: &&), "ANY propertySet.name LIKE[cd] \"T1\" AND ANY propertySet.name LIKE[cd] \"T2\"")
    
    /// Making sure it accepts CompoundString
    let t: CompoundString = "T1" || "T2"
    assertPredicate(.exists(t), "ANY propertySet.name LIKE[cd] \"T1\" OR ANY propertySet.name LIKE[cd] \"T2\"")
    assertPredicate(.exists("T1" || "T2"), "ANY propertySet.name LIKE[cd] \"T1\" OR ANY propertySet.name LIKE[cd] \"T2\"")
  }
  
  func testPropertyPredicates() {
    /// String
    assertPredicate("key" == "value", property("key", value: "value"))
    assertPredicate("key" != "value", property("key", value: "value", "!="))
    
    /// Boolean
    assertPredicate("key" == true, property("key", value: true))
    assertPredicate("key" != false, property("key", value: false, "!="))
    
    /// Integer
    assertPredicate("key" == 123, property("key", value: 123))
    assertPredicate("key" != 123, property("key", value: 123, "!="))
    assertPredicate("key" > 123, property("key", value: 123, ">"))
    assertPredicate("key" < 123, property("key", value: 123, "<"))
    assertPredicate("key" >= 123, property("key", value: 123, ">="))
    assertPredicate("key" <= 123, property("key", value: 123, "<="))
    
    /// Double
    assertPredicate("key" == 123.4, property("key", value: 123.4))
    assertPredicate("key" != 123.4, property("key", value: 123.4, "!="))
    assertPredicate("key" > 123.4, property("key", value: 123.4, ">"))
    assertPredicate("key" < 123.4, property("key", value: 123.4, "<"))
    assertPredicate("key" >= 123.4, property("key", value: 123.4, ">="))
    assertPredicate("key" <= 123.4, property("key", value: 123.4, "<="))
  }
  
  func testPredicateComposition() {
    let p1: Predicate = .exists("T1")
    let p2: Predicate = .has(tags: "T2")
    let p1String = "ANY propertySet.name LIKE[cd] \"T1\""
    let p2String = "ANY tagSet.name LIKE[cd] \"T2\""
    
    assertPredicate(!p1, "NOT (\(p1String))")
    assertPredicate(p1 && p2, "(\(p1String)) AND (\(p2String))")
    assertPredicate(p1 || p2, "(\(p1String)) OR (\(p2String))")
    assertPredicate(!p1 && !p2, "(NOT (\(p1String))) AND (NOT (\(p2String)))")
    
    assertPredicate(!p1 && !(p2 || .member(of: "T3")) && "key" == "value", "((NOT (ANY propertySet.name LIKE[cd] \"T1\")) AND (NOT ((ANY tagSet.name LIKE[cd] \"T2\") OR (ANY groupSet.name LIKE[cd] \"T3\")))) AND (SUBQUERY(propertySet, $property, $property.name LIKE[cd] \"key\" AND $property.object LIKE[cd] \"value\").@count > 0)")
  }
  
  func testApi() {
    let g = Graph()
    g.clear()
    let u1 = Entity("User")
    let u2 = Entity("User")
    let u3 = Entity("User")
    
    u1.firstName = "Daniel"
    u1.lastName = "Dahan"
    u1.age = 34
    
    u2.firstName = "Orkhan"
    u2.lastName = "Alikhanov"
    u2.age = 20
    u2.hasBoolean = true
    
    u3.firstName = "Adam"
    u3.lastName = "Dahan"
    u3.age = 28
    u3.hasBoolean = false
    
    g.sync()
    
    assertSearch(.type("User"), 3)
    assertSearch(.type("T"), 0)
    
    assertSearch(.type("User") && "firstName" == "Daniel" && "age" == 20, 0)
    assertSearch(.type("User") && "lastName" == "Dahan", 2)
    assertSearch(.type("User") && "lastName" != "Dahan", 1)
    assertSearch(.type("User") && "lastName" == "*han", 2)
    assertSearch(.type("User") && "lastName" != "*han", 1)
    
    assertSearch("age" != 20, 2)
    assertSearch(!("age" == 20), 2)
    assertSearch(.type("User") && !(!("age" != 20)), 2)
    
    assertSearch(.type("User") && "age" <= 20, 1)
    assertSearch(.type("User") && "age" < 20, 0)
    
    assertSearch(.type("User") && "age" >= 20, 3)
    assertSearch(.type("User") && "age" > 20, 2)
    
    assertSearch(.type("User") && "age" >= 34, 1)
    assertSearch(.type("User") && "age" > 34, 0)
    
    assertSearch(.exists("hasBoolean"), 2)
    assertSearch(!.exists("hasBoolean"), 1)
    assertSearch("hasBoolean" == true, 1)
    assertSearch("hasBoolean" == false, 1)
    assertSearch("hasBoolean" != true, 1)
  }
  
  
  func property(_ key: String, value: CVarArg, _ operator: String = "==") -> String {
    let isString = value is String
    let op = isString ? "LIKE[cd]" : `operator`
    let v = isString ? "\"\(value)\"" : "\(value as! NSNumber)"
    let valuePart = "$property.object \(op) \(v)"
    let requiresNot = isString && `operator` == "!="
    
    return "\(requiresNot ? "NOT " : "")SUBQUERY(propertySet, $property, $property.name LIKE[cd] \"\(key)\" AND \(valuePart)).@count > 0"
  }
}

private extension ApiTests {
  func assertCompoundString(_ compoundString: CompoundString, _ string: String, file: StaticString = #file, line: UInt = #line) {
    assertPredicate(compoundString.predicate(with: "VALUE =="), string, file: file, line: line)
  }
  
  func assertPredicate(_ predicate: Predicate, _ string: String, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(predicate.predicate.predicateFormat, string, file: file, line: line)
  }
  
  func assertSearch(_ predicate: Predicate, _ count: Int, file: StaticString = #file, line: UInt = #line) {
    let search = Search<Entity>().where(predicate)
    XCTAssertEqual(search.sync().count, count, file: file, line: line)
    
    let testExpectation1 = expectation(description: "[ApiTests Error: Test failed.]")
    
    search.sync {
      XCTAssertEqual($0.count, count, file: file, line: line)
      testExpectation1.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    let testExpectation2 = expectation(description: "[ApiTests Error: Test failed.]")
    
    search.async {
      XCTAssertEqual($0.count, count, file: file, line: line)
      testExpectation2.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
}
