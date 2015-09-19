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

public class OrderedDictionary<Key : Comparable, Value> : Probability<Key>, CollectionType, Equatable, CustomStringConvertible {
	public typealias Generator = AnyGenerator<(key: Key, value: Value?)>
	public typealias OrderedKey = OrderedSet<Key>
	public typealias OrderedValue = Array<Value>
	public typealias OrderedSearch = OrderedDictionary<Key, Value>
	internal typealias OrderedNode = RedBlackNode<Key, Value>
	
	/**
		:name:	tree
		:description:	Internal storage of (key, value) pairs.
		- returns:	RedBlackTree<Key, Value>
	*/
	internal var tree: RedBlackTree<Key, Value>
	
	/**
		:name:	description
		:description:	Conforms to the Printable Protocol. Outputs the
		data in the OrderedDictionary in a readable format.
		- returns:	String
	*/
	public var description: String {
		return tree.internalDescription
	}
	
	/**
		:name:	first
		:description:	Get the first (key, value) pair.
		k1 <= k2 <= K3 ... <= Kn
		- returns:	(key: Key, value: Value?)?
	*/
	public var first: (key: Key, value: Value?)? {
		return tree.first
	}
	
	/**
		:name:	last
		:description:	Get the last (key, value) pair.
		k1 <= k2 <= K3 ... <= Kn
		- returns:	(key: Key, value: Value?)?
	*/
	public var last: (key: Key, value: Value?)? {
		return tree.last
	}
	
	/**
		:name:	isEmpty
		:description:	A boolean of whether the OrderedDictionary is empty.
		- returns:	Bool
	*/
	public var isEmpty: Bool {
		return 0 == count
	}
	
	/**
		:name:	startIndex
		:description:	Conforms to the CollectionType Protocol.
		- returns:	Int
	*/
	public var startIndex: Int {
		return 0
	}
	
	/**
		:name:	endIndex
		:description:	Conforms to the CollectionType Protocol.
		- returns:	Int
	*/
	public var endIndex: Int {
		return count
	}
	
	/**
		:name:	keys
		:description:	Returns an array of the key values in ordered.
		- returns:	OrderedDictionary.OrderedKey
	*/
	public var keys: OrderedDictionary.OrderedKey {
		let s: OrderedKey = OrderedKey()
		for x in self {
			s.insert(x.key)
		}
		return s
	}
	
	/**
		:name:	values
		:description:	Returns an array of the values that are ordered based
		on the key ordering.
		- returns:	OrderedDictionary.OrderedValue
	*/
	public var values: OrderedDictionary.OrderedValue {
		var s: OrderedValue = OrderedValue()
		for x in self {
			s.append(x.value!)
		}
		return s
	}
	
	/**
		:name:	init
		:description:	Constructor.
	*/
	public override init() {
		tree = RedBlackTree<Key, Value>(uniqueKeys: true)
	}
	
	/**
		:name:	init
		:description:	Constructor.
		- parameter	elements:	(Key, Value?)...	Initiates with a given list of elements.
	*/
	public convenience init(elements: (Key, Value?)...) {
		self.init(elements: elements)
	}
	
	/**
		:name:	init
		:description:	Constructor.
		- parameter	elements:	Array<(Key, Value?)>	Initiates with a given array of elements.
	*/
	public convenience init(elements: Array<(Key, Value?)>) {
		self.init()
		insert(elements)
	}
	
	//
	//	:name:	generate
	//	:description:	Conforms to the SequenceType Protocol. Returns
	//	the next value in the sequence of nodes using
	//	index values [0...n-1].
	//	:returns:	OrderedDictionary.Generator
	//
	public func generate() -> OrderedDictionary.Generator {
		var index = startIndex
		return anyGenerator {
			if index < self.endIndex {
				return self[index++]
			}
			return nil
		}
	}
	
	/**
		:name:	operator [key 1...key n]
		:description:	Property key mapping. If the key type is a
		String, this feature allows access like a
		Dictionary.
		- returns:	Value?
	*/
	public subscript(key: Key) -> Value? {
		get {
			return tree[key]
		}
		set(value) {
			tree[key] = value
			count = tree.count
		}
	}
	
	/**
		:name:	operator [0...count - 1]
		:description:	Allows array like access of the index.
		Items are kept in order, so when iterating
		through the items, they are returned in their
		ordered form.
		- returns:	(key: Key, value: Value?)
	*/
	public subscript(index: Int) -> (key: Key, value: Value?) {
		get {
			return tree[index]
		}
		set(value) {
			tree[index] = value
			count = tree.count
		}
	}
	
	/**
		:name:	indexOf
		:description:	Returns the Index of a given member, or -1 if the member is not present in the set.
		- returns:	Int
	*/
	public func indexOf(key: Key) -> Int {
		return tree.indexOf(key)
	}
	
	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
		- returns:	Int
	*/
	public override func countOf(keys: Key...) -> Int {
		return tree.countOf(keys)
	}
	
	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
		- returns:	Int
	*/
	public override func countOf(keys: Array<Key>) -> Int {
		return tree.countOf(keys)
	}
	
