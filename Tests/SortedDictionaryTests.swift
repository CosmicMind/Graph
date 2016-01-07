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
*	*	Neither the name of GraphKit nor the names of its
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
@testable import GraphKit

class SortedDictionaryTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let s: SortedDictionary<Int, Int> = SortedDictionary<Int, Int>()
		
		XCTAssert(0 == s.count, "Test failed, got \(s.count).")
		
		for var i: Int = 1000; 0 < i; --i {
			s.insert((1, 1))
			s.insert((2, 2))
			s.insert((3, 3))
		}
		
		XCTAssert(3 == s.count, "Test failed.")
		XCTAssert(1 == s[0].value, "Test failed.")
		XCTAssert(2 == s[1].value, "Test failed.")
		XCTAssert(3 == s[2].value, "Test failed.")
		
		for var i: Int = 500; 0 < i; --i {
			s.removeValueForKeys(1)
			s.removeValueForKeys(3)
		}
		
		XCTAssert(1 == s.count, "Test failed.")
		s.removeValueForKeys(2)
		
		s.insert((2, 10))
		XCTAssert(1 == s.count, "Test failed.")
		XCTAssert(10 == s.findValueForKey(2), "Test failed.")
		XCTAssert(10 == s[0].value!, "Test failed.")
		
		s.removeValueForKeys(2)
		XCTAssert(0 == s.count, "Test failed.")
		
		s.insert((1, 1))
		s.insert((2, 2))
		s.insert((3, 3))
		s.insert((3, 3))
		s.updateValue(5, forKey: 3)
		
		let subs: SortedDictionary<Int, Int> = s.search(3)
		XCTAssert(1 == subs.count, "Test failed.")
		
		let generator: SortedDictionary<Int, Int>.Generator = subs.generate()
		while let x = generator.next() {
			XCTAssert(5 == x.value, "Test failed.")
		}
		
		for (var i: Int = s.endIndex - 1; i >= s.startIndex; --i) {
			s[i] = (s[i].key, 100)
			XCTAssert(100 == s[i].value, "Test failed.")
		}
		
		s.removeAll()
		XCTAssert(0 == s.count, "Test failed.")
	}
	
	func testIndexOf() {
		let d1: SortedDictionary<Int, Int> = SortedDictionary<Int, Int>()
		d1.insert(1, value: 1)
		d1.insert(2, value: 2)
		d1.insert(3, value: 3)
		d1.insert(4, value: 4)
		d1.insert(5, value: 5)
		d1.insert(5, value: 5)
		d1.insert(6, value: 6)
		
		XCTAssert(0 == d1.indexOf(1), "Test failed.")
		XCTAssert(5 == d1.indexOf(6), "Test failed.")
		XCTAssert(-1 == d1.indexOf(100), "Test failed.")
	}
	
	func testKeys() {
		let s: SortedDictionary<String, Int> = SortedDictionary<String, Int>(elements: ("adam", 1), ("daniel", 2), ("mike", 3), ("natalie", 4))
		let keys: SortedSet<String> = SortedSet<String>(elements: "adam", "daniel", "mike", "natalie")
		XCTAssert(keys == s.keys, "Test failed.")
	}
	
	func testValues() {
		let s: SortedDictionary<String, Int> = SortedDictionary<String, Int>(elements: ("adam", 1), ("daniel", 2), ("mike", 3), ("natalie", 4))
		let values: Array<Int> = [1, 2, 3, 4]
		XCTAssert(values == s.values, "Test failed.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
