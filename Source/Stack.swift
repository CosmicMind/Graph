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

public class Stack<Element> : Printable, SequenceType {
	internal typealias Generator = GeneratorOf<Element?>

	/**
		list
		Underlying data structure.
	*/
	private var list: List<Element>

	/**
		count
		Total number of items in the Stack.
	*/
	public var count: Int {
		return list.count
	}

	/**
		top
		Get the latest element at the top
		of the Stack and do not remove
		it.
	*/
	public var top: Element? {
		return list.front
	}

	/**
		isEmpty
		A boolean of whether the Stack is empty.
	*/
	public var isEmpty: Bool {
		return list.isEmpty
	}

	/**
		description
		Conforms to the Printable Protocol.
	*/
	public var description: String {
		return "Stack" + list.internalDescription
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
		push
		Insert a new element at the top of the Stack.
	*/
	public func push(element: Element?) {
		list.insertAtFront(element)
	}

	/**
		pop
		Get the latest element at the top of
		the Stack and remove it from the
		Stack.
	*/
	public func pop() -> Element? {
		return list.removeAtFront()
	}

	/**
		removeAll
		Remove all elements from the Stack.
	*/
	public func removeAll() {
		list.removeAll()
	}
}

public func +<Element>(lhs: Stack<Element>, rhs: Stack<Element>) -> Stack<Element> {
	let s: Stack<Element> = Stack<Element>()
	for x in lhs {
		s.push(x)
	}
	for x in rhs {
		s.push(x)
	}
	return s
}
