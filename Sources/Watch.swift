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

@objc(GraphDelegate)
public protocol GraphDelegate {}

@objc(GraphEntityDelegate)
public protocol GraphEntityDelegate: GraphDelegate {
    /**
     A delegation method that is executed when an Entity is inserted.
     - Parameter graph: A Graph instance.
     - Parameter inserted entity: An Entity instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, inserted entity: Entity, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity is deleted.
     - Parameter graph: A Graph instance.
     - Parameter deleted entity: An Entity instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, deleted entity: Entity, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity added a property and value.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter added property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, entity: Entity, added property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity updated a property and value.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter updated property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, entity: Entity, updated property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity removed a property and value.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter removed property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, entity: Entity, removed property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity added a tag.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter added tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, entity: Entity, added tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity removed a tag.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter removed tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, entity: Entity, removed tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity was added to a group.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter addedTo group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, entity: Entity, addedTo group: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Entity was removed from a group.
     - Parameter graph: A Graph instance.
     - Parameter entity: An Entity instance.
     - Parameter removedFrom group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, entity: Entity, removedFrom group: String, source: GraphSource)
}
    
@objc(GraphRelationshipDelegate)
public protocol GraphRelationshipDelegate: GraphDelegate {
    /**
     A delegation method that is executed when a Relationship is inserted.
     - Parameter graph: A Graph instance.
     - Parameter inserted relationship: A Relationship instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, inserted relationship: Relationship, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship is updated.
     - Parameter graph: A Graph instance.
     - Parameter updated relationship: A Relationship instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, updated relationship: Relationship, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship is deleted.
     - Parameter graph: A Graph instance.
     - Parameter deleted relationship: A Relationship instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, deleted relationship: Relationship, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship added a property and value.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter added property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, relationship: Relationship, added property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship updated a property and value.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter updated property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, relationship: Relationship, updated property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship removed a property and value.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter removed property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, relationship: Relationship, removed property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship added a tag.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter added tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, relationship: Relationship, added tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship removed a tag.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter removed tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, relationship: Relationship, removed tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship was added to a group.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter addedTo group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, relationship: Relationship, addedTo group: String, source: GraphSource)
    
    /**
     A delegation method that is executed when a Relationship was removed from a group.
     - Parameter graph: A Graph instance.
     - Parameter relationship: A Relationship instance.
     - Parameter removedFrom group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, relationship: Relationship, removedFrom group: String, source: GraphSource)
}

@objc(GraphActionDelegate)
public protocol GraphActionDelegate: GraphDelegate {
    /**
     A delegation method that is executed when an Action is inserted.
     - Parameter graph: A Graph instance.
     - Parameter inserted action: An Action instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, inserted action: Action, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action is deleted.
     - Parameter graph: A Graph instance.
     - Parameter deleted action: An Action instance.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, deleted action: Action, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action added a property and value.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter added property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, action: Action, added property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action updated a property and value.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter updated property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, action: Action, updated property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action removed a property and value.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter removed property: A String.
     - Parameter with value: Any object.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, action: Action, removed property: String, with value: Any, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action added a tag.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter added tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, action: Action, added tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action removed a tag.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter removed tag: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, action: Action, removed tag: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action was added to a group.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter addedTo group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, action: Action, addedTo group: String, source: GraphSource)
    
    /**
     A delegation method that is executed when an Action was removed from a group.
     - Parameter graph: A Graph instance.
     - Parameter action: An Action instance.
     - Parameter removedFrom group: A String.
     - Parameter source: A GraphSource value.
     */
    @objc
    optional func graph(graph: Graph, action: Action, removedFrom group: String, source: GraphSource)
}

@objc(GraphCloudDelegate)
public protocol GraphCloudDelegate: GraphDelegate {
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

/// Watch.
public class Watch {
    /// A reference to the NodeClass value.
    public internal(set) var nodeClass: NodeClass
    
    /// A reference to the predicate.
    public internal(set) var predicate: NSPredicate?
    
    /// A reference to cache the watch values.
    internal lazy var watchers = [String: [String]]()
    
    /**
     An initializer that accepts a NodeClass and Graph
     instance.
     - Parameter nodeClass: A NodeClass value.
     */
    internal init(nodeClass: NodeClass) {
        self.nodeClass = nodeClass
    }
    
