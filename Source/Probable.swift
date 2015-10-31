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

internal protocol ProbableType {
	typealias ElementType
	
	/**
		:name:	countOf
		:description:	The instance count of elements.
		- parameter	elements:	ElementType...	The element values to count.
		- returns:	Int
	*/
	func countOf(elements: ElementType...) -> Int
	
	/**
		:name:	countOf
		:description:	The instance count of elements.
		- parameter	elements:	Array<ElementType>	An array of element values to count.
		- returns:	Int
	*/
	func countOf(elements: Array<ElementType>) -> Int
	
	/**
		:name:	probabilityOf
		:description:	The probability of elements.
		- parameter	elements:	ElementType...	The element values to determine the probability of.
		- returns:	Double
	*/
	func probabilityOf(elements: ElementType...) -> Double
	
	/**
		:name:	probabilityOf
		:description:	The probability of elements.
		- parameter	elements:	Array<ElementType>	An array of element values to determine the probability of.
		- returns:	Double
	*/
	func probabilityOf(elements: Array<ElementType>) -> Double
	
	/**
		:name:	expectedValueOf
		:description:	The expected value of elements.
		- parameter	trials:	Int	The number of trials to execute.
		- parameter	elements:	ElementType...	The element values to determine the expected value of.
		- returns:	Double
	*/
	func expectedValueOf(trials: Int, elements: ElementType...) -> Double
	
	/**
		:name:	expectedValueOf
		:description:	The expected value of elements.
		- parameter	trials:	Int	The number of trials to execute.
		- parameter	elements:	Array<ElementType>	An array of element values to determine the expected value of.
		- returns:	Double
	*/
	func expectedValueOf(trials: Int, elements: Array<ElementType>) -> Double
}

public class Probable<Element : Comparable> : ProbableType {
	typealias ElementType = Element

	public internal(set) var count: Int = 0

	/**
		:name:	countOf
		:description:	The instance count of elements.
		- parameter	elements:	ElementType...	The element values to count.
		- returns:	Int
	*/
	public func countOf(elements: Element...) -> Int { return 0 }

	/**
		:name:	countOf
		:description:	The instance count of elements.
		- parameter	elements:	Array<ElementType>	An array of element values to count.
		- returns:	Int
	*/
	public func countOf(elements: Array<Element>) -> Int { return 0 }

	/**
		:name:	probabilityOf
		:description:	The probability of elements.
		- parameter	elements:	ElementType...	The element values to determine the probability of.
		- returns:	Double
	*/
	public func probabilityOf(elements: Element...) -> Double {
		return probabilityOf(elements)
	}
	
	/**
		:name:	probabilityOf
		:description:	The probability of elements.
		- parameter	elements:	Array<ElementType>	An array of element values to determine the probability of.
		- returns:	Double
	*/
	public func probabilityOf(elements: Array<Element>) -> Double {
		return 0 == count ? 0 : Double(countOf(elements)) / Double(count)
	}

	/**
		:name:	expectedValueOf
		:description:	The expected value of elements.
		- parameter	trials:	Int	The number of trials to execute.
		- parameter	elements:	ElementType...	The element values to determine the expected value of.
		- returns:	Double
	*/
	public func expectedValueOf(trials: Int, elements: Element...) -> Double {
		return expectedValueOf(trials, elements: elements)
	}

	/**
		:name:	expectedValueOf
		:description:	The expected value of elements.
		- parameter	trials:	Int	The number of trials to execute.
		- parameter	elements:	Array<ElementType>	An array of element values to determine the expected value of.
		- returns:	Double
	*/
	public func expectedValueOf(trials: Int, elements: Array<Element>) -> Double {
		return Double(trials) * probabilityOf(elements)
	}
}
