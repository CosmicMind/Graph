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

/**
	Overview
	Represents Action Nodes, which are repetitive relationships between Entity Nodes.
*/
@objc(Action) public class Action: NSObject {
	internal let node: ManagedAction

	/**
		init
		Initializes Action with a given ManagedAction.
	*/
	internal init(action: ManagedAction!) {
		node = action
	}

	/**
		init
		An initializer for the wrapped Model Object with a given type.
	*/
	public convenience init(type: String) {
		self.init(action: ManagedAction(type: type))
	}

	/**
		nodeClass
		Retrieves the nodeClass for the Model Object that is wrapped internally.
	*/
	public var nodeClass: String {
		return node.nodeClass
	}

	/**
		type
		Retrieves the type for the Model Object that is wrapped internally.
	*/
	public var type: String {
		return node.type
	}

	/**
		id
		Retrieves the ID for the Model Object that is wrapped internally.
	*/
	public var id: String {
		let nodeURL: NSURL = node.objectID.URIRepresentation()
		let oID: String = nodeURL.lastPathComponent!
		return nodeClass + type + oID
	}

	/**
		createdDate
		Retrieves the date the Model Object was created.
	*/
	public var createdDate: NSDate {
		return node.createdDate
	}

	/**
		groups
		Retrieves the Groups the Action is a part of.
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
		addGroup
		Adds a Group name to the list of Groups if it does not exist.
	*/
	public func addGroup(name: String) -> Bool {
		return node.addGroup(name)
	}

	/**
		hasGroup
		Checks whether the Node is a part of the Group name passed or not.
	*/
	public func hasGroup(name: String) -> Bool {
		return node.hasGroup(name)
	}

	/**
		removeGroup
		Removes a Group name from the list of Groups if it exists.
	*/
	public func removeGroup(name: String) -> Bool {
		return node.removeGroup(name)
	}

	/**
		properties
		Retrieves the Properties the Node is a part of.
	*/
	public var properties: Tree<String, AnyObject> {
		var properties: Tree<String, AnyObject> = Tree<String, AnyObject>()
		for property in node.propertySet {
			properties.insert(property.name, value: property.value)
		}
		return properties
	}

	/**
		properties
		Allows for Dictionary style coding, which maps to the wrapped Model Object property values.
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
    	subjects
    	Retrieves a MultiTree of Entity Objects. Where the key is the type
		of Entity, and the value is the Entity instance.
    */
    public var subjects: MultiTree<String, Entity> {
		let nodes: MultiTree<String, Entity> = MultiTree<String, Entity>()
		for entry in node.subjectSet {
			let entity: Entity = Entity(entity: entry as! ManagedEntity)
			nodes.insert(entity.type, value: entity)
		}
		return nodes
    }

    /**
    	objects
		Retrieves a MultiTree of Entity Objects. Where the key is the type
		of Entity, and the value is the Entity instance.
    */
    public var objects: MultiTree<String, Entity> {
		let nodes: MultiTree<String, Entity> = MultiTree<String, Entity>()
		for entry in node.objectSet {
			let entity: Entity = Entity(entity: entry as! ManagedEntity)
			nodes.insert(entity.type, value: entity)
		}
		return nodes
    }

    /**
    	addSubject
    	Adds a Entity Model Object to the Subject Set.
    */
    public func addSubject(entity: Entity!) -> Bool {
        return node.addSubject(entity.node)
	}

    /**
    	removeSubject
    	Removes a Entity Model Object from the Subject Set.
    */
    public func removeSubject(entity: Entity!) -> Bool {
		return node.removeSubject(entity.node)
    }

	/**
		hasSubject
		Checks if a Entity exists in the Subjects Set.
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
    	addObject
    	Adds a Entity Object to the Object Set.
    */
    public func addObject(entity: Entity!) -> Bool {
        return node.addObject(entity.node)
    }

    /**
    	removeObject
    	Removes a Entity Model Object from the Object Set.
    */
    public func removeObject(entity: Entity!) -> Bool {
		return node.removeObject(entity.node)
    }

	/**
		hasObject
		Checks if a Entity exists in the Objects Set.
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
    	delete
    	Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
		node.delete()
    }
}

extension Action: Equatable, Printable {
	override public var description: String {
		return "{id: \((id)), type: \(type), groups: \(groups), properties: \(properties), subjects: \(subjects), objects: \(objects), createdDate: \(createdDate)}"
	}
}

public func ==(lhs: Action, rhs: Action) -> Bool {
	return lhs.id == rhs.id
}
