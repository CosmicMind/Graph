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

public class OrderedMultiDictionary<Key : Comparable, Value> : Probability<Key>, CollectionType, Equatable, Printable {
	internal typealias Generator = GeneratorOf<(key: Key, value: Value?)>
	
	/**
		:name:	tree
		:description:	Internal storage of (key, value) pairs.
		:returns:	MultiTree<Key, Value>
	*/
	internal var tree: MultiTree<Key, Value>
	
	/**
		:name:	description
		:description:	Conforms to the Printable Protocol. Outputs the
		data in the OrderedMultiDictionary in a readable format.
	*/
	public var description: String {
		var output: String = "OrderedMultiDictionary("
		for var i: Int = 0; i < count; ++i {
			output += "\(tree[i].value!)"
			if i + 1 != count {
				output += ", "
			}
		}
		return output + ")"
	}
	
	/**
		:name:	first
		:description:	Get the first (key, value) pair.
		k1 <= k2 <= K3 ... <= Kn
	*/
	public var first: (key: Key, value: Value?)? {
		return tree.first
	}
	
	/**
		:name:	last
		:description:	Get the last (key, value) pair.
		k1 <= k2 <= K3 ... <= Kn
	*/
	public var last: (key: Key, value: Value?)? {
		return tree.last
	}
	
	/**
		:name:	isEmpty
		:description:	A boolean of whether the OrderedMultiDictionary is empty.
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
		:description:	Constructor.
	*/
	public override init() {
		tree = MultiTree<Key, Value>()
	}
	
	/**
		:name:	init
		:description:	Constructor.
		:param:	elements	(Key, Value?)...	Initiates with a given list of elements.
	*/
	public convenience init(elements: (Key, Value?)...) {
		self.init(elements: elements)
	}
	
	/**
		:name:	init
		:description:	Constructor.
		:param:	elements	Array<(Key, Value?)>	Initiates with a given array of elements.
	*/
	public convenience init(elements: Array<(Key, Value?)>) {
		self.init()
		insert(elements)
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
		:name:	operator [key 1...key n]
		:description:	Property key mapping. If the key type is a
		String, this feature allows access like a
		Dictionary.
	*/
	public subscript(name: String) -> Value? {
		get {
			return tree[name]
		}
		set(value) {
			tree[name] = value
		}
	}
	
	/**
		:name:	operator [0...count - 1]
		:description:	Allows array like access of the index.
		Items are kept in order, so when iterating
		through the items, they are returned in their
		ordered form.
	*/
	public subscript(index: Int) -> (key: Key, value: Value?) {
		get {
			return tree[index]
		}
		set(value) {
			tree[index] = value
		}
	}
	
	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
	*/
	public override func countOf(keys: Key...) -> Int {
		return tree.countOf(keys)
	}
	
	/**
		:name:	countOf
		:description:	Conforms to ProbabilityType protocol.
	*/
	public override func countOf(keys: Array<Key>) -> Int {
		return tree.countOf(keys)
	}
	
	/**
		:name:	insert
		:description:	Inserts a list of (Key, Value?) pairs.
		:param:	elements	(Key, Value?)...	Elements to insert.
	*/
	public func insert(elements: (Key, Value?)...) {
		insert(elements)
	}
	
	/**
		:name:	insert
		:description:	Inserts an array of (Key, Value?) pairs.
		:param:	elements	Array<(Key, Value?)>	Elements to insert.
	*/
	public func insert(elements: Array<(Key, Value?)>) {
		for x in elements {
			tree.insert(x.0, value: x.1)
			count = tree.count
		}
	}
	
	/**
		:name:	removeValueForKey
		:description:	Removes a node from the tree based on the key value given.
		If the tree allows non-unique keys, then all keys matching
		the given key value will be removed.
		:returns:	Value?
	*/
	public func removeValueForKey(key: Key) -> Value? {
		var x: Value? = tree.removeValueForKey(key)
		count = tree.count
		return x
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
		All keys matching the given key value will be updated.
	*/
	public func updateValue(value: Value?, forKey: Key) -> Bool {
		return tree.updateValue(value, forKey: forKey)
	}
	
	/**
		:name:	findValueForKey
		:description:	Finds the value for key passed.
		:param:	key	Key	The key to find.
		:returns:	Value?
	*/
	public func findValueForKey(key: Key) -> Value? {
		return tree.findValueForKey(key)
	}
	
	/**
		:name:	search
		:description:	Accepts a list of keys and returns a subset
		OrderedMultiDictionary with the given values if they exist.
	*/
	public func search(keys: Key...) -> OrderedMultiDictionary<Key, Value> {
		return search(keys)
	}
	
	/**
		:name:	search
		:description:	Accepts an array of keys and returns a subset
		OrderedMultiDictionary with the given values if they exist.
	*/
	public func search(keys: Array<Key>) -> OrderedMultiDictionary<Key, Value> {
		var dict: OrderedMultiDictionary<Key, Value> = OrderedMultiDictionary<Key, Value>()
		for key: Key in keys {
			subDictionary(key, node: tree.root, dict: &dict)
		}
		return dict
	}
	
	/**
		:name:	subDictionary
		:description:	Traverses the OrderedMultiDictionary, looking for a key match.
	*/
	internal func subDictionary(key: Key, node: RedBlackNode<Key, Value>, inout dict: OrderedMultiDictionary<Key, Value>) {
		if tree.sentinel !== node {
			if key == node.key {
				dict.insert((key, node.value))
			}
			subDictionary(key, node: node.left, dict: &dict)
			subDictionary(key, node: node.right, dict: &dict)
		}
	}
}

public func ==<Key: Comparable, Value>(lhs: OrderedMultiDictionary<Key, Value>, rhs: OrderedMultiDictionary<Key, Value>) -> Bool {
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

public func ==<Key: Comparable, Value: Comparable>(lhs: OrderedMultiDictionary<Key, Value>, rhs: OrderedMultiDictionary<Key, Value>) -> Bool {
	if lhs.count != rhs.count {
		return false
	}
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		let l: (key: Key, value: Value?) = lhs[i]
		let r: (key: Key, value: Value?) = rhs[i]
		if l.key != r.key || l.value != r.value {
			return false
		}
	}
	return true
}

public func +<Key : Comparable, Value>(lhs: OrderedMultiDictionary<Key, Value>, rhs: OrderedMultiDictionary<Key, Value>) -> OrderedMultiDictionary<Key, Value> {
	let t: OrderedMultiDictionary<Key, Value> = OrderedMultiDictionary<Key, Value>()
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

public func -<Key : Comparable, Value>(lhs: OrderedMultiDictionary<Key, Value>, rhs: OrderedMultiDictionary<Key, Value>) -> OrderedMultiDictionary<Key, Value> {
	let t: OrderedMultiDictionary<Key, Value> = OrderedMultiDictionary<Key, Value>()
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
