//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

public class List<Element> : CustomStringConvertible, SequenceType {
	public typealias Generator = AnyGenerator<Element?>

	/**
		:name:	head
		:description:	First node in the list.
		- returns:	ListNode<Element>?
	*/
	private var head: ListNode<Element>?

	/**
		:name:	tail
		:description:	Last node in list.
		- returns:	ListNode<Element>?
	*/
	private var tail: ListNode<Element>?

	/**
		:name:	current
		:description:	Current cursor position when iterating.
		- returns:	ListNode<Element>?
	*/
	private var current: ListNode<Element>?

	/**
		:name:	count
		:description:	Number of nodes in List.
		- returns:	Int
	*/
	public private(set) var count: Int

	/**
		:name:	internalDescription
		:description:	Returns a String with only the node data for all
		nodes in the List.
		- returns:	String
	*/
	internal var internalDescription: String {
		var output: String = "("
		var c: Int = 0
		var x: ListNode<Element>? = head
		while nil !== x {
			output += "\(x)"
			if ++c != count {
				output += ", "
			}
			x = x!.next
		}
		output += ")"
		return output
	}

	/**
		:name:	description
		:description:	Conforms to Printable Protocol.
		- returns:	String
	*/
	public var description: String {
		return "List" + internalDescription
	}

	/**
		:name:	front
		:description:	Retrieves the data at first node of the List.
		- returns:	Element?
	*/
	public var front: Element? {
		return head?.element
	}

	/**
		:name:	back
		:description:	Retrieves the element at the back node of teh List.
		- returns:	Element?
	*/
	public var back: Element? {
		return tail?.element
	}

	/**
		:name:	cursor
		:description:	Retrieves the element at the current iterator position
		in the List.
		- returns:	Element?
	*/
	public var cursor: Element? {
		return current?.element
	}

	/**
		:name:	next
		:description:	Retrieves the element at the poistion after the
		current cursor poistion. Also moves the cursor
		to that node.
		- returns:	Element?
	*/
	public var next: Element? {
		current = current?.next
		return current?.element
	}

	/**
		:name:	previous
		:description:	Retrieves the element at the poistion before the
		current cursor poistion. Also moves the cursor
		to that node.
		- returns:	Element?
	*/
	public var previous: Element? {
		current = current?.previous
		return current?.element
	}

	/**
		:name:	isEmpty
		:description:	A boolean of whether the List is empty.
		- returns:	Bool
	*/
	public var isEmpty: Bool {
		return 0 == count
	}

	/**
		:name:	isCursorAtBack
		:description:	A boolean of whether the cursor has reached
		the back of the List.
		- returns:	Bool
	*/
	public var isCursorAtBack: Bool {
		return nil === current
	}

	/**
		:name:	isCursorAtFront
		:description:	A boolean of whether the cursor has reached
		the front of the List.
		- returns:	Bool
	*/
	public var isCursorAtFront: Bool {
		return nil === current
	}

	/**
		:name:	init
		:description:	Constructor.
	*/
	public init() {
		count = 0
		reset()
	}

	//		
	//	:name:	generate
	//	:description:	Conforms to the SequenceType Protocol. Returns
	//	the next value in the sequence of nodes.
	//	:returns:	List.Generator
	//
	public func generate() -> List.Generator {
		cursorToFront()
		return anyGenerator {
			if !self.isCursorAtBack {
				let element: Element? = self.cursor
				self.next
				return element
			}
			return nil
		}
	}

	/**
		:name:	removeAll
		:description:	Removes all nodes from the List.
	*/
	public func removeAll() {
		while !isEmpty {
			removeAtFront()
		}
	}

	/**
		:name:	insertAtFront
		:description:	Insert a new element at the front
		of the List.
	*/
	public func insertAtFront(element: Element) {
		var z: ListNode<Element>
		if 0 == count {
			z = ListNode<Element>(next: nil, previous: nil,  element: element)
			tail = z
		} else {
			z = ListNode<Element>(next: head, previous: nil, element: element)
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
		:name:	removeAtFront
		:description:	Remove the element at the front of the List
		and return the element at the poistion.
		- returns:	Element?
	*/
	public func removeAtFront() -> Element? {
		if 0 == count {
			return nil
		}
		let element: Element? = head!.element
		if 0 == --count {
			reset()
		} else {
			head = head!.next
		}
		return element
	}

	/**
		:name:	insertAtBack
		:description:	Insert a new element at the back
		of the List.
	*/
	public func insertAtBack(element: Element) {
		var z: ListNode<Element>
		if 0 == count {
			z = ListNode<Element>(next: nil, previous: nil,  element: element)
			head = z
		} else {
			z = ListNode<Element>(next: nil, previous: tail, element: element)
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
		:name:	removeAtBack
		:description:	Remove the element at the back of the List
		and return the element at the poistion.
		- returns:	Element?
	*/
	public func removeAtBack() -> Element? {
		if 0 == count {
			return nil
		}
		let element: Element? = tail!.element
		if 0 == --count {
			reset()
		} else {
			tail = tail!.previous
		}
		return element
	}

	/**
		:name:	cursorToFront
		:description:	Move the cursor to the front of the List.
	*/
	public func cursorToFront() {
		current = head
	}

	/**
		:name:	cursorToBack
		:description:	Move the cursor to the back of the List.
	*/
	public func cursorToBack() {
		current = tail
	}

	/**
		:name:	insertBeforeCursor
		:description:	Insert a new element before the cursor position.
	*/
	public func insertBeforeCursor(element: Element) {
		if nil === current || head === current {
			insertAtFront(element)
		} else {
			let z: ListNode<Element> = ListNode<Element>(next: current, previous: current!.previous,  element: element)
			current!.previous?.next = z
			current!.previous = z
			++count
		}
	}

	/**
		:name:	insertAfterCursor
		:description:	Insert a new element after the cursor position.
	*/
	public func insertAfterCursor(element: Element) {
		if nil === current || tail === current {
			insertAtBack(element)
		} else {
			let z: ListNode<Element> = ListNode<Element>(next: current!.next, previous: current,  element: element)
			current!.next?.previous = z
			current!.next = z
			++count
		}
	}

	/**
		:name:	removeAtCursor
		:description:	Removes the element at the cursor position.
		- returns:	Element?
	*/
	public func removeAtCursor() -> Element? {
		if 1 >= count {
			return removeAtFront()
		} else {
			let element: Element? = current!.element
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
			return element
		}
	}

	/**
		:name:	reset
		:description:	Reinitializes pointers to sentinel value.
	*/
	private func reset() {
		head = nil
		tail = nil
		current = nil
	}
}

public func +<Element>(lhs: List<Element>, rhs: List<Element>) -> List<Element> {
	let l: List<Element> = List<Element>()
	for x in lhs {
		l.insertAtBack(x!)
	}
	for x in rhs {
		l.insertAtBack(x!)
	}
	return l
}

public func +=<Element>(lhs: List<Element>, rhs: List<Element>) {
	for x in rhs {
		lhs.insertAtBack(x!)
	}
}