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

import Foundation

@objc(Bond)
public class Bond : NSObject, Comparable {
	internal let node: Node<ManagedBond>

	/**
		:name:	description
	*/
	public override var description: String {
		return "[nodeClass: \(nodeClass), id: \(id), type: \(type), groups: \(groups), properties: \(properties), subject: \(subject), object: \(object), createdDate: \(createdDate)]"
	}
	
	/**
		:name:	json
	*/
	public var json: JSON {
		let j: JSON = node.json
		j["subject"] = subject?.json
		j["object"] = object?.json
		return j
	}
	
	/**
		:name:	nodeClass
	*/
	public var nodeClass: NSNumber {
		return node.nodeClass
	}

	/**
		:name:	type
	*/
	public var type: String {
		return node.type
	}

	/**
		:name:	id
	*/
	public var id: String {
		return node.id
	}

	/**
		:name:	createdDate
	*/
	public var createdDate: NSDate {
		return node.createdDate
	}

	/**
		:name:	groups
	*/
	public var groups: SortedSet<String> {
		return node.groups
	}
	
	/**
		:name:	properties
	*/
	public var properties: Dictionary<String, AnyObject> {
		return node.properties
	}
	
	/**
		:name:	subject
	*/
	public var subject: Entity? {
		get {
			return nil == node.object.subject ? nil : Entity(entity: node.object.subject!)
		}
		set(entity) {
			node.object.subject = entity?.node.object
		}
	}
	
	/**
		:name:	object
	*/
	public var object: Entity? {
		get {
			return nil == node.object.object ? nil : Entity(entity: node.object.object!)
		}
		set(entity) {
			node.object.object = entity?.node.object
		}
	}
	
	/**
		:name:	init
	*/
	internal init(bond: ManagedBond) {
		node = Node<ManagedBond>(object: bond)
	}
	
	/**
		:name:	init
	*/
	public convenience init(type: String) {
		self.init(bond: ManagedBond(type: type))
	}
	
	/**
		:name:	isEqual
	*/
	public override func isEqual(object: AnyObject?) -> Bool {
		if let rhs = object as? Bond {
			return id == rhs.id
		}
		return false
	}
	
	/**
		:name:	addGroup
	*/
	public func addGroup(name: String) -> Bool {
		return node.object.addGroup(name)
	}

	/**
		:name:	hasGroup
	*/
	public func hasGroup(name: String) -> Bool {
		return node.object.hasGroup(name)
	}

	/**
		:name:	removeGroup
	*/
	public func removeGroup(name: String) -> Bool {
		return node.object.removeGroup(name)
	}
	
	/**
		:name:	toggleGroup
	*/
	public func toggleGroup(name: String) -> Bool {
		return hasGroup(name) ? removeGroup(name) : addGroup(name)
	}

	/**
		:name:	properties
	*/
	public subscript(name: String) -> AnyObject? {
		get {
			return node.object[name]
		}
		set(value) {
			node.object[name] = value
		}
	}

	/**
    	:name:	delete
    */
    public func delete() {
        node.object.delete()
    }
}

public func <=(lhs: Bond, rhs: Bond) -> Bool {
	return lhs.id <= rhs.id
}

public func >=(lhs: Bond, rhs: Bond) -> Bool {
	return lhs.id >= rhs.id
}

public func >(lhs: Bond, rhs: Bond) -> Bool {
	return lhs.id > rhs.id
}

public func <(lhs: Bond, rhs: Bond) -> Bool {
	return lhs.id < rhs.id
}
