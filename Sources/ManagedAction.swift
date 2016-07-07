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
                            if let p = property as? ManagedActionProperty {
                                p.delete()
                                self.removePropertySetObject(p)
                                break
                            }
                        }
                    }
                    return
                }
                
                var hasProperty: Bool = false
                for property in self.propertySet {
                    if name == property.name {
                        (property as? ManagedActionProperty)?.object = object
                        hasProperty = true
                        break
                    }
                }
                
                if !hasProperty {
                    let property = ManagedActionProperty(name: name, object: object, managedObjectContext: moc)
                    property.node = self
                    self.addPropertySetObject(property)
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
                let group = ManagedActionGroup(name: name, managedObjectContext: moc)
                group.node = self
                self.addGroupSetObject(group)
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
                    if let g = group as? ManagedActionGroup {
                        g.delete()
                        self.removeGroupSetObject(g)
                        result = true
                        break
                    }
                }
            }
        }
        return result!
    }
    
    /**
     Adds a ManagedEntity to the subjectSet.
     - Parameter entity: A ManagedEntity to add.
     - Returns: A boolean of the result, true if added, false otherwise.
     */
    internal func addSubject(entity: ManagedEntity) -> Bool {
        var result: Bool?
        managedObjectContext?.performBlockAndWait { [unowned self] in
            let count: Int = self.subjectSet.count
            self.mutableSetValueForKey("subjectSet").addObject(entity)
            result = count != self.subjectSet.count
        }
        return result!
    }
    
    /**
     Removes a ManagedEntity from the subjectSet.
     - Parameter entity: A ManagedEntity to remove.
     - Returns: A boolean of the result, true if removed, false otherwise.
     */
    internal func removeSubject(entity: ManagedEntity) -> Bool {
        var result: Bool?
        managedObjectContext?.performBlockAndWait { [unowned self] in
            let count: Int = self.subjectSet.count
            self.mutableSetValueForKey("subjectSet").removeObject(entity)
            result = count != self.subjectSet.count
        }
        return result!
    }
    
    /**
     Adds a ManagedEntity to the objectSet.
     - Parameter entity: A ManagedEntity to add.
     - Returns: A boolean of the result, true if added, false otherwise.
     */
    internal func addObject(entity: ManagedEntity) -> Bool {
        var result: Bool?
        managedObjectContext?.performBlockAndWait { [unowned self] in
            let count: Int = self.objectSet.count
            self.mutableSetValueForKey("objectSet").addObject(entity)
            result = count != self.objectSet.count
        }
        return result!
    }
    
    /**
     Removes a ManagedEntity from the objectSet.
     - Parameter entity: A ManagedEntity to remove.
     - Returns: A boolean of the result, true if removed, false otherwise.
     */
    internal func removeObject(entity: ManagedEntity) -> Bool {
        var result: Bool?
        managedObjectContext?.performBlockAndWait { [unowned self] in
            let count: Int = self.objectSet.count
            self.mutableSetValueForKey("objectSet").removeObject(entity)
            result = count != self.objectSet.count
        }
        return result!
    }
}

internal extension ManagedAction {
    /**
     Adds the relationship between ActionProperty and ManagedAction.
     - Parameter value: A reference to a ManagedActionProperty.
     */
    func addPropertySetObject(value: ManagedActionProperty) {
        (propertySet as! NSMutableSet).addObject(value)
    }
    
    /**
     Removes the relationship between ActionProperty and ManagedAction.
     - Parameter value: A reference to a ManagedActionProperty.
     */
    func removePropertySetObject(value: ManagedActionProperty) {
        (propertySet as! NSMutableSet).removeObject(value)
    }
    
    /**
     Adds the relationship between ActionGroup and ManagedAction.
     - Parameter value: A reference to a ManagedActionGroup.
     */
    func addGroupSetObject(value: ManagedActionGroup) {
        (groupSet as! NSMutableSet).addObject(value)
    }
    
    /**
     Removes the relationship between ActionGroup and ManagedAction.
     - Parameter value: A reference to a ManagedActionGroup.
     */
    func removeGroupSetObject(value: ManagedActionGroup) {
        (groupSet as! NSMutableSet).removeObject(value)
    }
}
