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
	internal typealias RBNode = RedBlackNode<K, V>
	
	/**
	* parent
	* A reference to the parent node of a given node.
	*/
	internal var parent: RBNode!
	
	/**
	* left
	* A reference to the left child node of a given node.
	*/
	internal var left: RBNode!
	
	/**
	* right
	* A reference to the right child node of a given node.
	*/
	internal var right: RBNode!
	
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
	* data
	* Satellite data stored in the node.
	*/
	internal var data: V?
	
	/**
	* description
	* Conforms to the Printable Protocol.
	*/
	internal var description: String {
		return "{\(key): \(data)}"
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
	* @param		parent: RedBlackNode<K, V>
	* @param		sentinel: RedBlackNode<K, V>
	* @param		key: K
	* @param		data: V?
	*/
	internal init(parent: RBNode, sentinel: RBNode, key: K, data: V?) {
		self.key = key
		self.data = data
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
