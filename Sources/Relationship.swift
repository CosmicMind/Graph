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
    /// A reference to the node.
    internal let node: Node<ManagedRelationship>
    
    public override var description: String {
        return "[nodeClass: \(nodeClass), id: \(id), type: \(type), groups: \(groups), properties: \(properties), subject: \(subject), object: \(object), createdDate: \(createdDate)]"
    }
    
    /// A reference to the nodeClass.
    public var nodeClass: NodeClass {
        return .Relationship
    }
    
    /// A reference to the type.
    public var type: String {
        return node.type
    }
    
    /// A reference to the ID.
    public var id: String {
        return node.id
    }
    
    /// A reference to the createDate.
    public var createdDate: NSDate {
        return node.createdDate
    }
    
    /// A reference to groups.
    public var groups: Set<String> {
        return node.groups
    }
    
    /**
     Access properties using the subscript operator.
     - Parameter name: A property name value.
     - Returns: The optional AnyObject value.
     */
    public subscript(name: String) -> AnyObject? {
        get {
            return node[name]
        }
        set(value) {
            node[name] = value
        }
    }
    
    /// A reference to the properties Dictionary.
    public var properties: [String: AnyObject] {
        return node.properties
    }
    
    /// A reference to the subject Entity.
    public var subject: Entity? {
        get {
            var n: ManagedEntity?
            node.managedNode.managedObjectContext?.performBlockAndWait { [unowned self] in
                n = self.node.managedNode.subject
            }
            return nil == n ? nil : Entity(managedNode: n!)
        }
        set(entity) {
            node.managedNode.managedObjectContext?.performBlockAndWait { [unowned self] in
                if let e = entity?.node.managedNode {
                    self.node.managedNode.subject?.mutableSetValueForKey("relationshipSubjectSet").removeObject(self.node.managedNode)
                    self.node.managedNode.subject = e
                    e.mutableSetValueForKey("relationshipSubjectSet").addObject(self.node.managedNode)
                } else {
                    self.node.managedNode.subject?.mutableSetValueForKey("relationshipSubjectSet").removeObject(self.node.managedNode)
                    self.node.managedNode.subject = nil
                }
            }
        }
    }
    
    /// A reference to the object Entity.
    public var object: Entity? {
        get {
            var n: ManagedEntity?
            node.managedNode.managedObjectContext?.performBlockAndWait { [unowned self] in
                n = self.node.managedNode.object
            }
            return nil == n ? nil : Entity(managedNode: n!)
        }
        set(entity) {
            node.managedNode.managedObjectContext?.performBlockAndWait { [unowned self] in
                if let e = entity?.node.managedNode {
                    self.node.managedNode.object?.mutableSetValueForKey("relationshipObjectSet").removeObject(self.node.managedNode)
                    self.node.managedNode.object = e
                    e.mutableSetValueForKey("relationshipObjectSet").addObject(self.node.managedNode)
                } else {
                    self.node.managedNode.object?.mutableSetValueForKey("relationshipObjectSet").removeObject(self.node.managedNode)
                    self.node.managedNode.object = nil
                }
            }
        }
    }
    
    /**
     Initializer that accepts a ManagedRelationship.
     - Parameter managedNode: A reference to a ManagedRelationship.
     */
    internal init(managedNode: ManagedRelationship) {
        node = Node<ManagedRelationship>(managedNode: managedNode)
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
        context.performBlockAndWait {
            managedNode = ManagedRelationship(type, managedObjectContext: context)
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
        context.performBlockAndWait {
            managedNode = ManagedRelationship(type, managedObjectContext: context)
        }
        self.init(managedNode: managedNode!)
    }
    
    /**
     Initializer that accepts a type value.
     - Parameter type: A reference to a type.
     */
    public convenience init(type: String) {
        self.init(type: type, graph: GraphDefaults.name)
    }
    
    /**
     Checks equality between Entities.
     - Parameter object: A reference to an object to test
     equality against.
     - Returns: A boolean of the result, true if equal, false
     otherwise.
     */
    public override func isEqual(object: AnyObject?) -> Bool {
        return id == (object as? Relationship)?.id
    }
    
    /**
     Adds the Relationship to the group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if added, false
     otherwise.
     */
    public func addToGroup(name: String) -> Bool {
        return node.managedNode.addToGroup(name)
    }
    
    /**
     Checks membership in a group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if a member, false
     otherwise.
     */
    public func memberOfGroup(name: String) -> Bool {
        return node.managedNode.memberOfGroup(name)
    }
    
    /**
     Removes the Relationship from a group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if removed, false
     otherwise.
     */
    public func removeFromGroup(name: String) -> Bool {
        return node.managedNode.removeFromGroup(name)
    }
    
    /**
     Adds the Relationship to the group if it is not a member, or
     removes it if it is a member.
     - Parameter name: The group name.
     */
    public func toggleGroupMembership(name: String) {
        memberOfGroup(name) ? removeFromGroup(name) : addToGroup(name)
    }
    
    /// Marks the Relationship for deletion.
    public func delete() {
        node.managedNode.delete()
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