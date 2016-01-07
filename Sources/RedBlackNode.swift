/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of GraphKit nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
