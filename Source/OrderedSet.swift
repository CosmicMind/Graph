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
* OrderedSet
*
* A powerful data structure that is backed by a RedBlackOrderedSet using an order
* statistic. This allows for manipulation and access of the data as if an array,
* while maintaining log(n) performance on all operations. All items in a OrderedSet
* are uniquely keyed.
*/

public class OrderedSet<T: Comparable>: CollectionType, Printable {
	private typealias TreeType = Tree<T, T>
	internal typealias OrderedSetType = OrderedSet<T>
	internal typealias Generator = GeneratorOf<T>
	
	/**
	* tree
	*/
	internal var tree: TreeType
	
	/**
	* description
	* Conforms to the Printable Protocol. Outputs the
	* data in the OrderedSet in a readable format.
	*/
	public var description: String {
		return "OrderedSet" + tree.internalDescription
	}
	
	/**
	* count
	* Total number of nodes in the tree.
	*/
	public var count: Int {
		return tree.count
	}
	
	/**
	* first
	* Get the first node value in the tree, this is
	* the first node based on the order of keys where
	* k1 <= k2 <= K3 ... <= Kn
	*/
	public var first: T? {
		return tree.first
	}
	
	/**
	* last
	* Get the last node value in the tree, this is
	* the last node based on the order of keys where
	* k1 <= k2 <= K3 ... <= Kn
	*/
	public var last: T? {
		return tree.last
	}
	
	/**
	* isEmpty
	* A boolean of whether the RedBlackTree is empty.
	*/
	public var isEmpty: Bool {
		return 0 == count
	}
	
	/**
	* startIndex
	* Conforms to the CollectionType Protocol.
	*/
	public var startIndex: Int {
		return 0
	}
	
	/**
	* endIndex
	* Conforms to the CollectionType Protocol.
	*/
	public var endIndex: Int {
		return count
	}
	
	/**
	* init
	* Constructor
	*/
	public init() {
		tree = TreeType()
	}
	
	/**
	* generate
	* Conforms to the SequenceType Protocol. Returns
	* the next value in the sequence of nodes using
	* index values [0...n-1].
	*/
	public func generate() -> Generator {
		var index = startIndex
		return GeneratorOf {
			if index < self.endIndex {
				return self[index++]
			}
			return nil
		}
	}
	
	/**
	* operator [0...count - 1]
	* Allows array like access of the index.
	* Items are kept in order, so when iterating
	* through the items, they are returned in their
	* ordered form.
	* @param		index: Int
	* @return		value V?
	*/
	public subscript(index: Int) -> T {
		return tree[index]!
	}
	
	public func insert(member: T) -> Bool {
		return tree.insert(member, value: member)
	}
	
	public func remove(member: T) -> Bool {
		return tree.remove(member)
	}
	
	/**
	* removeAll
	* Remove all nodes from the tree.
	*/
	public func removeAll() {
		tree.removeAll()
	}
}

//public func +<T: Comparable>(lhs: OrderedSet<T>, rhs: OrderedSet<T>) -> OrderedSet<T> {
//	let s: OrderedSet<T> = OrderedSet<T>()
//	for var i: Int = lhs.count; i > 0; --i {
//		let n: RedBlackNode<T, T> = lhs.select(lhs.root, order: i)
//		s.insert(n.key, value: n.value)
//	}
//	for var i: Int = rhs.count; i > 0; --i {
//		let n: RedBlackNode<T, T> = rhs.select(rhs.root, order: i)
//		s.insert(n.key, value: n.value)
//	}
//	return s
//}
