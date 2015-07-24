/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import XCTest
import GraphKit

class SessionTests: XCTestCase {
	
	var expectation: XCTestExpectation?
	
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testSession() {
		let session: Session = Session()
		
		expectation = expectationWithDescription("Test failed.")
		
		if let u1: NSURL = NSURL(string: "http://graph.sandbox.local:5000/key/1/graph/test") {
			session.get(u1) { (json: JSON?, error: NSError?) in
				if nil != json && nil == error {
					self.expectation?.fulfill()
				}
			}
		}
		waitForExpectationsWithTimeout(5, handler: nil)
		
		if let u1: NSURL = NSURL(string: "http://graph.sandbox.local:5000/key/1/graph") {
			session.get(u1) { (json: JSON?, error: NSError?) in
				if nil != error && nil == json {
					self.expectation?.fulfill()
				}
			}
		}
		
		expectation = expectationWithDescription("Test failed.")
		
		waitForExpectationsWithTimeout(5, handler: nil)
	}

	func testPerformance() {
		self.measureBlock() {}
	}
}
