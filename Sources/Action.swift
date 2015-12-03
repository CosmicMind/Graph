//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
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
	//
	//	:name:	node
	//
	internal let node: Node<ManagedAction>
	
	/**
		:name:	description
	*/
	public override var description: String {
		return "[nodeClass: \(nodeClass), id: \(id), type: \(type), groups: \(groups), properties: \(properties), subjects: \(subjects), objects: \(objects), createdDate: \(createdDate)]"
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
	public var properties: SortedDictionary<String, AnyObject> {
		return node.properties
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
    	:name:	subjects
    */
    public var subjects: SortedSet<Entity> {
		let nodes: SortedSet<Entity> = SortedSet<Entity>()
		for entity in node.object.subjectSet {
			nodes.insert(Entity(entity: entity as! ManagedEntity))
		}
		return nodes
    }

    /**
    	:name:	objects
	*/
    public var objects: SortedSet<Entity> {
		let nodes: SortedSet<Entity> = SortedSet<Entity>()
		for entity in node.object.objectSet {
			nodes.insert(Entity(entity: entity as! ManagedEntity))
		}
		return nodes
    }
	
	/**
		:name:	init
	*/
	internal init(action: ManagedAction) {
		node = Node<ManagedAction>(object: action)
	}
	
	/**
		:name:	init
	*/
	public convenience init(type: String) {
		self.init(action: ManagedAction(type: type))
	}
	
	/**
		:name:	isEqual
	*/
	public override func isEqual(object: AnyObject?) -> Bool {
		if let rhs = object as? Action {
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
    	:name:	addSubject
    */
    public func addSubject(entity: Entity) -> Bool {
        return node.object.addSubject(entity.node.object)
	}

    /**
    	:name:	removeSubject
    */
    public func removeSubject(entity: Entity) -> Bool {
		return node.object.removeSubject(entity.node.object)
    }

	/**
		:name:	hasSubject
	*/
	public func hasSubject(entity: Entity) -> Bool {
		return subjects.contains(entity)
	}

    /**
    	:name:	addObject
    */
    public func addObject(entity: Entity) -> Bool {
        return node.object.addObject(entity.node.object)
    }

    /**
    	:name:	removeObject
    */
    public func removeObject(entity: Entity) -> Bool {
		return node.object.removeObject(entity.node.object)
    }

	/**
		:name:	hasObject
	*/
	public func hasObject(entity: Entity) -> Bool {
		return objects.contains(entity)
	}

    /**
    	:name:	delete
    */
    public func delete() {
		node.object.delete()
    }
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
