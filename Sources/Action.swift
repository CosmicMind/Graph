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
	public var nodeClass: NodeClass {
		return .Action
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
	public var properties: Dictionary<String, AnyObject> {
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
    public var subjects: Array<Entity> {
		return node.object.subjectSet.map {
			return Entity(object: $0 as! ManagedEntity)
		} as Array<Entity>
    }

    /**
    	:name:	objects
	*/
    public var objects: Array<Entity> {
		return node.object.objectSet.map {
			return Entity(object: $0 as! ManagedEntity)
		} as Array<Entity>
    }
	
	/**
		:name:	init
	*/
	internal init(object: ManagedAction) {
		node = Node<ManagedAction>(object: object)
	}
	
	/**
		:name:	init
	*/
	public required convenience init(type: String) {
		self.init(object: ManagedAction(type: type))
	}
	
	/**
		:name:	isEqual
	*/
	public override func isEqual(object: AnyObject?) -> Bool {
		if let v = object as? Action {
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
		for x in node.object.subjectSet {
			if let v: ManagedEntity = x as? ManagedEntity {
				(v.actionSubjectSet as! NSMutableSet).removeObject(node.object)
			}
		}
		
		for x in node.object.objectSet {
			if let v: ManagedEntity = x as? ManagedEntity {
				(v.actionObjectSet as! NSMutableSet).removeObject(node.object)
			}
		}
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
