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

@objc(Entity)
public class Entity : NSObject, Comparable {
	internal let node: ManagedEntity

	/**
		:name:	init
		:description:	Initializes Entity with a given ManagedEntity.
	*/
	internal init(entity: ManagedEntity!) {
		node = entity
	}

	/**
		:name:	init
		:description:	An initializer for the wrapped Model Object with a given type.
	*/
	public convenience init(type: String) {
		self.init(entity: ManagedEntity(type: type))
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
		:description:	Retrieves the Groups the Entity is a part of.
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
	public var properties: Dictionary<String, AnyObject> {
		var properties: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		for property in node.propertySet {
			properties[property.name] = property.object
		}
		return properties
	}

	/**
    	:name:	actions
    	:description:	Retrieves an OrderedSet<Action> of Action objects. Where the key
		is the type of Action and the value is the Action instance.
    */
    public var actions: OrderedSet<Action> {
		return actionsWhenSubject + actionsWhenObject
    }

    /**
    	:name:	actionsWhenSubject
		:description:	Retrieves an OrderedSet<Action> of Action objects. Where the key
		is the type of Action and the value is the Action instance.
		The Actions included are those when the Entity is the subject of
		the Action.
    */
    public var actionsWhenSubject: OrderedSet<Action> {
		var nodes: OrderedSet<Action> = OrderedSet<Action>()
		for entry in node.actionSubjectSet {
			nodes.insert(Action(action: entry as! ManagedAction))
		}
		return nodes
    }

    /**
    	:name:	actionsWhenObject
		:description:	Retrieves an OrderedSet<Action> of Action objects. Where the key
		is the type of Action and the value is the Action instance.
		The Actions included are those when the Entity is the object of
		the Action.
	*/
    public var actionsWhenObject: OrderedSet<Action> {
        var nodes: OrderedSet<Action> = OrderedSet<Action>()
		for entry in node.actionObjectSet {
			nodes.insert(Action(action: entry as! ManagedAction))
		}
		return nodes
    }

    /**
    	:name:	bonds
		:description:	Retrieves an OrderedSet<Bond> of Bond objects. Where the key
		is the type of Bond and the value is the Bond instance.
	*/
    public var bonds: OrderedSet<Bond> {
		return bondsWhenSubject + bondsWhenObject
    }

    /**
    	:name:	bondsWhenSubject
		:description:	Retrieves a OrderedSet<Bond> of Bond objects. Where the key
		is the type of Bond and the value is the Bond instance.
		The Bonds included are those when the Entity is the subject of
		the Bond.
	*/
    public var bondsWhenSubject: OrderedSet<Bond> {
		var nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for entry in node.bondSubjectSet {
			nodes.insert(Bond(bond: entry as! ManagedBond))
		}
		return nodes
    }

    /**
    	:name:	bondsWhenObject
		:description:	Retrieves an OrderedSet<Bond> of Bond objects. Where the key
		is the type of Bond and the value is the Bond instance.
		The Bonds included are those when the Entity is the object of
		the Bond.
	*/
    public var bondsWhenObject: OrderedSet<Bond> {
		var nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for entry in node.bondObjectSet {
			nodes.insert(Bond(bond: entry as! ManagedBond))
		}
		return nodes
    }

    /**
		:name:	delete
		:description:	Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
		node.delete()
    }
}

extension Entity : Equatable, Printable {
	override public var description: String {
		return "[nodeClass: \(nodeClass), id: \(id), type: \(type), groups: \(groups), properties: \(properties), createdDate: \(createdDate)]"
	}
}

public func ==(lhs: Entity, rhs: Entity) -> Bool {
	return lhs.id == rhs.id
}

public func <=(lhs: Entity, rhs: Entity) -> Bool {
	return lhs.id <= rhs.id
}

public func >=(lhs: Entity, rhs: Entity) -> Bool {
	return lhs.id >= rhs.id
}

public func >(lhs: Entity, rhs: Entity) -> Bool {
	return lhs.id > rhs.id
}

public func <(lhs: Entity, rhs: Entity) -> Bool {
	return lhs.id < rhs.id
}

