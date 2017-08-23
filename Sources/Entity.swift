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

import Foundation

@objc(Entity)
public class Entity: Node {
    /// A reference to the managedNode.
    internal let managedNode: ManagedEntity

    /// A string representation of the Entity.
    public override var description: String {
        return "[nodeClass: \(nodeClass), id: \(id), type: \(type), tags: \(tags), groups: \(groups), properties: \(properties), createdDate: \(createdDate)]"
    }

    /// A reference to the nodeClass.
    public var nodeClass: NodeClass {
        return .entity
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

    /**
     Retrieves all the Actions that are given.
     - Parameter types: A list of Strings.
     - Returns: An Array of Actions.
     */
    public func action(types: String...) -> [Action] {
        return action(types: types)
    }

    /**
     Retrieves all the Actions that are given.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Actions.
     */
    public func action(types: [String]) -> [Action] {
        return self.actions.filter { [types = types] (action) -> Bool in
            return types.contains(action.type)
        }
    }

    /// A reference to all the Actions that the Entity is a part of.
    public var actions: [Action] {
        var s = managedNode.actionSubjectSet as! Set<ManagedAction>
        s.formUnion(managedNode.actionObjectSet as! Set<ManagedAction>)
        return s.map {
            return Action(managedNode: $0 as ManagedAction)
            } as [Action]
    }

    /**
     An Array of Actions the Entity belongs to when it's part of the
     subject set.
     */
    public var actionsWhenSubject: [Action] {
        return managedNode.actionSubjectSet.map {
            return Action(managedNode: $0 as! ManagedAction)
            } as [Action]
    }

    /**
     An Array of Actions the Entity belongs to when it's part of the
     object set.
     */
    public var actionsWhenObject: [Action] {
        return managedNode.actionObjectSet.map {
            return Action(managedNode: $0 as! ManagedAction)
            } as [Action]
    }

    /**
     Retrieves all the Relationships that are given.
     - Parameter types: A list of Strings.
     - Returns: An Array of Relationships.
     */
    public func relationship(types: String...) -> [Relationship] {
        return relationship(types: types)
    }

    /**
     Retrieves all the Relationships that are given.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Relationships.
     */
    public func relationship(types: [String]) -> [Relationship] {
        return self.relationships.filter { [types = types] (relationship) -> Bool in
            return types.contains(relationship.type)
        }
    }

    /// A reference to all the Relationships that the Entity is a part of.
    public var relationships: [Relationship] {
        var s = managedNode.relationshipSubjectSet as! Set<ManagedRelationship>
        s.formUnion(managedNode.relationshipObjectSet as! Set<ManagedRelationship>)
        return s.map {
            return Relationship(managedNode: $0 as ManagedRelationship)
            } as [Relationship]
    }

    /**
     An Array of Relationships the Entity belongs to when it's part of the
     subject set.
     */
    public var relationshipsWhenSubject: [Relationship] {
        var result: [Relationship]?
        managedNode.managedObjectContext?.performAndWait { [unowned self] in
            result = self.managedNode.relationshipSubjectSet.map {
                return Relationship(managedNode: $0 as! ManagedRelationship)
                } as [Relationship]
        }
        return result!
    }

    /**
     An Array of Relationships the Entity belongs to when it's part of the
     object set.
     */
    public var relationshipsWhenObject: [Relationship] {
        var result: [Relationship]?
        managedNode.managedObjectContext?.performAndWait { [unowned self] in
            result = self.managedNode.relationshipObjectSet.map {
                return Relationship(managedNode: $0 as! ManagedRelationship)
                } as [Relationship]
        }
        return result!
    }

    /**
     Initializer that accepts a ManagedEntity.
     - Parameter managedNode: A reference to a ManagedEntity.
     */
    internal init(managedNode: ManagedEntity) {
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
        var managedNode: ManagedEntity?
        context?.performAndWait {
            managedNode = ManagedEntity(type, managedObjectContext: context!)
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
        var managedNode: ManagedEntity?
        context?.performAndWait {
            managedNode = ManagedEntity(type, managedObjectContext: context!)
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
        return id == (object as? Entity)?.id
    }

    /**
     Adds given tags to an Entity.
     - Parameter tags: A list of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func add(tags: String...) -> Entity {
        return add(tags: tags)
    }

    /**
     Adds given tags to an Entity.
     - Parameter tags: An Array of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func add(tags: [String]) -> Entity {
        managedNode.add(tags: tags)
        return self
    }

    /**
     Checks if the Entity has the given tags.
     - Parameter tags: A list of Strings.
     - Returns: A boolean of the result, true if has the
     given tags, false otherwise.
     */
    public func has(tags: String...) -> Bool {
        return has(tags: tags)
    }

    /**
     Checks if the Entity has the given tags.
     - Parameter tags: An Array of Strings.
     - Returns: A boolean of the result, true if has the
     given tags, false otherwise.
     */
    public func has(tags: [String]) -> Bool {
        return managedNode.has(tags: tags)
    }

    /**
     Removes given tags from an Entity.
     - Parameter tags: A list of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func remove(tags: String...) -> Entity {
        return remove(tags: tags)
    }

    /**
     Removes given tags from an Entity.
     - Parameter tags: An Array of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func remove(tags: [String]) -> Entity {
        managedNode.remove(tags: tags)
        return self
    }

    /**
     Adds given tags to an Entity or removes them, based on their
     previous state.
     - Parameter tags: A list of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func toggle(tags: String...) -> Entity {
        return toggle(tags: tags)
    }

    /**
     Adds given tags to an Entity or removes them, based on their
     previous state.
     - Parameter tags: An Array of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func toggle(tags: [String]) -> Entity {
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
     Adds given groups to an Entity.
     - Parameter to groups: A list of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func add(to groups: String...) -> Entity {
        return add(to: groups)
    }

    /**
     Adds given groups to an Entity.
     - Parameter to groups: An Array of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func add(to groups: [String]) -> Entity {
        managedNode.add(to: groups)
        return self
    }

    /**
     Checks if the Entity is a member of the given groups.
     - Parameter of groups: A list of Strings.
     - Returns: A boolean of the result, true if has the
     given groups, false otherwise.
     */
    public func member(of groups: String...) -> Bool {
        return member(of: groups)
    }

    /**
     Checks if the Entity has a the given tags.
     - Parameter of groups: An Array of Strings.
     - Returns: A boolean of the result, true if has the
     given groups, false otherwise.
     */
    public func member(of groups: [String]) -> Bool {
        return managedNode.member(of: groups)
    }

    /**
     Removes given groups from an Entity.
     - Parameter from groups: A list of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func remove(from groups: String...) -> Entity {
        return remove(from: groups)
    }

    /**
     Removes given groups from an Entity.
     - Parameter from groups: An Array of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func remove(from groups: [String]) -> Entity {
        managedNode.remove(from: groups)
        return self
    }

    /**
     Adds given groups to an Entity or removes them, based on their
     previous state.
     - Parameter groups: A list of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func toggle(groups: String...) -> Entity {
        return toggle(groups: groups)
    }

    /**
     Adds given groups to an Entity or removes them, based on their
     previous state.
     - Parameter groups: An Array of Strings.
     - Returns: The Entity.
     */
    @discardableResult
    public func toggle(groups: [String]) -> Entity {
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
     Sets the Entity as the subject of the Relationship and the
     passed in Entity as the object of the Relationship.
     - Parameters:
        - to entity: An Entity
     */
    public func relate(to entity: Entity) {
        let relationship = Relationship(managedNode: ManagedRelationship(type, managedObjectContext: managedNode.managedObjectContext!))
        relationship.subject = self
        relationship.object = entity
    }
    
    /**
     Sets the Entity as the subject of the Relationship.
     - Parameter relationship type: A String.
     - Returns: A Relationship.
     */
    @discardableResult
    public func `is`(relationship type: String) -> Relationship {
        let relationship = Relationship(managedNode: ManagedRelationship(type, managedObjectContext: managedNode.managedObjectContext!))
        relationship.subject = self
        return relationship
    }

    /**
     Sets the Entity as to the subjects set of an Action.
     - Parameter action type: A String.
     - Returns: A Action.
     */
    @discardableResult
    public func will(action type: String) -> Action {
        let action = Action(managedNode: ManagedAction(type, managedObjectContext: managedNode.managedObjectContext!))
        action.add(subjects: self)
        return action
    }

    /**
     Sets the Entity as to the subjects set of an Action.
     - Parameter action type: A String.
     - Returns: A Action.
     */
    @discardableResult
    public func did(action type: String) -> Action {
        return will(action: type)
    }

    /// Marks the Entity for deletion.
    public func delete() {
        managedNode.delete()
    }
}

extension Entity : Comparable {
    static public func ==(lhs: Entity, rhs: Entity) -> Bool {
        return lhs.id == rhs.id
    }

    static public func <(lhs: Entity, rhs: Entity) -> Bool {
        return lhs.id < rhs.id
    }
}


