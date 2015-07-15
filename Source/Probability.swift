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

internal protocol ProbabilityType {
	typealias ElementType
	func countOf(elements: ElementType...) -> Int
	func countOf(elements: Array<ElementType>) -> Int
	func probabilityOf(elements: ElementType...) -> Double
	func probabilityOf(elements: Array<ElementType>) -> Double
	func expectedValueOf(trials: Int, elements: ElementType...) -> Double
	func expectedValueOf(trials: Int, elements: Array<ElementType>) -> Double
}

public class Probability<Element : Comparable> : ProbabilityType {
	typealias ElementType = Element

	public internal(set) var count: Int = 0

	public func countOf(elements: Element...) -> Int { return 0 }

	public func countOf(elements: Array<Element>) -> Int { return 0 }

	public func probabilityOf(elements: Element...) -> Double {
		return probabilityOf(elements)
	}

	public func probabilityOf(elements: Array<Element>) -> Double {
		let x: Double = Double(countOf(elements))
		let y: Double = Double(count)
		return 0 == y ? 0 : x / y
	}

	public func expectedValueOf(trials: Int, elements: Element...) -> Double {
		return expectedValueOf(trials, elements: elements)
	}

	public func expectedValueOf(trials: Int, elements: Array<Element>) -> Double {
		return Double(trials) * probabilityOf(elements)
	}
}
