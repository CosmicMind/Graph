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

public class Action : Equatable, CustomStringConvertible, Comparable {
	internal let node: ManagedAction
	
	/**
		:name:	description
	*/
	public var description: String {
		return "[nodeClass: \(nodeClass), id: \(id), type: \(type), groups: \(groups), properties: \(properties), subjects: \(subjects), objects: \(objects), createdDate: \(createdDate)]"
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
		:description:	Specifies the Type the Action belongs too.
		- returns:	String
	*/
	public var type: String {
		return node.type
	}

	/**
		:name:	id
		:description:	A unique identifier that is automatically
		generated. The identifier represents the Action instance
		globally amongst all data in Graph.
		- returns:	String
	*/
	public var id: String {
		let nodeURL: NSURL = node.objectID.URIRepresentation()
		let oID: String = nodeURL.lastPathComponent!
		return nodeClass + type + oID
	}

	/**
		:name:	createdDate
		:description:	Retrieves the date the Model Object was created.
		- returns:	NSDate
	*/
	public var createdDate: NSDate {
		return node.createdDate
	}

	/**
		:name:	groups
		:description:	Retrieves the Groups the Action is a part of.
		- returns: OrderedSet<Srting>
	*/
	public var groups: OrderedSet<String> {
		let groups: OrderedSet<String> = OrderedSet<String>()
		for group in node.groupSet {
			let name: String = group.name
			groups.insert(name)
		}
		return groups
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
		:name:	properties
		:description:	Allows for Dictionary style coding, which maps to the wrapped Model Object property values.
		- returns:	AnyObject?
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
    	:name:	subjects
    	:description:	Retrieves an OrderedMultiDictionary of Entity Objects. Where the key is the type
		of Entity, and the value is the Entity instance.
		- returns:	OrderedSet<Entity>
    */
    public var subjects: OrderedSet<Entity> {
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for entry in node.subjectSet {
			nodes.insert(Entity(entity: entry as! ManagedEntity))
		}
		return nodes
    }

    /**
    	:name:	objects
		:description:	Retrieves an OrderedMultiDictionary of Entity Objects. Where the key is the type
		of Entity, and the value is the Entity instance.
		- returns:	OrderedSet<Entity>
    */
    public var objects: OrderedSet<Entity> {
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for entry in node.objectSet {
			nodes.insert(Entity(entity: entry as! ManagedEntity))
		}
		return nodes
    }
	
	/**
		:name:	init
		:description: Initializes Action with a given ManagedAction.
	*/
	internal init(action: ManagedAction) {
		node = action
	}
	
	/**
		:name:	init
		:description:	An initializer for the wrapped Model Object with a given type.
	*/
	public convenience init(type: String) {
		self.init(action: ManagedAction(type: type))
	}
	
	/**
		:name:	addGroup
		:description:	Adds a Group name to the list of Groups if it does not exist.
		- returns:	Bool
	*/
	public func addGroup(name: String) -> Bool {
		return node.addGroup(name)
	}
	
	/**
		:name:	hasGroup
		:descriptions: Checks whether the Node is a part of the Group name passed or not.
		- returns:	Bool
	*/
	public func hasGroup(name: String) -> Bool {
		return node.hasGroup(name)
	}
	
	/**
		:name:	removeGroup
		:description:	Removes a Group name from the list of Groups if it exists.
		- returns:	Bool
	*/
	public func removeGroup(name: String) -> Bool {
		return node.removeGroup(name)
	}
	
    /**
    	:name:	addSubject
    	:description:	Adds a Entity Model Object to the Subject Set.
		- returns:	Bool
    */
    public func addSubject(entity: Entity) -> Bool {
        return node.addSubject(entity.node)
	}

    /**
    	:name:	removeSubject
    	:description:	Removes a Entity Model Object from the Subject Set.
		- returns:	Bool
    */
    public func removeSubject(entity: Entity) -> Bool {
		return node.removeSubject(entity.node)
    }

	/**
		:name:	hasSubject
		:description:	Checks if a Entity exists in the Subjects Set.
		- returns:	Bool
	*/
	public func hasSubject(entity: Entity) -> Bool {
		return subjects.contains(entity)
	}

    /**
    	:name:	addObject
    	:description:	Adds a Entity Object to the Object Set.
		- returns:	Bool
    */
    public func addObject(entity: Entity) -> Bool {
        return node.addObject(entity.node)
    }

    /**
    	:name:	removeObject
    	:description:	Removes a Entity Model Object from the Object Set.
		- returns:	Bool
    */
    public func removeObject(entity: Entity) -> Bool {
		return node.removeObject(entity.node)
    }

	/**
		:name:	hasObject
		:description:	Checks if a Entity exists in the Objects Set.
		- returns:	Bool
	*/
	public func hasObject(entity: Entity) -> Bool {
		return objects.contains(entity)
	}

    /**
    	:name:	delete
    	:description:	Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
		node.delete()
    }
}

public func ==(lhs: Action, rhs: Action) -> Bool {
	return lhs.id == rhs.id
}

public func <=(lhs: Action, rhs: Action) -> Bool {
	return lhs.id <= rhs.id
}

public func >=(lhs: Action, rhs: Action) -> Bool {
	return lhs.id >= rhs.id
}

public func >(lhs: Action, rhs: Action) -> Bool {
	return lhs.id > rhs.id
}

public func <(lhs: Action, rhs: Action) -> Bool {
	return lhs.id < rhs.id
}
