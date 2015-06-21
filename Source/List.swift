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

public class List<T>: Printable, SequenceType {
	private typealias NodeType = ListNode<T>
	internal typealias Generator = GeneratorOf<T?>
	
	/**
	* head
	* First node in the list.
	*/
	private var head: NodeType?
	
	/**
	* tail
	* Last node in list.
	*/
	private var tail: NodeType?
	
	/**
	* current
	* Current cursor position when iterating.
	*/
	private var current: NodeType?
	
	/**
	* count
	* Number of nodes in List.
	*/
	public private(set) var count: Int
	
	/**
	* internalDescription
	* Returns a String with only the node data for all
	* nodes in the List.
	*/
	internal var internalDescription: String {
		var output: String = "("
		var c: Int = 0
		var x: NodeType? = head
		while nil != x {
			output += x!.description
			if ++c != count {
				output += ", "
			}
			x = x!.next
		}
		output += ")"
		return output
	}
	
	/**
	* description
	* Conforms to Printable Protocol.
	*/
	public var description: String {
		return "List" + internalDescription
	}
	
	/**
	* front
	* Retrieves the data at first node of the List.
	*/
	public var front: T? {
		return head?.data
	}
	
	/**
	* back
	* Retrieves the data at the back node of teh List.
	*/
	public var back: T? {
		return tail?.data
	}
	
	/**
	* cursor
	* Retrieves the data at the current iterator position
	* in the List.
	*/
	public var cursor: T? {
		return current?.data
	}
	
	/**
	* next
	* Retrieves the data at the poistion after the 
	* current cursor poistion. Also moves the cursor
	* to that node.
	*/
	public var next: T? {
		current = current?.next
		return current?.data
	}
	
	/**
	* previous
	* Retrieves the data at the poistion before the
	* current cursor poistion. Also moves the cursor
	* to that node.
	*/
	public var previous: T? {
		current = current?.previous
		return current?.data
	}
	
	/**
	* empty
	* A boolean of whether the List is empty.
	*/
	public var empty: Bool {
		return 0 == count
	}
	
	/**
	* cursorBack
	* A boolean of whether the cursor has reached
	* the back of the List.
	*/
	public var cursorBack: Bool {
		return nil == current
	}
	
	/**
	* cursorFront
	* A boolean of whether the cursor has reached
	* the front of the List.
	*/
	public var cursorFront: Bool {
		return nil == current
	}
	
	/**
	* init
	* Constructor.
	*/
	public init() {
		count = 0
		reset()
	}
	
	/**
	* generate
	* Conforms to the SequenceType Protocol. Returns
	* the next value in the sequence of nodes.
	*/
	public func generate() -> Generator {
		cursorToFront()
		return GeneratorOf {
			if !self.cursorBack {
				var data: T? = self.cursor
				self.next
				return data
			}
			return nil
		}
	}
	
	/**
	* removeAll
	* Removes all nodes from the List.
	*/
	public func removeAll() {
		while !empty {
			removeFront()
		}
	}
	
	/**
	* insertFront
	* Insert a new node with data at the front
	* of the List.
	* @param		data: T?
	*/
	public func insertFront(data: T?) {
		var z: NodeType
		if 0 == count {
			z = NodeType(next: nil, previous: nil,  data: data)
			tail = z
		} else {
			z = NodeType(next: head, previous: nil, data: data)
			head!.previous = z
		}
		head = z
		if 1 == ++count {
			current = head
		} else if head === current {
			current = head!.next
		}
	}
	
	/**
	* removeFront
	* Remove the node at the front of the List
	* and return the data at the poistion.
	* @return		data T?
	*/
	public func removeFront() -> T? {
		if 0 == count {
			return nil
		}
		var data: T? = head!.data
		if 0 == --count {
			reset()
		} else {
			head = head!.next
		}
		return data
	}
	
	/**
	* insertBack
	* Insert a new node with data at the back
	* of the List.
	* @param		data: T?
	*/
	public func insertBack(data: T?) {
		var z: NodeType
		if 0 == count {
			z = NodeType(next: nil, previous: nil,  data: data)
			head = z
		} else {
			z = NodeType(next: nil, previous: tail, data: data)
			tail!.next = z
		}
		tail = z
		if 1 == ++count {
			current = tail
		} else if tail === current {
			current = tail!.previous
		}
	}
	
	/**
	* removeBack
	* Remove the node at the back of the List
	* and return the data at the poistion.
	* @return		data T?
	*/
	public func removeBack() -> T? {
		if 0 == count {
			return nil
		}
		var data: T? = tail!.data
		if 0 == --count {
			reset()
		} else {
			tail = tail!.previous
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
	* @param		data: T?
	*/
	public func insertBeforeCursor(data: T?) {
		if nil == current || head === current {
			insertFront(data)
		} else {
			let z: NodeType = NodeType(next: current, previous: current!.previous,  data: data)
			current!.previous?.next = z
			current!.previous = z
			++count
		}
	}
	
	/**
	* insertAfterCursor
	* Insert a new node with data after the current
	* cursor position.
	* @param		data: T?
	*/
	public func insertAfterCursor(data: T?) {
		if nil == current || tail === current {
			insertBack(data)
		} else {
			let z: NodeType = NodeType(next: current!.next, previous: current,  data: data)
			current!.next?.previous = z
			current!.next = z
			++count
		}
	}
	
	/**
	* removeCursor
	* Removes a node at the current cursor position.
	* @return		data T?
	*/
	public func removeCursor() -> T? {
		if 1 >= count {
			return removeFront()
		} else {
			var data: T? = current!.data
			current!.previous?.next = current!.next
			current!.next?.previous = current!.previous
			if tail === current {
				current = tail!.previous
				tail = current
			} else if head === current {
				current = head!.next
				head = current
			} else {
				current = current!.next
			}
			--count
			return data
		}
	}
	
	/**
	* reset
	* Reinitializes pointers to sentinel value.
	*/
	private func reset() {
		head = nil
		tail = nil
		current = nil
	}
}