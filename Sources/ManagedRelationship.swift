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

@objc(ManagedRelationship)
internal class ManagedRelationship: ManagedNode {
    @NSManaged internal var subject: ManagedEntity?
    @NSManaged internal var object: ManagedEntity?
    
    /**
     Initializer that accepts a type and a NSManagedObjectContext.
     - Parameter type: A reference to the Relationship type.
     - Parameter managedObjectContext: A reference to the NSManagedObejctContext.
     */
    internal convenience init(_ type: String, managedObjectContext: NSManagedObjectContext) {
        self.init(identifier: ModelIdentifier.relationshipDescriptionName, type: type, managedObjectContext: managedObjectContext)
        nodeClass = NodeClass.Relationship.rawValue
        subject = nil
        object = nil
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
        set(value) {
            managedObjectContext?.performBlockAndWait { [unowned self] in
                guard let object = value else {
                    for property in self.propertySet {
                        if name == property.name {
                            (property as? ManagedRelationshipProperty)?.delete()
                            (self.propertySet as! NSMutableSet).removeObject(property)
                            break
                        }
                    }
                    return
                }
                
                for property in self.propertySet {
                    if name == property.name {
                        (property as? ManagedEntityProperty)?.object = object
                        return
                    }
                }
                
                let property = ManagedRelationshipProperty(name: name, object: object, managedObjectContext: self.managedObjectContext!)
                property.node = self
            }
        }
    }
    
    /**
     Adds the ManagedAction to the group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if added, false
     otherwise.
     */
    internal override func addToGroup(name: String) -> Bool {
        var result: Bool? = false
        managedObjectContext?.performBlockAndWait { [unowned self] in
            if !self.memberOfGroup(name) {
                let group = ManagedRelationshipGroup(name: name, managedObjectContext: self.managedObjectContext!)
                group.node = self
                result = true
                return
            }
        }
        return result!
    }
}

internal extension ManagedRelationship {
    /**
     Adds the relationship between RelationshipProperty and ManagedRelationship.
     - Parameter value: A reference to a ManagedRelationshipProperty.
     */
    func addPropertySetObject(value: ManagedRelationshipProperty) {
        (propertySet as! NSMutableSet).addObject(value)
    }
    
    /**
     Removes the relationship between RelationshipProperty and ManagedRelationship.
     - Parameter value: A reference to a ManagedRelationshipProperty.
     */
    func removePropertySetObject(value: ManagedRelationshipProperty) {
        (propertySet as! NSMutableSet).removeObject(value)
    }
    
    /**
     Adds the relationship between RelationshipGroup and ManagedRelationship.
     - Parameter value: A reference to a ManagedRelationshipGroup.
     */
    func addGroupSetObject(value: ManagedRelationshipGroup) {
        (groupSet as! NSMutableSet).addObject(value)
    }
    
    /**
     Removes the relationship between RelationshipGroup and ManagedRelationship.
     - Parameter value: A reference to a ManagedRelationshipGroup.
     */
    func removeGroupSetObject(value: ManagedRelationshipGroup) {
        (groupSet as! NSMutableSet).removeObject(value)
    }
}
