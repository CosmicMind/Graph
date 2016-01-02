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

// #internal

internal class DoublyLinkedListNode<Element> : CustomStringConvertible {
	/**
		:name:	next
		:description:	Points to the successor element in the DoublyLinkedList.
		- returns:	DoublyLinkedListNode<Element>?
	*/
	internal var next: DoublyLinkedListNode<Element>?

	/**
		:name:	previous
		:description:	points to the predacessor element in the DoublyLinkedList.
		- returns:	DoublyLinkedListNode<Element>?
	*/
	internal var previous: DoublyLinkedListNode<Element>?

	/**
		:name:	data
		:description:	Satellite data.
		- returns:	Element?
	*/
	internal var element: Element?

	/**
		:name:	description
		:description:	Conforms to the Printable Protocol.
		- returns:	String
	*/
	internal var description: String {
		return "\(element)"
	}

	/**
		:name:	init
		:description:	Constructor.
	*/
	internal init(next: DoublyLinkedListNode<Element>?, previous: DoublyLinkedListNode<Element>?, element: Element?) {
		self.next = next
		self.previous = previous
		self.element = element
	}
}
