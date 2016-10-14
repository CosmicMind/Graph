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

@objc(WatchCloudDelegate)
public protocol WatchCloudDelegate: WatchDelegate {
    /**
     A delegation method that is executed when a graph instance
     will prepare cloud storage.
     - Parameter graph: A Graph instance.
     - Parameter transition: A GraphCloudStorageTransition value.
     */
    @objc
    optional func graphWillPrepareCloudStorage(graph: Graph, transition: GraphCloudStorageTransition)
    
    /**
     A delegation method that is executed when a graph instance
     did prepare cloud storage.
     - Parameter graph: A Graph instance.
     */
    @objc
    optional func graphDidPrepareCloudStorage(graph: Graph)
    
    /**
     A delegation method that is executed when a graph instance
     will update from cloud storage.
     - Parameter graph: A Graph instance.
     */
    @objc
    optional func graphWillUpdateFromCloudStorage(graph: Graph)
    
    /**
     A delegation method that is executed when a graph instance 
     did update from cloud storage.
     - Parameter graph: A Graph instance.
     */
    @objc
    optional func graphDidUpdateFromCloudStorage(graph: Graph)
}

public enum WatchCondition: Int {
    case or
    case and
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
    
    /** 
     A boolean indicating if the Watch instance is
     currently watching.
     */
    public private(set) var isRunning = false
    
    /// A Graph instance.
    internal internal(set) var graph: Graph
    
    /// A reference to a delagte object.
    public weak var delegate: WatchDelegate?
    
    /// A reference to the type.
    public private(set) var types: [String]?
    
    /// A reference to the typesPredicate.
    public internal(set) var typesPredicate: NSPredicate?
    
    /// A reference to the tags.
    public private(set) var tags: [String]?
    
    /// A WatchCondition value for tags.
    public private(set) var tagsWatchCondition = WatchCondition.and
    
    /// A reference to the tagsPredicate.
    public internal(set) var tagsPredicate: NSPredicate?
    
    /// A reference to the groups.
    public private(set) var groups: [String]?
    
    /// A WatchCondition value for groups.
    public private(set) var groupsWatchCondition = WatchCondition.and
    
    /// A reference to the groupsPredicate.
    public internal(set) var groupsPredicate: NSPredicate?
    
    /// A reference to the properties.
    public private(set) var properties: [String]?
    
    /// A WatchCondition value for properties.
    public private(set) var propertiesWatchCondition = WatchCondition.and
    
