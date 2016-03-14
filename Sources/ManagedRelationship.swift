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

@objc(ManagedRelationship)
internal class ManagedRelationship : ManagedNode {
	@NSManaged internal var subject: ManagedEntity?
    @NSManaged internal var object: ManagedEntity?

	/**
		:name:	init
		:description:	Initializes the Model Object with e a given type.
	*/
	internal convenience init(type: String) {
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.relationshipDescriptionName, inManagedObjectContext: Graph.context!)!, insertIntoManagedObjectContext: Graph.context)
		nodeClass = NodeClass.Relationship.rawValue
        self.type = type
		createdDate = NSDate()
		propertySet = NSSet()
		groupSet = NSSet()
		subject = nil
		object = nil
		context = Graph.context
	}

	/**
		:name:	properties
		:description:	Allows for Dictionary style coding, which maps to the internal properties Dictionary.
    */
	internal subscript(name: String) -> AnyObject? {
		get {
			for n in propertySet {
				let property: ManagedRelationshipProperty = n as! ManagedRelationshipProperty
				if name == property.name {
					return property.object
				}
			}
			return nil
		}
		set(object) {
			if nil == object {
				for n in propertySet {
					let property: ManagedRelationshipProperty = n as! ManagedRelationshipProperty
					if name == property.name {
						property.delete()
						(propertySet as! NSMutableSet).removeObject(property)
						break
					}
				}
			} else {
				var hasProperty: Bool = false
				for n in propertySet {
					let property: ManagedRelationshipProperty = n as! ManagedRelationshipProperty
					if name == property.name {
						hasProperty = true
						property.object = object!
						break
					}
				}
				if false == hasProperty {
					let property: ManagedRelationshipProperty = ManagedRelationshipProperty(name: name, object: object!)
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
			let group: ManagedRelationshipGroup = ManagedRelationshipGroup(name: name)
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
            let group: ManagedRelationshipGroup = n as! ManagedRelationshipGroup
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
            let group: ManagedRelationshipGroup = n as! ManagedRelationshipGroup
            if name == group.name {
				group.delete()
				(groupSet as! NSMutableSet).removeObject(group)
				return true
            }
        }
        return false
    }
}

internal extension ManagedRelationship {

	/**
		:name:	addPropertySetObject
		:description:	Adds the Property to the propertySet for the Relationship.
	*/
	func addPropertySetObject(value: ManagedRelationshipProperty) {
		(propertySet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removePropertySetObject
		:description:	Removes the Property to the propertySet for the Relationship.
	*/
	func removePropertySetObject(value: ManagedRelationshipProperty) {
		(propertySet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addGroupSetObject
		:description:	Adds the Group to the groupSet for the Relationship.
	*/
	func addGroupSetObject(value: ManagedRelationshipGroup) {
		(groupSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeGroupSetObject
		:description:	Removes the Group to the groupSet for the Relationship.
	*/
	func removeGroupSetObject(value: ManagedRelationshipGroup) {
		(groupSet as! NSMutableSet).removeObject(value)
	}
}
