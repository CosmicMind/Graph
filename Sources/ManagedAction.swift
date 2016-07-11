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

@objc(ManagedAction)
internal class ManagedAction: ManagedNode {
    @NSManaged internal var subjectSet: NSSet
    @NSManaged internal var objectSet: NSSet
    
    /**
     Initializer that accepts a type and a NSManagedObjectContext.
     - Parameter type: A reference to the Action type.
     - Parameter managedObjectContext: A reference to the NSManagedObejctContext.
     */
    internal convenience init(_ type: String, managedObjectContext: NSManagedObjectContext) {
        self.init(identifier: ModelIdentifier.actionDescriptionName, type: type, managedObjectContext: managedObjectContext)
        nodeClass = NodeClass.Action.rawValue
        subjectSet = NSSet()
        objectSet = NSSet()
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
                            (property as? ManagedActionProperty)?.delete()
                            break
                        }
                    }
                    return
                }
                
                var exists: Bool = false
                for property in self.propertySet {
                    if name == property.name {
                        (property as? ManagedActionProperty)?.object = object
                        exists = true
                        break
                    }
                }
                
                if !exists {
                    _ = ManagedActionProperty(name: name, object: object, node: self, managedObjectContext: moc)
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
                _ = ManagedActionGroup(name: name, node: self, managedObjectContext: moc)
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
                    (group as? ManagedActionGroup)?.delete()
                    result = true
                    break
                }
            }
        }
        return result!
    }
    
    /**
     Adds a ManagedEntity to the subjectSet.
     - Parameter managedEntity: A ManagedEntity to add.
     - Returns: A boolean of the result, true if added, false otherwise.
     */
    internal func addSubject(managedEntity: ManagedEntity) -> Bool {
        var result: Bool?
        managedObjectContext?.performBlockAndWait { [unowned self, unowned managedEntity] in
            let count: Int = self.subjectSet.count
            self.mutableSetValueForKey("subjectSet").addObject(managedEntity)
            result = count != self.subjectSet.count
        }
        return result!
    }
    
    /**
     Removes a ManagedEntity from the subjectSet.
     - Parameter managedEntity: A ManagedEntity to remove.
     - Returns: A boolean of the result, true if removed, false otherwise.
     */
    internal func removeSubject(managedEntity: ManagedEntity) -> Bool {
        var result: Bool?
        managedObjectContext?.performBlockAndWait { [unowned self, unowned managedEntity] in
            let count: Int = self.subjectSet.count
            self.mutableSetValueForKey("subjectSet").removeObject(managedEntity)
            result = count != self.subjectSet.count
        }
        return result!
    }
    
    /**
     Adds a ManagedEntity to the objectSet.
     - Parameter managedEntity: A ManagedEntity to add.
     - Returns: A boolean of the result, true if added, false otherwise.
     */
    internal func addObject(managedEntity: ManagedEntity) -> Bool {
        var result: Bool?
        managedObjectContext?.performBlockAndWait { [unowned self, unowned managedEntity] in
            let count: Int = self.objectSet.count
            self.mutableSetValueForKey("objectSet").addObject(managedEntity)
            result = count != self.objectSet.count
        }
        return result!
    }
    
    /**
     Removes a ManagedEntity from the objectSet.
     - Parameter managedEntity: A ManagedEntity to remove.
     - Returns: A boolean of the result, true if removed, false otherwise.
     */
    internal func removeObject(managedEntity: ManagedEntity) -> Bool {
        var result: Bool?
        managedObjectContext?.performBlockAndWait { [unowned self, unowned managedEntity] in
            let count: Int = self.objectSet.count
            self.mutableSetValueForKey("objectSet").removeObject(managedEntity)
            result = count != self.objectSet.count
        }
        return result!
    }
    
    /// Marks the Action for deletion and clears all its relationships.
    internal override func delete() {
        guard let moc = managedObjectContext else {
            return
        }
        
        moc.performBlockAndWait { [unowned self] in
            self.groupSet.forEach { (object: AnyObject) in
                guard let group = object as? ManagedActionGroup else {
                    return
                }
                group.delete()
            }
            
            self.propertySet.forEach { (object: AnyObject) in
                guard let property = object as? ManagedActionProperty else {
                    return
                }
                property.delete()
            }
            
//            self.subjectSet.forEach { [unowned self] (object: AnyObject) in
//                guard let managedEntity: ManagedEntity = object as? ManagedEntity else {
//                    return
//                }
//                self.mutableSetValueForKey("subjectSet").removeObject(managedEntity)
//            }
//            
//            self.objectSet.forEach { [unowned self] (object: AnyObject) in
//                guard let managedEntity: ManagedEntity = object as? ManagedEntity else {
//                    return
//                }
//                self.mutableSetValueForKey("objectSet").removeObject(managedEntity)
//            }
        }
        
        super.delete()
    }
}
