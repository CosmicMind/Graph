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
* RedBlackNode
*
* Used internally by the RedBlackTree data structure to store pointers to nodes and satellite
* data.
*/

internal class RedBlackNode<K: Comparable, V>: Comparable, Equatable, Printable {
	internal typealias NodeType = RedBlackNode<K, V>
	
	/**
	* parent
	* A reference to the parent node of a given node.
	*/
	internal var parent: NodeType!
	
	/**
	* left
	* A reference to the left child node of a given node.
	*/
	internal var left: NodeType!
	
	/**
	* right
	* A reference to the right child node of a given node.
	*/
	internal var right: NodeType!
	
	/**
	* red
	* A boolean indicating whether te node is marked red or black.
	*/
	internal var red: Bool
	
	/**
	* order
	* Used to track the order statistic of a node, which maintains
	* key order in the tree.
	*/
	internal var order: Int
	
	/**
	* key
	* A reference to the key value of the node, which is what organizes
	* a node in a given tree.
	*/
	internal var key: K! = nil
	
	/**
	* value
	* Satellite data stored in the node.
	*/
	internal var value: V?
	
	/**
	* description
	* Conforms to the Printable Protocol.
	*/
	internal var description: String {
		return "[\(key): \(value)]"
	}
	
	/**
	* init
	* Constructor used for sentinel nodes.
	*/
	internal init() {
		red = false
		order = 0
	}
	
	/**
	* init
	* Constructor used for nodes that store data.
	* @param		parent: NodeType
	* @param		sentinel: NodeType
	* @param		key: K
	* @param		value: V?
	*/
	internal init(parent: NodeType, sentinel: NodeType, key: K, value: V?) {
		self.key = key
		self.value = value
		self.parent = parent
		left = sentinel
		right = sentinel
		red = true
		order = 1
	}
}

/**
* ==
* Conforms to the Comparable Protocol.
*/
func == <K: Comparable, V>(lhs: RedBlackNode<K, V>, rhs: RedBlackNode<K, V>) -> Bool {
	return lhs.key == rhs.key
}

/**
* <=
* Conforms to the Comparable Protocol.
*/
func <= <K: Comparable, V>(lhs: RedBlackNode<K, V>, rhs: RedBlackNode<K, V>) -> Bool {
	return lhs.key <= rhs.key
}

/**
* >=
* Conforms to the Comparable Protocol.
*/
func >= <K: Comparable, V>(lhs: RedBlackNode<K, V>, rhs: RedBlackNode<K, V>) -> Bool {
	return lhs.key >= rhs.key
}

/**
* >
* Conforms to the Comparable Protocol.
*/
func > <K: Comparable, V>(lhs: RedBlackNode<K, V>, rhs: RedBlackNode<K, V>) -> Bool {
	return lhs.key > rhs.key
}

/**
* <
* Conforms to the Comparable Protocol.
*/
func < <K: Comparable, V>(lhs: RedBlackNode<K, V>, rhs: RedBlackNode<K, V>) -> Bool {
	return lhs.key < rhs.key
}
