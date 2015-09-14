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

// #internal

internal class RedBlackNode<Key : Comparable, Value> : Comparable, Equatable, CustomStringConvertible {
	/**
		:name:	parent
		:description:	A reference to the parent node of a given node.
		- returns:	RedBlackNode<Key, Value>!
	*/
	internal var parent: RedBlackNode<Key, Value>!

	/**
		:name:	left
		:description:	A reference to the left child node of a given node.
		- returns:	RedBlackNode<Key, Value>!
	*/
	internal var left: RedBlackNode<Key, Value>!

	/**
		:name:	right
		:description:	A reference to the right child node of a given node.
		- returns:	RedBlackNode<Key, Value>!
	*/
	internal var right: RedBlackNode<Key, Value>!

	/**
		:name:	isRed
		:description:	A boolean indicating whether te node is marked isRed or black.
		- returns:	Bool
	*/
	internal var isRed: Bool

	/**
		:name:	order
		:description:	Used to track the order statistic of a node, which maintains
		key order in the tree.
		- returns:	Int
	*/
	internal var order: Int

	/**
		:name:	key
		:description:	A reference to the key value of the node, which is what organizes
		a node in a given tree.
		- returns:	Key!
	*/
	internal var key: Key!

	/**
		:name:	value
		:description:	Satellite data stoisRed in the node.
		- returns:	Value?
	*/
	internal var value: Value?

	/**
		:name:	description
		:description:	Conforms to the Printable Protocol.
		- returns:	String
	*/
	internal var description: String {
		return "(\(key), \(value))"
	}

	/**
		:name:	init
		:description:	Constructor used for sentinel nodes.
	*/
	internal init() {
		isRed = false
		order = 0
	}

	/**
		:name:	init
		:description:	Constructor used for nodes that store data.
	*/
	internal init(parent: RedBlackNode<Key, Value>, sentinel: RedBlackNode<Key, Value>, key: Key, value: Value?) {
		self.key = key
		self.value = value
		self.parent = parent
		left = sentinel
		right = sentinel
		isRed = true
		order = 1
	}
}

func ==<Key : Comparable, Value>(lhs: RedBlackNode<Key, Value>, rhs: RedBlackNode<Key, Value>) -> Bool {
	return lhs.key == rhs.key
}

func <=<Key : Comparable, Value>(lhs: RedBlackNode<Key, Value>, rhs: RedBlackNode<Key, Value>) -> Bool {
	return lhs.key <= rhs.key
}

func >=<Key : Comparable, Value>(lhs: RedBlackNode<Key, Value>, rhs: RedBlackNode<Key, Value>) -> Bool {
	return lhs.key >= rhs.key
}

func ><Key : Comparable, Value>(lhs: RedBlackNode<Key, Value>, rhs: RedBlackNode<Key, Value>) -> Bool {
	return lhs.key > rhs.key
}

func <<Key : Comparable, Value>(lhs: RedBlackNode<Key, Value>, rhs: RedBlackNode<Key, Value>) -> Bool {
	return lhs.key < rhs.key
}
