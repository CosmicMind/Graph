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
*
* List
*/

public class List<V>: Printable {
	private typealias LNode = ListNode<V>
	
	private var head: LNode?
	private var tail: LNode?
	private var sentinel: LNode?
	private var current: LNode?
	
	public private(set) var count: Int
	
	public var description: String {
		var output: String = "List("
		var x: LNode? = head
		var c: Int = 0
		while nil !== x {
			output += x!.description
			if ++c != count {
				output += ", "
			}
			x = x!.next
		}
		output += ")"
		return output
	}
	
	public var front: V? {
		return head?.data
	}
	
	public var back: V? {
		return tail?.data
	}
	
	public var cursor: V? {
		return current?.data
	}
	
	public var next: V? {
		current = current?.next
		if sentinel === current {
			return nil
		}
		return current!.data
	}
	
	public var previous: V? {
		current = current?.previous
		if sentinel === current {
			return nil
		}
		return current!.data
	}
	
	/**
	* empty
	* A boolean if the List is empty.
	*/
	public var empty: Bool {
		return 0 == count
	}
	
	public var cursorAtEnd: Bool {
		return current === sentinel
	}
	
	public init() {
		count = 0
		sentinel = LNode(data: nil)
		resetList()
	}
	
	public func insertAtFront(data: V?) {
		let z: LNode = LNode(data: data)
		if sentinel === head {
			initialNode(z)
		} else {
			z.next = head
			z.previous = head!.previous
			head!.previous = z
			head = z
		}
		++count
	}
	
	public func removeAtFront() -> V? {
		if sentinel === head {
			return sentinel!.data
		}
		
		var data: V? = head!.data
		if 1 == count {
			resetList()
		} else {
			if head === current {
				current = head!.next
			}
			head!.next!.previous = nil
			head = head!.next
		}
		--count
		return data
	}
	
	public func insertAtBack(data: V?) {
		let z: LNode = LNode(data: data)
		if sentinel === tail {
			initialNode(z)
		} else {
			z.previous = tail
			z.next = tail!.next
			tail!.next = z
			tail = z
		}
		++count
	}
	
	public func removeAtBack() -> V? {
		if sentinel === tail {
			return sentinel!.data
		}
		
		var data: V? = tail!.data
		if 1 == count {
			resetList()
		} else {
			if tail === current {
				current = tail!.previous
			}
			tail!.previous!.next = nil
			tail = tail!.previous
		}
		--count
		return data
	}
	
	public func cursorToFront() {
		current = head
	}
	
	public func cursorToBack() {
		current = tail
	}
	
	private func initialNode(z: LNode) {
		head = z
		tail = z
		head!.previous = sentinel
		tail!.next = sentinel
	}
	
	private func resetList() {
		head = sentinel
		tail = sentinel
		current = sentinel
	}
}