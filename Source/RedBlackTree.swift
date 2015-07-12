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
* RedBlackTree
*
* The following is a RedBlackTree implementation with an Order Statistic. 
* The power of the Order Statistic allows the RedBlackTree to reliably operate
* in log(n) time, while maintaining order of the nodes as if in a sorted Array.
* Also, it is possible to specifiy a unique keyed tree or non-unique keyed tree.
*/

public class RedBlackTree<Key: Comparable, Value>: Probability<Key>, CollectionType, Printable {
	private typealias TreeType = RedBlackTree<Key, Value>
	internal typealias NodeType = RedBlackNode<Key, Value>
	internal typealias Element = (key: Key, value: Value?)
	internal typealias Generator = GeneratorOf<Element>
	
	/**
	* sentinel
	* A node used to mark the end of a path in the tree.
	*/
	internal private(set) var sentinel: NodeType
	
	/**
	* root
	* The root of the tree data structure.
	*/
	internal private(set) var root: NodeType
	
	/**
	* unique
	* A boolean used to indicate whether to allow the
	* tree to store non-unique key values or only unique
	* key values.
	*/
	public private(set) var unique: Bool
	
	/**
	* internalDescription
	* Returns a String with only the node data for all
	* nodes in the Tree.
	*/
	internal var internalDescription: String {
		var output: String = "("
		for var i: Int = 1; i <= count; ++i {
			output += internalSelect(root, order: i).description
			if i != count {
				output += ", "
			}
		}
		return output + ")"
	}
	
	/**
	* description
	* Conforms to the Printable Protocol. Outputs the
	* data in the Tree in a readable format.
	*/
	public var description: String {
		return "RedBlackTree" + internalDescription
	}
	
	/**
	* first
	* Get the first node value in the tree, this is
	* the first node based on the order of keys where
	* k1 <= k2 <= Key3 ... <= Keyn
	*/
	public var first: Value? {
		return internalSelect(root, order: 1).value
	}
	
