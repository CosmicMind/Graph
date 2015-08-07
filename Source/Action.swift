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

@objc(Action)
public class Action : NSObject, Comparable {
	internal let node: ManagedAction

	/**
		:name:	init
		:description: Initializes Action with a given ManagedAction.
	*/
	internal init(action: ManagedAction!) {
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
	:name:	nodeClass
	:description:	Retrieves the nodeClass for the Model Object that is wrapped internally.
	*/
	public var nodeClass: String {
		return node.nodeClass
	}

	/**
		:name:	type
		:description:	Specifies the Type the Action belongs too.
		:returns:	String
	*/
	public var type: String {
		return node.type
	}

	/**
		:name:	id
		:description:	A unique identifier that is automatically
		generated. The identifier represents the Action instance
		globally amongst all data in Graph.
		:returns:	String
	*/
	public var id: String {
		let nodeURL: NSURL = node.objectID.URIRepresentation()
		let oID: String = nodeURL.lastPathComponent!
		return nodeClass + type + oID
	}

	/**
		:name:	createdDate
		:description:	Retrieves the date the Model Object was created.
		:returns:	NSDate
	*/
	public var createdDate: NSDate {
		return node.createdDate
	}

	/**
		:name:	groups
		:description:	Retrieves the Groups the Action is a part of.
		:returns: OrderedSet<Srting>
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
		:returns:	Bool
	*/
	public func addGroup(name: String) -> Bool {
		return node.addGroup(name)
	}

	/**
		:name:	hasGroup
		:descriptions: Checks whether the Node is a part of the Group name passed or not.
		:returns:	Bool
	*/
	public func hasGroup(name: String) -> Bool {
		return node.hasGroup(name)
	}

	/**
		:name:	removeGroup
		:description:	Removes a Group name from the list of Groups if it exists.
		:returns:	Bool
	*/
	public func removeGroup(name: String) -> Bool {
		return node.removeGroup(name)
	}

	/**
		:name:	properties
		:description:	Retrieves the Properties the Node is a part of.
		:returns:	OrderedTree<String, AnyObject>
	*/
	public var properties: OrderedDictionary<String, AnyObject> {
		var properties: OrderedDictionary<String, AnyObject> = OrderedDictionary<String, AnyObject>()
		for property in node.propertySet {
			properties.insert((property.name, property.value))
		}
		return properties
	}

	/**
		:name:	properties
		:description:	Allows for Dictionary style coding, which maps to the wrapped Model Object property values.
		:returns:	AnyObject?
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
    	:description:	Retrieves an OrderedMultiTree of Entity Objects. Where the key is the type
		of Entity, and the value is the Entity instance.
		:returns:	OrderedMultiTree<String, Entity>
    */
    public var subjects: OrderedMultiTree<String, Entity> {
		let nodes: OrderedMultiTree<String, Entity> = OrderedMultiTree<String, Entity>()
		for entry in node.subjectSet {
			let entity: Entity = Entity(entity: entry as! ManagedEntity)
			nodes.insert(entity.type, value: entity)
		}
		return nodes
    }

    /**
    	:name:	objects
		:description:	Retrieves an OrderedMultiTree of Entity Objects. Where the key is the type
		of Entity, and the value is the Entity instance.
		:returns:	OrderedMultiTree<String, Entity>
    */
    public var objects: OrderedMultiTree<String, Entity> {
		let nodes: OrderedMultiTree<String, Entity> = OrderedMultiTree<String, Entity>()
		for entry in node.objectSet {
			let entity: Entity = Entity(entity: entry as! ManagedEntity)
			nodes.insert(entity.type, value: entity)
		}
		return nodes
    }

    /**
    	:name:	addSubject
    	:description:	Adds a Entity Model Object to the Subject Set.
		:returns:	Bool
    */
    public func addSubject(entity: Entity!) -> Bool {
        return node.addSubject(entity.node)
	}

    /**
    	:name:	removeSubject
    	:description:	Removes a Entity Model Object from the Subject Set.
		:returns:	Bool
    */
    public func removeSubject(entity: Entity!) -> Bool {
		return node.removeSubject(entity.node)
    }

	/**
		:name:	hasSubject
		:description:	Checks if a Entity exists in the Subjects Set.
		:returns:	Bool
	*/
	public func hasSubject(entity: Entity!) -> Bool {
		for (_, e) in subjects.search(entity.type) {
			if e!.id == entity.id {
				return true
			}
		}
		return false
	}

    /**
    	:name:	addObject
    	:description:	Adds a Entity Object to the Object Set.
		:returns:	Bool
    */
    public func addObject(entity: Entity!) -> Bool {
        return node.addObject(entity.node)
    }

    /**
    	:name:	removeObject
    	:description:	Removes a Entity Model Object from the Object Set.
		:returns:	Bool
    */
    public func removeObject(entity: Entity!) -> Bool {
		return node.removeObject(entity.node)
    }

	/**
		:name:	hasObject
		:description:	Checks if a Entity exists in the Objects Set.
		:returns:	Bool
	*/
	public func hasObject(entity: Entity!) -> Bool {
		for (_, e) in objects.search(entity.type) {
			if e!.id == entity.id {
				return true
			}
		}
		return false
	}

    /**
    	:name:	delete
    	:description:	Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
		node.delete()
    }
}

extension Action : Equatable, Printable {
	override public var description: String {
		return "[nodeClass: \(nodeClass), id: \(id), type: \(type), groups: \(groups), properties: \(properties), subjects: \(subjects), objects: \(objects), createdDate: \(createdDate)]"
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
