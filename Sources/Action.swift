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

public extension Array where Element: Entity {
    /**
     An Array of Entity objects may add themselves to an
     Action.
     - Parameter action type: A String.
     - Returns: The Action.
     */
    public func will(action type: String) -> Action {
        let action = Action(type: type)
        action.add(subjects: self)
        return action
    }
    
    /**
     An Array of Entity objects may add themselves to an
     Action. 
     - Parameter action type: A String.
     - Returns: The Action.
     */
    public func did(action type: String) -> Action {
        return will(action: type)
    }
}

@objc(Action)
public class Action: Node {
    /// A reference to the managedNode.
    internal let managedNode: ManagedAction
    
    public override var description: String {
        return "[nodeClass: \(nodeClass), id: \(id), type: \(type), tags: \(tags), groups: \(groups), properties: \(properties), subjects: \(subjects), objects: \(objects), createdDate: \(createdDate)]"
    }
    
    /// A reference to the nodeClass.
    public var nodeClass: NodeClass {
        return .action
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
    
    /// An Array of Entity subjects.
    public var subjects: [Entity] {
        guard let moc = managedNode.managedObjectContext else {
            return [Entity]()
        }
        
        var s: [Entity]?
        moc.performAndWait { [unowned managedNode] in
            s = managedNode.subjectSet.map {
                return Entity(managedNode: $0 as! ManagedEntity)
            } as [Entity]
        }
        return s!
    }
    
    /// An Array of Entity objects.
    public var objects: [Entity] {
        guard let moc = managedNode.managedObjectContext else {
            return [Entity]()
        }
        
        
        var o: [Entity]?
        moc.performAndWait { [unowned managedNode] in
            o = managedNode.objectSet.map {
                return Entity(managedNode: $0 as! ManagedEntity)
            } as [Entity]
        }
        return o!
    }
    
    /**
     Initializer that accepts a ManagedAction.
     - Parameter managedNode: A reference to a ManagedAction.
     */
    internal init(managedNode: ManagedAction) {
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
        var managedNode: ManagedAction?
        context?.performAndWait {
            managedNode = ManagedAction(type, managedObjectContext: context!)
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
        var managedNode: ManagedAction?
        context?.performAndWait {
            managedNode = ManagedAction(type, managedObjectContext: context!)
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
        return id == (object as? Action)?.id
    }
    
    /**
     Adds a given tag to an Action.
     - Parameter tag: A tag name.
     - Returns: The Action.
     */
    @discardableResult
    public func add(tag: String) -> Action {
        managedNode.add(tag: tag)
        return self
    }
    
    /**
     Checks if the Action has a given tag.
     - Parameter tag: A tag name.
     - Returns: A boolean of the result, true if has the given tag,
     otherwise.
     */
    public func has(tag: String) -> Bool {
        return managedNode.has(tag: tag)
    }
    
    /**
     Checks if the Action has a the given tags.
     - Parameter tags: An Array of Strings.
     - Returns: A boolean of the result, true if has the tags,
     false otherwise.
     */
    public func has(tags: [String]) -> Bool {
        return managedNode.has(tags: tags)
    }
    
    /**
     Removes a given tag from an Action.
     - Parameter tag: A tag name.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(tag: String) -> Action {
        managedNode.remove(tag: tag)
        return self
    }
    
    /**
     Adds a given tag to the Action or removes it, based on its previous state.
     - Parameter tag: A tag name.
     - Returns: The Action.
     */
    @discardableResult
    public func toggle(tag: String) -> Action {
        return has(tag: tag) ? remove(tag: tag) : add(tag: tag)
    }
    
    /**
     Adds the Action to a given group.
     - Parameter to group: A group name.
     - Returns: The Action.
     */
    @discardableResult
    public func add(to group: String) -> Action {
        managedNode.add(to: group)
        return self
    }
    
    /**
     Checks if the Action is a member of a given group.
     - Parameter of group: A list of Strings.
     - Returns: A boolean of the result, true if a member, false
     otherwise.
     */
    public func member(of groups: String...) -> Bool {
        return member(of: groups)
    }
    
    /**
     Checks if the Action is a member of a given group.
     - Parameter of group: A group name.
     - Returns: A boolean of the result, true if a member, false
     otherwise.
     */
    public func member(of groups: [String]) -> Bool {
        return managedNode.member(of: groups)
    }
    
    /**
     Removes an Action from a given group.
     - Parameter from group: A group name.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(from group: String) -> Action {
        managedNode.remove(from: group)
        return self
    }
    
    /**
     Adds an Action to a given group, or removes it, based on its previous
     state.
     - Parameter group: A group name.
     - Returns: The Action.
     */
    @discardableResult
    public func toggle(group: String) -> Action {
        return member(of: group) ? remove(from: group) : add(to: group)
    }
    
    /**
     Adds an Entity to the subject set.
     - Parameter subejct: A list of Entity objects.
     - Returns: The Action.
     */
    @discardableResult
    public func add(subjects: Entity...) -> Action {
        return add(subjects: subjects)
    }
    
    /**
     Adds an Array of Entity objects to the subject set.
     - Parameter subjects: An Array of Entity objects.
     - Returns: The Action.
     */
    @discardableResult
    public func add(subjects: [Entity]) -> Action {
        for s in subjects {
            managedNode.add(subject: s.managedNode)
        }
        return self
    }
    
    /**
     Removes an Entity from the subject set.
     - Parameter subject: A list of Entity objects.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(subjects: Entity...) -> Action {
        return remove(subjects: subjects)
    }
    
    /**
     Removes an Array of Entity objects from the subject set.
     - Parameter subjects: An Array of Entity objects.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(subjects: [Entity]) -> Action {
        for s in subjects {
            managedNode.remove(subject: s.managedNode)
        }
        return self
    }
    
    /**
     Adds an Entity to the object set.
     - Parameter object: A list of Entity objects.
     - Returns: The Action.
     */
    @discardableResult
    public func add(objects: Entity...) -> Action {
        return add(objects: objects)
    }
    
    /**
     Adds an Array of Entity objects to the objects set.
     - Parameter subjects: An Array of Entity objects.
     - Returns: The Action.
     */
    @discardableResult
    public func add(objects: [Entity]) -> Action {
        for o in objects {
            managedNode.add(object: o.managedNode)
        }
        return self
    }
    
    /**
     Removes an Entity from the object set.
     - Parameter object: A list of Entity objects.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(objects: Entity...) -> Action {
        return remove(objects: objects)
    }
    
    /**
     Removes an Array of Entity objects from the subject set.
     - Parameter objects: An Array of Entity objects.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(objects: [Entity]) -> Action {
        for o in objects {
            managedNode.remove(object: o.managedNode)
        }
        return self
    }
    
    /**
     Adds an Array of Entity objects to the objects set.
     - Parameter objects: An Array of Entity objects.
     - Returns: The Action.
     */
    @discardableResult
    public func what(objects: [Entity]) -> Action {
        return add(objects: objects)
    }
    
    /// Marks the Action for deletion.
    public func delete() {
        managedNode.delete()
    }
}

public func <=(lhs: Action, rhs: Action) -> Bool {
    return lhs.id <= rhs.id
}

public func >=(lhs: Action, rhs: Action) -> Bool {
    return lhs.id >= rhs.id
}

public func >(lhs: Action, rhs: Action) -> Bool {
    return lhs.id > rhs.id
}

public func <(lhs: Action, rhs: Action) -> Bool {
    return lhs.id < rhs.id
}