    /**
     Watches nodes with given types.
     - Parameter types: An Array of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func `for`(types: [String]) -> Watch {
        switch nodeClass {
        case .entity:
            watchForEntity(types: types)
        case .relationship:
            watchForRelationship(types: types)
        case .action:
            watchForAction(types: types)
        }
        
        return self
    }
    
    /**
     Watches nodes with given tags.
     - Parameter tags: An Array of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func has(tags: [String]) -> Watch {
        switch nodeClass {
        case .entity:
            watchForEntity(tags: tags)
        case .relationship:
            watchForRelationship(tags: tags)
        case .action:
            watchForAction(tags: tags)
        }
        
        return self
    }
    
    /**
     Watches nodes in given groups.
     - Parameter of groups: An Array of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func member(of groups: [String]) -> Watch {
        switch nodeClass {
        case .entity:
            watchForEntity(groups: groups)
        case .relationship:
            watchForRelationship(groups: groups)
        case .action:
            watchForAction(groups: groups)
        }
        
        return self
    }
    
    /**
     Watches nodes with given properties.
     - Parameter properties: An Array of Strings.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func `where`(properties: [String]) -> Watch {
        switch nodeClass {
        case .entity:
            watchForEntity(properties: properties)
        case .relationship:
            watchForRelationship(properties: properties)
        case .action:
            watchForAction(properties: properties)
        }
        
        return self
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
        types?.forEach { [unowned self] in
            self.watch(Node: $0, index: ModelIdentifier.entityName)
        }
        
        tags?.forEach { [unowned self] in
            self.watch(Tag: $0, index: ModelIdentifier.entityTagName)
        }
        
        groups?.forEach { [unowned self] in
            self.watch(Group: $0, index: ModelIdentifier.entityGroupName)
        }
        
        properties?.forEach { [unowned self] in
            self.watch(Property: $0, index: ModelIdentifier.entityPropertyName)
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
        types?.forEach { [unowned self] in
            self.watch(Node: $0, index: ModelIdentifier.relationshipName)
        }
        
        tags?.forEach { [unowned self] in
            self.watch(Tag: $0, index: ModelIdentifier.relationshipTagName)
        }
        
        groups?.forEach { [unowned self] in
            self.watch(Group: $0, index: ModelIdentifier.relationshipGroupName)
        }
        
        properties?.forEach { [unowned self] in
            self.watch(Property: $0, index: ModelIdentifier.relationshipPropertyName)
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
        types?.forEach { [unowned self] in
            self.watch(Node: $0, index: ModelIdentifier.actionName)
        }
        
        tags?.forEach { [unowned self] in
            self.watch(Tag: $0, index: ModelIdentifier.actionTagName)
        }
        
        groups?.forEach { [unowned self] in
            self.watch(Group: $0, index: ModelIdentifier.actionGroupName)
        }
        
        properties?.forEach { [unowned self] in
            self.watch(Property: $0, index: ModelIdentifier.actionPropertyName)
        }
    }
    
    /**
     Watch for an Entity type.
     - Parameter type: An Entity type to watch for.
     */
    private func watch(Node type: String, index: String) {
        addWatcher(
            key: "type",
            index: index,
            value: type,
            entityDescriptionName: index,
            managedObjectClassName: index)
    }
    
    /**
     Watch for an Entity tag.
     - Parameter name: An Entity tag name to watch for.
     */
    private func watch(Tag name: String, index: String) {
        addWatcher(
            key: "name",
            index: index,
            value: name,
            entityDescriptionName: index,
            managedObjectClassName: index)
    }
    
    /**
     Watch for an Entity group.
     - Parameter name: An Entity group name to watch for.
     */
    private func watch(Group name: String, index: String) {
        addWatcher(
            key: "name",
            index: index,
            value: name,
            entityDescriptionName: index,
            managedObjectClassName: index)
    }
    
    /**
     Watch for an Entity property.
     - Parameter name: An Entity property to watch for.
     */
    private func watch(Property name: String, index: String) {
        addWatcher(
            key: "name",
            index: index,
            value: name,
            entityDescriptionName: index,
            managedObjectClassName: index)
    }
    
