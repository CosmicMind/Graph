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

internal class ListNode<Element>: Printable {
	private typealias NodeType = ListNode<Element>

	/**
		next
		Points to the successor element in the List.
	*/
	internal var next: NodeType?

	/**
		previous
		points to the predacessor element in the List.
	*/
	internal var previous: NodeType?

	/**
		data
		Satellite data.
	*/
	internal var element: Element?

	/**
		description
		Conforms to the Printable Protocol.
	*/
	internal var description: String {
		return "\(element)"
	}

	/**
		init
		Constructor.
	*/
	internal init(next: NodeType?, previous: NodeType?, element: Element?) {
		self.next = next
		self.previous = previous
		self.element = element
	}
}
