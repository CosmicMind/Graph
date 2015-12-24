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

public class Queue<Element> : CustomStringConvertible, SequenceType {
	public typealias Generator = AnyGenerator<Element?>

	/**
		:name:	list
		:description:	Underlying data structure.
		- returns:	List<Element>
	*/
	private var list: List<Element>

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
		list = List<Element>()
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