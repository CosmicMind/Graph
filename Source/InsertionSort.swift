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

extension Sort {
	/**
		:name: insertion
		:description:	An implementation of the popular Insertion Sort algorithm.
		An inplace sort that sorts small sized Arrays well in O(n^2) time.
	*/
	static public func insertion<Element : Comparable>(inout elements: Array<Element>) {
		var i: Int
		var j: Int
		let n: Int = elements.count
		for (i = 1; i < n; ++i) {
			j = i
			while (0 < j && elements[j] < elements[j - 1]) {
				swap(&elements[j], &elements[--j])
			}
		}
	}
}
