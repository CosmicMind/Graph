/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

import Foundation

@objc(Relationship)
public class Relationship: Node {
    /// A reference to the managedNode.
    internal let managedNode: ManagedRelationship

    public override var description: String {
        return "[nodeClass: \(nodeClass), id: \(id), type: \(type), tags: \(tags), groups: \(groups), properties: \(properties), subject: \(String(describing: subject)), object: \(String(describing: object)), createdDate: \(createdDate)]"
    }

    /// A reference to the nodeClass.
    public var nodeClass: NodeClass {
        return .relationship
    }

    /// A reference to the type.
    public var type: String {
        var result: String?
        managedNode.managedObjectContext?.performAndWait { [unowned self] in
            result = self.managedNode.type
        }
        return result!
    }

    /// A reference to the hash.
    public override var hash: Int {
        return managedNode.hash
    }

    /// A reference to the hashValue.
    public override var hashValue: Int {
        return managedNode.hashValue
    }

    /// A reference to the ID.
    public var id: String {
        return managedNode.id
    }

    /// A reference to the createDate.
    public var createdDate: Date {
        var result: Date?
        managedNode.managedObjectContext?.performAndWait { [unowned self] in
            result = self.managedNode.createdDate as Date
        }
        return result!
    }

    /// A reference to tags.
    public var tags: [String] {
        return managedNode.tags
    }

    /// A reference to groups.
    public var groups: [String] {
        return managedNode.groups
    }

    /**
     Access properties using the subscript operator.
     - Parameter name: A property name value.
     - Returns: The optional Any value.
     */
    public subscript(name: String) -> Any? {
        get {
            return managedNode[name]
        }
        set(value) {
            managedNode[name] = value
        }
    }

    /// A reference to the properties Dictionary.
    public var properties: [String: Any] {
        return managedNode.properties
    }

    /// A reference to the subject Entity.
    public var subject: Entity? {
        get {
            var n: ManagedEntity?
            managedNode.managedObjectContext?.performAndWait { [unowned self] in
                n = self.managedNode.subject
            }

            return n.map { Entity(managedNode: $0) }
        }
        set(entity) {
            managedNode.managedObjectContext?.performAndWait { [unowned self] in
                if let e = entity?.managedNode {
                    self.managedNode.subject?.mutableSetValue(forKey: "relationshipSubjectSet").remove(self.managedNode)
                    self.managedNode.subject = e
                    e.mutableSetValue(forKey: "relationshipSubjectSet").add(self.managedNode)
                } else {
                    self.managedNode.subject?.mutableSetValue(forKey: "relationshipSubjectSet").remove(self.managedNode)
                    self.managedNode.subject = nil
                }
            }
        }
    }

    /// A reference to the object Entity.
    public var object: Entity? {
        get {
            var n: ManagedEntity?
            managedNode.managedObjectContext?.performAndWait { [unowned self] in
                n = self.managedNode.object
            }
            return n.map { Entity(managedNode: $0) }
        }
        set(entity) {
            managedNode.managedObjectContext?.performAndWait { [unowned self] in
                if let e = entity?.managedNode {
                    self.managedNode.object?.mutableSetValue(forKey: "relationshipObjectSet").remove(self.managedNode)
                    self.managedNode.object = e
                    e.mutableSetValue(forKey: "relationshipObjectSet").add(self.managedNode)
                } else {
                    self.managedNode.object?.mutableSetValue(forKey: "relationshipObjectSet").remove(self.managedNode)
                    self.managedNode.object = nil
                }
            }
        }
    }

    /**
     Initializer that accepts a ManagedRelationship.
     - Parameter managedNode: A reference to a ManagedRelationship.
     */
    internal init(managedNode: ManagedRelationship) {
        self.managedNode = managedNode
    }

    /**
     Initializer that accepts a type and graph. The graph
     indicates which graph to save to.
     - Parameter type: A reference to a type.
     - Parameter graph: A reference to a Graph instance by name.
     */
    @nonobjc
    public convenience init(type: String, graph: String) {
        let context = Graph(name: graph).managedObjectContext
        var managedNode: ManagedRelationship?
        context?.performAndWait {
            managedNode = ManagedRelationship(type, managedObjectContext: context!)
        }
        self.init(managedNode: managedNode!)
    }

    /**
     Initializer that accepts a type and graph. The graph
     indicates which graph to save to.
     - Parameter type: A reference to a type.
     - Parameter graph: A reference to a Graph instance.
     */
    public convenience init(type: String, graph: Graph) {
        let context = graph.managedObjectContext
        var managedNode: ManagedRelationship?
        context?.performAndWait {
            managedNode = ManagedRelationship(type, managedObjectContext: context!)
        }
        self.init(managedNode: managedNode!)
    }

    /**
     Initializer that accepts a type value.
     - Parameter type: A reference to a type.
     */
    public convenience init(type: String) {
        self.init(type: type, graph: GraphStoreDescription.name)
    }

    /**
     Checks equality between Entities.
     - Parameter object: A reference to an object to test
     equality against.
     - Returns: A boolean of the result, true if equal, false
     otherwise.
     */
    public override func isEqual(_ object: Any?) -> Bool {
        return id == (object as? Relationship)?.id
    }