	/**
	* last
	* Get the last node value in the tree, this is
	* the last node based on the order of keys where
	* k1 <= k2 <= Key3 ... <= Keyn
	*/
	public var last: Value? {
		return isEmpty ? sentinel.value : internalSelect(root, order: count).value
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
	* Constructor where the tree is guaranteed to store
	* non-unique keys.
	*/
	public override init() {
		unique = false
		sentinel = NodeType()
		root = sentinel
	}
	
	/**
	* init
	* Constructor where the tree is optionally allowed
	* to store uniqe or non-unique keys.
	*/
	public init(unique: Bool) {
		self.unique = unique
		sentinel = NodeType()
		root = sentinel
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
	* removeAll
	* Remove all nodes from the tree.
	*/
	public func removeAll() {
		while sentinel !== root {
			internalRemove(root.key)
		}
	}
	
	/**
	* insert
	* Insert a node in the tree.
	*/
	public func insert(key: Key, value: Value?) -> Bool {
		return sentinel !== internalInsert(key, value: value)
	}
	
	/**
	* remove
	* Removes a node from the tree based on the key value given.
	* If the tree allows non-unique keys, then all keys matching 
	* the given key value will be removed.
	*/
	public func remove(key: Key) -> Bool {
		var removed: Bool = false
		while sentinel !== internalRemove(key) {
			removed = true
		}
		return removed
	}

	/**
	* update
	* Updates a node for the given key value.
	* If the tree allows non-unique keys, then all keys matching
	* the given key value will be updated.
	*/
	public func update(key: Key, value: Value?) -> Bool {
		var updated: Bool = false
		var x: NodeType = root
		while x !== sentinel {
			if key == x.key {
				x.value = value
				updated = true
			}
			x = key < x.key ? x.left : x.right
		}
		return updated
	}
	
	/**
	* find
	* Finds the first instance in a non-unique tree and only instance
	* in unique tree of a given keyed node.
	*/
	public func find(key: Key) -> Value? {
		return internalFindByKey(key).value
	}
	
	/**
	* operator [0...count - 1]
	* Allows array like access of the index.
	* Items are kept in order, so when iterating
	* through the items, they are returned in their
	* ordered form.
	*/
	public subscript(index: Int) -> Element {
		get {
			if !isIndexValid(index) {
				let x: NodeType = internalSelect(root, order: index + 1)
				return (x.key, x.value)
			} else {
				assert(false, "[GraphKit Error: Index out of bounds.]")
			}
		}
		set(element) {
			if !isIndexValid(index) {
				let x: NodeType = internalSelect(root, order: index + 1)
				if x.key != element.key {
					assert(false, "[GraphKit Error: Key error.]")
				}
				x.value = element.value
			} else {
				assert(false, "[GraphKit Error: Index out of bounds.]")
			}
		}
	}
	
	/**
	* operator ["key 1"..."key 2"]
	* Property key mapping. If the key type is a
	* String, this feature allows access like a
	* Dictionary.
	*/
	public subscript(name: String) -> Value? {
		get {
			return internalFindByKey(name as! Key).value
		}
		set(value) {
			let node: NodeType = internalFindByKey(name as! Key)
			if sentinel === node {
				insert(name as! Key, value: value!)
			} else {
				node.value = value
			}
		}
	}
	
	/**
	* select
	* Searches for a node based on the order statistic value.
	*/
	internal func select(x: NodeType, order: Int) -> NodeType {
		return internalSelect(x, order: order)
	}
	
	/**
	* internalInsert
	* Insert a new node with the given key and value.
	*/
	private func internalInsert(key: Key, value: Value?) -> NodeType {
		if unique && sentinel !== internalFindByKey(key) {
			return sentinel;
		}
		
		var y: NodeType = sentinel
		var x: NodeType = root
		
		while x !== sentinel {
			y = x
			++y.order
			x = key < x.key ? x.left : x.right
		}
		
		var z: NodeType = NodeType(parent: y, sentinel: sentinel, key: key, value: value)
		
		if y === sentinel {
			root = z
		} else if key < y.key {
			y.left = z
		} else {
			y.right = z
		}
		
		insertCleanUp(z)
		++count
		return z
	}
	
	/**
	* insertCleanUp
	* The clean up procedure needed to maintain the RedBlackTree balance.
	*/
	private func insertCleanUp(var z: NodeType) {
		while z.parent.red {
			if z.parent === z.parent.parent.left {
				var y: NodeType = z.parent.parent.right
				// violation 1, parent child relationship re to red
				if y.red {
					z.parent.red = false
					y.red = false
					z.parent.parent.red = true
					z = z.parent.parent
				} else {
					// case 2, parent is red, uncle is black
					if z === z.parent.right {
						z = z.parent
						leftRotate(z)
					}
					// case 3, balance colours
					z.parent.red = false
					z.parent.parent.red = true
					rightRotate(z.parent.parent)
				}
			} else {
				// symetric
				var y: NodeType = z.parent.parent.left
				// violation 1, parent child relationship re to red
				if y.red {
					z.parent.red = false
					y.red = false
					z.parent.parent.red = true
					z = z.parent.parent
				} else {
					// case 2, parent is red, uncle is black
					if z === z.parent.left {
						z = z.parent
						rightRotate(z)
					}
					// case 3, balance colours
					z.parent.red = false
					z.parent.parent.red = true
					leftRotate(z.parent.parent)
				}
			}
		}
		root.red = false
	}
	
	/**
	* internalRemove
	* Removes a node with the given key value and returns that
	* node. If the value does not exist, the sentinel is returned.
	*/
	private func internalRemove(key: Key) -> NodeType {
		var z: NodeType = internalFindByKey(key)
		if z === sentinel {
			return sentinel
		}
		
		if z !== root {
			var t: NodeType = z.parent
			while t !== root {
				--t.order
				t = t.parent
			}
			--root.order
		}
		
		
		var x: NodeType!
		var y: NodeType = z
		var red: Bool = y.red
		
		if z.left === sentinel {
			x = z.right
			transplant(z, v: z.right)
		} else if z.right === sentinel {
			x = z.left
			transplant(z, v: z.left)
		} else {
			y = minimum(z.right)
			red = y.red
			x = y.right
			if y.parent === z {
				x.parent = y
			} else {
				transplant(y, v: y.right)
				y.right = z.right
				y.right.parent = y
				var t: NodeType = x.parent
				while t !== y {
					--t.order
					t = t.parent
				}
				y.order = y.left.order + 1
			}
			transplant(z, v: y)
			y.left = z.left
			y.left.parent = y
			y.red = z.red
			y.order = y.left.order + y.right.order + 1
		}
		if !red {
			removeCleanUp(x)
		}
		--count
		return z
	}
	
	/**
	* removeCleanUp
	* After a successful removal of a node, the RedBlackTree
	* is rebalanced by this method.
	*/
	private func removeCleanUp(var x: NodeType) {
		while x !== root && !x.red {
			if x === x.parent.left {
				var y: NodeType = x.parent.right
				if y.red {
					y.red = false
					x.parent.red = true
					leftRotate(x.parent)
					y = x.parent.right
				}
				if !y.left.red && !y.right.red {
					y.red = true
					x = x.parent
				} else {
					if !y.right.red {
						y.left.red = false
						y.red = true
						rightRotate(y)
						y = x.parent.right
					}
					y.red = x.parent.red
					x.parent.red = false
					y.right.red = false
					leftRotate(x.parent)
					x = root
				}
			} else { // symetric left and right
				var y: NodeType = x.parent.left
				if y.red {
					y.red = false
					x.parent.red = true
					rightRotate(x.parent)
					y = x.parent.left
				}
				if !y.right.red && !y.left.red {
					y.red = true
					x = x.parent
				} else {
					if !y.left.red {
						y.right.red = false
						y.red = true
						leftRotate(y)
						y = x.parent.left
					}
					y.red = x.parent.red
					x.parent.red = false
					y.left.red = false
					rightRotate(x.parent)
					x = root
				}
			}
		}
		x.red = false
	}
	
	/**
	* minimum
	* Finds the minimum keyed node.
	*/
	private func minimum(var x: NodeType) -> NodeType {
		var y: NodeType = sentinel
		while x !== sentinel {
			y = x
			x = x.left
		}
		return y
	}
	
	/**
	* transplant
	* Swaps two subtrees in the tree.
	*/
	private func transplant(u: NodeType, v: NodeType) {
		if u.parent === sentinel {
			root = v
		} else if u === u.parent.left {
			u.parent.left = v
		} else {
			u.parent.right = v
		}
		v.parent = u.parent
	}
	
	/**
	* leftRotate
	* Rotates the nodes to satisfy the RedBlackTree 
	* balance property.
	*/
	private func leftRotate(x: NodeType) {
		var y: NodeType = x.right
		
		x.right = y.left
		if sentinel !== y.left {
			y.left.parent = x
		}
		
		y.parent = x.parent
		
		if sentinel === x.parent {
			root = y
		} else if x === x.parent.left {
			x.parent.left = y
		} else {
			x.parent.right = y
		}
		
		y.left = x
		x.parent = y
		y.order = x.order
		x.order = x.left.order + x.right.order + 1
	}
	
	/**
	* rightRotate
	* Rotates the nodes to satisfy the RedBlackTree
	* balance property.
	*/
	private func rightRotate(y: NodeType) {
		var x: NodeType = y.left
		
		y.left = x.right
		if sentinel !== x.right {
			x.right.parent = y
		}
		
		x.parent = y.parent
		
		if sentinel === y.parent {
			root = x
		} else if y === y.parent.right {
			y.parent.right = x
		} else {
			y.parent.left = x
		}
		
		x.right = y
		y.parent = x
		x.order = y.order
		y.order = y.left.order + y.right.order + 1
	}
	
	/**
	* internalFindByKey
	* Finds a node with a given key value.
	*/
	private func internalFindByKey(key: Key) -> NodeType {
		var z: NodeType = root
		while z !== sentinel {
			if key == z.key {
				return z
			}
			z = key < z.key ? z.left : z.right
		}
		return sentinel
	}
	
	/**
	* internalSelect
	* Internally searches for a node by the order statistic value. 
	*/
	private func internalSelect(x: NodeType, order: Int) -> NodeType {
		var r: Int = x.left.order + 1
		if order == r {
			return x
		} else if order < r {
			return internalSelect(x.left, order: order)
		}
		return internalSelect(x.right, order: order - r)
	}
	
	/**
	* isIndexValid
	* Checks the validation of the index being within range of 0...n-1.
	*/
	private func isIndexValid(index: Int) -> Bool {
		return index < startIndex || index >= endIndex
	}
}

public func +<Key: Comparable, Value>(lhs: RedBlackTree<Key, Value>, rhs: RedBlackTree<Key, Value>) -> RedBlackTree<Key, Value> {
	let rb: RedBlackTree<Key, Value> = RedBlackTree<Key, Value>()
	for var i: Int = lhs.count; i > 0; --i {
		let n: RedBlackNode<Key, Value> = lhs.select(lhs.root, order: i)
		rb.insert(n.key, value: n.value)
	}
	for var i: Int = rhs.count; i > 0; --i {
		let n: RedBlackNode<Key, Value> = rhs.select(rhs.root, order: i)
		rb.insert(n.key, value: n.value)
	}
	return rb
}