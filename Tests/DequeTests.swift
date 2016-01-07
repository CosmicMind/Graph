/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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

class DequeTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let d: Deque<Int> = Deque<Int>()
		
		d.insertAtFront(1)
		d.insertAtFront(2)
		d.insertAtFront(3)
		
		XCTAssert(3 == d.count, "Count incorrect, got \(d.count).")
		
		XCTAssert(3 == d.front, "Front incorrect, got \(d.front)")
		XCTAssert(1 == d.back, "Back incorrect, got \(d.back)")
		
		d.insertAtBack(5)
		d.insertAtBack(6)
		d.insertAtBack(7)
		
		XCTAssert(6 == d.count, "Count incorrect, got \(d.count).")
		
		XCTAssert(3 == d.front, "Front incorrect, got \(d.front)")
		XCTAssert(7 == d.back, "Back incorrect, got \(d.back)")
		
		XCTAssert(3 == d.removeAtFront() && 5 == d.count && 2 == d.front, "RemoveAtFront incorrect")
		XCTAssert(2 == d.removeAtFront() && 4 == d.count && 1 == d.front, "RemoveAtFront incorrect")
		XCTAssert(1 == d.removeAtFront() && 3 == d.count && 5 == d.front, "RemoveAtFront incorrect")
		
		XCTAssert(7 == d.removeAtBack() && 2 == d.count && 6 == d.back, "RemoveAtBack incorrect")
		XCTAssert(6 == d.removeAtBack() && 1 == d.count && 5 == d.back, "RemoveAtBack incorrect")
		XCTAssert(5 == d.removeAtBack() && 0 == d.count && nil == d.back, "RemoveAtBack incorrect")
		
		d.insertAtFront(1)
		d.insertAtFront(2)
		d.insertAtFront(3)
		d.removeAll()
		
		XCTAssert(0 == d.count, "Count incorrect, got \(d.count).")
	}
	
	func testConcat() {
		let d1: Deque<Int> = Deque<Int>()
		d1.insertAtBack(1)
		d1.insertAtBack(2)
		d1.insertAtBack(3)
		
		let d2: Deque<Int> = Deque<Int>()
		d2.insertAtBack(4)
		d2.insertAtBack(5)
		d2.insertAtBack(6)
		
		let d3: Deque<Int> = d1 + d2
		
		for x in d1 {
			XCTAssert(x == d3.removeAtFront(), "Concat incorrect.")
		}
		
		for x in d2 {
			XCTAssert(x == d3.removeAtFront(), "Concat incorrect.")
		}
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
