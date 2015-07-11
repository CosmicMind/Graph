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
*
* Probability
* Probability algorithms are addaed to Probability struct.
*/


public protocol _ProbabilityType {
	typealias MemberType
	func countOf(members: MemberType...) -> Int
	func countOf(members: Array<MemberType>) -> Int
}

public class Probability<T: Comparable>: _ProbabilityType {
	typealias MemberType = T
	public internal(set) var count: Int = 0
	public func countOf(members: MemberType...) -> Int { return 0 }
	public func countOf(members: Array<MemberType>) -> Int { return 0 }
	public func expectedValue(members: T...) -> Double {
		let x: Double = Double(countOf(members))
		let y: Double = Double(count)
		return 0 == y ? 0 : x / y
	}
}