    /// A reference to the propertiesPredicate.
    public internal(set) var propertiesPredicate: NSPredicate?
    
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
        tagsWatchCondition = .and
        tagsPredicate = nil
        groups = nil
        groupsWatchCondition = .and
        groupsPredicate = nil
        properties = nil
        propertiesWatchCondition = .and
        propertiesPredicate = nil
        return self
    }
    
    /**
     Pauses the watcher.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func pause() -> Watch {
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
    public func has(tags: [String], using condition: WatchCondition = .and) -> Watch {
        self.tags = tags
        tagsWatchCondition = condition
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
    public func member(of groups: [String], using condition: WatchCondition = .and) -> Watch {
        self.groups = groups
        groupsWatchCondition = condition
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
    public func `where`(properties: [String], using condition: WatchCondition = .and) -> Watch {
        self.properties = properties
        propertiesWatchCondition = condition
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
    private func delegateToInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        delegateToEntityInsertedWatchers(set, source: source)
        delegateToRelationshipInsertedWatchers(set, source: source)
        delegateToActionInsertedWatchers(set, source: source)
    }
    
    /**
     Passes the handle to the inserted notification delegates for Entities.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToEntityInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
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
    private func delegateToRelationshipInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
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
    private func delegateToActionInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
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
    private func delegateToUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        delegateToEntityUpdatedWatchers(set, source: source)
        delegateToRelationshipUpdatedWatchers(set, source: source)
        delegateToActionUpdatedWatchers(set, source: source)
    }
    
    /**
     Passes the handle to the updated notification delegates for Entities.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToEntityUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
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
    private func delegateToRelationshipUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
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
    private func delegateToActionUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
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
    private func delegateToDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        delegateToEntityDeletedWatchers(set, source: source)
        delegateToRelationshipDeletedWatchers(set, source: source)
        delegateToActionDeletedWatchers(set, source: source)
    }
    
    /**
     Passes the handle to the deleted notification delegates for Entities.
     - Parameter _ set: A Set of AnyHashable objects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToEntityDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
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
    private func delegateToRelationshipDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
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
    private func delegateToActionDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
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
    private func removeFromObservation() {
        NotificationCenter.default.removeObserver(self)
        isRunning = false
    }
    
    /// Prepares the Watch instance.
    private func prepare() {
        prepareGraph()
    }
    
    /// Prepares the instance for save notifications.
    internal func prepareForObservation() {
        guard !isRunning else {
            return
        }
        
        isRunning = true
        
        guard let moc = graph.managedObjectContext else {
            return
        }
        
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(notifyInsertedWatchers(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: moc)
        defaultCenter.addObserver(self, selector: #selector(notifyUpdatedWatchers(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: moc)
        defaultCenter.addObserver(self, selector: #selector(notifyDeletedWatchers(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: moc)
    }
    
    /// Prepares graph for watching.
    private func prepareGraph() {
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
    internal func watchForEntity(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
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
    internal func watchForRelationship(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
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
    internal func watchForAction(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
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
    private func watch(types: [String], index: String) {
        let p = addWatcher(using: .or, key: "type", index: index, values: types)
        typesPredicate = nil == typesPredicate ? p : NSCompoundPredicate(andPredicateWithSubpredicates: [p, typesPredicate!])
    }
    
    /**
     Watch for a Tag.
     - Parameter tags: An Array of Strings.
     - Parameter index: A String.
     */
    private func watch(tags: [String], index: String) {
        let p = addWatcher(using: .or, key: "name", index: index, values: tags)
        tagsPredicate = nil == tagsPredicate ? p : NSCompoundPredicate(andPredicateWithSubpredicates: [p, tagsPredicate!])
    }
    
    /**
     Watch for a Group.
     - Parameter groups: An Array of Strings.
     - Parameter index: A String.
     */
    private func watch(groups: [String], index: String) {
        let p = addWatcher(using: .or, key: "name", index: index, values: groups)
        groupsPredicate = nil == groupsPredicate ? p : NSCompoundPredicate(andPredicateWithSubpredicates: [p, groupsPredicate!])
    }
    
    /**
     Watch for a Property.
     - Parameter properties: An Array of Strings.
     - Parameter index: A String.
     */
    private func watch(properties: [String], index: String) {
        let p = addWatcher(using: .or, key: "name", index: index, values: properties)
        propertiesPredicate = nil == propertiesPredicate ? p : NSCompoundPredicate(andPredicateWithSubpredicates: [p, propertiesPredicate!])
    }
    
    /**
     Adds a watcher.
     - Parameter using: A WatchCondition value.
     - Parameter key: A parent level key to watch for.
     - Parameter index: A Model index.
     */
    private func addWatcher(using: WatchCondition, key: String, index: String, values: [String]) -> NSCompoundPredicate {
        var p = [NSPredicate]()
        values.forEach { [key = key] in
            p.append(NSPredicate(format: "%K LIKE %@", key, $0))
        }
        
        let cp = .and == using ? NSCompoundPredicate(andPredicateWithSubpredicates: p) : NSCompoundPredicate(orPredicateWithSubpredicates: p)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "entity.name == %@", index), cp])
    }
}

extension Watch where T: Entity {
    /**
     Resumes the watcher.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func resume() -> Watch {
        watchForEntity(types: types, tags: tags, groups: groups, properties: properties)
        prepareForObservation()
        return self
    }
}

extension Watch where T: Relationship {
    /**
     Resumes the watcher.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func resume() -> Watch {
        watchForRelationship(types: types, tags: tags, groups: groups, properties: properties)
        prepareForObservation()
        return self
    }
}

extension Watch where T: Action {
    /**
     Resumes the watcher.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func resume() -> Watch {
        watchForAction(types: types, tags: tags, groups: groups, properties: properties)
        prepareForObservation()
        return self
    }
}
