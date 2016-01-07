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

class StackTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let s: Stack<Int> = Stack<Int>()
		
		s.push(1)
		s.push(2)
		s.push(3)
		
		XCTAssert(3 == s.count, "Count incorrect, got \(s.count).")
		XCTAssert(3 == s.top, "Top incorrect, got \(s.top)")
		
		s.push(5)
		s.push(6)
		s.push(7)
		
		XCTAssert(6 == s.count, "Count incorrect, got \(s.count).")
		XCTAssert(7 == s.top, "Top incorrect, got \(s.top)")
		
		XCTAssert(7 == s.pop() && 5 == s.count && 6 == s.top, "Pop incorrect")
		XCTAssert(6 == s.pop() && 4 == s.count && 5 == s.top, "Pop incorrect")
		XCTAssert(5 == s.pop() && 3 == s.count && 3 == s.top, "Pop incorrect")
		XCTAssert(3 == s.pop() && 2 == s.count && 2 == s.top, "Pop incorrect")
		XCTAssert(2 == s.pop() && 1 == s.count && 1 == s.top, "Pop incorrect")
		XCTAssert(1 == s.pop() && 0 == s.count && nil == s.top, "Pop incorrect")
		
		s.push(1)
		s.push(2)
		s.push(3)
		s.removeAll()
		
		XCTAssert(0 == s.count, "Count incorrect, got \(s.count).")
	}
	
	func testConcat() {
		let s1: Stack<Int> = Stack<Int>()
		s1.push(1)
		s1.push(2)
		s1.push(3)
		
		let s2: Stack<Int> = Stack<Int>()
		s2.push(4)
		s2.push(5)
		s2.push(6)
		
		let s3: Stack<Int> = s1 + s2
		XCTAssert(6 == s3.count, "Concat incorrect.")
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
