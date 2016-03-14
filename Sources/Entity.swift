/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Graph nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
	public var nodeClass: NodeClass {
		return .Entity
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
		var s: Set<ManagedAction> = Set<ManagedAction>()
		s.unionInPlace(node.object.actionSubjectSet as! Set<ManagedAction>)
		s.unionInPlace(node.object.actionObjectSet as! Set<ManagedAction>)
		return s.map {
			return Action(object: $0 as ManagedAction)
		} as Array<Action>
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
    	:name:	relationships
	*/
    public var relationships: Array<Relationship> {
		var s: Set<ManagedRelationship> = Set<ManagedRelationship>()
		s.unionInPlace(node.object.relationshipSubjectSet as! Set<ManagedRelationship>)
		s.unionInPlace(node.object.relationshipObjectSet as! Set<ManagedRelationship>)
		return s.map {
			return Relationship(object: $0 as ManagedRelationship)
		} as Array<Relationship>
    }

    /**
    	:name:	relationshipsWhenSubject
	*/
    public var relationshipsWhenSubject: Array<Relationship> {
		return node.object.relationshipSubjectSet.map {
			return Relationship(object: $0 as! ManagedRelationship)
		} as Array<Relationship>
    }

    /**
    	:name:	relationshipsWhenObject
	*/
    public var relationshipsWhenObject: Array<Relationship> {
		return node.object.relationshipObjectSet.map {
			return Relationship(object: $0 as! ManagedRelationship)
		} as Array<Relationship>
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
	public required convenience init(type: String) {
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

