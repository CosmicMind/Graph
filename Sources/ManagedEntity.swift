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

@objc(ManagedEntity)
internal class ManagedEntity: ManagedNode {
    @NSManaged internal var actionSubjectSet: NSSet
    @NSManaged internal var actionObjectSet: NSSet
    @NSManaged internal var relationshipSubjectSet: NSSet
    @NSManaged internal var relationshipObjectSet: NSSet
    
    /**
     Initializer that accepts a type and a NSManagedObjectContext.
     - Parameter type: A reference to the Entity type.
     - Parameter managedObjectContext: A reference to the NSManagedObejctContext.
    */
    internal convenience init(_ type: String, managedObjectContext: NSManagedObjectContext) {
        self.init(identifier: ModelIdentifier.entityDescriptionName, type: type, managedObjectContext: managedObjectContext)
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
        set(value) {
            guard let moc = managedObjectContext else {
                return
            }
            moc.performBlockAndWait { [unowned self, unowned moc] in
                guard let object = value else {
                    for property in self.propertySet {
                        if name == property.name {
                            (property as? ManagedEntityProperty)?.delete()
                            break
                        }
                    }
                    return
                }
                
                var exists: Bool = false
                for property in self.propertySet {
                    if name == property.name {
                        (property as? ManagedEntityProperty)?.object = object
                        exists = true
                        break
                    }
                }
                
                if !exists {
                    _ = ManagedEntityProperty(name: name, object: object, node: self, managedObjectContext: moc)
                }
            }
        }
    }
    
    /**
     Adds the ManagedAction to the group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if added, false
     otherwise.
     */
    internal func addToGroup(name: String) -> Bool {
        guard let moc = managedObjectContext else {
            return false
        }
        var result: Bool? = false
        moc.performBlockAndWait { [unowned self, unowned moc] in
            if !self.memberOfGroup(name) {
                _ = ManagedEntityGroup(name: name, node: self, managedObjectContext: moc)
                result = true
            }
        }
        return result!
    }
    
    /**
     Removes the ManagedAction from the group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if removed, false
     otherwise.
     */
    internal func removeFromGroup(name: String) -> Bool {
        guard let moc = managedObjectContext else {
            return false
        }
        var result: Bool? = false
        moc.performBlockAndWait { [unowned self] in
            for group in self.groupSet {
                if name == group.name {
                    (group as? ManagedEntityGroup)?.delete()
                    result = true
                    break
                }
            }
        }
        return result!
    }
    
    /// Marks the Entity for deletion and clears all its relationships.
    internal override func delete() {
        guard let moc = self.managedObjectContext else {
            return
        }
        
        moc.performBlockAndWait { [unowned self] in
            self.groupSet.forEach { (object: AnyObject) in
                guard let group = object as? ManagedEntityGroup else {
                    return
                }
                group.delete()
            }
            
            self.propertySet.forEach { (object: AnyObject) in
                guard let property = object as? ManagedEntityProperty else {
                    return
                }
                property.delete()
            }
            
            self.actionSubjectSet.forEach { (object: AnyObject) in
                guard let action = object as? ManagedAction else {
                    return
                }
                action.delete()
            }
            
            self.actionObjectSet.forEach { (object: AnyObject) in
                guard let action = object as? ManagedAction else {
                    return
                }
                action.delete()
            }
            
            self.relationshipSubjectSet.forEach { (object: AnyObject) in
                guard let relationship = object as? ManagedRelationship else {
                    return
                }
                relationship.delete()
            }
            
            self.relationshipObjectSet.forEach { (object: AnyObject) in
                guard let relationship = object as? ManagedRelationship else {
                    return
                }
                relationship.delete()
            }
        }
        
        super.delete()
    }
}
