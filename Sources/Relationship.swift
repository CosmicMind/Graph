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
import CoreData

@objc(Relationship)
public class Relationship : NSObject, Comparable {
	internal let node: Node<ManagedRelationship>

	/**
		:name:	description
	*/
	public override var description: String {
		return "[nodeClass: \(nodeClass), id: \(id), type: \(type), groups: \(groups), properties: \(properties), subject: \(subject), object: \(object), createdDate: \(createdDate)]"
	}
	
	/**
		:name:	nodeClass
	*/
	public var nodeClass: NodeClass {
		return .Relationship
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
		:name:	subject
	*/
	public var subject: Entity? {
		get {
			if let v: ManagedEntity = node.object.subject {
				return Entity(object: v)
			}
			return nil
		}
		set(entity) {
			node.object.subject = entity?.node.object
		}
	}
	
	/**
		:name:	object
	*/
	public var object: Entity? {
		get {
			if let v: ManagedEntity = node.object.object {
				return Entity(object: v)
			}
			return nil
		}
		set(entity) {
			node.object.object = entity?.node.object
		}
	}
	
	/**
		:name:	init
	*/
	internal init(object: ManagedRelationship) {
		node = Node<ManagedRelationship>(object: object)
	}
	
	/**
		:name:	init
	*/
	public convenience init(type: String) {
		self.init(object: ManagedRelationship(type: type))
	}

 /**
  :name: init
  */
 public convenience required init(objectID: NSManagedObjectID, context: NSManagedObjectContext) {
  self.init(object:context.objectWithID(objectID) as! ManagedRelationship)
 }
 
 /**
  :name: cast
  */
 public func cast<R: Relationship>() -> R {
  if let context = self.node.object.context {
   return cast(context)
  } else {
   return cast(self.node.object.context!)
  }
 }
 /**
  :name: cast
  */
 public func cast<R: Relationship>(context: NSManagedObjectContext) -> R {
  return R(objectID: self.node.object.objectID, context: context)
 }

	/**
		:name:	isEqual
	*/
	public override func isEqual(object: AnyObject?) -> Bool {
		if let v = object as? Relationship {
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
    	:name:	delete
    */
    public func delete() {
		node.object.subject?.removeRelationshipSubjectSetObject(node.object)
		node.object.object?.removeRelationshipObjectSetObject(node.object)
        node.object.delete()
    }
}

public func <=(lhs: Relationship, rhs: Relationship) -> Bool {
	return lhs.id <= rhs.id
}

public func >=(lhs: Relationship, rhs: Relationship) -> Bool {
	return lhs.id >= rhs.id
}

public func >(lhs: Relationship, rhs: Relationship) -> Bool {
	return lhs.id > rhs.id
}

public func <(lhs: Relationship, rhs: Relationship) -> Bool {
	return lhs.id < rhs.id
}
