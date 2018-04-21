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

import CoreData

@objc(GraphSource)
public enum GraphSource: Int {
    case cloud
    case local
}

@objc(WatchDelegate)
public protocol WatchDelegate {}

@objc(WatchEntityDelegate)
public protocol WatchEntityDelegate: WatchDelegate {
    /**
     A delegation method that is executed when an Entity is inserted.
     - Parameter graph: A Graph instance.
     - Parameter inserted entity: An Entity instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, inserted entity: Entity, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity is deleted.
     - Parameter graph: A Graph instance.
     - Parameter deleted entity: An Entity instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, deleted entity: Entity, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity added a property and value.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter added property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, entity: Entity, added property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity updated a property and value.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter updated property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, entity: Entity, updated property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity removed a property and value.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter removed property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, entity: Entity, removed property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity added a tag.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter added tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, entity: Entity, added tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity removed a tag.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter removed tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, entity: Entity, removed tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity was added to a group.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter addedTo group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, entity: Entity, addedTo group: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity was removed from a group.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter removedFrom group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, entity: Entity, removedFrom group: String, source: GraphSource)
}
    
@objc(WatchRelationshipDelegate)
public protocol WatchRelationshipDelegate: WatchDelegate {
    /**
     A delegation method that is executed when a Relationship is inserted.
     - Parameter graph: A Graph instance.
     - Parameter inserted relationship: A Relationship instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, inserted relationship: Relationship, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship is updated.
     - Parameter graph: A Graph instance.
     - Parameter updated relationship: A Relationship instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, updated relationship: Relationship, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship is deleted.
     - Parameter graph: A Graph instance.
     - Parameter deleted relationship: A Relationship instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, deleted relationship: Relationship, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship added a property and value.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter added property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, relationship: Relationship, added property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship updated a property and value.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter updated property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, relationship: Relationship, updated property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship removed a property and value.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter removed property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, relationship: Relationship, removed property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship added a tag.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter added tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, relationship: Relationship, added tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship removed a tag.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter removed tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, relationship: Relationship, removed tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship was added to a group.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter addedTo group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, relationship: Relationship, addedTo group: String, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship was removed from a group.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter removedFrom group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, relationship: Relationship, removedFrom group: String, source: GraphSource)
}

@objc(WatchActionDelegate)
public protocol WatchActionDelegate: WatchDelegate {
    /**
     A delegation method that is executed when an Action is inserted.
     - Parameter graph: A Graph instance.
     - Parameter inserted action: An Action instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, inserted action: Action, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action is deleted.
     - Parameter graph: A Graph instance.
     - Parameter deleted action: An Action instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, deleted action: Action, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action added a property and value.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter added property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, action: Action, added property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action updated a property and value.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter updated property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, action: Action, updated property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action removed a property and value.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter removed property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, action: Action, removed property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action added a tag.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter added tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, action: Action, added tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action removed a tag.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter removed tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, action: Action, removed tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action was added to a group.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter addedTo group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, action: Action, addedTo group: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action was removed from a group.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter removedFrom group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func watch(graph: Graph, action: Action, removedFrom group: String, source: GraphSource)
}

public protocol Watchable {
    /// Element type.
    associatedtype Element: Node
}

public struct Watcher {
    /// A weak reference to the stored object.
    private weak var object: AnyObject?
    
    /// A reference to the weak Watch<T> instance.
    public var watch: Watch<Node>? {
        return object as? Watch<Node>
    }
    
    /**
     An initializer that takes in an object instance.
     - Parameter watch: A Watch<T> instance.
     */
    public init (object: AnyObject) {
        self.object = object
    }
}

/// Watch.
public class Watch<T: Node>: Watchable {
    public typealias Element = T
    
    /// A Graph instance.
    public fileprivate(set) var graph: Graph
    
    /// A reference to a delagte object.
    public weak var delegate: WatchDelegate?
    
    /// A reference to the type.
    public fileprivate(set) var types: [String]?
    
    /// A reference to the typesPredicate.
    public fileprivate(set) var typesPredicate: NSPredicate?
    
    /// A reference to the tags.
    public fileprivate(set) var tags: [String]?
    
    /// A reference to the tagsPredicate.
    public fileprivate(set) var tagsPredicate: NSPredicate?
    
    /// A reference to the groups.
    public fileprivate(set) var groups: [String]?
    
    /// A reference to the groupsPredicate.
    public fileprivate(set) var groupsPredicate: NSPredicate?
    
    /// A reference to the properties.
    public fileprivate(set) var properties: [String]?
    
