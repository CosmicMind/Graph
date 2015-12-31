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
	public var groups: Array<String> {
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
	public var properties: Dictionary<String, AnyObject> {
		return node.properties
	}

	/**
    	:name:	actions
    */
    public var actions: Array<Action> {
		return actionsWhenSubject + actionsWhenObject
    }

    /**
    	:name:	actionsWhenSubject
	*/
    public var actionsWhenSubject: Array<Action> {
		return node.object.actionSubjectSet.map {
			return Action(object: $0 as! ManagedAction)
		} as Array<Action>
    }

    /**
    	:name:	actionsWhenObject
	*/
    public var actionsWhenObject: Array<Action> {
		return node.object.actionObjectSet.map {
			return Action(object: $0 as! ManagedAction)
		} as Array<Action>
    }

    /**
    	:name:	bonds
	*/
    public var bonds: Array<Bond> {
		return bondsWhenSubject + bondsWhenObject
    }

    /**
    	:name:	bondsWhenSubject
	*/
    public var bondsWhenSubject: Array<Bond> {
		return node.object.bondSubjectSet.map {
			return Bond(object: $0 as! ManagedBond)
		} as Array<Bond>
    }

    /**
    	:name:	bondsWhenObject
	*/
    public var bondsWhenObject: Array<Bond> {
		return node.object.bondObjectSet.map {
			return Bond(object: $0 as! ManagedBond)
		} as Array<Bond>
    }
	
	/**
		:name:	init
	*/
	internal init(object: ManagedEntity) {
		node = Node<ManagedEntity>(object: object)
	}
	
	/**
		:name:	init
	*/
	public convenience init(type: String) {
		self.init(object: ManagedEntity(type: type))
	}
	
	/**
		:name:	isEqual
	*/
	public override func isEqual(object: AnyObject?) -> Bool {
		if let v = object as? Entity {
			return id == v.id
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

