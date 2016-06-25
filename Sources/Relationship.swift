/*
 * Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>.
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
    public var groups: [String] {
        return node.groups
    }
    
    /**
     Access properties using the subscript operator.
     - Parameter name: A property name value.
     - Returns: The optional AnyObject value.
     */
    public subscript(name: String) -> AnyObject? {
        get {
            return node.managedNode[name]
        }
        set(value) {
            node.managedNode[name] = value
        }
    }
    
    /// A reference to the properties Dictionary.
    public var properties: [String: AnyObject] {
        return node.properties
    }
    
    /// A reference to the subject Entity.
    public var subject: Entity? {
        didSet {
            node.managedNode.object = subject?.node.managedNode
        }
    }
    
    /// A reference to the object Entity.
    public var object: Entity? {
        didSet {
            node.managedNode.object = object?.node.managedNode
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
     - Parameter name: A reference to a Graph instance by name.
     */
    @nonobjc
    public convenience init(type: String, graph: String) {
        self.init(managedNode: ManagedRelationship(type, context: Graph(name: graph).context))
    }
    
    /**
     Initializer that accepts a type and graph. The graph
     indicates which graph to save to.
     - Parameter type: A reference to a type.
     - Parameter graph: A reference to a Graph instance.
     */
    @nonobjc
    public convenience init(type: String, graph: Graph) {
        self.init(managedNode: ManagedRelationship(type, context: graph.context))
    }
    
    /**
     Initializer that accepts a type value.
     - Parameter type: A reference to a type.
     */
    public convenience init(type: String) {
        self.init(type: type, graph: Graph(name: Storage.name))
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
        return node.addToGroup(name)
    }
    
    /**
     Checks membership in a group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if a member, false
     otherwise.
     */
    public func memberOfGroup(name: String) -> Bool {
        return node.memberOfGroup(name)
    }
    
    /**
     Removes the Relationship from a group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if removed, false
     otherwise.
     */
    public func removeFromGroup(name: String) -> Bool {
        return node.removeFromGroup(name)
    }
    
    /**
     Adds the Relationship to the group if it is not a member, or
     removes it if it is a member.
     - Parameter name: The group name.
     */
    public func toggleGroup(name: String) {
        memberOfGroup(name) ? removeFromGroup(name) : addToGroup(name)
    }
    
    /**
     Marks the Relationship for deletion and removes the subject 
     and object relationships.
    */
    public func delete() {
        node.managedNode.subject?.removeRelationshipSubjectSetObject(node.managedNode)
        node.managedNode.object?.removeRelationshipObjectSetObject(node.managedNode)
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