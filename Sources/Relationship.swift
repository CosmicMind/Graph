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

@objc(Relationship)
public class Relationship: NSObject, NodeType {
    /// A reference to the 
    internal let managedNode: ManagedRelationship
    
    public override var description: String {
        return "[nodeClass: \(nodeClass), id: \(id), type: \(type), tags: \(tags), properties: \(properties), subject: \(subject), object: \(object), createdDate: \(createdDate)]"
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
    
    /// A reference to the subject Entity.
    public var subject: Entity? {
        get {
            var n: ManagedEntity?
            managedNode.managedObjectContext?.performAndWait { [unowned self] in
                n = self.managedNode.subject
            }
            return nil == n ? nil : Entity(managedNode: n!)
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
            return nil == n ? nil : Entity(managedNode: n!)
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
    @nonobjc
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
     Adds a given tag to a Relationship.
     - Parameter tag: A tag name.
     - Returns: A boolean of the result, true if added, false
     otherwise.
     */
    public func add(tag: String) {
        managedNode.add(tag: tag)
    }
    
    /**
     Checks if a Relationship has a given tag.
     - Parameter tag: A tag name.
     - Returns: A boolean of the result, true if a member, false
     otherwise.
     */
    public func has(tag: String) -> Bool {
        return managedNode.has(tag: tag)
    }
    
    /**
     Removes a given tag from a Relationship.
     - Parameter tag: A tag name.
     - Returns: A boolean of the result, true if removed, false
     otherwise.
     */
    public func remove(tag: String) {
        managedNode.remove(tag: tag)
    }
    
    /**
     Adds a given tag to an Relationship or removes it, based on its 
     previous state.
     - Parameter tag: A tag name.
     */
    public func toggle(tag: String) {
        has(tag: tag) ? remove(tag: tag) : add(tag: tag)
    }
    
    /**
     Adds a Relationship to a given group.
     - Parameter to group: A group name.
     - Returns: A boolean of the result, true if added, false
     otherwise.
     */
    public func add(to group: String) {
        managedNode.add(to: group)
    }
    
    /**
     Checks if a Relationship is a member of a given group.
     - Parameter of group: A group name.
     - Returns: A boolean of the result, true if a member, false
     otherwise.
     */
    public func member(of group: String) -> Bool {
        return managedNode.member(of: group)
    }
    
    /**
     Removes a Relationship from a given group.
     - Parameter from group: A group name.
     - Returns: A boolean of the result, true if removed, false
     otherwise.
     */
    public func remove(from group: String) {
        managedNode.remove(from: group)
    }
    
    /**
     Adds a Relationship to a given group, or removes it, based on its previous
     state.
     - Parameter group: A group name.
     */
    public func toggle(group: String) {
        member(of: group) ? remove(from: group) : add(to: group)
    }
    
    /// Marks the Relationship for deletion.
    public func delete() {
        managedNode.delete()
    }
}

public func <=(lhs: Relationship, rhs: Relationship) -> Bool {
    return lhs.id <= rhs.id
}

public func >=(lhs: Relationship, rhs: Relationship) -> Bool {
    return lhs.id >= rhs.id
}

public func >(lhs: Relationship, rhs: Relationship) -> Bool {
    return lhs.id > rhs.id
}

public func <(lhs: Relationship, rhs: Relationship) -> Bool {
    return lhs.id < rhs.id
}
