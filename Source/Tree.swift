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

public class Tree<K: Comparable, V>: Printable {
	private typealias TreeNode = RedBlackNode<K, V>
	
	/**
	* tree
	* Underlying data structure.
	*/
	private var tree: RedBlackTree<K, V>
	
	/**
	* count
	* Number of nodes in the Tree.
	*/
	public var count: Int {
		return tree.count
	}
	
	/**
	* last
	* Last node in the tree based on the key ordering.
	*/
	public var last: V? {
		return tree.last
	}
	
	/**
	* first
	* First node in the tree based on the key ordering.
	*/
	public var first: V? {
		return tree.first
	}
	
	/**
	* empty
	* A boolean if the Tree is empty. 
	*/
	public var empty: Bool {
		return tree.empty
	}
	
	/**
	* description
	* Conforms to the Printable Protocol. Outputs the
	* data in the Tree in a readable format.
	*/
	public var description: String {
		var output: String = "Tree("
		for (var i: Int = 1; i <= count; ++i) {
			output += tree.select(tree.root, order: i).description
			if i != count {
				output += ","
			}
		}
		return output + ")"
	}
	
	/**
	* init
	* Constructor.
	*/
	public init() {
		tree = RedBlackTree<K, V>(unique: true)
	}
	
	/**
	* insert
	* Insert a new node into the Tree.
	* @param		key: K
	* @param		data: V?
	* @return		Bool of the result. True if inserted, false otherwise. 
	*				Failure of insertion would mean the key already
	*				exists in the Tree.
	*/
	public func insert(key: K, data: V?) -> Bool {
		return tree.insert(key, data: data)
	}
	
	/**
	* remove
	* Remove a node from the Tree by the key value.
	* @param		key: K
	* @return		Bool of the result. True if removed, false otherwise.
	*/
	public func remove(key: K) -> Bool {
		return tree.remove(key)
	}
	
	/**
	* find
	* Finds a node by its key value and returns the
	* data that the node points to. 
	* @param		key: K
	* @return		data V?
	*/
	public func find(key: K) -> V? {
		return tree.find(key)
	}
	
	/**
	* operator [0...count - 1]
	* Allos array like access of the index. 
	* Items are kept in order, so when iterating
	* through the items, they are returned in their
	* ordered form.
	* @param		index: Int
	* @return		data V?
	*/
	public subscript(index: Int) -> V? {
		get {
			return tree[index]
		}
	}
	
	/**
	* operator ["key 1"..."key 2"]
	* Property key mapping. If the key type is a
	* String, this feature allows access like a
	* Dictionary. 
	* @param		name: String
	* @return		data V?
	*/
	public subscript(name: String) -> V? {
		get {
			return tree[name]
		}
		set(value) {
			tree[name] = value
		}
	}
	
	/**
	* search
	* Accepts a paramter list of keys and returns a subset 
	* Tree with the indicated values if
	* they exist. 
	* @param		keys: K...
	* @return		Tree<K, V> subset.
	*/
	public func search(keys: K...) -> Tree<K, V> {
		return search(keys)
	}

	/**
	* search
	* Accepts an array of keys and returns a subset 
	* Tree with the indicated values if
	* they exist.
	* @param		keys: K...
	* @return		Tree<K, V> subset.
	*/
	public func search(keys: Array<K>) -> Tree<K, V> {
		var s: Tree<K, V> = Tree<K, V>()
		for key: K in keys {
			traverse(key, node: tree.root, set: &s)
		}
		return s
	}
	
	/**
	* clear
	* Removes all nodes in the Tree.
	*/
	public func clear() {
		tree.clear()
	}
	
	/**
	* traverse
	* Traverses the Tree and looking for a key value. 
	* This is used for internal search. 
	* @param		key: K
	* @param		node: TreeNode
	* @param		inout set: Tree<K, V>
	*/
	private func traverse(key: K, node: TreeNode, inout set: Tree<K, V>) {
		if tree.sentinel !== node {
			if key == node.key {
				set.insert(key, data: node.data)
			}
			traverse(key, node: node.left, set: &set)
			traverse(key, node: node.right, set: &set)
		}
	}
}