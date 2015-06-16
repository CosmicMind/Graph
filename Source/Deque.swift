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
* A Deque is a combination between a Stack and Queue. It allows for
* access of the latest and oldest data, as well as, allows insertion
* of data to be placed at the back or front of the structure. The
* following Deque implementation is backed by a List data structure.
*/

public class Deque<T>: Printable {
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
		var output: String = list.description
		return "Deque" + output.substringWithRange(Range<String.Index>(start: advance(output.startIndex, 4), end: output.endIndex))
	}
	
	/**
	* init
	* Constructor.
	*/
	public init() {
		list = List<T>()
	}
	
	/**
	* pushFront
	* Insert a new item at the front of the Deque.
	*/
	public func pushFront(data: T?) {
		list.insertAtFront(data)
	}
	
	/**
	* popFront
	* Get the item at the front of the Deque
	* and remove it.
	*/
	public func popFront() -> T? {
		return list.removeAtFront()
	}
	
	/**
	* pushBack
	* Insert a new item at the back of the Deque.
	*/
	public func pushBack(data: T?) {
		list.insertAtBack(data)
	}
	
	/**
	* Get the item at the back of the Deque
	* and remove it.
	*/
	public func popBack() -> T? {
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