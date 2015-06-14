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
* Heap
*/

internal class Heap<K: Comparable, V>: Printable {
	internal typealias HTree = Heap<K, V>
	internal typealias HNode = HeapNode<K, V>
	
	internal private(set) var sentinel: HNode
	internal private(set) var root: HNode
	internal private(set) var count: Int
	
	internal var description: String {
		var output: String = "Heap("
		for (var i: Int = 1; i <= count; ++i) {
			
		}
		return output + ")"
	}
	
	internal init() {
		sentinel = HNode()
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
	
	private func internalMaxHeapify(var z: HNode) {
		var largest: HNode! = nil
		var l: HNode = z.left
		var r: HNode = z.right
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
	
	private func internalInsert(key: K, data: V?) -> HNode {
		var y: HNode = sentinel
		var x: HNode = root
		
		while x !== sentinel {
			y = x
			x = key < x.key ? x.left : x.right
		}

		var z: HNode = HNode(parent: y, sentinel: sentinel, key: key, data: data)
		
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
	
	private func internalRemove(key: K) -> HNode {
		var z: HNode = internalFindByKey(key)
		if z === sentinel {
			return sentinel
		}
		
		var x: HNode!
		var y: HNode = z
		
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
	
	private func minimum(var x: HNode) -> HNode {
		var y: HNode = sentinel
		while x !== sentinel {
			y = x
			x = x.left
		}
		return y
	}
	
	private func transplant(u: HNode, v: HNode) {
		if u.parent === sentinel {
			root = v
		} else if u === u.parent.left {
			u.parent.left = v
		} else {
			u.parent.right = v
		}
		v.parent = u.parent
	}
	
	private func internalFindByKey(key: K) -> HNode {
		var z: HNode = root
		while z !== sentinel {
			if key == z.key {
				return z
			}
			z = key < z.key ? z.left : z.right
		}
		return sentinel
	}
}