    /**
     Adds a watcher.
     - Parameter key: A parent level key to watch for.
     - Parameter index: A Model index.
     - Parameter value: A value to watch for.
     - Parameter entityDescription: An entity description.
     - Parameter managedObjectClassName: A Mode class name.
     */
    private func addWatcher(key: String, index: String, value: String, entityDescriptionName: String, managedObjectClassName: String) {
        guard !isWatching(key: value, index: index) else {
            return
        }
        
        let entityDescription = NSEntityDescription()
        entityDescription.name = entityDescriptionName
        entityDescription.managedObjectClassName = managedObjectClassName
        
        let predicate = NSPredicate(format: "%K LIKE %@", key as NSString, value as NSString)
        addPredicateToObserve(entityDescription, predicate: predicate)
    }
    
    /**
     Checks if the Watch API is watching a certain facet.
     - Parameter key: A key for top level organization.
     - Parameter index: A Model index.
     - Returns: A boolean for the result, true if watching, false
     otherwise.
     */
    private func isWatching(key: String, index: String) -> Bool {
        if nil == watchers[key] {
            watchers[key] = [String](arrayLiteral: index)
            return false
        }
        
        if watchers[key]!.contains(index) {
            return true
        }
        
        watchers[key]!.append(index)
        return false
    }
    
    /**
     Adds a predicate to watch for.
     - Parameter entityDescription: An NSEntityDescription to watch.
     - Parameter predicate: An NSPredicate.
     */
    private func addPredicateToObserve(_ entityDescription: NSEntityDescription, predicate p: NSPredicate) {
        let p = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "entity.name == %@", entityDescription.name! as NSString), p])
        predicate = NSCompoundPredicate(orPredicateWithSubpredicates: nil == predicate ? [p] : [predicate!, p])
    }
}

extension Graph {
    /// A reference to the overall predicate.
    internal var predicate: NSPredicate? {
        var p: NSPredicate?
        for watch in watchers {
            if let v = watch.predicate {
                p = NSCompoundPredicate(orPredicateWithSubpredicates: nil == p ? [v] : [v, p!])
            }
        }
        return p
    }
    
