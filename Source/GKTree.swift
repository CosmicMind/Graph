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
* GKTree
*
* A powerful data structure that is backed by a RedBlackTree using an order 
* statistic. This allows for manipulation and access of the data as if an array, 
* while maintaining log(n) performance on all operations. All items in a GKTree
* are uniquely keyed.
*/

public class GKTree<K: Comparable, V>: Printable {
	private typealias GKTreeNode = GKRedBlackNode<K, V>
	
	/**
	* tree
	* Underlying data structure.
	*/
	private var tree: GKRedBlackTree<K, V>
	
	/**
	* count
	* Number of nodes in the GKTree.
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
	* description
	* Conforms to the Printable Protocol. Outputs the
	* data in the GKTree in a readable format.
	*/
	public var description: String {
		var output: String = "GKTree("
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
		tree = GKRedBlackTree<K, V>(unique: true)
	}
	
	/**
	* insert
	* Insert a new node into the GKTree.
	* @param		key: K
	* @param		data: V?
	* @return		Bool of the result. True if inserted, false otherwise. 
	*				Failure of insertion would mean the key already
	*				exists in the GKTree.
	*/
	public func insert(key: K, data: V?) -> Bool {
		return tree.insert(key, data: data)
	}
	
	/**
	* remove
	* Remove a node from the GKTree by the key value.
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
	* GKTree with the indicated values if
	* they exist. 
	* @param		keys: K...
	* @return		GKTree<K, V> subset.
	*/
	public func search(keys: K...) -> GKTree<K, V> {
		var s: GKTree<K, V> = GKTree<K, V>()
		for key: K in keys {
			traverse(key, node: tree.root, set: &s)
		}
		return s
	}

	/**
	* search
	* Accepts an array of keys and returns a subset 
	* GKTree with the indicated values if
	* they exist.
	* @param		keys: K...
	* @return		GKTree<K, V> subset.
	*/
	public func search(keys: Array<K>) -> GKTree<K, V> {
		var s: GKTree<K, V> = GKTree<K, V>()
		for key: K in keys {
			traverse(key, node: tree.root, set: &s)
		}
		return s
	}
	
	/**
	* traverse
	* Traverses the GKTree and looking for a key value. 
	* This is used for internal search. 
	* @param		key: K
	* @param		node: GKTreeNode
	* @param		inout set: GKTree<K, V>
	*/
	private func traverse(key: K, node: GKTreeNode, inout set: GKTree<K, V>) {
		if tree.sentinel !== node {
			if key == node.key {
				set.insert(key, data: node.data)
			}
			traverse(key, node: node.left, set: &set)
			traverse(key, node: node.right, set: &set)
		}
	}
}