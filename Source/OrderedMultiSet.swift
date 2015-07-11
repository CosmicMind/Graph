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
* OrderedMultiSet
*
* A powerful data structure that is backed by a RedBlackOrderedMultiSet using an order
* statistic. This allows for manipulation and access of the data as if an array,
* while maintaining log(n) performance on all operations. All items in a OrderedMultiSet
* are uniquely keyed.
*/

public class OrderedMultiSet<T: Comparable>: RedBlackTree<T, T> {
	internal typealias OrderedMultiSetType = OrderedMultiSet<T>
	
	/**
	* description
	* Conforms to the Printable Protocol. Outputs the
	* data in the OrderedMultiSet in a readable format.
	*/
	public override var description: String {
		return "OrderedMultiSet" + internalDescription
	}
	
	/**
	* init
	* Constructor
	*/
	public override init() {
		super.init(unique: false)
	}
	
	/**
	* search
	* Accepts a paramter list of keys and returns a subset
	* OrderedMultiSet with the indicated values if
	* they exist.
	* @param		keys: T...
	* @return		OrderedMultiSetType subtree.
	*/
	public func search(keys: T...) -> OrderedMultiSetType {
		return search(keys)
	}
	
	/**
	* search
	* Accepts an array of keys and returns a subset
	* OrderedMultiSet with the indicated values if
	* they exist.
	* @param		keys: T...
	* @return		OrderedMultiSetType subtree.
	*/
	public func search(array: Array<T>) -> OrderedMultiSetType {
		var set: OrderedMultiSetType = OrderedMultiSetType()
		for key: T in array {
			subtree(key, node: root, tree: &set)
		}
		return set
	}
	
	/**
	* subtree
	* Traverses the OrderedMultiSet and looking for a key value.
	* This is used for internal search.
	* @param		key: T
	* @param		node: NodeType
	* @param		inout tree: OrderedMultiSetType
	*/
	internal func subtree(key: T, node: NodeType, inout tree: OrderedMultiSetType) {
		if sentinel !== node {
			if key == node.key {
				tree.insert(key, value: node.value)
			}
			subtree(key, node: node.left, tree: &tree)
			subtree(key, node: node.right, tree: &tree)
		}
	}
}

public func +<T: Comparable>(lhs: OrderedMultiSet<T>, rhs: OrderedMultiSet<T>) -> OrderedMultiSet<T> {
	let s: OrderedMultiSet<T> = OrderedMultiSet<T>()
	for var i: Int = lhs.count; i > 0; --i {
		let n: RedBlackNode<T, T> = lhs.select(lhs.root, order: i)
		s.insert(n.key, value: n.value)
	}
	for var i: Int = rhs.count; i > 0; --i {
		let n: RedBlackNode<T, T> = rhs.select(rhs.root, order: i)
		s.insert(n.key, value: n.value)
	}
	return s
}
