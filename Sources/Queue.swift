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

public class Queue<Element> : CustomStringConvertible, SequenceType {
	public typealias Generator = AnyGenerator<Element?>

	/**
		:name:	list
		:description:	Underlying data structure.
		- returns:	DoublyLinkedList<Element>
	*/
	private var list: DoublyLinkedList<Element>

	/**
		:name:	count
		:description:	Total number of items in the Queue.
		- returns:	Int
	*/
	public var count: Int {
		return list.count
	}

	/**
		:name:	peek
		:description:	Get the element at the front of
		the Queue, and do not remove it.
		- returns:	Element?
	*/
	public var peek: Element? {
		return list.front
	}

	/**
		:name:	isEmpty
		:description:	A boolean of whether the Queue is empty.
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
		return "Queue" + list.internalDescription
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
	//	:returns:	Queue.Generator
	//
	public func generate() -> Queue.Generator {
		return list.generate()
	}

	/**
		:name:	enqueue
		:description:	Insert a new element at the back of the Queue.
	*/
	public func enqueue(element: Element) {
		list.insertAtBack(element)
	}

	/**
		:name:	dequeue
		:description:	Get and remove the element at the front
		of the Queue.
		- returns:	Element?
	*/
	public func dequeue() -> Element? {
		return list.removeAtFront()
	}

	/**
		:name:	removeAll
		:description:	Remove all elements from the Queue.
	*/
	public func removeAll() {
		list.removeAll()
	}
}

public func +<Element>(lhs: Queue<Element>, rhs: Queue<Element>) -> Queue<Element> {
	let q: Queue<Element> = Queue<Element>()
	for x in lhs {
		q.enqueue(x!)
	}
	for x in rhs {
		q.enqueue(x!)
	}
	return q
}

public func +=<Element>(lhs: Queue<Element>, rhs: Queue<Element>) {
	for x in rhs {
		lhs.enqueue(x!)
	}
}