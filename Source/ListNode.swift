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
* ListNode
* 
* Used internally by the List data structure to store pointers to nodes and satellite
* data.
*/

internal class ListNode<T>: Printable {
	private typealias LNode = ListNode<T>
	
	/**
	* next
	* Points to the successor item in the List.
	*/
	internal var next: LNode?
	
	/**
	* previous
	* points to the predacessor item in the List.
	*/
	internal var previous: LNode?
	
	/**
	* data
	* Satellite data.
	*/
	internal var data: T?
	
	/**
	* description
	* Conforms to the Printtable Protocol.
	*/
	internal var description: String {
		return "\(data)"
	}
	
	/**
	* init
	* Constructor.
	* @param		next: ListNode<T>?
	* @param		previous: ListNode<T>?
	* @param		data: T?
	*/
	internal init(next: LNode?, previous: LNode?, data: T?) {
		self.next = next
		self.previous = previous
		self.data = data
	}
}