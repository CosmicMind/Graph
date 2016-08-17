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
    @objc
    optional func graph(graph: Graph, inserted entity: Entity, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, deleted entity: Entity, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, entity: Entity, added property: String, with value: Any, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, entity: Entity, updated property: String, with value: Any, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, entity: Entity, removed property: String, with value: Any, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, entity: Entity, added tag: String, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, entity: Entity, removed tag: String, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, entity: Entity, addedTo group: String, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, entity: Entity, removedFrom group: String, source: GraphSource)
}
    
@objc(GraphRelationshipDelegate)
public protocol GraphRelationshipDelegate: GraphDelegate {
    @objc
    optional func graph(graph: Graph, inserted relationship: Relationship, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, updated relationship: Relationship, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, deleted relationship: Relationship, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, relationship: Relationship, added property: String, with value: Any, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, relationship: Relationship, updated property: String, with value: Any, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, relationship: Relationship, removed property: String, with value: Any, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, relationship: Relationship, added tag: String, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, relationship: Relationship, removed tag: String, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, relationship: Relationship, addedTo group: String, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, relationship: Relationship, removedFrom group: String, source: GraphSource)
}

@objc(GraphActionDelegate)
public protocol GraphActionDelegate: GraphDelegate {
    @objc
    optional func graph(graph: Graph, inserted action: Action, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, deleted action: Action, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, action: Action, added property: String, with value: Any, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, action: Action, updated property: String, with value: Any, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, action: Action, removed property: String, with value: Any, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, action: Action, added tag: String, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, action: Action, removed tag: String, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, action: Action, addedTo group: String, source: GraphSource)
    
    @objc
    optional func graph(graph: Graph, action: Action, removedFrom group: String, source: GraphSource)
}

@objc(GraphCloudDelegate)
public protocol GraphCloudDelegate: GraphDelegate {
    @objc
    optional func graphWillPrepareCloudStorage(graph: Graph, transition: GraphCloudStorageTransition)
    
    @objc
    optional func graphDidPrepareCloudStorage(graph: Graph)
    
    @objc
    optional func graphWillUpdateFromCloudStorage(graph: Graph)
    
    @objc
    optional func graphDidUpdateFromCloudStorage(graph: Graph)
}

