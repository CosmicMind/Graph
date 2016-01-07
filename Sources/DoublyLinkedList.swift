/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of GraphKit nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

public class DoublyLinkedList<Element> : CustomStringConvertible, SequenceType {
	public typealias Generator = AnyGenerator<Element?>

	/**
		:name:	head
		:description:	First node in the list.
		- returns:	DoublyLinkedListNode<Element>?
	*/
	private var head: DoublyLinkedListNode<Element>?

	/**
		:name:	tail
		:description:	Last node in list.
		- returns:	DoublyLinkedListNode<Element>?
	*/
	private var tail: DoublyLinkedListNode<Element>?

	/**
		:name:	current
		:description:	Current cursor position when iterating.
		- returns:	DoublyLinkedListNode<Element>?
	*/
	private var current: DoublyLinkedListNode<Element>?

	/**
		:name:	count
		:description:	Number of nodes in DoublyLinkedList.
		- returns:	Int
	*/
	public private(set) var count: Int

	/**
		:name:	internalDescription
		:description:	Returns a String with only the node data for all
		nodes in the DoublyLinkedList.
		- returns:	String
	*/
	internal var internalDescription: String {
		var output: String = "("
		var c: Int = 0
		var x: DoublyLinkedListNode<Element>? = head
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
		return "DoublyLinkedList" + internalDescription
	}

	/**
		:name:	front
		:description:	Retrieves the data at first node of the DoublyLinkedList.
		- returns:	Element?
	*/
	public var front: Element? {
		return head?.element
	}

	/**
		:name:	back
		:description:	Retrieves the element at the back node of teh DoublyLinkedList.
		- returns:	Element?
	*/
	public var back: Element? {
		return tail?.element
	}

	/**
		:name:	cursor
		:description:	Retrieves the element at the current iterator position
		in the DoublyLinkedList.
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
		:description:	A boolean of whether the DoublyLinkedList is empty.
		- returns:	Bool
	*/
	public var isEmpty: Bool {
		return 0 == count
	}

	/**
		:name:	isCursorAtBack
		:description:	A boolean of whether the cursor has reached
		the back of the DoublyLinkedList.
		- returns:	Bool
	*/
	public var isCursorAtBack: Bool {
		return nil === current
	}

	/**
		:name:	isCursorAtFront
		:description:	A boolean of whether the cursor has reached
		the front of the DoublyLinkedList.
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
	//	:returns:	DoublyLinkedList.Generator
	//
	public func generate() -> DoublyLinkedList.Generator {
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
		:description:	Removes all nodes from the DoublyLinkedList.
	*/
	public func removeAll() {
		while !isEmpty {
			removeAtFront()
		}
	}

	/**
		:name:	insertAtFront
		:description:	Insert a new element at the front
		of the DoublyLinkedList.
	*/
	public func insertAtFront(element: Element) {
		var z: DoublyLinkedListNode<Element>
		if 0 == count {
			z = DoublyLinkedListNode<Element>(next: nil, previous: nil,  element: element)
			tail = z
		} else {
			z = DoublyLinkedListNode<Element>(next: head, previous: nil, element: element)
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
		:description:	Remove the element at the front of the DoublyLinkedList
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
		of the DoublyLinkedList.
	*/
	public func insertAtBack(element: Element) {
		var z: DoublyLinkedListNode<Element>
		if 0 == count {
			z = DoublyLinkedListNode<Element>(next: nil, previous: nil,  element: element)
			head = z
		} else {
			z = DoublyLinkedListNode<Element>(next: nil, previous: tail, element: element)
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
		:description:	Remove the element at the back of the DoublyLinkedList
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
		:description:	Move the cursor to the front of the DoublyLinkedList.
	*/
	public func cursorToFront() {
		current = head
	}

	/**
		:name:	cursorToBack
		:description:	Move the cursor to the back of the DoublyLinkedList.
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
			let z: DoublyLinkedListNode<Element> = DoublyLinkedListNode<Element>(next: current, previous: current!.previous,  element: element)
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
			let z: DoublyLinkedListNode<Element> = DoublyLinkedListNode<Element>(next: current!.next, previous: current,  element: element)
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

public func +<Element>(lhs: DoublyLinkedList<Element>, rhs: DoublyLinkedList<Element>) -> DoublyLinkedList<Element> {
	let l: DoublyLinkedList<Element> = DoublyLinkedList<Element>()
	for x in lhs {
		l.insertAtBack(x!)
	}
	for x in rhs {
		l.insertAtBack(x!)
	}
	return l
}

public func +=<Element>(lhs: DoublyLinkedList<Element>, rhs: DoublyLinkedList<Element>) {
	for x in rhs {
		lhs.insertAtBack(x!)
	}
}