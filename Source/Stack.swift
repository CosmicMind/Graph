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
*/

public class Stack<V>: Printable {
	private var list: List<V>
	
	public var count: Int {
		return list.count
	}
	
	public var top: V? {
		return list.front
	}
	
	/**
	* empty
	* A boolean if the Stack is empty.
	*/
	public var empty: Bool {
		return list.empty
	}
	
	public var description: String {
		var output: String = "Stack("
		output += ")"
		return output
	}
	
	public init() {
		list = List<V>()
	}
	
	public func push(data: V?) {
		list.insertAtFront(data)
	}
	
	public func pop() -> V? {
		return list.removeAtFront()
	}
}