    /**
     Watch for a given NodeClass.
     - Parameter for nodeClass: A NodeClass value.
     - Returns: A Watch instance.
     */
    @discardableResult
    public func watch(for nodeClass: NodeClass) -> Watch {
        prepareForObservation()
        
        let watch = Watch(nodeClass: nodeClass)
        watchers.append(watch)
        
        return watch
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
        
        guard let moc = managedObjectContext else {
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
        
        guard let moc = managedObjectContext else {
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
        
        guard let moc = managedObjectContext else {
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
     - Parameter _ set: A Set of NSManagedObjects to pass.
     - Parameter source: A GraphSource value.
     */
    private func delegateToInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        let nodes = sortToArray(set)
        
        delegateToEntityInsertedWatchers(nodes: nodes, source: source)
        delegateToRelationshipInsertedWatchers(nodes: nodes, source: source)
        delegateToActionInsertedWatchers(nodes: nodes, source: source)
    }
    
    /**
     Passes the handle to the inserted notification delegates for Entities.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToEntityInsertedWatchers(nodes: [NSManagedObject], source: GraphSource) {
        nodes.forEach { [unowned self] in
            guard let n = $0 as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, inserted: Entity(managedNode: n), source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityTag else {
                return
            }
            
            guard let n = o.node as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: n), added: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityGroup else {
                return
            }
            
            guard let n = o.node as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: n), addedTo: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityProperty else {
                return
            }
            
            guard let n = o.node as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: n), added: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the inserted notification delegates for Relationships.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToRelationshipInsertedWatchers(nodes: [NSManagedObject], source: GraphSource) {
        nodes.forEach { [unowned self] in
            guard let n = $0 as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, inserted: Relationship(managedNode: n), source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipTag else {
                return
            }
            
            guard let n = o.node as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: n), added: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipGroup else {
                return
            }
            
            guard let n = o.node as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: n), addedTo: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipProperty else {
                return
            }
            
            guard let n = o.node as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: n), added: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the inserted notification delegates for Actions.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToActionInsertedWatchers(nodes: [NSManagedObject], source: GraphSource) {
        nodes.forEach { [unowned self] in
            guard let n = $0 as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, inserted: Action(managedNode: n), source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionTag else {
                return
            }
            
            guard let n = o.node as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: n), added: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionGroup else {
                return
            }
            
            guard let n = o.node as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: n), addedTo: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionProperty else {
                return
            }
            
            guard let n = o.node as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: n), added: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the updated notification delegates.
     - Parameter _ set: A Set of NSManagedObjects to pass.
     - Parameter source: A GraphSource value.
     */
    private func delegateToUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        let nodes = sortToArray(set)
        
        delegateToEntityUpdatedWatchers(nodes: nodes, source: source)
        delegateToRelationshipUpdatedWatchers(nodes: nodes, source: source)
        delegateToActionUpdatedWatchers(nodes: nodes, source: source)
    }
    
    /**
     Passes the handle to the updated notification delegates for Entities.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToEntityUpdatedWatchers(nodes: [NSManagedObject], source: GraphSource) {
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityProperty else {
                return
            }
            
            guard let n = o.node as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: n), updated: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the updated notification delegates for Relationships.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToRelationshipUpdatedWatchers(nodes: [NSManagedObject], source: GraphSource) {
        nodes.forEach { [unowned self] in
            guard let n = $0 as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, updated: Relationship(managedNode: n), source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipProperty else {
                return
            }
            
            guard let n = o.node as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: n), updated: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the updated notification delegates for Actions.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToActionUpdatedWatchers(nodes: [NSManagedObject], source: GraphSource) {
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionProperty else {
                return
            }
            
            guard let n = o.node as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: n), updated: o.name, with: o.object, source: source)
        }
    }
    
    /**
     Passes the handle to the deleted notification delegates.
     - Parameter _ set: A Set of NSManagedObjects to pass.
     - Parameter source: A GraphSource value.
     */
    private func delegateToDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
        let nodes = sortToArray(set)
        
        delegateToEntityDeletedWatchers(nodes: nodes, source: source)
        delegateToRelationshipDeletedWatchers(nodes: nodes, source: source)
        delegateToActionDeletedWatchers(nodes: nodes, source: source)
    }
    
    /**
     Passes the handle to the deleted notification delegates for Entities.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToEntityDeletedWatchers(nodes: [NSManagedObject], source: GraphSource) {
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityTag else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: n), removed: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityGroup else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: n), removedFrom: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedEntityProperty else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: n), removed: o.name, with: o.object, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let n = $0 as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, deleted: Entity(managedNode: n), source: source)
        }
    }
    
    /**
     Passes the handle to the deleted notification delegates for Relationships.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToRelationshipDeletedWatchers(nodes: [NSManagedObject], source: GraphSource) {
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipTag else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: n), removed: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipGroup else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: n), removedFrom: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedRelationshipProperty else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: n), removed: o.name, with: o.object, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let n = $0 as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, deleted: Relationship(managedNode: n), source: source)
        }
    }
    
    /**
     Passes the handle to the deleted notification delegates for Actions.
     - Parameter nodes: An Array of ManagedObjects.
     - Parameter source: A GraphSource value.
     */
    private func delegateToActionDeletedWatchers(nodes: [NSManagedObject], source: GraphSource) {
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionTag else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: n), removed: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionGroup else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: n), removedFrom: o.name, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let o = $0 as? ManagedActionProperty else {
                return
            }
            
            guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: n), removed: o.name, with: o.object, source: source)
        }
        
        nodes.forEach { [unowned self] in
            guard let n = $0 as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, deleted: Action(managedNode: n), source: source)
        }
    }
    
    /**
     Sort nodes.
     - Parameter _ set: A Set of NSManagedObjects.
     - Returns: A Set of NSManagedObjects in sorted order.
     */
    private func sortToArray(_ set: Set<AnyHashable>) -> [NSManagedObject] {
        var objects = Set<NSManagedObject>()
        
        set.forEach { (object) in
            objects.insert(object as! NSManagedObject)
        }
        
        return objects.sorted { (a, b) -> Bool in
            guard let a1 = a as? ManagedNode else {
                return false
            }
            guard let b1 = b as? ManagedNode else {
                return false
            }
            return a1 < b1
        }
    }
    
    /// Prepares the instance for save notifications.
    private func prepareForObservation() {
        guard 0 == watchers.count else {
            return
        }
        
        guard let moc = managedObjectContext else {
            return
        }
        
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(notifyInsertedWatchers(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: moc)
        defaultCenter.addObserver(self, selector: #selector(notifyUpdatedWatchers(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: moc)
        defaultCenter.addObserver(self, selector: #selector(notifyDeletedWatchers(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: moc)
    }
}
