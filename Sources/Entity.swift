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

import Foundation

@objc(Entity)
public class Entity: NSObject, NodeType {
    /// A reference to the node.
    internal let managedNode: ManagedEntity
    
    /// A string representation of the Entity.
    public override var description: String {
        return "[nodeClass: \(nodeClass), id: \(id), type: \(type), tags: \(tags), properties: \(properties), createdDate: \(createdDate)]"
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
    public var tags: Set<String> {
        return managedNode.tags
    }
    
    /// A reference to groups.
    public var groups: Set<String> {
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
    
    /// A reference to all the Actions that the Entity is a part of.
    public var actions: [Action] {
        var s = Set<ManagedAction>()
        s.formUnion(managedNode.actionSubjectSet as! Set<ManagedAction>)
        s.formUnion(managedNode.actionObjectSet as! Set<ManagedAction>)
        return s.map {
            return Action(managedNode: $0 as ManagedAction)
        } as [Action]
    }
    
    /**
    	:name:	actionsWhenSubject
     */
    public var actionsWhenSubject: [Action] {
        return managedNode.actionSubjectSet.map {
            return Action(managedNode: $0 as! ManagedAction)
        } as [Action]
    }
    
    /**
    	:name:	actionsWhenObject
     */
    public var actionsWhenObject: [Action] {
        return managedNode.actionObjectSet.map {
            return Action(managedNode: $0 as! ManagedAction)
        } as [Action]
    }
    
    /**
    	:name:	relationships
     */
    public var relationships: [Relationship] {
        var result: [Relationship]?
        managedNode.managedObjectContext?.performAndWait { [unowned self] in
            var set = Set<ManagedRelationship>()
            set.formUnion(self.managedNode.relationshipSubjectSet as! Set<ManagedRelationship>)
            set.formUnion(self.managedNode.relationshipObjectSet as! Set<ManagedRelationship>)
            result = set.map {
                return Relationship(managedNode: $0 as ManagedRelationship)
            } as [Relationship]
        }
        return result!
    }
    
    /**
    	:name:	relationshipsWhenSubject
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
    	:name:	relationshipsWhenObject
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
    @nonobjc
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
     Adds a given tag to an Entity.
     - Parameter tag: A tag name.
     - Returns: A boolean of the result, true if added, false
     otherwise.
     */
    public func add(tag: String) {
        managedNode.add(tag: tag)
    }
    
    /**
     Checks if an Entity has a given tag.
     - Parameter tag: A tag name.
     - Returns: A boolean of the result, true if a member, false
     otherwise.
     */
    public func has(tag: String) -> Bool {
        return managedNode.has(tag: tag)
    }
    
    /**
     Removes a given tag from an Entity.
     - Parameter tag: A tag name.
     - Returns: A boolean of the result, true if removed, false
     otherwise.
     */
    public func remove(tag: String) {
        managedNode.remove(tag: tag)
    }
    
    /**
     Adds a given tag to an Entity or removes it, based on its previous state.
     - Parameter tag: A tag name.
     */
    public func toggle(tag: String) {
        has(tag: tag) ? remove(tag: tag) : add(tag: tag)
    }
    
    /**
     Adds an Entity to a given group.
     - Parameter to group: A group name.
     - Returns: A boolean of the result, true if added, false
     otherwise.
     */
    public func add(to group: String) {
        managedNode.add(to: group)
    }
    
    /**
     Checks if an Entity is a member of a given group.
     - Parameter of group: A group name.
     - Returns: A boolean of the result, true if a member, false
     otherwise.
     */
    public func member(of group: String) -> Bool {
        return managedNode.member(of: group)
    }
    
    /**
     Removes an Entity from a given group.
     - Parameter from group: A group name.
     - Returns: A boolean of the result, true if removed, false
     otherwise.
     */
    public func remove(from group: String) {
        managedNode.remove(from: group)
    }
    
    /**
     Adds an Entity to a given group, or removes it, based on its previous
     state.
     - Parameter group: A group name.
     */
    public func toggle(group: String) {
        member(of: group) ? remove(from: group) : add(to: group)
    }
    
    /// Marks the Entity for deletion.
    public func delete() {
        managedNode.delete()
    }
}

public func <=(lhs: Entity, rhs: Entity) -> Bool {
    return lhs.id <= rhs.id
}

public func >=(lhs: Entity, rhs: Entity) -> Bool {
    return lhs.id >= rhs.id
}

public func >(lhs: Entity, rhs: Entity) -> Bool {
    return lhs.id > rhs.id
}

public func <(lhs: Entity, rhs: Entity) -> Bool {
    return lhs.id < rhs.id
}
