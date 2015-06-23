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
* Deque
*
* A Deque is a combination between a Deque and Queue. It allows for
* access of the latest and oldest data, as well as, allows insertion
* of data to be placed at the back or front of the structure. The
* following Deque implementation is backed by a List data structure.
*/

public class Deque<T>: Printable, SequenceType {
	internal typealias Generator = GeneratorOf<T?>
	
	/**
	* list
	* Underlying data structure.
	*/
	private var list: List<T>
	
	/**
	* count
	* Total number of items in the Deque.
	*/
	public var count: Int {
		return list.count
	}
	
	/**
	* front
	* Get the item at the front of the Deque
	* and do not remove it.
	*/
	public var front: T? {
		return list.front
	}
	
	/**
	* back
	* Get the item at the back of the Deque
	* and do not remove it.
	*/
	public var back: T? {
		return list.back
	}
	
	/**
	* empty
	* A boolean of whether the Deque is empty.
	*/
	public var empty: Bool {
		return list.empty
	}
	
	/**
	* description
	* Conforms to the Printable Protocol.
	*/
	public var description: String {
		return "Deque" + list.internalDescription
	}
	
	/**
	* init
	* Constructor.
	*/
	public init() {
		list = List<T>()
	}
	
	/**
	* generate
	* Conforms to the SequenceType Protocol. Returns
	* the next value in the sequence of nodes.
	*/
	public func generate() -> Generator {
		return list.generate()
	}
	
	/**
	* insertAtFront
	* Insert a new item at the front of the Deque.
	*/
	public func insertAtFront(data: T?) {
		list.insertAtFront(data)
	}
	
	/**
	* removeAtFront
	* Get the item at the front of the Deque
	* and remove it.
	*/
	public func removeAtFront() -> T? {
		return list.removeAtFront()
	}
	
	/**
	* insertAtBack
	* Insert a new item at the back of the Deque.
	*/
	public func insertAtBack(data: T?) {
		list.insertAtBack(data)
	}
	
	/**
	* Get the item at the back of the Deque
	* and remove it.
	*/
	public func removeAtBack() -> T? {
		return list.removeAtBack()
	}
	
	/**
	* removeAll
	* Remove all items from the Deque.
	*/
	public func removeAll() {
		list.removeAll()
	}
}

public func +<T>(lhs: Deque<T>, rhs: Deque<T>) -> Deque<T> {
	let d: Deque<T> = Deque<T>()
	for x in lhs {
		d.insertAtBack(x)
	}
	for x in rhs {
		d.insertAtBack(x)
	}
	return d
}
