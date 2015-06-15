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
* Stack
*
* A Stack is a first-in, last-out (FILO) data structure. A Stack is an 
* excellent data structure for working with the most current data coming
* in. The following Stack implementation is backed by a List data structure.
*/

public class Stack<T>: Printable {
	/**
	* list
	* Underlying data structure.
	*/
	private var list: List<T>
	
	/**
	* count
	* Total number of items in the Stack.
	*/
	public var count: Int {
		return list.count
	}
	
	/**
	* top
	* Get the latest item at the top
	* of the Stack and do not remove 
	* it.
	*/
	public var top: T? {
		return list.front
	}
	
	/**
	* empty
	* A boolean of whether the Stack is empty.
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
		return "Stack" + output.substringWithRange(Range<String.Index>(start: advance(output.startIndex, 4), end: output.endIndex))
	}
	
	/**
	* init
	* Constructor
	*/
	public init() {
		list = List<T>()
	}
	
	/**
	* push
	* Insert data at the top of the Stack.
	*/
	public func push(data: T?) {
		list.insertAtFront(data)
	}
	
	/**
	* pop
	* Get the latest data at the top of 
	* the Stack and remove it from the
	* Stack.
	*/
	public func pop() -> T? {
		return list.removeAtFront()
	}
	
	/**
	* clear
	* Remove all items from the Stack.
	*/
	public func clear() {
		list.clear()
	}
}