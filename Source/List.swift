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
*/

public class List<Element>: Printable, SequenceType {
	private typealias NodeType = ListNode<Element>
	internal typealias Generator = GeneratorOf<Element?>

	/**
		head
		First node in the list.
	*/
	private var head: NodeType?

	/**
		tail
		Last node in list.
	*/
	private var tail: NodeType?

	/**
		current
		Current cursor position when iterating.
	*/
	private var current: NodeType?

	/**
		count
		Number of nodes in List.
	*/
	public private(set) var count: Int

	/**
		internalDescription
		Returns a String with only the node data for all
		nodes in the List.
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
		description
		Conforms to Printable Protocol.
	*/
	public var description: String {
		return "List" + internalDescription
	}

	/**
		front
		Retrieves the data at first node of the List.
	*/
	public var front: Element? {
		return head?.element
	}

	/**
		back
		Retrieves the element at the back node of teh List.
	*/
	public var back: Element? {
		return tail?.element
	}

	/**
		cursor
		Retrieves the element at the current iterator position
		in the List.
	*/
	public var cursor: Element? {
		return current?.element
	}

	/**
		next
		Retrieves the element at the poistion after the
		current cursor poistion. Also moves the cursor
		to that node.
	*/
	public var next: Element? {
		current = current?.next
		return current?.element
	}

	/**
		previous
		Retrieves the element at the poistion before the
		current cursor poistion. Also moves the cursor
		to that node.
	*/
	public var previous: Element? {
		current = current?.previous
		return current?.element
	}

	/**
		isEmpty
		A boolean of whether the List is empty.
	*/
	public var isEmpty: Bool {
		return 0 == count
	}

	/**
		cursorAtBack
		A boolean of whether the cursor has reached
		the back of the List.
	*/
	public var cursorAtBack: Bool {
		return nil == current
	}

	/**
		cursorAtFront
		A boolean of whether the cursor has reached
		the front of the List.
	*/
	public var cursorAtFront: Bool {
		return nil == current
	}

	/**
		init
		Constructor.
	*/
	public init() {
		count = 0
		reset()
	}

	/**
		generate
		Conforms to the SequenceType Protocol. Returns
		the next value in the sequence of nodes.
	*/
	public func generate() -> Generator {
		cursorToFront()
		return GeneratorOf {
			if !self.cursorAtBack {
				var element: Element? = self.cursor
				self.next
				return element
			}
			return nil
		}
	}

	/**
		removeAll
		Removes all nodes from the List.
	*/
	public func removeAll() {
		while !isEmpty {
			removeAtFront()
		}
	}

	/**
		insertAtFront
		Insert a new element at the front
		of the List.
	*/
	public func insertAtFront(element: Element?) {
		var z: NodeType
		if 0 == count {
			z = NodeType(next: nil, previous: nil,  element: element)
			tail = z
		} else {
			z = NodeType(next: head, previous: nil, element: element)
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
		removeAtFront
		Remove the element at the front of the List
		and return the element at the poistion.
	*/
	public func removeAtFront() -> Element? {
		if 0 == count {
			return nil
		}
		var element: Element? = head!.element
		if 0 == --count {
			reset()
		} else {
			head = head!.next
		}
		return element
	}

	/**
		insertAtBack
		Insert a new element at the back
		of the List.
	*/
	public func insertAtBack(element: Element?) {
		var z: NodeType
		if 0 == count {
			z = NodeType(next: nil, previous: nil,  element: element)
			head = z
		} else {
			z = NodeType(next: nil, previous: tail, element: element)
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
		removeAtBack
		Remove the element at the back of the List
		and return the element at the poistion.
	*/
	public func removeAtBack() -> Element? {
		if 0 == count {
			return nil
		}
		var element: Element? = tail!.element
		if 0 == --count {
			reset()
		} else {
			tail = tail!.previous
		}
		return element
	}

	/**
		cursorToFront
		Move the cursor to the front of the List.
	*/
	public func cursorToFront() {
		current = head
	}

	/**
		cursorToBack
		Move the cursor to the back of the List.
	*/
	public func cursorToBack() {
		current = tail
	}

	/**
		insertBeforeCursor
		Insert a new element before the cursor position.
	*/
	public func insertBeforeCursor(element: Element?) {
		if nil == current || head === current {
			insertAtFront(element)
		} else {
			let z: NodeType = NodeType(next: current, previous: current!.previous,  element: element)
			current!.previous?.next = z
			current!.previous = z
			++count
		}
	}

	/**
		insertAfterCursor
		Insert a new element after the cursor position.
	*/
	public func insertAfterCursor(element: Element?) {
		if nil == current || tail === current {
			insertAtBack(element)
		} else {
			let z: NodeType = NodeType(next: current!.next, previous: current,  element: element)
			current!.next?.previous = z
			current!.next = z
			++count
		}
	}

	/**
		removeAtCursor
		Removes the element at the cursor position.
	*/
	public func removeAtCursor() -> Element? {
		if 1 >= count {
			return removeAtFront()
		} else {
			var element: Element? = current!.element
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
		reset
		Reinitializes pointers to sentinel value.
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
		l.insertAtBack(x)
	}
	for x in rhs {
		l.insertAtBack(x)
	}
	return l
}
