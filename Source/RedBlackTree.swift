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
*/

public class RedBlackTree<Key : Comparable, Value> : Probability<Key>, CollectionType, Printable {
	internal typealias Generator = GeneratorOf<(key: Key, value: Value?)>

	/**
		:name:	sentinel
		:description:	A node used to mark the end of a path in the tree.
	*/
	internal private(set) var sentinel: RedBlackNode<Key, Value>

	/**
		:name:	root
		:description:	The root of the tree data structure.
	*/
	internal private(set) var root: RedBlackNode<Key, Value>

	/**
		:name:	isUnique
		:description:	A boolean used to indicate whether to allow the
		tree to store non-unique key values or only unique
		key values.
	*/
	public private(set) var isUnique: Bool

	/**
		:name:	internalDescription
		:description:	Returns a String with only the node data for all
		nodes in the Tree.
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
		:name:	description
		:description:	Conforms to the Printable Protocol. Outputs the
		data in the Tree in a readable format.
	*/
	public var description: String {
		return "RedBlackTree" + internalDescription
	}

	/**
		:name:	first
		:description:	Get the first node value in the tree, this is
		the first node based on the order of keys where
		k1 <= k2 <= Key3 ... <= Keyn
		:returns:	(key: Key, value: Value?)?
	*/
	public var first: (key: Key, value: Value?)? {
		return self[0]
	}

	/**
		:name:	last
		:description:	Get the last node value in the tree, this is
		the last node based on the order of keys where
		k1 <= k2 <= Key3 ... <= Keyn
		:returns:	(key: Key, value: Value?)?
	*/
	public var last: (key: Key, value: Value?)? {
		return isEmpty ? nil : self[count - 1]
	}

	/**
		:name:	isEmpty
		:description:	A boolean of whether the RedBlackTree is empty.
	*/
	public var isEmpty: Bool {
		return 0 == count
	}

	/**
		:name:	startIndex
		:description:	Conforms to the CollectionType Protocol.
	*/
	public var startIndex: Int {
		return 0
	}

	/**
		:name:	endIndex
		:description:	Conforms to the CollectionType Protocol.
	*/
	public var endIndex: Int {
		return count
	}

	/**
		:name:	init
		:description:	Constructor where the tree is guaranteed to store
		non-unique keys.
	*/
	public override init() {
		isUnique = false
		sentinel = RedBlackNode<Key, Value>()
		root = sentinel
	}

	/**
		:name:	init
		:description:	Constructor where the tree is optionally allowed
		to store uniqe or non-unique keys.
		:param:	uniqueKeys	Bool	Set the keys to be unique.
	*/
	public init(uniqueKeys: Bool) {
		isUnique = uniqueKeys
		sentinel = RedBlackNode<Key, Value>()
		root = sentinel
	}

	/**
		:name:	generate
		:description:	Conforms to the SequenceType Protocol. Returns
		the next value in the sequence of nodes using
		index values [0...n-1].
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
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
	*/
	public override func countOf(keys: Key...) -> Int {
		return countOf(keys)
	}

	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
	*/
	public override func countOf(keys: Array<Key>) -> Int {
		var count: Int = 0
		for key in keys {
			internalCount(key, node: root, count: &count)
		}
		return count
	}

	/**
		:name:	insert
		:description:	Insert a node in the tree.
	*/
	public func insert(key: Key, value: Value?) -> Bool {
		return sentinel !== internalInsert(key, value: value)
	}

	/**
		:name:	removeValueForKey
		:description:	Removes a node from the tree based on the key value given.
		If the tree allows non-unique keys, then all keys matching
		the given key value will be removed.
		:returns:	Value?
	*/
	public func removeValueForKey(key: Key) -> Value? {
		var removed: RedBlackNode<Key, Value>?
		var x: RedBlackNode<Key, Value>?
		while sentinel !== x {
			removed = x
			x = internalRemove(key)
		}
		return removed?.value
	}

	/**
		:name:	removeAll
		:description:	Remove all nodes from the tree.
	*/
	public func removeAll() {
		while sentinel !== root {
			internalRemove(root.key)
		}
	}

	/**
		:name:	updateValue
		:description:	Updates a node for the given key value.
		If the tree allows non-unique keys, then all keys matching
		the given key value will be updated.
	*/
	public func updateValue(value: Value?, forKey: Key) -> Bool {
		var updated: Bool = false
		var x: RedBlackNode<Key, Value> = root
		while x !== sentinel {
			if forKey == x.key {
				x.value = value
				updated = true
			}
			x = forKey < x.key ? x.left : x.right
		}
		return updated
	}

	/**
		:name:	findValueForKey
		:description:	Finds the first instance in a non-unique tree and only instance
		in isUnique tree of a given keyed node.
	*/
	public func findValueForKey(key: Key) -> Value? {
		return internalFindByKey(key).value
	}

