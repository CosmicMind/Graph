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
* Tree
*
* A powerful data structure that is backed by a RedBlackTree using an order
* statistic. This allows for manipulation and access of the data as if an array,
* while maintaining log(n) performance on all operations. All items in a Tree
* are uniquely keyed.
*/

public class Tree<K: Comparable, V>: RedBlackTree<K, V> {
	internal typealias TreeType = Tree<K, V>
	
	/**
	* description
	* Conforms to the Printable Protocol. Outputs the
	* data in the Tree in a readable format.
	*/
	public override var description: String {
		return "Tree" + internalDescription
	}
	
	/**
	* init
	* Constructor
	*/
	public override init() {
		super.init(unique: true)
	}

	/**
	* search
	* Accepts a paramter list of keys and returns a subset
	* Tree with the indicated values if
	* they exist.
	* @param		keys: K...
	* @return		TreeType subtree.
	*/
	public func search(keys: K...) -> TreeType {
		return search(keys)
	}
	
	/**
	* search
	* Accepts an array of keys and returns a subset
	* Tree with the indicated values if
	* they exist.
	* @param		keys: K...
	* @return		TreeType subtree.
	*/
	public func search(array: Array<K>) -> TreeType {
		var s: TreeType = TreeType()
		for key: K in array {
			subtree(key, node: root, set: &s)
		}
		return s
	}
	
	/**
	* subtree
	* Traverses the Tree and looking for a key value.
	* This is used for internal search.
	* @param		key: K
	* @param		node: NodeType
	* @param		inout set: TreeType
	*/
	internal func subtree(key: K, node: NodeType, inout set: TreeType) {
		if node !== sentinel {
			if key == node.key {
				set.insert(key, value: node.value)
			}
			subtree(key, node: node.left, set: &set)
			subtree(key, node: node.right, set: &set)
		}
	}
}

public func +<K: Comparable, V>(lhs: Tree<K, V>, rhs: Tree<K, V>) -> Tree<K, V> {
	let t: Tree<K, V> = Tree<K, V>()
	for var i: Int = lhs.count; i > 0; --i {
		let n: RedBlackNode<K, V> = lhs.select(lhs.root, order: i)
		t.insert(n.key, value: n.value)
	}
	for var i: Int = rhs.count; i > 0; --i {
		let n: RedBlackNode<K, V> = rhs.select(rhs.root, order: i)
		t.insert(n.key, value: n.value)
	}
	return t
}
