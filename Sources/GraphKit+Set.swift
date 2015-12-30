//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>.
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

extension Set : ProbableType {
	/**
	The instance count of elements.
	*/
	public func countOf<Element: Equatable>(elements: Element...) -> Int {
		return countOf(elements)
	}
	
	/**
	The instance count of elements.
	*/
	public func countOf<Element: Equatable>(elements: Array<Element>) -> Int {
		var c: Int = 0
		for v in elements {
			for x in self {
				if v == x as! Element {
					++c
				}
			}
		}
		return c
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf<Element: Equatable>(elements: Element...) -> Double {
		return probabilityOf(elements)
	}
	
	/**
	The probability of elements.
	*/
	public func probabilityOf<Element: Equatable>(elements: Array<Element>) -> Double {
		return 0 == count ? 0 : Double(countOf(elements)) / Double(count)
	}
	
	/**
	The expected value of elements.
	*/
	public func expectedValueOf<Element: Equatable>(trials: Int, elements: Element...) -> Double {
		return expectedValueOf(trials, elements: elements)
	}
	
	/**
	The expected value of elements.
	*/
	public func expectedValueOf<Element: Equatable>(trials: Int, elements: Array<Element>) -> Double {
		return Double(trials) * probabilityOf(elements)
	}
}
