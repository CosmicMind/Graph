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
        self.init(identifier: ModelIdentifier.relationshipName, type: type, managedObjectContext: managedObjectContext)
        nodeClass = NodeClass.relationship.rawValue
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
            guard let moc = managedObjectContext else {
                return
            }
            moc.performAndWait { [unowned self, unowned moc] in
                guard let object = value else {
                    for property in self.propertySet {
                        if name == property.name {
                            if let p = property as? ManagedRelationshipProperty {
                                p.delete()
                                break
                            }
                        }
                    }
                    return
                }
                
                var exists: Bool = false
                for property in self.propertySet {
                    if name == property.name {
                        (property as? ManagedRelationshipProperty)?.object = object
                        exists = true
                        break
                    }
                }
                
                if !exists {
                    _ = ManagedRelationshipProperty(name: name, object: object, node: self, managedObjectContext: moc)
                }
            }
        }
    }
    
    /**
     Adds a tag to the ManagedRelationship.
     - Parameter tag: A tag name.
     */
    internal func add(tag: String) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, unowned moc] in
            if !self.has(tag: tag) {
                _ = ManagedRelationshipTag(name: tag, node: self, managedObjectContext: moc)
            }
        }
    }
    
    /**
     Removes a tag from a ManagedRelationship.
     - Parameter tag: A tag name.
     */
    internal func remove(tag: String) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self] in
            for t in self.tagSet {
                if tag == t.name {
                    (t as? ManagedRelationshipTag)?.delete()
                    break
                }
            }
        }
    }
    
    /**
     Adds the ManagedRelationship to a given group.
     - Parameter to group: A group name.
     */
    internal func add(to group: String) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, unowned moc] in
            if !self.member(of: group) {
                _ = ManagedRelationshipGroup(name: group, node: self, managedObjectContext: moc)
            }
        }
    }
    
    /**
     Removes the ManagedRelationship from a given group.
     - Parameter from group: A group name.
     */
    internal func remove(from group: String) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self] in
            for g in self.groupSet {
                if group == g.name {
                    (g as? ManagedRelationshipGroup)?.delete()
                    break
                }
            }
        }
    }
    
    /// Marks the Relationship for deletion and clears all its relationships.
    internal override func delete() {
//        guard let moc = self.managedObjectContext else {
//            return
//        }
        
//        moc.performAndWait { [unowned self] in
//            self.subject?.mutableSetValueForKey("relationshipSubjectSet").removeObject(self)
//            self.object?.mutableSetValueForKey("relationshipObjectSet").removeObject(self)
//        }
        
        super.delete()
    }
}
