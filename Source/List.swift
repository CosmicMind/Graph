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
* List
*/

public class List<V>: Printable {
	private typealias LNode = ListNode<V>
	
	/**
	* sentinel
	* Sentinel node.
	*/
	private var sentinel: LNode
	
	/**
	* current
	* Current cursor position when iterating.
	*/
	private var current: LNode
	
	/**
	* head
	* First node in the list.
	*/
	private var head: LNode
	
	/**
	* tail
	* Last node in list.
	*/
	private var tail: LNode
	
	/**
	* count
	* Number of nodes in List.
	*/
	public private(set) var count: Int
	
	/**
	* description
	* Conforms to Printable Protocol.
	*/
	public var description: String {
		var output: String = "List("
		var c: Int = 0
		var x: LNode = head
		while sentinel !== x {
			output += x.description
			if ++c != count {
				output += ", "
			}
			x = x.next
		}
		output += ")"
		return output
	}
	
	/**
	* front
	* Retrieves the data at first node of the List.
	*/
	public var front: V? {
		return head.data
	}
	
	/**
	* back
	* Retrieves the data at the back node of teh List.
	*/
	public var back: V? {
		return tail.data
	}
	
	/**
	* cursor
	* Retrieves the data at the current iterator position
	* in the List.
	*/
	public var cursor: V? {
		return current.data
	}
	
	/**
	* next
	* Retrieves the data at the poistion after the 
	* current cursor poistion. Also moves the cursor
	* to that node.
	*/
	public var next: V? {
		current = current.next
		return current.data
	}
	
	/**
	* previous
	* Retrieves the data at the poistion before the
	* current cursor poistion. Also moves the cursor
	* to that node.
	*/
	public var previous: V? {
		current = current.previous
		return current.data
	}
	
	/**
	* empty
	* A boolean if the List is empty.
	*/
	public var empty: Bool {
		return 0 == count
	}
	
	/**
	* cursorAtEnd
	* A boolean of whether the cursor has reached
	* the end of an iteration cycle.
	*/
	public var cursorAtEnd: Bool {
		return sentinel === current
	}
	
	/**
	* init
	* Constructor.
	*/
	public init() {
		count = 0
		sentinel = LNode()
		head = sentinel
		tail = sentinel
		current = sentinel
	}
	
	/**
	* clear
	* Removes all nodes from the List.
	*/
	public func clear() {
		while !empty {
			removeAtFront()
		}
	}
	
	/**
	* insertAtFront
	* Insert a new node with data at the front
	* of the List.
	* @param		data: V?
	*/
	public func insertAtFront(data: V?) {
		var z: LNode
		if 0 == count {
			z = LNode(next: sentinel, previous: sentinel,  data: data)
			tail = z
		} else {
			z = LNode(next: head, previous: sentinel, data: data)
			head.previous = z
		}
		head = z
		++count
	}
	
	/**
	* removeAtFront
	* Remove the node at the front of the List
	* and return the data at the poistion.
	* @return		data V?
	*/
	public func removeAtFront() -> V? {
		if 0 == count {
			return sentinel.data
		}
		var data: V? = head.data
		if 0 == --count {
			reset()
		} else {
			head.next.previous = sentinel
			head = head.next
		}
		return data
	}
	
	/**
	* insertAtBack
	* Insert a new node with data at the back
	* of the List.
	* @param		data: V?
	*/
	public func insertAtBack(data: V?) {
		var z: LNode
		if 0 == count {
			z = LNode(next: sentinel, previous: sentinel,  data: data)
			head = z
		} else {
			z = LNode(next: sentinel, previous: tail, data: data)
			tail.next = z
		}
		tail = z
		++count
	}
	
	/**
	* removeAtBack
	* Remove the node at the back of the List
	* and return the data at the poistion.
	* @return		data V?
	*/
	public func removeAtBack() -> V? {
		if 0 == count {
			return sentinel.data
		}
		var data: V? = tail.data
		if 0 == --count {
			reset()
		} else {
			tail.previous.next = sentinel
			tail = tail.previous
		}
		return data
	}
	
	/**
	* cursorToFront
	* Move the cursor to the front of the List.
	*/
	public func cursorToFront() {
		current = head
	}
	
	/**
	* cursorToBack
	* Move the cursor to the back of the List.
	*/
	public func cursorToBack() {
		current = tail
	}
	
	/**
	* insertBeforeCursor
	* Insert a new node with data before the current
	* cursor position.
	* @param		data: V?
	*/
	public func insertBeforeCursor(data: V?) {
		if sentinel === current || head === current {
			insertAtFront(data)
		} else {
			let z: LNode = LNode(next: current, previous: current.previous,  data: data)
			current.previous = z
			++count
		}
	}
	
	/**
	* insertAfterCursor
	* Insert a new node with data after the current
	* cursor position.
	* @param		data: V?
	*/
	public func insertAfterCursor(data: V?) {
		if sentinel === current || tail === current {
			insertAtBack(data)
		} else {
			current.next = LNode(next: current.next, previous: current,  data: data)
			++count
		}
	}
	
	/**
	* reset
	* Reinitializes pointers to sentinel value.
	*/
	func reset() {
		head = sentinel
		tail = sentinel
		current = sentinel
	}
}