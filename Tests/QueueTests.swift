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

class QueueTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInt() {
		let q: Queue<Int> = Queue<Int>()
		
		q.enqueue(1)
		q.enqueue(2)
		q.enqueue(3)
		
		XCTAssert(3 == q.count, "Count incorrect, got \(q.count).")
		XCTAssert(1 == q.peek, "Peek incorrect, got \(q.peek)")
		
		q.enqueue(5)
		q.enqueue(6)
		q.enqueue(7)
		
		XCTAssert(6 == q.count, "Count incorrect, got \(q.count).")
		XCTAssert(1 == q.peek, "Peek incorrect, got \(q.peek)")
		
		XCTAssert(1 == q.dequeue() && 5 == q.count && 2 == q.peek, "Dequeue incorrect")
		XCTAssert(2 == q.dequeue() && 4 == q.count && 3 == q.peek, "Dequeue incorrect")
		XCTAssert(3 == q.dequeue() && 3 == q.count && 5 == q.peek, "Dequeue incorrect")
		XCTAssert(5 == q.dequeue() && 2 == q.count && 6 == q.peek, "Dequeue incorrect")
		XCTAssert(6 == q.dequeue() && 1 == q.count && 7 == q.peek, "Dequeue incorrect")
		XCTAssert(7 == q.dequeue() && 0 == q.count && nil == q.peek, "Dequeue incorrect")
		
		q.enqueue(1)
		q.enqueue(2)
		q.enqueue(3)
		q.removeAll()
		
		XCTAssert(0 == q.count, "Count incorrect, got \(q.count).")
		
		q.enqueue(1)
		q.enqueue(2)
		q.enqueue(3)
	}
	
	func testConcat() {
		let q1: Queue<Int> = Queue<Int>()
		q1.enqueue(1)
		q1.enqueue(2)
		q1.enqueue(3)
		
		let q2: Queue<Int> = Queue<Int>()
		q2.enqueue(4)
		q2.enqueue(5)
		q2.enqueue(6)
		
		let q3: Queue<Int> = q1 + q2
		
		for x in q1 {
			XCTAssert(x == q3.dequeue(), "Concat incorrect.")
		}
		
		for x in q2 {
			XCTAssert(x == q3.dequeue(), "Concat incorrect.")
		}
		
		q3.removeAll()
		let q4: Queue<Int> = q1 + q2 + q3
		for x in q4 {
			XCTAssert(x == q4.dequeue(), "Concat incorrect.")
		}
	}

	func testPerformance() {
		self.measureBlock() {}
	}
}