    /// A reference to the propertiesPredicate.
    public fileprivate(set) var propertiesPredicate: NSPredicate?
    
    /// A reference to the predicate.
    public var predicate: NSPredicate? {
        var p = [NSPredicate]()
        if let v = typesPredicate {
            p.append(v)
        }
        
        if let v = tagsPredicate {
            p.append(v)
        }
        
        if let v = groupsPredicate {
            p.append(v)
        }
        
        if let v = propertiesPredicate {
            p.append(v)
        }
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: p)
    }
    
    /**
     A boolean indicating if the Watch instance is
     currently watching.
     */
    public fileprivate(set) var isRunning = false
    
    /// Deinitializer.
    deinit {
        removeFromObservation()
    }
    
    /**
     An initializer that accepts a NodeClass and Graph
     instance.
     - Parameter graph: A Graph instance.
     */
    public init(graph: Graph) {
        self.graph = graph
        prepare()
    }
    
    /**
     Clears the search parameters.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func clear() -> Watch {
        types = nil
        typesPredicate = nil
        tags = nil
        tagsPredicate = nil
        groups = nil
        groupsPredicate = nil
        properties = nil
        propertiesPredicate = nil
        
        return self
    }
    
    /**
     Resumes the watcher.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func resume() -> Watch {
        guard !isRunning else {
            return self
        }
        
        isRunning = true
        
        addForObservation()
        return self
    }
    
    /**
     Pauses the watcher.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func pause() -> Watch {
        isRunning = false
        
        removeFromObservation()
        return self
    }
    
    /**
     Watches nodes with given types.
     - Parameter types: A parameter list of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func `for`(types: String...) -> Watch {
        return self.for(types: types)
    }
    
    /**
     Watches nodes with given types.
     - Parameter types: An Array of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func `for`(types: [String]) -> Watch {
        self.types = types
        switch T.self {
        case is Entity.Type:
            watchForEntity(types: types)
        case is Relationship.Type:
            watchForRelationship(types: types)
        case is Action.Type:
            watchForAction(types: types)
        default: break
        }
        return self
    }
    
    /**
     Watches nodes with given tags.
     - Parameter tags: A parameter list of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func has(tags: String...) -> Watch {
        return has(tags: tags)
    }
    
    /**
     Watches nodes with given tags.
     - Parameter tags: An Array of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func has(tags: [String]) -> Watch {
        self.tags = tags
        switch T.self {
        case is Entity.Type:
            watchForEntity(tags: tags)
        case is Relationship.Type:
            watchForRelationship(tags: tags)
        case is Action.Type:
            watchForAction(tags: tags)
        default:break
        }
        return self
    }
    
    /**
     Watches nodes with given groups.
     - Parameter groups: A parameter list of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func member(of groups: String...) -> Watch {
        return member(of: groups)
    }
    
    /**
     Watches nodes with given groups.
     - Parameter groups: An Array of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func member(of groups: [String]) -> Watch {
        self.groups = groups
        switch T.self {
        case is Entity.Type:
            watchForEntity(groups: groups)
        case is Relationship.Type:
            watchForRelationship(groups: groups)
        case is Action.Type:
            watchForAction(groups: groups)
        default:break
        }
        return self
    }
    
    /**
     Watches nodes with given properties.
     - Parameter properties: A parameter list of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func `where`(properties: String...) -> Watch {
        return self.where(properties: properties)
    }
    
    /**
     Watches nodes with given properties.
     - Parameter groups: An Array of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func `where`(properties: [String]) -> Watch {
        self.properties = properties
        switch T.self {
        case is Entity.Type:
            watchForEntity(properties: properties)
        case is Relationship.Type:
            watchForRelationship(properties: properties)
        case is Action.Type:
            watchForAction(properties: properties)
        default:break
        }
        return self
    }
    
    /**
     Notifies inserted watchers from local changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyInsertedWatchers(_ notification: Notification) {
        guard let objects = notification.userInfo?[NSInsertedObjectsKey] as? NSSet else {
            return
        }
        
        guard let p = predicate else {
            return
        }
        
        delegateToInsertedWatchers(objects.filtered(using: p), source: .local)
    }
    
    /**
     Notifies updated watchers from local changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyUpdatedWatchers(_ notification: Notification) {
        guard let objects = notification.userInfo?[NSUpdatedObjectsKey] as? NSSet else {
            return
        }
        
        guard let p = predicate else {
            return
        }
        
        delegateToUpdatedWatchers(objects.filtered(using: p), source: .local)
    }
    
    /**
     Notifies deleted watchers from local changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyDeletedWatchers(_ notification: Notification) {
        guard let objects = notification.userInfo?[NSDeletedObjectsKey] as? NSSet else {
            return
        }
        
        guard let p = predicate else {
            return
        }
        
        delegateToDeletedWatchers(objects.filtered(using: p), source: .local)
    }
    
    /**
     Notifies inserted watchers from cloud changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyInsertedWatchersFromCloud(_ notification: Notification) {
        guard let objectIDs = notification.userInfo?[NSInsertedObjectsKey] as? NSSet else {
            return
        }
        
        guard let p = predicate else {
            return
        }
        
        guard let moc = graph.managedObjectContext else {
            return
        }
        
        let objects = NSMutableSet()
        (objectIDs.allObjects as! [NSManagedObjectID]).forEach { [unowned moc] (objectID: NSManagedObjectID) in
            objects.add(moc.object(with: objectID))
        }
        
        delegateToInsertedWatchers(objects.filtered(using: p), source: .cloud)
    }
    
    /**
     Notifies updated watchers from cloud changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyUpdatedWatchersFromCloud(_ notification: Notification) {
        guard let objectIDs = notification.userInfo?[NSUpdatedObjectsKey] as? NSSet else {
            return
        }
        
        guard let p = predicate else {
            return
        }
        
        guard let moc = graph.managedObjectContext else {
            return
        }
        
        let objects = NSMutableSet()
        (objectIDs.allObjects as! [NSManagedObjectID]).forEach { [unowned moc] (objectID: NSManagedObjectID) in
            objects.add(moc.object(with: objectID))
        }
        
        delegateToUpdatedWatchers(objects.filtered(using: p), source: .cloud)
    }
    
    /**
     Notifies deleted watchers from cloud changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyDeletedWatchersFromCloud(_ notification: Notification) {
        guard let objectIDs = notification.userInfo?[NSDeletedObjectsKey] as? NSSet else {
            return
        }
        
        guard let p = predicate else {
            return
        }
        
        guard let moc = graph.managedObjectContext else {
            return
        }
        
        let objects = NSMutableSet()
        (objectIDs.allObjects as! [NSManagedObjectID]).forEach { [unowned moc] (objectID: NSManagedObjectID) in
            objects.add(moc.object(with: objectID))
        }
        
        delegateToDeletedWatchers(objects.filtered(using: p), source: .cloud)
    }
    
    /**
     Passes the handle to the inserted notification delegates.
     - Parameter _ set: A Set of AnyHashable objects to pass.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        delegateToEntityInsertedWatchers(set, source: source)
        delegateToRelationshipInsertedWatchers(set, source: source)
        delegateToActionInsertedWatchers(set, source: source)
    }
    
    /**
     Passes the handle to the inserted notification delegates for Entities.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToEntityInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        set.forEach { [unowned self] in
            guard let n = $0 as? ManagedEntity else {
                return
            }
            
            (self.delegate as? WatchEntityDelegate)?.watch?(graph: self.graph, inserted: Entity(managedNode: n), source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityTag else {
                return
            }
            
            guard let n = o.node as? ManagedEntity else {
                return
            }
            
            (self.delegate as? WatchEntityDelegate)?.watch?(graph: self.graph, entity: Entity(managedNode: n), added: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityGroup else {
                return
            }
            
            guard let n = o.node as? ManagedEntity else {
                return
            }
            
            (self.delegate as? WatchEntityDelegate)?.watch?(graph: self.graph, entity: Entity(managedNode: n), addedTo: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityProperty else {
                return
            }
            
            guard let n = o.node as? ManagedEntity else {
                return
            }
            
            (self.delegate as? WatchEntityDelegate)?.watch?(graph: self.graph, entity: Entity(managedNode: n), added: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the inserted notification delegates for Relationships.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToRelationshipInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        set.forEach { [unowned self] in
            guard let n = $0 as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, inserted: Relationship(managedNode: n), source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipTag else {
                return
            }
            
            guard let n = o.node as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, relationship: Relationship(managedNode: n), added: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipGroup else {
                return
            }
            
            guard let n = o.node as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, relationship: Relationship(managedNode: n), addedTo: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipProperty else {
                return
            }
            
            guard let n = o.node as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, relationship: Relationship(managedNode: n), added: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the inserted notification delegates for Actions.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToActionInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        set.forEach { [unowned self] in
            guard let n = $0 as? ManagedAction else {
                return
            }
            
            (self.delegate as? WatchActionDelegate)?.watch?(graph: self.graph, inserted: Action(managedNode: n), source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionTag else {
                return
            }
            
            guard let n = o.node as? ManagedAction else {
                return
            }
            
            (self.delegate as? WatchActionDelegate)?.watch?(graph: self.graph, action: Action(managedNode: n), added: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionGroup else {
                return
            }
            
            guard let n = o.node as? ManagedAction else {
                return
            }
            
            (self.delegate as? WatchActionDelegate)?.watch?(graph: self.graph, action: Action(managedNode: n), addedTo: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionProperty else {
                return
            }
            
            guard let n = o.node as? ManagedAction else {
                return
            }
            
            (self.delegate as? WatchActionDelegate)?.watch?(graph: self.graph, action: Action(managedNode: n), added: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the updated notification delegates.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        delegateToEntityUpdatedWatchers(set, source: source)
        delegateToRelationshipUpdatedWatchers(set, source: source)
        delegateToActionUpdatedWatchers(set, source: source)
    }
    
    /**
     Passes the handle to the updated notification delegates for Entities.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToEntityUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityProperty else {
                return
            }
            
            guard let n = o.node as? ManagedEntity else {
                return
            }
            
            (self.delegate as? WatchEntityDelegate)?.watch?(graph: self.graph, entity: Entity(managedNode: n), updated: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the updated notification delegates for Relationships.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToRelationshipUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        set.forEach { [unowned self] in
            guard let n = $0 as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, updated: Relationship(managedNode: n), source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipProperty else {
                return
            }
            
            guard let n = o.node as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, relationship: Relationship(managedNode: n), updated: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the updated notification delegates for Actions.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToActionUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionProperty else {
                return
            }
            
            guard let n = o.node as? ManagedAction else {
                return
            }
            
            (self.delegate as? WatchActionDelegate)?.watch?(graph: self.graph, action: Action(managedNode: n), updated: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the deleted notification delegates.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        delegateToEntityDeletedWatchers(set, source: source)
        delegateToRelationshipDeletedWatchers(set, source: source)
        delegateToActionDeletedWatchers(set, source: source)
    }
    
    /**
     Passes the handle to the deleted notification delegates for Entities.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToEntityDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityTag else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedEntity else {
                return
            }
            
            (self.delegate as? WatchEntityDelegate)?.watch?(graph: self.graph, entity: Entity(managedNode: n), removed: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityGroup else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedEntity else {
                return
            }
            
            (self.delegate as? WatchEntityDelegate)?.watch?(graph: self.graph, entity: Entity(managedNode: n), removedFrom: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityProperty else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedEntity else {
                return
            }
            
            (self.delegate as? WatchEntityDelegate)?.watch?(graph: self.graph, entity: Entity(managedNode: n), removed: o.name, with: o.object, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let n = $0 as? ManagedEntity else {
                return
            }
            
            (self.delegate as? WatchEntityDelegate)?.watch?(graph: self.graph, deleted: Entity(managedNode: n), source: source)
        }
    }
    
    /**
     Passes the handle to the deleted notification delegates for Relationships.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToRelationshipDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipTag else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, relationship: Relationship(managedNode: n), removed: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipGroup else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, relationship: Relationship(managedNode: n), removedFrom: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipProperty else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, relationship: Relationship(managedNode: n), removed: o.name, with: o.object, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let n = $0 as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? WatchRelationshipDelegate)?.watch?(graph: self.graph, deleted: Relationship(managedNode: n), source: source)
        }
    }
    
    /**
     Passes the handle to the deleted notification delegates for Actions.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    fileprivate func delegateToActionDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionTag else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedAction else {
                return
            }
            
            (self.delegate as? WatchActionDelegate)?.watch?(graph: self.graph, action: Action(managedNode: n), removed: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionGroup else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedAction else {
                return
            }
            
            (self.delegate as? WatchActionDelegate)?.watch?(graph: self.graph, action: Action(managedNode: n), removedFrom: o.name, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionProperty else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedAction else {
                return
            }
            
            (self.delegate as? WatchActionDelegate)?.watch?(graph: self.graph, action: Action(managedNode: n), removed: o.name, with: o.object, source: source)
        }
        
        set.forEach { [unowned self] in
            guard let n = $0 as? ManagedAction else {
                return
            }
            
            (self.delegate as? WatchActionDelegate)?.watch?(graph: self.graph, deleted: Action(managedNode: n), source: source)
        }
    }
    
    /// Removes the watcher.
    fileprivate func removeFromObservation() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Prepares the Watch instance.
    fileprivate func prepare() {
        prepareGraph()
        resume()
    }
    
    /// Prepares the instance for save notifications.
    fileprivate func addForObservation() {
        guard let moc = graph.managedObjectContext else {
            return
        }
        
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(notifyInsertedWatchers), name: .NSManagedObjectContextDidSave, object: moc)
        defaultCenter.addObserver(self, selector: #selector(notifyUpdatedWatchers), name: .NSManagedObjectContextDidSave, object: moc)
        defaultCenter.addObserver(self, selector: #selector(notifyDeletedWatchers), name: .NSManagedObjectContextObjectsDidChange, object: moc)
    }
    
    /// Prepares graph for watching.
    fileprivate func prepareGraph() {
        graph.watchers.append(Watcher(object: self))
    }
}

/// Watch mechanics.
extension Watch {
    /**
     Watches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property typles.
     - Returns: An Array of Entities.
     */
    fileprivate func watchForEntity(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        if let v = types {
            watch(types: v, index: ModelIdentifier.entityName)
        }
        
        if let v = tags {
            watch(tags: v, index: ModelIdentifier.entityTagName)
        }
        
        if let v = groups {
            watch(groups: v, index: ModelIdentifier.entityGroupName)
        }
        
        if let v = properties {
            watch(properties: v, index: ModelIdentifier.entityPropertyName)
        }
    }
    
    /**
     Watches for Relationships that fall into any of the specified facets.
     - Parameter types: An Array of Relationship types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property typles.
     - Returns: An Array of Relationships.
     */
    fileprivate func watchForRelationship(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        if let v = types {
            watch(types: v, index: ModelIdentifier.relationshipName)
        }
        
        if let v = tags {
            watch(tags: v, index: ModelIdentifier.relationshipTagName)
        }
        
        if let v = groups {
            watch(groups: v, index: ModelIdentifier.relationshipGroupName)
        }
        
        if let v = properties {
            watch(properties: v, index: ModelIdentifier.relationshipPropertyName)
        }
    }
    
    /**
     Watches for Actions that fall into any of the specified facets.
     - Parameter types: An Array of Action types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property typles.
     - Returns: An Array of Actions.
     */
    fileprivate func watchForAction(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        if let v = types {
            watch(types: v, index: ModelIdentifier.actionName)
        }
        
        if let v = tags {
            watch(tags: v, index: ModelIdentifier.actionTagName)
        }
        
        if let v = groups {
            watch(groups: v, index: ModelIdentifier.actionGroupName)
        }
        
        if let v = properties {
            watch(properties: v, index: ModelIdentifier.actionPropertyName)
        }
    }
    
    /**
     Watch for a Node.
     - Parameter types: An Array of Strings.
     - Parameter index: A String.
     */
    fileprivate func watch(types: [String], index: String) {
        let p = addWatcher(key: "type", index: index, values: types)
        typesPredicate = nil == typesPredicate ? p : NSCompoundPredicate(andPredicateWithSubpredicates: [p, typesPredicate!])
    }
    
    /**
     Watch for a Tag.
     - Parameter tags: An Array of Strings.
     - Parameter index: A String.
     */
    fileprivate func watch(tags: [String], index: String) {
        let p = addWatcher(key: "name", index: index, values: tags)
        tagsPredicate = nil == tagsPredicate ? p : NSCompoundPredicate(andPredicateWithSubpredicates: [p, tagsPredicate!])
    }
    
    /**
     Watch for a Group.
     - Parameter groups: An Array of Strings.
     - Parameter index: A String.
     */
    fileprivate func watch(groups: [String], index: String) {
        let p = addWatcher(key: "name", index: index, values: groups)
        groupsPredicate = nil == groupsPredicate ? p : NSCompoundPredicate(andPredicateWithSubpredicates: [p, groupsPredicate!])
    }
    
    /**
     Watch for a Property.
     - Parameter properties: An Array of Strings.
     - Parameter index: A String.
     */
    fileprivate func watch(properties: [String], index: String) {
        let p = addWatcher(key: "name", index: index, values: properties)
        propertiesPredicate = nil == propertiesPredicate ? p : NSCompoundPredicate(andPredicateWithSubpredicates: [p, propertiesPredicate!])
    }
    
    /**
     Adds a watcher.
     - Parameter key: A parent level key to watch for.
     - Parameter index: A Model index.
     - Parameter values: An Array of Strings.
     */
    fileprivate func addWatcher(key: String, index: String, values: [String]) -> NSCompoundPredicate {
        var p = [NSPredicate]()
        values.forEach { [key = key] in
            p.append(NSPredicate(format: "%K LIKE %@", key, $0))
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "entity.name == %@", index), NSCompoundPredicate(orPredicateWithSubpredicates: p)])
    }
}
