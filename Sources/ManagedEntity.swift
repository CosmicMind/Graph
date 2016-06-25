/*
 * Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>.
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
 *	*	Neither the name of CosmicMind nor the names of its
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
internal class ManagedEntity: ManagedNode {
    @NSManaged internal var actionSubjectSet: NSSet
    @NSManaged internal var actionObjectSet: NSSet
    @NSManaged internal var relationshipSubjectSet: NSSet
    @NSManaged internal var relationshipObjectSet: NSSet
    
    /**
     Initializer that accepts a type and a NSManagedObjectContext.
     - Parameter type: A reference to the Entity type.
     - Parameter context: A reference to the NSManagedObejctContext.
    */
    internal convenience init(_ type: String, context: NSManagedObjectContext) {
        self.init(identifier: ModelIdentifier.entityDescriptionName, type: type, context: context)
        nodeClass = NodeClass.Entity.rawValue
        actionSubjectSet = NSSet()
        actionObjectSet = NSSet()
        relationshipSubjectSet = NSSet()
        relationshipObjectSet = NSSet()
    }
    
    /**
     Access properties using the subscript operator.
     - Parameter name: A property name value.
     - Returns: The optional AnyObject value.
     */
    internal override subscript(name: String) -> AnyObject? {
        get {
            return super[name]
        }
        set(object) {
            guard let value = object else {
                for property in propertySet as! Set<ManagedEntityProperty> {
                    if name == property.name {
                        property.delete()
                        (propertySet as! NSMutableSet).removeObject(property)
                        break
                    }
                }
                return
            }
            
            let property = ManagedEntityProperty(name: name, object: value, context: context)
            property.node = self
        }
    }
    
    /**
     Adds the ManagedEntity to the group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if added, false
     otherwise.
     */
    internal override func addToGroup(name: String) -> Bool {
        if !memberOfGroup(name) {
            let group = ManagedEntityGroup(name: name, context: context)
            group.node = self
            return true
        }
        return false
    }
}

internal extension ManagedEntity {
    /**
     Adds the relationship between EntityProperty and ManagedEntity.
     - Parameter value: A reference to a ManagedEntityProperty.
     */
    func addPropertySetObject(value: ManagedEntityProperty) {
        (propertySet as! NSMutableSet).addObject(value)
    }
    
    /**
     Removes the relationship between EntityProperty and ManagedEntity.
     - Parameter value: A reference to a ManagedEntityProperty.
     */
    func removePropertySetObject(value: ManagedEntityProperty) {
        (propertySet as! NSMutableSet).removeObject(value)
    }
    
    /**
     Adds the relationship between EntityGroup and ManagedEntity.
     - Parameter value: A reference to a ManagedEntityGroup.
     */
    func addGroupSetObject(value: ManagedEntityGroup) {
        (groupSet as! NSMutableSet).addObject(value)
    }
    
    /**
     Removes the relationship between EntityGroup and ManagedEntity.
     - Parameter value: A reference to a ManagedEntityGroup.
     */
    func removeGroupSetObject(value: ManagedEntityGroup) {
        (groupSet as! NSMutableSet).removeObject(value)
    }
    
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
}
