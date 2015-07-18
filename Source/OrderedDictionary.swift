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

public class OrderedDictionary<Key : Comparable, Value> : Probability<Key>, Printable {
	internal typealias Generator = GeneratorOf<(key: Key, value: Value?)>
	
	/**
	:name:	tree
	:description:	Internal storage of members.
	:returns:	Tree<Key, Value>
	*/
	internal var tree: Tree<Key, Value>
	
	/**
	:name:	description
	:description:	Conforms to the Printable Protocol. Outputs the
	data in the OrderedDictionary in a readable format.
	*/
	public var description: String {
		var output: String = "OrderedDictionary("
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
	:description:	Get the first node value in the tree, this is
	the first node based on the order of keys where
	k1 <= k2 <= K3 ... <= Kn
	*/
	public var first: (key: Key, value: Value?)? {
		return tree.first
	}
	
	/**
	:name:	last
	:description:	Get the last node value in the tree, this is
	the last node based on the order of keys where
	k1 <= k2 <= K3 ... <= Kn
	*/
	public var last: (key: Key, value: Value?)? {
		return tree.last
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
	:description:	Constructor.
	*/
	public override init() {
		tree = Tree<Key, Value>()
	}
	
	public convenience init(dictionaryLiteral elements: (Key, Value?)...) {
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
	:name:	operator ["key1"..."keyN"]
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
	If the tree allows non-unique keys, then all keys matching
	the given key value will be updated.
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
	:description:	Accepts a paramter list of keys and returns a subset
	Tree with the indicated values if
	they exist.
	*/
	public func search(keys: Key...) -> OrderedDictionary<Key, Value> {
		return search(keys)
	}
	
	/**
	:name:	search
	:description:	Accepts an array of keys and returns a subset
	Tree with the indicated values if
	they exist.
	*/
	public func search(keys: Array<Key>) -> OrderedDictionary<Key, Value> {
		var dict: OrderedDictionary<Key, Value> = OrderedDictionary<Key, Value>()
		for key: Key in keys {
			subtree(key, node: tree.root, dict: &dict)
		}
		return dict
	}
	
	/**
	:name:	subtree
	:description:	Traverses the Tree and looking for a key value.
	This is used for internal search.
	*/
	internal func subtree(key: Key, node: RedBlackNode<Key, Value>, inout dict: OrderedDictionary<Key, Value>) {
		if tree.sentinel !== node {
			if key == node.key {
				dict.insert((key, node.value))
			}
			subtree(key, node: node.left, dict: &dict)
			subtree(key, node: node.right, dict: &dict)
		}
	}
}
