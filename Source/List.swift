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
		if nil == current || tail === current {
			return nil
		}
		var data: V? = current!.next.data
		current = current!.next
		return data
	}
	
	public var previous: V? {
		if nil == current || head === current {
			return nil
		}
		
		var data: V? = current!.previous.data
		current = current!.previous
		return data
	}
	
	public init() {
		count = 0
	}
	
	public func insertAtFront(data: V?) {
		let z: LNode = LNode(data: data)
		if nil == head {
			head = z
			tail = z
		} else {
			z.next = head
			head!.previous = z
			head = z
		}
		++count
	}
	
	public func removeAtFront() -> V? {
		if nil == head {
			return nil
		}
		
		var data: V? = head!.data
		if 1 == count {
			head = nil
			tail = nil
			current = nil
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
		if nil == tail {
			head = z
			tail = z
		} else {
			tail!.next = z
			z.previous = tail
			tail = z
		}
		++count
	}
	
	public func removeAtBack() -> V? {
		if nil == tail {
			return nil
		}
		
		var data: V? = tail!.data
		if 1 == count {
			head = nil
			tail = nil
			current = nil
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
	
	public func resetToFront() {
		current = head
	}
	
	public func resetToBack() {
		current = tail
	}
}