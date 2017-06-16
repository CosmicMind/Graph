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
            return []
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
            return []
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
     Adds given tags to an Action.
     - Parameter tags: A list of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func add(tags: String...) -> Action {
        return add(tags: tags)
    }

    /**
     Adds given tags to an Action.
     - Parameter tags: An Array of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func add(tags: [String]) -> Action {
        managedNode.add(tags: tags)
        return self
    }

    /**
     Checks if the Action has the given tags.
     - Parameter tags: A list of Strings.
     - Returns: A boolean of the result, true if has the
     given tags, false otherwise.
     */
    public func has(tags: String...) -> Bool {
        return has(tags: tags)
    }

    /**
     Checks if the Action has the given tags.
     - Parameter tags: An Array of Strings.
     - Returns: A boolean of the result, true if has the
     given tags, false otherwise.
     */
    public func has(tags: [String]) -> Bool {
        return managedNode.has(tags: tags)
    }

    /**
     Removes given tags from an Action.
     - Parameter tags: A list of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(tags: String...) -> Action {
        return remove(tags: tags)
    }

    /**
     Removes given tags from an Action.
     - Parameter tags: An Array of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(tags: [String]) -> Action {
        managedNode.remove(tags: tags)
        return self
    }

    /**
     Adds given tags to an Action or removes them, based on their
     previous state.
     - Parameter tags: A list of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func toggle(tags: String...) -> Action {
        return toggle(tags: tags)
    }

    /**
     Adds given tags to an Action or removes them, based on their
     previous state.
     - Parameter tags: An Array of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func toggle(tags: [String]) -> Action {
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
     Adds given groups to an Action.
     - Parameter to groups: A list of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func add(to groups: String...) -> Action {
        return add(to: groups)
    }

    /**
     Adds given groups to an Action.
     - Parameter to groups: An Array of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func add(to groups: [String]) -> Action {
        managedNode.add(to: groups)
        return self
    }

    /**
     Checks if the Action is a member of the given groups.
     - Parameter of groups: A list of Strings.
     - Returns: A boolean of the result, true if has the
     given groups, false otherwise.
     */
    public func member(of groups: String...) -> Bool {
        return member(of: groups)
    }

    /**
     Checks if the Action has a the given tags.
     - Parameter of groups: An Array of Strings.
     - Returns: A boolean of the result, true if has the
     given groups, false otherwise.
     */
    public func member(of groups: [String]) -> Bool {
        return managedNode.member(of: groups)
    }

    /**
     Removes given groups from an Action.
     - Parameter from groups: A list of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(from groups: String...) -> Action {
        return remove(from: groups)
    }

    /**
     Removes given groups from an Action.
     - Parameter from groups: An Array of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func remove(from groups: [String]) -> Action {
        managedNode.remove(from: groups)
        return self
    }

    /**
     Adds given groups to an Action or removes them, based on their
     previous state.
     - Parameter groups: A list of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func toggle(groups: String...) -> Action {
        return toggle(groups: groups)
    }

    /**
     Adds given groups to an Action or removes them, based on their
     previous state.
     - Parameter groups: An Array of Strings.
     - Returns: The Action.
     */
    @discardableResult
    public func toggle(groups: [String]) -> Action {
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
     Adds an Entity to the objects set.
     - Parameter objects: A list of Entity objects..
     - Returns: The Action.
     */
    @discardableResult
    public func what(objects: Entity...) -> Action {
        return what(objects: objects)
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

extension Action {
    /**
     Finds the given types of subject Entities that are part
     of the Action.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func subject(types: String...) -> [Entity] {
        return subject(types: types)
    }

    /**
     Finds the given types of subject Entities that are part
     of the Action.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func subject(types: [String]) -> [Entity] {
        var s = Set<Entity>()
        subjects.forEach { [types = types] (e) in
            guard types.contains(e.type) else {
                return
            }

            s.insert(e)
        }
        return [Entity](s)
    }

    /**
     Finds the given types of object Entities that are part
     of the Action.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func object(types: String...) -> [Entity] {
        return object(types: types)
    }

    /**
     Finds the given types of object Entities that are part
     of the Action.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func object(types: [String]) -> [Entity] {
        var s = Set<Entity>()
        objects.forEach { [types = types] (e) in
            guard types.contains(e.type) else {
                return
            }

            s.insert(e)
        }
        return [Entity](s)
    }
}

extension Array where Element: Action {
    /**
     Finds the given types of subject Entities that are part
     of the Actions in the Array.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func subject(types: String...) -> [Entity] {
        return subject(types: types)
    }

    /**
     Finds the given types of subject Entities that are part
     of the Actions in the Array.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func subject(types: [String]) -> [Entity] {
        var s = Set<Entity>()
        forEach { [types = types] (a) in
            a.subject(types: types).forEach {
                s.insert($0)
            }
        }
        return [Entity](s)
    }

    /**
     Finds the given types of object Entities that are part
     of the Actions in the Array.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func object(types: String...) -> [Entity] {
        return object(types: types)
    }

    /**
     Finds the given types of object Entities that are part
     of the Actions in the Array.
     - Parameter types: An Array of Strings.
     - Returns: An Array of Entities.
     */
    public func object(types: [String]) -> [Entity] {
        var s = Set<Entity>()
        forEach { [types = types] (a) in
            a.object(types: types).forEach {
                s.insert($0)
            }
        }
        return [Entity](s)
    }
}

extension Action : Comparable {
    static public func ==(lhs: Action, rhs: Action) -> Bool {
        return lhs.id == rhs.id
    }

    static public func <(lhs: Action, rhs: Action) -> Bool {
        return lhs.id < rhs.id
    }
}

