//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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

import Foundation

internal class Node <Type : ManagedNode> : NSObject {
	//
	//	:name:	object
	//
	internal let object: Type
	
	//
	//	:name:	nodeClass
	//
	internal var nodeClass: String {
		return object.nodeClass
	}
	
	//
	//	:name:	type
	//
	internal var type: String {
		return object.type
	}
	
	//
	//	:name:	id
	//
	internal var id: String {
		let nodeURL: NSURL = object.objectID.URIRepresentation()
		let oID: String = nodeURL.lastPathComponent!
		return nodeClass + type + oID
	}
	
	//
	//	:name:	createdDate
	//
	internal var createdDate: NSDate {
		return object.createdDate
	}
	
	//
	//	:name:	groups
	//
	internal var groups: OrderedSet<String> {
		let groups: OrderedSet<String> = OrderedSet<String>()
		for group in object.groupSet {
			let name: String = group.name
			groups.insert(name)
		}
		return groups
	}
	
	//
	//	:name:	properties
	//
	internal var properties: Dictionary<String, AnyObject> {
		var properties: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		for property in object.propertySet {
			properties[property.name] = property.object
		}
		return properties
	}
	
	//
	//	:name:	init
	//
	internal init(node: Type) {
		self.object = node
		super.init()
	}
}