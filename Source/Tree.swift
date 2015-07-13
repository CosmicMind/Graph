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

public class Tree<Key: Comparable, Value>: RedBlackTree<Key, Value> {
	internal typealias TreeType = Tree<Key, Value>
	
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
	* countOf
	* Conforms to ProbabilityType protocol.
	*/
	public override func countOf(keys: Key...) -> Int {
		return countOf(keys)
	}

	/**
	* countOf
	* Conforms to ProbabilityType protocol.
	*/
	public override func countOf(keys: Array<Key>) -> Int {
		return search(keys).count
	}
	
	/**
	* search
	* Accepts a paramter list of keys and returns a subset
	* Tree with the indicated values if
	* they exist.
	*/
	public func search(keys: Key...) -> TreeType {
		return search(keys)
	}
	
	/**
	* search
	* Accepts an array of keys and returns a subset
	* Tree with the indicated values if
	* they exist.
	*/
	public func search(array: Array<Key>) -> TreeType {
		var tree: TreeType = TreeType()
		for key: Key in array {
			subtree(key, node: root, tree: &tree)
		}
		return tree
	}
	
	/**
	* subtree
	* Traverses the Tree and looking for a key value.
	* This is used for internal search.
	*/
	internal func subtree(key: Key, node: NodeType, inout tree: TreeType) {
		if sentinel !== node {
			if key == node.key {
				tree.insert(key, value: node.value)
			}
			subtree(key, node: node.left, tree: &tree)
			subtree(key, node: node.right, tree: &tree)
		}
	}
}

public func +<Key: Comparable, Value>(lhs: Tree<Key, Value>, rhs: Tree<Key, Value>) -> Tree<Key, Value> {
	let t: Tree<Key, Value> = Tree<Key, Value>()
	for var i: Int = lhs.count; i > 0; --i {
		let n: RedBlackNode<Key, Value> = lhs.select(lhs.root, order: i)
		t.insert(n.key, value: n.value)
	}
	for var i: Int = rhs.count; i > 0; --i {
		let n: RedBlackNode<Key, Value> = rhs.select(rhs.root, order: i)
		t.insert(n.key, value: n.value)
	}
	return t
}
