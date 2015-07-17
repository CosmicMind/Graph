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
*/

import Foundation

@objc(Bond)
public class Bond : NSObject {
	internal let node: ManagedBond

	/**
		:name:	init
		:description: Initializes Bond with a given ManagedBond.
	*/
	internal init(bond: ManagedBond!) {
		node = bond
	}

	/**
		:name:	init
		:description:	An initializer for the wrapped Model Object with a given type.
	*/
	public convenience init(type: String) {
		self.init(bond: ManagedBond(type: type))
	}

	/**
		:name:	nodeClass
		:description:	Retrieves the nodeClass for the Model Object that is wrapped internally.
	*/
	public var nodeClass: String {
		return node.nodeClass
	}

	/**
		:name:	type
		:description:	Retrieves the type for the Model Object that is wrapped internally.
	*/
	public var type: String {
		return node.type
	}

	/**
		:name:	id
		:description:	Retrieves the ID for the Model Object that is wrapped internally.
	*/
	public var id: String {
		let nodeURL: NSURL = node.objectID.URIRepresentation()
		let oID: String = nodeURL.lastPathComponent!
		return nodeClass + type + oID
	}

	/**
		:name:	createdDate
		:description:	Retrieves the date the Model Object was created.
	*/
	public var createdDate: NSDate {
		return node.createdDate
	}

	/**
		:name:	groups
		:description:	Retrieves the Groups the Bond is a part of.
	*/
	public var groups: OrderedSet<String> {
		var groups: OrderedSet<String> = OrderedSet<String>()
		for group in node.groupSet {
			let name: String = group.name
			groups.insert(name)
		}
		return groups
	}

	/**
		:name:	addGroup
		:description:	Adds a Group name to the list of Groups if it does not exist.
	*/
	public func addGroup(name: String) -> Bool {
		return node.addGroup(name)
	}

	/**
		:name:	hasGroup
		:description:	Checks whether the Node is a part of the Group name passed or not.
	*/
	public func hasGroup(name: String) -> Bool {
		return node.hasGroup(name)
	}

	/**
		:name:	removeGroup
		:description:	Removes a Group name from the list of Groups if it exists.
	*/
	public func removeGroup(name: String) -> Bool {
		return node.removeGroup(name)
	}

	/**
		:name:	properties
		:description:	Allows for Dictionary style coding, which maps to the wrapped Model Object property values.
	*/
	public subscript(name: String) -> AnyObject? {
		get {
			return node[name]
		}
		set(value) {
			node[name] = value
		}
	}

	/**
		:name:	properties
		:description:	Retrieves the Properties the Node is a part of.
	*/
	public var properties: Tree<String, AnyObject> {
		var properties: Tree<String, AnyObject> = Tree<String, AnyObject>()
		for property in node.propertySet {
			properties.insert(property.name, value: property.value)
		}
		return properties
	}

    /**
    	:name:	subject
    	:description:	Retrieves an Entity Object.
    */
    public var subject: Entity? {
        get {
			return nil == node.subject ? nil : Entity(entity: node.subject)
        }
        set(entity) {
            node.subject = entity?.node
        }
    }

    /**
    	:name:	object
    	:description:	Retrieves an Entity Object.
    */
    public var object: Entity? {
		get {
			return nil == node.object ? nil : Entity(entity: node.object)
		}
		set(entity) {
			node.object = entity?.node
		}
    }

    /**
    	:name:	delete
    	:description:	Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
        node.delete()
    }
}

extension Bond : Equatable, Printable {
	override public var description: String {
		return "[nodeClass: \(nodeClass), id: \(id), type: \(type), groups: \(groups), properties: \(properties), subject: \(subject), object: \(object), createdDate: \(createdDate)]"
	}
}

public func ==(lhs: Bond, rhs: Bond) -> Bool {
	return lhs.id == rhs.id
}