/// Storage Watch API.
extension Graph {
    /**
     Watches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property typles.
     - Returns: An Array of Entities.
     */
    public func watchForEntity(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        types?.forEach { [unowned self] (type: String) in
            self.watch(Entity: type)
        }
        
        tags?.forEach { [unowned self] (tag: String) in
            self.watch(EntityTag: tag)
        }
        
        groups?.forEach { [unowned self] (group: String) in
            self.watch(EntityGroup: group)
        }
        
        properties?.forEach { [unowned self] (property: String) in
            self.watch(EntityProperty: property)
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
    public func watchForRelationship(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        types?.forEach { [unowned self] (type: String) in
            self.watch(Relationship: type)
        }
        
        tags?.forEach { [unowned self] (tag: String) in
            self.watch(RelationshipTag: tag)
        }
        
        groups?.forEach { [unowned self] (group: String) in
            self.watch(RelationshipGroup: group)
        }
        
        properties?.forEach { [unowned self] (property: String) in
            self.watch(RelationshipProperty: property)
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
    public func watchForAction(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        types?.forEach { [unowned self] (type: String) in
            self.watch(Action: type)
        }
        
        tags?.forEach { [unowned self] (tag: String) in
            self.watch(ActionTag: tag)
        }
        
        groups?.forEach { [unowned self] (group: String) in
            self.watch(ActionGroup: group)
        }
        
        properties?.forEach { [unowned self] (property: String) in
            self.watch(ActionProperty: property)
        }
    }
    
    /**
     Notifies inserted watchers from local changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyInsertedWatchers(_ notification: Notification) {
        guard let objects = (notification as NSNotification).userInfo?[NSInsertedObjectsKey] as? NSMutableSet else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        objects.filter(using: predicate)
        
        delegateToInsertedWatchers(objects, source: .local)
    }
    
    /**
     Notifies updated watchers from local changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyUpdatedWatchers(_ notification: Notification) {
        guard let objects = (notification as NSNotification).userInfo?[NSUpdatedObjectsKey] as? NSMutableSet else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        objects.filter(using: predicate)
        
        delegateToUpdatedWatchers(objects, source: .local)
    }
    
    /**
     Notifies deleted watchers from local changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyDeletedWatchers(_ notification: Notification) {
        guard let objects = (notification as NSNotification).userInfo?[NSDeletedObjectsKey] as? NSMutableSet else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        objects.filter(using: predicate)
        
        delegateToDeletedWatchers(objects, source: .local)
    }
    
    /**
     Notifies inserted watchers from cloud changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyInsertedWatchersFromCloud(_ notification: Notification) {
        guard let objectIDs = (notification as NSNotification).userInfo?[NSInsertedObjectsKey] as? NSMutableSet else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        guard let moc = managedObjectContext else {
            return
        }
        
        let objects = NSMutableSet()
        (objectIDs.allObjects as! [NSManagedObjectID]).forEach { [unowned moc] (objectID: NSManagedObjectID) in
            objects.add(moc.object(with: objectID))
        }
        objects.filter(using: predicate)
        
        delegateToInsertedWatchers(objects, source: .cloud)
    }
    
    /**
     Notifies updated watchers from cloud changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyUpdatedWatchersFromCloud(_ notification: Notification) {
        guard let objectIDs = (notification as NSNotification).userInfo?[NSUpdatedObjectsKey] as? NSMutableSet else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        guard let moc = managedObjectContext else {
            return
        }
        
        let objects = NSMutableSet()
        (objectIDs.allObjects as! [NSManagedObjectID]).forEach { [unowned moc] (objectID: NSManagedObjectID) in
            objects.add(moc.object(with: objectID))
        }
        objects.filter(using: predicate)
        
        delegateToUpdatedWatchers(objects, source: .cloud)
    }
    
    /**
     Notifies deleted watchers from cloud changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyDeletedWatchersFromCloud(_ notification: Notification) {
        guard let objectIDs = (notification as NSNotification).userInfo?[NSDeletedObjectsKey] as? NSMutableSet else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        guard let moc = managedObjectContext else {
            return
        }
        
        let objects = NSMutableSet()
        (objectIDs.allObjects as! [NSManagedObjectID]).forEach { [unowned moc] (objectID: NSManagedObjectID) in
            objects.add(moc.object(with: objectID))
        }
        objects.filter(using: predicate)
        
        delegateToDeletedWatchers(objects, source: .cloud)
    }
    
    /**
     Passes the handle to the inserted notification delegates.
     - Parameter set: A Set of NSManagedObjects to pass.
     */
    private func delegateToInsertedWatchers(_ set: NSMutableSet, source: GraphSource) {
        let nodes = sortToArray(set)
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedEntity_ManagedEntity_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, inserted: Entity(managedNode: managedObject as! ManagedEntity), source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedEntityTag_ManagedEntityTag_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let tag = managedObject as! ManagedEntityTag
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: tag.node), added: tag.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedEntityGroup_ManagedEntityGroup_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let group = managedObject as! ManagedEntityGroup
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: group.node), addedTo: group.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedEntityProperty_ManagedEntityProperty_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let property = managedObject as! ManagedEntityProperty
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: property.node), added: property.name, with: property.object, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationship_ManagedRelationship_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, inserted: Relationship(managedNode: managedObject as! ManagedRelationship), source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationshipTag_ManagedRelationshipTag_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let tag = managedObject as! ManagedRelationshipTag
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: tag.node), added: tag.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationshipGroup_ManagedRelationshipGroup_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let group = managedObject as! ManagedRelationshipGroup
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: group.node), addedTo: group.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationshipProperty_ManagedRelationshipProperty_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let property = managedObject as! ManagedRelationshipProperty
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: property.node), added: property.name, with: property.object, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedAction_ManagedAction_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, inserted: Action(managedNode: managedObject as! ManagedAction), source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedActionTag_ManagedActionTag_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let tag: ManagedActionTag = managedObject as! ManagedActionTag
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: tag.node), added: tag.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedActionGroup_ManagedActionGroup_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let group = managedObject as! ManagedActionGroup
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: group.node), addedTo: group.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedActionProperty_ManagedActionProperty_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let property = managedObject as! ManagedActionProperty
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: property.node), added: property.name, with: property.object, source: source)
        }
    }
    
    /**
     Passes the handle to the updated notification delegates.
     - Parameter set: A Set of NSManagedObjects to pass.
     */
    private func delegateToUpdatedWatchers(_ set: NSMutableSet, source: GraphSource) {
        let nodes = sortToArray(set)
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedEntityProperty_ManagedEntityProperty_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let property = managedObject as! ManagedEntityProperty
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: property.node), updated: property.name, with: property.object, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationship_ManagedRelationship_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, updated: Relationship(managedNode: managedObject as! ManagedRelationship), source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationshipProperty_ManagedRelationshipProperty_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let property = managedObject as! ManagedRelationshipProperty
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: property.node), updated: property.name, with: property.object, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedActionProperty_ManagedActionProperty_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            let property = managedObject as! ManagedActionProperty
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: property.node), updated: property.name, with: property.object, source: source)
        }
    }
    
    /**
     Passes the handle to the deleted notification delegates.
     - Parameter set: A Set of NSManagedObjects to pass.
     */
    private func delegateToDeletedWatchers(_ set: NSMutableSet, source: GraphSource) {
        let nodes = sortToArray(set)
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedEntityTag_ManagedEntityTag_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            
            let tag = managedObject as! ManagedEntityTag
            
            guard let node = .cloud == source ? tag.node : tag.changedValuesForCurrentEvent()["node"] as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: node), removed: tag.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedEntityGroup_ManagedEntityGroup_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            
            let group = managedObject as! ManagedEntityGroup
            
            guard let node = .cloud == source ? group.node : group.changedValuesForCurrentEvent()["node"] as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: node), removedFrom: group.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedEntityProperty_ManagedEntityProperty_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            
            let property = managedObject as! ManagedEntityProperty
            
            guard let node = .cloud == source ? property.node : property.changedValuesForCurrentEvent()["node"] as? ManagedEntity else {
                return
            }
            
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, entity: Entity(managedNode: node), removed: property.name, with: property.object, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedEntity_ManagedEntity_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            (self.delegate as? GraphEntityDelegate)?.graph?(graph: self, deleted: Entity(managedNode: managedObject as! ManagedEntity), source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationshipTag_ManagedRelationshipTag_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            
            let tag = managedObject as! ManagedRelationshipTag
            
            guard let node = .cloud == source ? tag.node : tag.changedValuesForCurrentEvent()["node"] as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: node), removed: tag.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationshipGroup_ManagedRelationshipGroup_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            
            let group = managedObject as! ManagedRelationshipGroup
            
            guard let node = .cloud == source ? group.node : group.changedValuesForCurrentEvent()["node"] as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: node), removedFrom: group.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationshipProperty_ManagedRelationshipProperty_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            
            let property = managedObject as! ManagedRelationshipProperty
            
            guard let node = .cloud == source ? property.node : property.changedValuesForCurrentEvent()["node"] as? ManagedRelationship else {
                return
            }
            
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, relationship: Relationship(managedNode: node), removed: property.name, with: property.object, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedRelationship_ManagedRelationship_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            (self.delegate as? GraphRelationshipDelegate)?.graph?(graph: self, deleted: Relationship(managedNode: managedObject as! ManagedRelationship), source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedActionTag_ManagedActionTag_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            
            let tag: ManagedActionTag = managedObject as! ManagedActionTag
            
            guard let node = .cloud == source ? tag.node : tag.changedValuesForCurrentEvent()["node"] as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: node), removed: tag.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedActionGroup_ManagedActionGroup_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            
            let group = managedObject as! ManagedActionGroup
            
            guard let node = .cloud == source ? group.node : group.changedValuesForCurrentEvent()["node"] as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: node), removedFrom: group.name, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedActionProperty_ManagedActionProperty_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            
            let property = managedObject as! ManagedActionProperty
            
            guard let node = .cloud == source ? property.node : property.changedValuesForCurrentEvent()["node"] as? ManagedAction else {
                return
            }
            
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, action: Action(managedNode: node), removed: property.name, with: property.object, source: source)
        }
        
        nodes.forEach { [unowned self] (managedObject: NSManagedObject) in
            guard "ManagedAction_ManagedAction_" == String(cString: object_getClassName(managedObject)) else {
                return
            }
            (self.delegate as? GraphActionDelegate)?.graph?(graph: self, deleted: Action(managedNode: managedObject as! ManagedAction), source: source)
        }
    }
    
    /**
     Sort nodes.
     - Parameter set: A Set of NSManagedObjects.
     - Returns: A Set of NSManagedObjects in sorted order.
     */
    private func sortToArray(_ set: NSMutableSet) -> [NSManagedObject] {
        return set.sorted { (a, b) -> Bool in
            return (a as! ManagedNode).id < (b as! ManagedNode).id
        } as! [NSManagedObject]
    }
    
    /**
     Watch for an Entity type.
     - Parameter type: An Entity type to watch for.
     */
    private func watch(Entity type: String) {
        addWatcher(
            "type",
            index: ModelIdentifier.entityName,
            value: type,
            entityDescriptionName: ModelIdentifier.entityName,
            managedObjectClassName: ModelIdentifier.entityName)
    }
    
    /**
     Watch for an Entity tag.
     - Parameter name: An Entity tag name to watch for.
     */
    private func watch(EntityTag name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.entityTagName,
            value: name,
            entityDescriptionName: ModelIdentifier.entityTagName,
            managedObjectClassName: ModelIdentifier.entityTagName)
    }
    
    /**
     Watch for an Entity group.
     - Parameter name: An Entity group name to watch for.
     */
    private func watch(EntityGroup name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.entityGroupName,
            value: name,
            entityDescriptionName: ModelIdentifier.entityGroupName,
            managedObjectClassName: ModelIdentifier.entityGroupName)
    }
    
    /**
     Watch for an Entity property.
     - Parameter name: An Entity property to watch for.
     */
    private func watch(EntityProperty name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.entityPropertyName,
            value: name,
            entityDescriptionName: ModelIdentifier.entityPropertyName,
            managedObjectClassName: ModelIdentifier.entityPropertyName)
    }
    
    /**
     Watch for a Relationship type.
     - Parameter type: A Relationship type to watch for.
     */
    private func watch(Relationship type: String) {
        addWatcher(
            "type",
            index: ModelIdentifier.relationshipName,
            value: type,
            entityDescriptionName: ModelIdentifier.relationshipName,
            managedObjectClassName: ModelIdentifier.relationshipName)
    }
    
    /**
     Watch for a Relationship tag.
     - Parameter name: A Relationship tag name to watch for.
     */
    private func watch(RelationshipTag name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.relationshipTagName,
            value: name,
            entityDescriptionName: ModelIdentifier.relationshipTagName,
            managedObjectClassName: ModelIdentifier.relationshipTagName)
    }
    
    /**
     Watch for an Relationship group.
     - Parameter name: An Relationship group name to watch for.
     */
    private func watch(RelationshipGroup name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.relationshipGroupName,
            value: name,
            entityDescriptionName: ModelIdentifier.relationshipGroupName,
            managedObjectClassName: ModelIdentifier.relationshipGroupName)
    }
    
    /**
     Watch for a Relationship property.
     - Parameter name: An Entity property to watch for.
     */
    private func watch(RelationshipProperty name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.relationshipPropertyName,
            value: name,
            entityDescriptionName: ModelIdentifier.relationshipPropertyName,
            managedObjectClassName: ModelIdentifier.relationshipPropertyName)
    }
    
    /**
     Watch for an Action type.
     - Parameter type: An Action type to watch for.
     */
    private func watch(Action type: String) {
        addWatcher(
            "type",
            index: ModelIdentifier.actionName,
            value: type,
            entityDescriptionName: ModelIdentifier.actionName,
            managedObjectClassName: ModelIdentifier.actionName)
    }
    
    /**
     Watch for an Action tag.
     - Parameter name: An Action tag name to watch for.
     */
    private func watch(ActionTag name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.actionTagName,
            value: name,
            entityDescriptionName: ModelIdentifier.actionTagName,
            managedObjectClassName: ModelIdentifier.actionTagName)
    }
    
    /**
     Watch for an Action group.
     - Parameter name: An Action group name to watch for.
     */
    private func watch(ActionGroup name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.actionGroupName,
            value: name,
            entityDescriptionName: ModelIdentifier.actionGroupName,
            managedObjectClassName: ModelIdentifier.actionGroupName)
    }
    
    /**
     Watch for an Action property.
     - Parameter name: An Action property to watch for.
     */
    private func watch(ActionProperty name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.actionPropertyName,
            value: name,
            entityDescriptionName: ModelIdentifier.actionPropertyName,
            managedObjectClassName: ModelIdentifier.actionPropertyName)
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
     Adds a watcher.
     - Parameter key: A parent level key to watch for.
     - Parameter index: A Model index.
     - Parameter value: A value to watch for.
     - Parameter entityDescription: An entity description.
     - Parameter managedObjectClassName: A Mode class name.
     */
    private func addWatcher(_ key: String, index: String, value: String, entityDescriptionName: String, managedObjectClassName: String) {
        prepareForObservation()
        
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
     Adds a predicate to watch for.
     - Parameter entityDescription: An NSEntityDescription to watch.
     - Parameter predicate: An NSPredicate.
     */
    private func addPredicateToObserve(_ entityDescription: NSEntityDescription, predicate: NSPredicate) {
        let finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "entity.name == %@", entityDescription.name! as NSString), predicate])
        watchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: nil == watchPredicate ? [finalPredicate] : [watchPredicate!, finalPredicate])
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

