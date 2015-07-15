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

/**
	A Queue is a first-in, first-out (FIFO) data structure that is excellent for
	incoming data that may need to be temporarily cached and used in the order it
	entered. The following Queue implementation is backed by a List data structure.
*/
public class Queue<Element> : Printable, SequenceType {
	internal typealias Generator = GeneratorOf<Element?>

	/**
		list
		Underlying data structure.
	*/
	private var list: List<Element>

	/**
		count
		Total number of items in the Queue.
	*/
	public var count: Int {
		return list.count
	}

	/**
		peek
		Get the element at the front of
		the Queue, and do not remove it.
	*/
	public var peek: Element? {
		return list.front
	}

	/**
		isEmpty
		A boolean of whether the Queue is empty.
	*/
	public var isEmpty: Bool {
		return list.isEmpty
	}

	/**
		description
		Conforms to the Printable Protocol.
	*/
	public var description: String {
		return "Queue" + list.internalDescription
	}

	/**
		init
		Constructor
	*/
	public init() {
		list = List<Element>()
	}

	/**
		generate
		Conforms to the SequenceType Protocol. Returns
		the next value in the sequence of nodes.
	*/
	public func generate() -> Generator {
		return list.generate()
	}

	/**
		enqueue
		Insert a new element at the back of the Queue.
	*/
	public func enqueue(element: Element?) {
		list.insertAtBack(element)
	}

	/**
		dequeue
		Get and remove the element at the front
		of the Queue.
	*/
	public func dequeue() -> Element? {
		return list.removeAtFront()
	}

	/**
		removeAll
		Remove all elements from the Queue.
	*/
	public func removeAll() {
		list.removeAll()
	}
}

public func +<Element>(lhs: Queue<Element>, rhs: Queue<Element>) -> Queue<Element> {
	let q: Queue<Element> = Queue<Element>()
	for x in lhs {
		q.enqueue(x)
	}
	for x in rhs {
		q.enqueue(x)
	}
	return q
}
