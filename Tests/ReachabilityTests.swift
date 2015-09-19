//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import XCTest
@testable import GraphKit

class ReachabilityTests: XCTestCase, ReachabilityDelegate {
	
	var reachability: Reachability?
	
	var callbackExpectation: XCTestExpectation?
	var delegateExpectation: XCTestExpectation?
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testConnectivity() {
//		reachability = Reachability.reachabilityForInternetConnection()
//		reachability?.delegate = self
//		reachability?.onStatusChange = { (reachability: Reachability) in
//			self.callbackExpectation?.fulfill()
//		}
//		
//		callbackExpectation = expectationWithDescription("Test failed.")
//		delegateExpectation = expectationWithDescription("Test failed.")
//		
//		reachability?.startWatcher()
//		
//		waitForExpectationsWithTimeout(15, handler: nil)
	}
	
	func reachabilityDidChangeStatus(reachability: Reachability) {
		delegateExpectation?.fulfill()
	}
	
	func testPerformance() {
		self.measureBlock() {}
	}
}
