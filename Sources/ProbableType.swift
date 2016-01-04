//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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
	/**
		:name:	countOf
		:description:	The instance count of elements.
		- parameter	elements:	Element...	The element values to count.
		- returns:	Int
	*/
	func countOf<Element: Equatable>(elements: Element...) -> Int
	
	/**
		:name:	countOf
		:description:	The instance count of elements.
		- parameter	elements:	Array<Element>	An array of element values to count.
		- returns:	Int
	*/
	func countOf<Element: Equatable>(elements: Array<Element>) -> Int
	
	/**
		:name:	probabilityOf
		:description:	The probability of elements.
		- parameter	elements:	Element...	The element values to determine the probability of.
		- returns:	Double
	*/
	func probabilityOf<Element: Equatable>(elements: Element...) -> Double
	
	/**
		:name:	probabilityOf
		:description:	The probability of elements.
		- parameter	elements:	Array<Element>	An array of element values to determine the probability of.
		- returns:	Double
	*/
	func probabilityOf<Element: Equatable>(elements: Array<Element>) -> Double
	
	/**
		:name:	expectedValueOf
		:description:	The expected value of elements.
		- parameter	trials:	Int	The number of trials to execute.
		- parameter	elements:	Element...	The element values to determine the expected value of.
		- returns:	Double
	*/
	func expectedValueOf<Element: Equatable>(trials: Int, elements: Element...) -> Double
	
	/**
		:name:	expectedValueOf
		:description:	The expected value of elements.
		- parameter	trials:	Int	The number of trials to execute.
		- parameter	elements:	Array<Element>	An array of element values to determine the expected value of.
		- returns:	Double
	*/
	func expectedValueOf<Element: Equatable>(trials: Int, elements: Array<Element>) -> Double
}
