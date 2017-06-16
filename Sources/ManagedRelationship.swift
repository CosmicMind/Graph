/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
     - Returns: The optional Any value.
     */
    internal override subscript(name: String) -> Any? {
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
                        if let p = property as? ManagedRelationshipProperty {
                            if name == p.name {
                                p.delete()
                                break
                            }
                        }
                    }
                    return
                }

                var exists: Bool = false
                for property in self.propertySet {
                    if let p = property as? ManagedRelationshipProperty {
                        if name == p.name {
                            p.object = object
                            exists = true
                            break
                        }
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
     - Parameter tag: An Array of Strings.
     */
    internal func add(tags: [String]) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, unowned moc, tags = tags] in
            for name in tags {
                if !self.has(tags: name) {
                    _ = ManagedRelationshipTag(name: name, node: self, managedObjectContext: moc)
                }
            }
        }
    }

    /**
     Removes a tag from a ManagedRelationship.
     - Parameter tags: An Array of Strings.
     */
    internal func remove(tags: [String]) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, tags = tags] in
            for name in tags {
                for tag in self.tagSet {
                    if let t = tag as? ManagedRelationshipTag {
                        if name == t.name {
                            t.delete()
                        }
                    }
                }
            }
        }
    }

    /**
     Adds the ManagedRelationship to a given group.
     - Parameter to groups: An Array of Strings.
     */
    internal func add(to groups: [String]) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, unowned moc, groups = groups] in
            for name in groups {
                if !self.member(of: name) {
                    _ = ManagedRelationshipGroup(name: name, node: self, managedObjectContext: moc)
                }
            }
        }
    }

    /**
     Removes the ManagedRelationship from a given group.
     - Parameter from groups: An Array of Strings.
     */
    internal func remove(from groups: [String]) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, groups = groups] in
            for name in groups {
                for group in self.groupSet {
                    if let g = group as? ManagedRelationshipGroup {
                        if name == g.name {
                            g.delete()
                        }
                    }
                }
            }
        }
    }

    /// Marks the Relationship for deletion and clears all its relationships.
    internal override func delete() {
        guard let moc = self.managedObjectContext else {
            return
        }

        moc.performAndWait { [unowned self] in
            self.propertySet.forEach {
                ($0 as? ManagedRelationshipProperty)?.delete()
            }

            self.tagSet.forEach {
                ($0 as? ManagedRelationshipTag)?.delete()
            }

            self.groupSet.forEach {
                ($0 as? ManagedRelationshipGroup)?.delete()
            }

            self.subject?.mutableSetValue(forKey: "relationshipSubjectSet").remove(self)
            self.object?.mutableSetValue(forKey: "relationshipObjectSet").remove(self)
        }

        super.delete()
    }
}
