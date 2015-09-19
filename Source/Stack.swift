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

public class Stack<Element> : CustomStringConvertible, SequenceType {
	public typealias Generator = AnyGenerator<Element?>

	/**
		:name:	list
		:description:	Underlying data structure.
		- returns:	List<Element>
	*/
	private var list: List<Element>

	/**
		:name:	count
		:description:	Total number of items in the Stack.
		- returns:	Int
	*/
	public var count: Int {
		return list.count
	}

	/**
		:name:	top
		:description:	Get the latest element at the top
		of the Stack and do not remove
		it.
		- returns:	Element?
	*/
	public var top: Element? {
		return list.front
	}

	/**
		:name:	isEmpty
		:description:	A boolean of whether the Stack is empty.
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
		return "Stack" + list.internalDescription
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
	//	:returns:	Stack.Generator
	//
	public func generate() -> Stack.Generator {
		return list.generate()
	}

	/**
		:name:	push
		:description:	Insert a new element at the top of the Stack.
	*/
	public func push(element: Element) {
		list.insertAtFront(element)
	}

	/**
		:name:	pop
		:description:	Get the latest element at the top of
		the Stack and remove it from the
		Stack.
		- returns:	Element?
	*/
	public func pop() -> Element? {
		return list.removeAtFront()
	}

	/**
		:name:	removeAll
		:description:	Remove all elements from the Stack.
	*/
	public func removeAll() {
		list.removeAll()
	}
}

public func +<Element>(lhs: Stack<Element>, rhs: Stack<Element>) -> Stack<Element> {
	let s: Stack<Element> = Stack<Element>()
	for x in lhs {
		s.push(x!)
	}
	for x in rhs {
		s.push(x!)
	}
	return s
}

public func +=<Element>(lhs: Stack<Element>, rhs: Stack<Element>) {
	for x in rhs {
		lhs.push(x!)
	}
}
