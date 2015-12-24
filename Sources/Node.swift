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

import Foundation

internal class Node <Type : ManagedNode> : NSObject {
	//
	//	:name:	object
	//
	internal let object: Type
	
	/**
		:name:	description
	*/
	internal override var description: String {
		return "[nodeClass: \(nodeClass), id: \(id), type: \(type), groups: \(groups), properties: \(properties), createdDate: \(createdDate)]"
	}
	
	//
	//	:name:	nodeClass
	//
	internal var nodeClass: NSNumber {
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
		do {
			try object.worker?.obtainPermanentIDsForObjects([object])
		} catch {}
		let nodeURL: NSURL = object.objectID.URIRepresentation()
		let oID: String = nodeURL.lastPathComponent!
		return String(stringInterpolationSegment: nodeClass) + type + oID
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
	internal var groups: SortedSet<String> {
		let groups: SortedSet<String> = SortedSet<String>()
		for group in object.groupSet {
			let name: String = group.name
			groups.insert(name)
		}
		return groups
	}
	
	//
	//	:name:	properties
	//
	internal var properties: SortedDictionary<String, AnyObject> {
		let properties: SortedDictionary<String, AnyObject> = SortedDictionary<String, AnyObject>()
		for property in object.propertySet {
			properties[property.name] = property.object
		}
		return properties
	}
	
	//
	//	:name:	init
	//
	internal init(object: Type) {
		self.object = object
	}
}