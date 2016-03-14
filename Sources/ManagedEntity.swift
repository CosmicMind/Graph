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
import CoreData

@objc(ManagedEntity)
internal class ManagedEntity : ManagedNode {
	@NSManaged internal var actionSubjectSet: NSSet
	@NSManaged internal var actionObjectSet: NSSet
	@NSManaged internal var relationshipSubjectSet: NSSet
	@NSManaged internal var relationshipObjectSet: NSSet

	/**
		:name:	init
		:description:	Initializes the Model Object with e a given type.
	*/
	internal convenience init(type: String) {
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.entityDescriptionName, inManagedObjectContext: Graph.context!)!, insertIntoManagedObjectContext: Graph.context)
		nodeClass = NodeClass.Entity.rawValue
		self.type = type
		createdDate = NSDate()
		propertySet = NSSet()
		groupSet = NSSet()
		actionSubjectSet = NSSet()
		actionObjectSet = NSSet()
		relationshipSubjectSet = NSSet()
		relationshipObjectSet = NSSet()
		context = Graph.context
	}

	/**
		:name:	properties
		:description:	Allows for Dictionary style coding, which maps to the internal properties Dictionary.
	*/
	internal subscript(name: String) -> AnyObject? {
		get {
			for n in propertySet {
				let property: ManagedEntityProperty = n as! ManagedEntityProperty
				if name == property.name {
					return property.object
				}
			}
			return nil
		}
		set(object) {
			if nil == object {
				for n in propertySet {
					let property: ManagedEntityProperty = n as! ManagedEntityProperty
					if name == property.name {
						property.delete()
						(propertySet as! NSMutableSet).removeObject(property)
						break
					}
				}
			} else {
				var hasProperty: Bool = false
				for n in propertySet {
					let property: ManagedEntityProperty = n as! ManagedEntityProperty
					if name == property.name {
						hasProperty = true
						property.object = object!
						break
					}
				}
				if false == hasProperty {
					let property: ManagedEntityProperty = ManagedEntityProperty(name: name, object: object!)
					property.node = self
				}
			}
		}
	}

	/**
		:name:	addGroup
		:description:	Adds a Group name to the list of Groups if it does not exist.
	*/
	internal func addGroup(name: String!) -> Bool {
		if !hasGroup(name) {
			let group: ManagedEntityGroup = ManagedEntityGroup(name: name)
			group.node = self
			return true
		}
		return false
	}

	/**
		:name:	hasGroup
		:description:	Checks whether the Node is a part of the Group name passed or not.
	*/
	internal func hasGroup(name: String!) -> Bool {
		for n in groupSet {
			let group: ManagedEntityGroup = n as! ManagedEntityGroup
			if name == group.name {
				return true
			}
		}
		return false
	}

	/**
		:name:	removeGroup
		:description:	Removes a Group name from the list of Groups if it exists.
	*/
	internal func removeGroup(name: String!) -> Bool {
		for n in groupSet {
			let group: ManagedEntityGroup = n as! ManagedEntityGroup
			if name == group.name {
				group.delete()
				(groupSet as! NSMutableSet).removeObject(group)
				return true
			}
		}
		return false
	}
}

internal extension ManagedEntity {

	/**
		:name:	addActionSubjectSetObject
		:description:	Adds the Action to the actionSubjectSet for the Entity.
	*/
	func addActionSubjectSetObject(value: ManagedAction) {
		(actionSubjectSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeActionSubjectSetObject
		:description:	Removes the Action to the actionSubjectSet for the Entity.
	*/
	func removeActionSubjectSetObject(value: ManagedAction) {
		(actionSubjectSet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addActionObjectSetObject
		:description:	Adds the Action to the actionObjectSet for the Entity.
	*/
	func addActionObjectSetObject(value: ManagedAction) {
		(actionObjectSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeActionObjectSetObject
		:description:	Removes the Action to the actionObjectSet for the Entity.
	*/
	func removeActionObjectSetObject(value: ManagedAction) {
		(actionObjectSet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addRelationshipSubjectSetObject
		:description:	Adds the Relationship to the relationshipSubjectSet for the Entity.
	*/
	func addRelationshipSubjectSetObject(value: ManagedRelationship) {
		(relationshipSubjectSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeRelationshipSubjectSetObject
		:description:	Removes the Relationship to the relationshipSubjectSet for the Entity.
	*/
	func removeRelationshipSubjectSetObject(value: ManagedRelationship) {
		(relationshipSubjectSet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addRelationshipObjectSetObject
		:description:	Adds the Relationship to the relationshipObjectSet for the Entity.
	*/
	func addRelationshipObjectSetObject(value: ManagedRelationship) {
		(relationshipObjectSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeRelationshipObjectSetObject
		:description:	Removes the Relationship to the relationshipObjectSet for the Entity.
	*/
	func removeRelationshipObjectSetObject(value: ManagedRelationship) {
		(relationshipObjectSet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addPropertySetObject
		:description:	Adds the Property to the propertySet for the Entity.
	*/
	func addPropertySetObject(value: ManagedEntityProperty) {
		(propertySet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removePropertySetObject
		:description:	Removes the Property to the propertySet for the Entity.
	*/
	func removePropertySetObject(value: ManagedEntityProperty) {
		(propertySet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addGroupSetObject
		:description:	Adds the Group to the groupSet for the Entity.
	*/
	func addGroupSetObject(value: ManagedEntityGroup) {
		(groupSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeGroupSetObject
		:description:	Removes the Group to the groupSet for the Entity.
	*/
	func removeGroupSetObject(value: ManagedEntityGroup) {
		(groupSet as! NSMutableSet).removeObject(value)
	}
}