	/**
		:name:	insert
		:description:	Insert a key / value pair.
		- returns:	Bool
	*/
	public func insert(key: Key, value: Value?) -> Bool {
		let result: Bool = tree.insert(key, value: value)
		count = tree.count
		return result
	}
	
	/**
		:name:	insert
		:description:	Inserts a list of (Key, Value?) pairs.
		- parameter	elements:	(Key, Value?)...	Elements to insert.
	*/
	public func insert(elements: (Key, Value?)...) {
		insert(elements)
	}
	
	/**
		:name:	insert
		:description:	Inserts an array of (Key, Value?) pairs.
		- parameter	elements:	Array<(Key, Value?)>	Elements to insert.
	*/
	public func insert(elements: Array<(Key, Value?)>) {
		tree.insert(elements)
		count = tree.count
	}
	
	/**
		:name:	removeValueForKeys
		:description:	Removes key / value pairs based on the key value given.
		- returns:	OrderedDictionary<Key, Value>?
	*/
	public func removeValueForKeys(keys: Key...) -> OrderedDictionary<Key, Value>? {
		return removeValueForKeys(keys)
	}
	
	/**
		:name:	removeValueForKeys
		:description:	Removes key / value pairs based on the key value given.
		- returns:	OrderedDictionary<Key, Value>?
	*/
	public func removeValueForKeys(keys: Array<Key>) -> OrderedDictionary<Key, Value>? {
		if let r: RedBlackTree<Key, Value> = tree.removeValueForKeys(keys) {
			let d: OrderedDictionary<Key, Value> = OrderedDictionary<Key, Value>()
			for (k, v) in r {
				d.insert(k, value: v)
			}
			count = tree.count
			return d
		}
		return nil
	}
	
	/**
		:name:	removeAll
		:description:	Remove all nodes from the tree.
	*/
	public func removeAll() {
		tree.removeAll()
		count = tree.count
	}
	
	/**
		:name:	updateValue
		:description:	Updates a node for the given key value.
	*/
	public func updateValue(value: Value?, forKey: Key) {
		tree.updateValue(value, forKey: forKey)
	}
	
	/**
		:name:	findValueForKey
		:description:	Finds the value for key passed.
		- parameter	key:	Key	The key to find.
		- returns:	Value?
	*/
	public func findValueForKey(key: Key) -> Value? {
		return tree.findValueForKey(key)
	}
	
	/**
		:name:	search
		:description:	Accepts a list of keys and returns a subset
		OrderedDictionary with the given values if they exist.
		- returns:	OrderedDictionary.OrderedSearch
	*/
	public func search(keys: Key...) -> OrderedDictionary.OrderedSearch {
		return search(keys)
	}
	
	/**
		:name:	search
		:description:	Accepts an array of keys and returns a subset
		OrderedDictionary with the given values if they exist.
		- returns:	OrderedDictionary.OrderedSearch
	*/
	public func search(keys: Array<Key>) -> OrderedDictionary.OrderedSearch {
		var dict: OrderedSearch = OrderedSearch()
		for key: Key in keys {
			traverse(key, node: tree.root, dict: &dict)
		}
		return dict
	}
	
	/**
		:name:	traverse
		:description:	Traverses the OrderedDictionary, looking for a key match.
	*/
	internal func traverse(key: Key, node: OrderedDictionary.OrderedNode, inout dict: OrderedDictionary.OrderedSearch) {
		if tree.sentinel !== node {
			if key == node.key {
				dict.insert((key, node.value))
			}
			traverse(key, node: node.left, dict: &dict)
			traverse(key, node: node.right, dict: &dict)
		}
	}
}

public func ==<Key : Comparable, Value>(lhs: OrderedDictionary<Key, Value>, rhs: OrderedDictionary<Key, Value>) -> Bool {
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

public func +<Key : Comparable, Value>(lhs: OrderedDictionary<Key, Value>, rhs: OrderedDictionary<Key, Value>) -> OrderedDictionary<Key, Value> {
	let t: OrderedDictionary<Key, Value> = OrderedDictionary<Key, Value>()
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = lhs[i]
		t.insert((n.key, n.value))
	}
	for var i: Int = rhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = rhs[i]
		t.insert((n.key, n.value))
	}
	return t
}

public func +=<Key : Comparable, Value>(lhs: OrderedDictionary<Key, Value>, rhs: OrderedDictionary<Key, Value>) {
	for var i: Int = rhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = rhs[i]
		lhs.insert((n.key, n.value))
	}
}

public func -<Key : Comparable, Value>(lhs: OrderedDictionary<Key, Value>, rhs: OrderedDictionary<Key, Value>) -> OrderedDictionary<Key, Value> {
	let t: OrderedDictionary<Key, Value> = OrderedDictionary<Key, Value>()
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = lhs[i]
		t.insert((n.key, n.value))
	}
	for var i: Int = rhs.count - 1; 0 <= i; --i {
		t.removeValueForKeys(rhs[i].key)
	}
	return t
}

public func -=<Key : Comparable, Value>(lhs: OrderedDictionary<Key, Value>, rhs: OrderedDictionary<Key, Value>) {
	for var i: Int = rhs.count - 1; 0 <= i; --i {
		lhs.removeValueForKeys(rhs[i].key)
	}
}
