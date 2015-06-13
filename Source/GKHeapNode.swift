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
* GKHeapNode
*/

internal class GKHeapNode<K: Comparable, V>: Comparable, Equatable, Printable {
	internal typealias GKHNode = GKHeapNode<K, V>
	
	internal var parent: GKHNode!
	internal var left: GKHNode!
	internal var right: GKHNode!
	internal var key: K! = nil
	internal var data: V?
	
	internal var description: String {
		return "{\(key): \(data)}"
	}
	
	internal init() {}
	
	internal init(parent: GKHNode, sentinel: GKHNode, key: K, data: V?) {
		self.key = key
		self.data = data
		self.parent = parent
		left = sentinel
		right = sentinel
	}
}

func == <K: Comparable, V>(lhs: GKHeapNode<K, V>, rhs: GKHeapNode<K, V>) -> Bool {
	return lhs.key == rhs.key
}

func <= <K: Comparable, V>(lhs: GKHeapNode<K, V>, rhs: GKHeapNode<K, V>) -> Bool {
	return lhs.key <= rhs.key
}

func >= <K: Comparable, V>(lhs: GKHeapNode<K, V>, rhs: GKHeapNode<K, V>) -> Bool {
	return lhs.key >= rhs.key
}

func > <K: Comparable, V>(lhs: GKHeapNode<K, V>, rhs: GKHeapNode<K, V>) -> Bool {
	return lhs.key > rhs.key
}

func < <K: Comparable, V>(lhs: GKHeapNode<K, V>, rhs: GKHeapNode<K, V>) -> Bool {
	return lhs.key < rhs.key
}
