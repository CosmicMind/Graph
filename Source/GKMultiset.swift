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
* GKMultiset
*/

public class GKMultiset<K: Comparable, V>: Printable {
	private var tree: GKRedBlackTree<K, V>
	
	public var count: Int {
		return tree.count
	}
	
	public var last: V? {
		return tree.last
	}
	
	public var first: V? {
		return tree.first
	}
	
	public var description: String {
		var output: String = "GKMultiset("
		for (var i: Int = 1; i <= count; ++i) {
			output += tree.select(tree.root, order: i).description
			if i != count {
				output += ","
			}
		}
		return output + ")"
	}
	
	public init() {
		tree = GKRedBlackTree<K, V>(unique: false)
	}
	
	public func insert(key: K, data: V?) -> Bool {
		return tree.insert(key, data: data)
	}
	
	public func remove(key: K) -> Bool {
		return tree.remove(key)
	}
	
	public func find(key: K) -> V? {
		return tree.find(key)
	}
	
	public subscript(index: Int) -> V? {
		get {
			return tree[index]
		}
	}
	
	public subscript(name: String) -> V? {
		get {
			return tree[name]
		}
		set(value) {
			tree[name] = value
		}
	}
	
	public func search(key: K) -> GKMultiset<K, V> {
		var s: GKMultiset<K, V> = GKMultiset<K, V>()
		traverse(key, node: tree.root, set: &s)
		return s
	}
	
	private func traverse(key: K, node: GKRedBlackNode<K, V>, inout set: GKMultiset<K, V>) {
		if tree.sentinel !== node {
			if key == node.key {
				set.insert(key, data: node.data)
			}
			traverse(key, node: node.left, set: &set)
			traverse(key, node: node.right, set: &set)
		}
	}
}