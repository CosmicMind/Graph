//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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

public class Deque<Element> : Printable, SequenceType {
	public typealias Generator = GeneratorOf<Element?>

	/**
		:name:	list
		:description:	Underlying element structure.
		:returns:	List<Element>
	*/
	private var list: List<Element>

	/**
		:name:	count
		:description:	Total number of items in the Deque.
		:returns:	Int
	*/
	public var count: Int {
		return list.count
	}

	/**
		:name:	front
		:description:	Get the element at the front of the Deque
		and do not remove it.
		:returns:	Element?
	*/
	public var front: Element? {
		return list.front
	}

	/**
		:name:	back
		:description:	Get the element at the back of the Deque
		and do not remove it.
		:returns:	Element?
	*/
	public var back: Element? {
		return list.back
	}

	/**
		:name:	isEmpty
		:description:	A boolean of whether the Deque is empty.
		:returns:	Bool
	*/
	public var isEmpty: Bool {
		return list.isEmpty
	}

	/**
		:name:	description
		:description:	Conforms to the Printable Protocol.
		:returns:	String
	*/
	public var description: String {
		return "Deque" + list.internalDescription
	}

	/**
		:name:	init
		:description:	Constructor.
	*/
	public init() {
		list = List<Element>()
	}

	/**
		:name:	generate
		:description:	Conforms to the SequenceType Protocol. Returns
		the next value in the sequence of nodes.
		:returns:	Deque.Generator
	*/
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
		:returns:	Element?
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
		:returns:	Element?
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