	/**
		:name:	operator [0...count - 1]
		:description:	Allows array like access of the index.
		Items are kept in order, so when iterating
		through the items, they are returned in their
		ordeisRed form.
	*/
	public subscript(index: Int) -> (key: Key, value: Value?) {
		get {
			if !isIndexValid(index) {
				let x: RedBlackNode<Key, Value> = internalSelect(root, order: index + 1)
				return (x.key, x.value)
			} else {
				assert(false, "[GraphKit Error: Index out of bounds.]")
			}
		}
		set(element) {
			if !isIndexValid(index) {
				let x: RedBlackNode<Key, Value> = internalSelect(root, order: index + 1)
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
		:name:	operator ["key1"..."keyN"]
		:description:	Property key mapping. If the key type is a
		String, this feature allows access like a
		Dictionary.
	*/
	public subscript(name: String) -> Value? {
		get {
			return internalFindByKey(name as! Key).value
		}
		set(value) {
			let node: RedBlackNode<Key, Value> = internalFindByKey(name as! Key)
			if sentinel === node {
				insert(name as! Key, value: value!)
			} else {
				node.value = value
			}
		}
	}

	/**
		:name:	select
		:description:	Searches for a node based on the order statistic value.
	*/
	internal func select(x: RedBlackNode<Key, Value>, order: Int) -> RedBlackNode<Key, Value> {
		return internalSelect(x, order: order)
	}

	/**
		:name:	internalInsert
		:description:	Insert a new node with the given key and value.
	*/
	private func internalInsert(key: Key, value: Value?) -> RedBlackNode<Key, Value> {
		if isUnique && sentinel !== internalFindByKey(key) {
			return sentinel;
		}

		var y: RedBlackNode<Key, Value> = sentinel
		var x: RedBlackNode<Key, Value> = root

		while x !== sentinel {
			y = x
			++y.order
			x = key < x.key ? x.left : x.right
		}

		var z: RedBlackNode<Key, Value> = RedBlackNode<Key, Value>(parent: y, sentinel: sentinel, key: key, value: value)

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
		:name:	insertCleanUp
		:description:	The clean up procedure needed to maintain the RedBlackTree balance.
	*/
	private func insertCleanUp(var z: RedBlackNode<Key, Value>) {
		while z.parent.isRed {
			if z.parent === z.parent.parent.left {
				var y: RedBlackNode<Key, Value> = z.parent.parent.right
				// violation 1, parent child relationship re to isRed
				if y.isRed {
					z.parent.isRed = false
					y.isRed = false
					z.parent.parent.isRed = true
					z = z.parent.parent
				} else {
					// case 2, parent is isRed, uncle is black
					if z === z.parent.right {
						z = z.parent
						leftRotate(z)
					}
					// case 3, balance colours
					z.parent.isRed = false
					z.parent.parent.isRed = true
					rightRotate(z.parent.parent)
				}
			} else {
				// symetric
				var y: RedBlackNode<Key, Value> = z.parent.parent.left
				// violation 1, parent child relationship re to isRed
				if y.isRed {
					z.parent.isRed = false
					y.isRed = false
					z.parent.parent.isRed = true
					z = z.parent.parent
				} else {
					// case 2, parent is isRed, uncle is black
					if z === z.parent.left {
						z = z.parent
						rightRotate(z)
					}
					// case 3, balance colours
					z.parent.isRed = false
					z.parent.parent.isRed = true
					leftRotate(z.parent.parent)
				}
			}
		}
		root.isRed = false
	}

	/**
		:name:	internalRemove
		:description:	Removes a node with the given key value and returns that
		node. If the value does not exist, the sentinel is returned.
	*/
	private func internalRemove(key: Key) -> RedBlackNode<Key, Value> {
		var z: RedBlackNode<Key, Value> = internalFindByKey(key)
		if z === sentinel {
			return sentinel
		}

		if z !== root {
			var t: RedBlackNode<Key, Value> = z.parent
			while t !== root {
				--t.order
				t = t.parent
			}
			--root.order
		}


		var x: RedBlackNode<Key, Value>!
		var y: RedBlackNode<Key, Value> = z
		var isRed: Bool = y.isRed

		if z.left === sentinel {
			x = z.right
			transplant(z, v: z.right)
		} else if z.right === sentinel {
			x = z.left
			transplant(z, v: z.left)
		} else {
			y = minimum(z.right)
			isRed = y.isRed
			x = y.right
			if y.parent === z {
				x.parent = y
			} else {
				transplant(y, v: y.right)
				y.right = z.right
				y.right.parent = y
				var t: RedBlackNode<Key, Value> = x.parent
				while t !== y {
					--t.order
					t = t.parent
				}
				y.order = y.left.order + 1
			}
			transplant(z, v: y)
			y.left = z.left
			y.left.parent = y
			y.isRed = z.isRed
			y.order = y.left.order + y.right.order + 1
		}
		if !isRed {
			removeCleanUp(x)
		}
		--count
		return z
	}

	/**
		:name:	removeCleanUp
		:description:	After a successful removal of a node, the RedBlackTree
		is rebalanced by this method.
	*/
	private func removeCleanUp(var x: RedBlackNode<Key, Value>) {
		while x !== root && !x.isRed {
			if x === x.parent.left {
				var y: RedBlackNode<Key, Value> = x.parent.right
				if y.isRed {
					y.isRed = false
					x.parent.isRed = true
					leftRotate(x.parent)
					y = x.parent.right
				}
				if !y.left.isRed && !y.right.isRed {
					y.isRed = true
					x = x.parent
				} else {
					if !y.right.isRed {
						y.left.isRed = false
						y.isRed = true
						rightRotate(y)
						y = x.parent.right
					}
					y.isRed = x.parent.isRed
					x.parent.isRed = false
					y.right.isRed = false
					leftRotate(x.parent)
					x = root
				}
			} else { // symetric left and right
				var y: RedBlackNode<Key, Value> = x.parent.left
				if y.isRed {
					y.isRed = false
					x.parent.isRed = true
					rightRotate(x.parent)
					y = x.parent.left
				}
				if !y.right.isRed && !y.left.isRed {
					y.isRed = true
					x = x.parent
				} else {
					if !y.left.isRed {
						y.right.isRed = false
						y.isRed = true
						leftRotate(y)
						y = x.parent.left
					}
					y.isRed = x.parent.isRed
					x.parent.isRed = false
					y.left.isRed = false
					rightRotate(x.parent)
					x = root
				}
			}
		}
		x.isRed = false
	}

	/**
		:name:	minimum
		:description:	Finds the minimum keyed node.
	*/
	private func minimum(var x: RedBlackNode<Key, Value>) -> RedBlackNode<Key, Value> {
		var y: RedBlackNode<Key, Value> = sentinel
		while x !== sentinel {
			y = x
			x = x.left
		}
		return y
	}

	/**
		:name:	transplant
		:description:	Swaps two subTrees in the tree.
	*/
	private func transplant(u: RedBlackNode<Key, Value>, v: RedBlackNode<Key, Value>) {
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
		:name:	leftRotate
		:description:	Rotates the nodes to satisfy the RedBlackTree
		balance property.
	*/
	private func leftRotate(x: RedBlackNode<Key, Value>) {
		var y: RedBlackNode<Key, Value> = x.right

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
		:name:	rightRotate
		:description:	Rotates the nodes to satisfy the RedBlackTree
		balance property.
	*/
	private func rightRotate(y: RedBlackNode<Key, Value>) {
		var x: RedBlackNode<Key, Value> = y.left

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
		:name:	internalFindByKey
		:description:	Finds a node with a given key value.
	*/
	private func internalFindByKey(key: Key) -> RedBlackNode<Key, Value> {
		var z: RedBlackNode<Key, Value> = root
		while z !== sentinel {
			if key == z.key {
				return z
			}
			z = key < z.key ? z.left : z.right
		}
		return sentinel
	}

	/**
		:name:	internalSelect
		:description:	Internally searches for a node by the order statistic value.
	*/
	private func internalSelect(x: RedBlackNode<Key, Value>, order: Int) -> RedBlackNode<Key, Value> {
		var r: Int = x.left.order + 1
		if order == r {
			return x
		} else if order < r {
			return internalSelect(x.left, order: order)
		}
		return internalSelect(x.right, order: order - r)
	}

	/**
		:name:	internalCount
		:description:	Traverses the Tree while counting number of times a key appears.
	*/
	private func internalCount(key: Key, node: RedBlackNode<Key, Value>, inout count: Int) {
		if sentinel !== node {
			if key == node.key {
				++count
			}
			internalCount(key, node: node.left, count: &count)
			internalCount(key, node: node.right, count: &count)
		}
	}

	/**
		:name:	isIndexValid
		:description:	Checks the validation of the index being within range of 0...n-1.
	*/
	private func isIndexValid(index: Int) -> Bool {
		return index < startIndex || index >= endIndex
	}
}

public func ==<Key : Comparable, Value>(lhs: RedBlackTree<Key, Value>, rhs: RedBlackTree<Key, Value>) -> Bool {
	if lhs.count != rhs.count {
		return false
	}
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		if lhs[i].key != rhs[i].key {
			return false
		}
	}
	return true
}

public func +<Key : Comparable, Value>(lhs: RedBlackTree<Key, Value>, rhs: RedBlackTree<Key, Value>) -> RedBlackTree<Key, Value> {
	let t: RedBlackTree<Key, Value> = RedBlackTree<Key, Value>()
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = lhs[i]
		t.insert(n.key, value: n.value)
	}
	for var i: Int = rhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = rhs[i]
		t.insert(n.key, value: n.value)
	}
	return t
}

public func -<Key : Comparable, Value>(lhs: RedBlackTree<Key, Value>, rhs: RedBlackTree<Key, Value>) -> RedBlackTree<Key, Value> {
	let t: RedBlackTree<Key, Value> = RedBlackTree<Key, Value>()
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = lhs[i]
		t.insert(n.key, value: n.value)
	}
	for var i: Int = rhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = rhs[i]
		t.removeValueForKey(n.key)
	}
	return t
}
