/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
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

public class Deque<Element> : CustomStringConvertible, SequenceType {
	public typealias Generator = AnyGenerator<Element?>

	/**
		:name:	list
		:description:	Underlying element structure.
		- returns:	DoublyLinkedList<Element>
	*/
	private var list: DoublyLinkedList<Element>

	/**
		:name:	count
		:description:	Total number of items in the Deque.
		- returns:	Int
	*/
	public var count: Int {
		return list.count
	}

	/**
		:name:	front
		:description:	Get the element at the front of the Deque
		and do not remove it.
		- returns:	Element?
	*/
	public var front: Element? {
		return list.front
	}

	/**
		:name:	back
		:description:	Get the element at the back of the Deque
		and do not remove it.
		- returns:	Element?
	*/
	public var back: Element? {
		return list.back
	}

	/**
		:name:	isEmpty
		:description:	A boolean of whether the Deque is empty.
		- returns:	Bool
	*/
	public var isEmpty: Bool {
		return list.isEmpty
	}

	/**
		:name:	description
		:description:	Conforms to the Printable Protocol.
		- returns:	String
	*/
	public var description: String {
		return "Deque" + list.internalDescription
	}

	/**
		:name:	init
		:description:	Constructor.
	*/
	public init() {
		list = DoublyLinkedList<Element>()
	}

	//
	//	:name:	generate
	//	:description:	Conforms to the SequenceType Protocol. Returns
	//	the next value in the sequence of nodes.
	//	:returns:	Deque.Generator
	//
	public func generate() -> Deque.Generator {
		return list.generate()
	}

	/**
		:name:	insertAtFront
		:description:	Insert a new element at the front of the Deque.
	*/
	public func insertAtFront(element: Element) {
		list.insertAtFront(element)
	}

	/**
		:name:	removeAtFront
		:description:	Get the element at the front of the Deque
		and remove it.
		- returns:	Element?
	*/
	public func removeAtFront() -> Element? {
		return list.removeAtFront()
	}

	/**
		:name:	insertAtBack
		:description:	Insert a new element at the back of the Deque.
	*/
	public func insertAtBack(element: Element) {
		list.insertAtBack(element)
	}

	/**
		:name:	removeAtBack
		:description:	Get the element at the back of the Deque
		and remove it.
		- returns:	Element?
	*/
	public func removeAtBack() -> Element? {
		return list.removeAtBack()
	}

	/**
		:name:	removeAll
		:description:	Remove all elements from the Deque.
	*/
	public func removeAll() {
		list.removeAll()
	}
}

public func +<Element>(lhs: Deque<Element>, rhs: Deque<Element>) -> Deque<Element> {
	let d: Deque<Element> = Deque<Element>()
	for x in lhs {
		d.insertAtBack(x!)
	}
	for x in rhs {
		d.insertAtBack(x!)
	}
	return d
}

public func +=<Element>(lhs: Deque<Element>, rhs: Deque<Element>) {
	for x in rhs {
		lhs.insertAtBack(x!)
	}
}