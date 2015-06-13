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
* GKHeap
*/

internal class GKHeap<K: Comparable, V>: Printable {
	internal typealias GKHTree = GKHeap<K, V>
	internal typealias GKHNode = GKHeapNode<K, V>
	
	internal private(set) var sentinel: GKHNode
	internal private(set) var root: GKHNode
	internal private(set) var count: Int
	
	internal var description: String {
		var output: String = "GKHeap("
		for (var i: Int = 1; i <= count; ++i) {
			
		}
		return output + ")"
	}
	
	internal init() {
		sentinel = GKHNode()
		root = sentinel
		count = 0
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
	
	private func internalMaxHeapify(var z: GKHNode) {
		var largest: GKHNode! = nil
		var l: GKHNode = z.left
		var r: GKHNode = z.right
		if l > z {
			l.parent = z.parent
			z.right = l.right
			z.left = l.left
			l.right = r
			l.left = z
			largest = z
		} else if r > z {
			r.parent = z.parent
			z.right = r.right
			z.left = r.left
			r.left = l
			r.right = z
			largest = z
		}
		if nil !== largest {
			internalMaxHeapify(largest!)
		}
	}
	
	private func internalInsert(key: K, data: V?) -> GKHNode {
		var y: GKHNode = sentinel
		var x: GKHNode = root
		
		while x !== sentinel {
			y = x
			x = key < x.key ? x.left : x.right
		}

		var z: GKHNode = GKHNode(parent: y, sentinel: sentinel, key: key, data: data)
		
		if y === sentinel {
			root = z
		} else if key < y.key {
			y.left = z
		} else {
			y.right = z
		}
		
		println("Left \(y.left) Largest \(y) Right \(y.right)")
		
		internalMaxHeapify(root)
		++count
		return z
	}
	
	private func internalRemove(key: K) -> GKHNode {
		var z: GKHNode = internalFindByKey(key)
		if z === sentinel {
			return sentinel
		}
		
		var x: GKHNode!
		var y: GKHNode = z
		
		if z.left === sentinel {
			x = z.right
			transplant(z, v: z.right)
		} else if z.right === sentinel {
			x = z.left
			transplant(z, v: z.left)
		} else {
			y = minimum(z.right)
			x = y.right
			if y.parent === z {
				x.parent = y
			} else {
				transplant(y, v: y.right)
				y.right = z.right
				y.right.parent = y
			}
			transplant(z, v: y)
			y.left = z.left
			y.left.parent = y
		}
		
		--count
		return z
	}
	
	private func minimum(var x: GKHNode) -> GKHNode {
		var y: GKHNode = sentinel
		while x !== sentinel {
			y = x
			x = x.left
		}
		return y
	}
	
	private func transplant(u: GKHNode, v: GKHNode) {
		if u.parent === sentinel {
			root = v
		} else if u === u.parent.left {
			u.parent.left = v
		} else {
			u.parent.right = v
		}
		v.parent = u.parent
	}
	
	private func internalFindByKey(key: K) -> GKHNode {
		var z: GKHNode = root
		while z !== sentinel {
			if key == z.key {
				return z
			}
			z = key < z.key ? z.left : z.right
		}
		return sentinel
	}
}

