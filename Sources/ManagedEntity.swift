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
        self.init(identifier: ModelIdentifier.entityName, type: type, managedObjectContext: managedObjectContext)
        nodeClass = NodeClass.entity.rawValue
        actionSubjectSet = []
        actionObjectSet = []
        relationshipSubjectSet = []
        relationshipObjectSet = []
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
                        if let p = property as? ManagedEntityProperty {
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
                    if let p = property as? ManagedEntityProperty {
                        if name == p.name {
                            p.object = object
                            exists = true
                            break
                        }
                    }
                }

                if !exists {
                    _ = ManagedEntityProperty(name: name, object: object, node: self, managedObjectContext: moc)
                }
            }
        }
    }

    /**
     Adds a tag to the ManagedEntity.
     - Parameter tag: An Array of Strings.
     */
    internal func add(tags: [String]) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, unowned moc, tags = tags] in
            for name in tags {
                if !self.has(tags: name) {
                    _ = ManagedEntityTag(name: name, node: self, managedObjectContext: moc)
                }
            }
        }
    }

    /**
     Removes a tag from a ManagedEntity.
     - Parameter tags: An Array of Strings.
     */
    internal func remove(tags: [String]) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, tags = tags] in
            for name in tags {
                for tag in self.tagSet {
                    if let t = tag as? ManagedEntityTag {
                        if name == t.name {
                            t.delete()
                        }
                    }
                }
            }
        }
    }

    /**
     Adds the ManagedEntity to a given group.
     - Parameter to groups: An Array of Strings.
     */
    internal func add(to groups: [String]) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, unowned moc, groups = groups] in
            for name in groups {
                if !self.member(of: name) {
                    _ = ManagedEntityGroup(name: name, node: self, managedObjectContext: moc)
                }
            }
        }
    }

    /**
     Removes the ManagedEntity from a given group.
     - Parameter from groups: An Array of Strings.
     */
    internal func remove(from groups: [String]) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait { [unowned self, groups = groups] in
            for name in groups {
                for group in self.groupSet {
                    if let g = group as? ManagedEntityGroup {
                        if name == g.name {
                            g.delete()
                        }
                    }
                }
            }
        }
    }

    /// Marks the Entity for deletion and clears all its relationships.
    internal override func delete() {
        guard let moc = self.managedObjectContext else {
            return
        }

        moc.performAndWait { [unowned self] in
            self.propertySet.forEach {
                ($0 as? ManagedEntityProperty)?.delete()
            }

            self.tagSet.forEach {
                ($0 as? ManagedEntityTag)?.delete()
            }

            self.groupSet.forEach {
                ($0 as? ManagedEntityGroup)?.delete()
            }

            self.actionSubjectSet.forEach {
                ($0 as? ManagedAction)?.delete()
            }

            self.actionObjectSet.forEach {
                ($0 as? ManagedAction)?.delete()
            }

            self.relationshipSubjectSet.forEach {
                ($0 as? ManagedRelationship)?.delete()
            }

            self.relationshipObjectSet.forEach {
                ($0 as? ManagedRelationship)?.delete()
            }
        }

        super.delete()
    }
}
