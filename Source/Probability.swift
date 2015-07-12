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


internal protocol ProbabilityType {
	typealias ElementType
	func countOf(elements: ElementType...) -> Int
	func countOf(elements: Array<ElementType>) -> Int
}

public class Probability<Element: Comparable>: ProbabilityType {
	typealias ElementType = Element
	public internal(set) var count: Int = 0
	
	public func countOf(elements: Element...) -> Int { return 0 }
	
	public func countOf(elements: Array<Element>) -> Int { return 0 }
	
	public func probability(elements: Element...) -> Double {
		return probability(elements)
	}
	
	public func probability(elements: Array<Element>) -> Double {
		let x: Double = Double(countOf(elements))
		let y: Double = Double(count)
		return 0 == y ? 0 : x / y
	}
	
	public func expectedValue(trials: Int, elements: Element...) -> Double {
		return expectedValue(trials, elements: elements)
	}
	
	public func expectedValue(trials: Int, elements: Array<Element>) -> Double {
		return Double(trials) * probability(elements)
	}
}
