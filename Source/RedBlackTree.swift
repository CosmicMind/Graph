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
*/

internal class RedBlackTree<K: Comparable, V>: Printable {
	internal typealias RBTree = RedBlackTree<K, V>
	internal typealias RBNode = RedBlackNode<K, V>
	
	internal private(set) var sentinel: RBNode
	internal private(set) var root: RBNode
	internal private(set) var count: Int
	internal private(set) var unique: Bool
	
	internal var description: String {
		var output: String = "RedBlackTree("
		for (var i: Int = 1; i <= count; ++i) {
			output += internalSelect(root, order: i).description
			if i != count {
				output += ","
			}
		}
		return output + ")"
	}
	
	internal var last: V? {
		if count == 0 {
			return sentinel.data
		}
		return internalSelect(root, order: count).data
	}
	
	internal var first: V? {
		return internalSelect(root, order: 1).data
	}
	
	/**
	* empty
	* A boolean if the RedBlackTree is empty.
	*/
	internal var empty: Bool {
		return 0 == count
	}
	
	internal init() {
		unique = false
		sentinel = RBNode()
		root = sentinel
		count = 0
	}
	
	internal init(unique: Bool) {
		self.unique = unique
		sentinel = RBNode()
		root = sentinel
		count = 0
	}
	
	internal func clear() {
		while sentinel !== root {
			internalRemove(root.key)
		}
	}
	
	internal func insert(key: K, data: V?) -> Bool {
		return sentinel !== internalInsert(key, data: data)
	}
	
	internal func remove(key: K) -> Bool {
		var removed: Bool = false
		while sentinel !== internalRemove(key) {
			removed = true
		}
		return removed
	}
	
	internal func find(key: K) -> V? {
		return internalFindByKey(key).data
	}
	
	internal func select(var x: RBNode, order: Int) -> RBNode {
		return internalSelect(x, order: order)
	}
	
	internal subscript(index: Int) -> V? {
		get {
			if index < 0 || index >= count {
				assert(false, "[AlgoKit Error: Index out of bounds.]")
			}
			return internalSelect(root, order: index + 1).data
		}
	}
	
	internal subscript(name: String) -> V? {
		get {
			return internalFindByKey(name as! K).data
		}
		set(value) {
			let node: RBNode = internalFindByKey(name as! K)
			if sentinel === node {
				insert(name as! K, data: value!)
			} else {
				node.data = value
			}
		}
	}
	
	private func internalInsert(key: K, data: V?) -> RBNode {
		var y: RBNode = sentinel
		var x: RBNode = root
		
		if true == unique {
			while x !== sentinel {
				y = x
				++y.order
				if key == x.key {
					while x !== root {
						--x.order
						x = x.parent
					}
					--x.order
					return sentinel
				}
				x = key < x.key ? x.left : x.right
			}
		} else {
			while x !== sentinel {
				y = x
				++y.order
				x = key < x.key ? x.left : x.right
			}
		}
		
		var z: RBNode = RBNode(parent: y, sentinel: sentinel, key: key, data: data)
		
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
	
	private func insertCleanUp(var z: RBNode) {
		while true == z.parent.red {
			if z.parent === z.parent.parent.left {
				var y: RBNode = z.parent.parent.right
				// violation 1, parent child relationship re to red
				if true == y.red {
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
				var y: RBNode = z.parent.parent.left
				// violation 1, parent child relationship re to red
				if true == y.red {
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
	
	private func internalRemove(key: K) -> RBNode {
		var z: RBNode = internalFindByKey(key)
		if z === sentinel {
			return sentinel
		}
		
		if z !== root {
			var t: RBNode = z.parent
			while t !== root {
				--t.order
				t = t.parent
			}
			--root.order
		}
		
		
		var x: RBNode!
		var y: RBNode = z
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
				var t: RBNode = x.parent
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
		if false == red {
			removeCleanup(x)
		}
		--count
		return z
	}
	
	private func removeCleanup(var x: RBNode) {
		while x !== root && false == x.red {
			if x === x.parent.left {
				var y: RBNode = x.parent.right
				if true == y.red {
					y.red = false
					x.parent.red = true
					leftRotate(x.parent)
					y = x.parent.right
				}
				if false == y.left.red && false == y.right.red {
					y.red = true
					x = x.parent
				} else {
					if false == y.right.red {
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
				var y: RBNode = x.parent.left
				if true == y.red {
					y.red = false
					x.parent.red = true
					rightRotate(x.parent)
					y = x.parent.left
				}
				if false == y.right.red && false == y.left.red {
					y.red = true
					x = x.parent
				} else {
					if false == y.left.red {
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
	
	private func minimum(var x: RBNode) -> RBNode {
		var y: RBNode = sentinel
		while x !== sentinel {
			y = x
			x = x.left
		}
		return y
	}
	
	private func transplant(u: RBNode, v: RBNode) {
		if u.parent === sentinel {
			root = v
		} else if u === u.parent.left {
			u.parent.left = v
		} else {
			u.parent.right = v
		}
		v.parent = u.parent
	}
	
	private func leftRotate(x: RBNode) {
		var y: RBNode = x.right
		
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
	
	private func rightRotate(y: RBNode) {
		var x: RBNode = y.left
		
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
	
	private func internalFindByKey(key: K) -> RBNode {
		var z: RBNode = root
		while z !== sentinel {
			if key == z.key {
				return z
			}
			z = key < z.key ? z.left : z.right
		}
		return sentinel
	}
	
	private func internalSelect(x: RBNode, order: Int) -> RBNode {
		var r: Int = x.left.order + 1
		if order == r {
			return x
		} else if order < r {
			return internalSelect(x.left, order: order)
		}
		return internalSelect(x.right, order: order - r)
	}
}

