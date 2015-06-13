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
* GKQueue
*/

public class GKQueue<K: Comparable, V>: Printable {
	private typealias GKQueueNode = GKHeapNode<K, V>
	
	/**
	* heap
	* Underlying data structure.
	*/
	private var heap: GKHeap<K, V>
	
	/**
	* count
	* Number of nodes in the GKQueue.
	*/
	public var count: Int {
		return heap.count
	}
	
	public var max: V? {
		return heap.root.data
	}
	
	/**
	* description
	* Conforms to the Printable Protocol. Outputs the
	* data in the GKQueue in a readable format.
	*/
	public var description: String {
		var output: String = "GKQueue("
		for (var i: Int = 1; i <= count; ++i) {
			
		}
		return output + ")"
	}
	
	/**
	* init
	* Constructor.
	*/
	public init() {
		heap = GKHeap<K, V>()
	}
	
	/**
	* insert
	* Insert a new node into the GKQueue.
	* @param		key: K
	* @param		data: V?
	* @return		Bool of the result. True if inserted, false otherwise.
	*				Failure of insertion would mean the key already
	*				exists in the GKQueue.
	*/
	public func insert(key: K, data: V?) -> Bool {
		return heap.insert(key, data: data)
	}
	
	/**
	* remove
	* Remove a node from the GKQueue by the key value.
	* @param		key: K
	* @return		Bool of the result. True if removed, false otherwise.
	*/
	public func remove(key: K) -> Bool {
		return heap.remove(key)
	}
	
	/**
	* find
	* Finds a node by its key value and returns the
	* data that the node points to.
	* @param		key: K
	* @return		data V?
	*/
	public func find(key: K) -> V? {
		return heap.find(key)
	}
	
	/**
	* traverse
	* Traverses the GKQueue and looking for a key value.
	* This is used for internal search.
	* @param		key: K
	* @param		node: GKQueueNode
	* @param		inout set: GKQueue<K, V>
	*/
	private func traverse(key: K, node: GKQueueNode, inout set: GKQueue<K, V>) {
		if heap.sentinel !== node {
			if key == node.key {
				set.insert(key, data: node.data)
			}
			traverse(key, node: node.left, set: &set)
			traverse(key, node: node.right, set: &set)
		}
	}
}