    /**
     Adds given tags to a Relationship.
     - Parameter tags: A list of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func add(tags: String...) -> Relationship {
        return add(tags: tags)
    }

    /**
     Adds given tags to a Relationship.
     - Parameter tags: An Array of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func add(tags: [String]) -> Relationship {
        managedNode.add(tags: tags)
        return self
    }

    /**
     Checks if the Relationship has the given tags.
     - Parameter tags: A list of Strings.
     - Returns: A boolean of the result, true if has the
     given tags, false otherwise.
     */
    public func has(tags: String...) -> Bool {
        return has(tags: tags)
    }

    /**
     Checks if the Relationship has the given tags.
     - Parameter tags: An Array of Strings.
     - Returns: A boolean of the result, true if has the
     given tags, false otherwise.
     */
    public func has(tags: [String]) -> Bool {
        return managedNode.has(tags: tags)
    }

    /**
     Removes given tags from a Relationship.
     - Parameter tags: A list of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func remove(tags: String...) -> Relationship {
        return remove(tags: tags)
    }

    /**
     Removes given tags from a Relationship.
     - Parameter tags: An Array of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func remove(tags: [String]) -> Relationship {
        managedNode.remove(tags: tags)
        return self
    }

    /**
     Adds given tags to a Relationship or removes them, based on their
     previous state.
     - Parameter tags: A list of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func toggle(tags: String...) -> Relationship {
        return toggle(tags: tags)
    }

    /**
     Adds given tags to a Relationship or removes them, based on their
     previous state.
     - Parameter tags: An Array of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func toggle(tags: [String]) -> Relationship {
        var a : [String] = []
        var r : [String] = []
        tags.forEach { [unowned self] in
            if self.managedNode.has(tags: $0) {
                r.append($0)
            } else {
                a.append($0)
            }
        }
        managedNode.add(tags: a)
        managedNode.remove(tags: r)
        return self
    }

    /**
     Adds given groups to a Relationship.
     - Parameter to groups: A list of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func add(to groups: String...) -> Relationship {
        return add(to: groups)
    }

    /**
     Adds given groups to a Relationship.
     - Parameter to groups: An Array of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func add(to groups: [String]) -> Relationship {
        managedNode.add(to: groups)
        return self
    }

    /**
     Checks if the Relationship is a member of the given groups.
     - Parameter of groups: A list of Strings.
     - Returns: A boolean of the result, true if has the
     given groups, false otherwise.
     */
    public func member(of groups: String...) -> Bool {
        return member(of: groups)
    }

    /**
     Checks if the Relationship has a the given tags.
     - Parameter of groups: An Array of Strings.
     - Returns: A boolean of the result, true if has the
     given groups, false otherwise.
     */
    public func member(of groups: [String]) -> Bool {
        return managedNode.member(of: groups)
    }

    /**
     Removes given groups from a Relationship.
     - Parameter from groups: A list of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func remove(from groups: String...) -> Relationship {
        return remove(from: groups)
    }

    /**
     Removes given groups from a Relationship.
     - Parameter from groups: An Array of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func remove(from groups: [String]) -> Relationship {
        managedNode.remove(from: groups)
        return self
    }

    /**
     Adds given groups to a Relationship or removes them, based on their
     previous state.
     - Parameter groups: A list of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func toggle(groups: String...) -> Relationship {
        return toggle(groups: groups)
    }

    /**
     Adds given groups to a Relationship or removes them, based on their
     previous state.
     - Parameter groups: An Array of Strings.
     - Returns: The Relationship.
     */
    @discardableResult
    public func toggle(groups: [String]) -> Relationship {
        var a : [String] = []
        var r : [String] = []
        groups.forEach { [unowned self] in
            if self.managedNode.member(of: $0) {
                r.append($0)
            } else {
                a.append($0)
            }
        }
        managedNode.add(to: a)
        managedNode.remove(from: r)
        return self
    }

    /**
     Sets the object of the Relationship.
     - Parameter _ entity: An Entity.
     - Returns: The Relationship.
     */
    @discardableResult
    public func of(_ entity: Entity) -> Relationship {
        self.object = entity
        return self
    }

    /**
     Sets the object of the Relationship.
     - Parameter object: An Entity.
     - Returns: The Relationship.
     */
    @discardableResult
    public func `in`(object: Entity) -> Relationship {
        self.object = object
        return self
    }

    /// Marks the Relationship for deletion.
    public func delete() {
        managedNode.delete()
    }
}

extension Array where Element: Relationship {
    /**
     Finds the given types of subject Entities that are part
     of the relationships in the Array.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func subject(types: String...) -> [Entity] {
        return subject(types: types)
    }

    /**
     Finds the given types of subject Entities that are part
     of the relationships in the Array.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func subject(types: [String]) -> [Entity] {
        var s : Set<Entity> = []
        forEach { [types = types] (r) in
            guard let e = r.subject else {
                return
            }

            guard types.contains(e.type) else {
                return
            }

            s.insert(e)
        }
        return [Entity](s)
    }

    /**
     Finds the given types of object Entities that are part
     of the relationships in the Array.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func object(types: String...) -> [Entity] {
        return object(types: types)
    }

    /**
     Finds the given types of object Entities that are part
     of the relationships in the Array.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func object(types: [String]) -> [Entity] {
        var s : Set<Entity> = []
        forEach { [types = types] (r) in
            guard let e = r.subject else {
                return
            }

            guard types.contains(e.type) else {
                return
            }

            s.insert(e)
        }
        return [Entity](s)
    }
}

extension Relationship : Comparable {
    static public func ==(lhs: Relationship, rhs: Relationship) -> Bool {
        return lhs.id == rhs.id
    }

    static public func <(lhs: Relationship, rhs: Relationship) -> Bool {
        return lhs.id < rhs.id
    }
}
