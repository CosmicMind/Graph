//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>
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
	//
	//	:name:	node
	//
	internal let node: Node<ManagedEntity>
	
	/**
		:name:	description
	*/
	public override var description: String {
		return node.description
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
	public subscript(name: String) -> AnyObject? {
		get {
			return node.object[name]
		}
		set(value) {
			node.object[name] = value
		}
	}

	/**
		:name:	properties
	*/
	public var properties: SortedDictionary<String, AnyObject> {
		return node.properties
	}

	/**
    	:name:	actions
    */
    public var actions: SortedSet<Action> {
		return actionsWhenSubject + actionsWhenObject
    }

    /**
    	:name:	actionsWhenSubject
	*/
    public var actionsWhenSubject: SortedSet<Action> {
		let nodes: SortedSet<Action> = SortedSet<Action>()
		for entry in node.object.actionSubjectSet {
			nodes.insert(Action(action: entry as! ManagedAction))
		}
		return nodes
    }

    /**
    	:name:	actionsWhenObject
	*/
    public var actionsWhenObject: SortedSet<Action> {
        let nodes: SortedSet<Action> = SortedSet<Action>()
		for entry in node.object.actionObjectSet {
			nodes.insert(Action(action: entry as! ManagedAction))
		}
		return nodes
    }

    /**
    	:name:	bonds
	*/
    public var bonds: SortedSet<Bond> {
		return bondsWhenSubject + bondsWhenObject
    }

    /**
    	:name:	bondsWhenSubject
	*/
    public var bondsWhenSubject: SortedSet<Bond> {
		let nodes: SortedSet<Bond> = SortedSet<Bond>()
		for entry in node.object.bondSubjectSet {
			nodes.insert(Bond(bond: entry as! ManagedBond))
		}
		return nodes
    }

    /**
    	:name:	bondsWhenObject
	*/
    public var bondsWhenObject: SortedSet<Bond> {
		let nodes: SortedSet<Bond> = SortedSet<Bond>()
		for entry in node.object.bondObjectSet {
			nodes.insert(Bond(bond: entry as! ManagedBond))
		}
		return nodes
    }
	
	/**
		:name:	init
	*/
	internal init(entity: ManagedEntity) {
		node = Node<ManagedEntity>(object: entity)
	}
	
	/**
		:name:	init
	*/
	public convenience init(type: String) {
		self.init(entity: ManagedEntity(type: type))
	}
	
	/**
		:name:	isEqual
	*/
	public override func isEqual(object: AnyObject?) -> Bool {
		if let rhs = object as? Entity {
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
		:name:	delete
	*/
    public func delete() {
		node.object.delete()
    }
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

