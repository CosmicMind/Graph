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

@objc(GraphDelegate)
public protocol GraphDelegate {
    optional func graphDidInsertEntity(graph: Graph, entity: Entity, fromCloud: Bool)
    optional func graphWillDeleteEntity(graph: Graph, entity: Entity, fromCloud: Bool)
    optional func graphDidAddEntityToGroup(graph: Graph, entity: Entity, group: String, fromCloud: Bool)
    optional func graphWillRemoveEntityFromGroup(graph: Graph, entity: Entity, group: String, fromCloud: Bool)
    optional func graphDidInsertEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject, fromCloud: Bool)
    optional func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject, fromCloud: Bool)
    optional func graphWillDeleteEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject, fromCloud: Bool)
    
    optional func graphDidInsertRelationship(graph: Graph, relationship: Relationship, fromCloud: Bool)
    optional func graphDidUpdateRelationship(graph: Graph, relationship: Relationship, fromCloud: Bool)
    optional func graphWillDeleteRelationship(graph: Graph, relationship: Relationship, fromCloud: Bool)
    optional func graphDidAddRelationshipToGroup(graph: Graph, relationship: Relationship, group: String, fromCloud: Bool)
    optional func graphWillRemoveRelationshipFromGroup(graph: Graph, relationship: Relationship, group: String, fromCloud: Bool)
    optional func graphDidInsertRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject, fromCloud: Bool)
    optional func graphDidUpdateRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject, fromCloud: Bool)
    optional func graphWillDeleteRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject, fromCloud: Bool)
    
    optional func graphDidInsertAction(graph: Graph, action: Action, fromCloud: Bool)
    optional func graphDidUpdateAction(graph: Graph, action: Action, fromCloud: Bool)
    optional func graphWillDeleteAction(graph: Graph, action: Action, fromCloud: Bool)
    optional func graphDidAddActionToGroup(graph: Graph, action: Action, group: String, fromCloud: Bool)
    optional func graphWillRemoveActionFromGroup(graph: Graph, action: Action, group: String, fromCloud: Bool)
    optional func graphDidInsertActionProperty(graph: Graph, action: Action, property: String, value: AnyObject, fromCloud: Bool)
    optional func graphDidUpdateActionProperty(graph: Graph, action: Action, property: String, value: AnyObject, fromCloud: Bool)
    optional func graphWillDeleteActionProperty(graph: Graph, action: Action, property: String, value: AnyObject, fromCloud: Bool)
    
    optional func graphWillPrepareCloudStorage(graph: Graph, transition: GraphCloudStorageTransition)
    optional func graphDidPrepareCloudStorage(graph: Graph)
    optional func graphWillResetFromCloudStorage(graph: Graph)
    optional func graphDidResetFromCloudStorage(graph: Graph)
}

/// Storage Watch API.
public extension Graph {
    /**
     Watches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property typles.
     - Returns: An Array of Entities.
     */
    public func watchForEntity(types types: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        types?.forEach { [unowned self] (type: String) in
            self.watch(Entity: type)
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
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property typles.
     - Returns: An Array of Relationships.
     */
    public func watchForRelationship(types types: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        types?.forEach { [unowned self] (type: String) in
            self.watch(Relationship: type)
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
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property typles.
     - Returns: An Array of Actions.
     */
    public func watchForAction(types types: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        types?.forEach { [unowned self] (type: String) in
            self.watch(Action: type)
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
    internal func notifyInsertedWatchers(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        if let objects = info[NSInsertedObjectsKey] as? NSSet {
            delegateToInsertedWatchers(objects.filteredSetUsingPredicate(predicate) as! Set<NSManagedObject>, fromCloud: false)
        }
    }
    
    /**
     Notifies updated watchers from local changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyUpdatedWatchers(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        if let objects = info[NSUpdatedObjectsKey] as? NSSet {
            delegateToUpdatedWatchers(objects.filteredSetUsingPredicate(predicate) as! Set<NSManagedObject>, fromCloud: false)
        }
    }
    
    /**
     Notifies deleted watchers from local changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyDeletedWatchers(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        if let objects = info[NSDeletedObjectsKey] as? NSSet {
            delegateToDeletedWatchers(objects.filteredSetUsingPredicate(predicate) as! Set<NSManagedObject>, fromCloud: false)
        }
    }
    
    /**
     Notifies inserted watchers from cloud changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyInsertedWatchersFromCloud(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        if let objectIDs = info[NSInsertedObjectsKey] as? NSSet {
            let objects = NSMutableSet()
            managedObjectContext.performBlockAndWait { [unowned self, unowned objects] in
                (objectIDs.allObjects as! [NSManagedObjectID]).forEach { (objectID: NSManagedObjectID) in
                    objects.addObject(self.managedObjectContext.objectWithID(objectID))
                }
                self.delegateToInsertedWatchers(objects.filteredSetUsingPredicate(predicate) as! Set<NSManagedObject>, fromCloud: true)
            }
        }
    }
    
    /**
     Notifies updated watchers from cloud changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyUpdatedWatchersFromCloud(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        if let objectIDs = info[NSUpdatedObjectsKey] as? NSSet {
            let objects = NSMutableSet()
            managedObjectContext.performBlockAndWait { [unowned self, unowned objects] in
                (objectIDs.allObjects as! [NSManagedObjectID]).forEach { (objectID: NSManagedObjectID) in
                    objects.addObject(self.managedObjectContext.objectWithID(objectID))
                }
                self.delegateToUpdatedWatchers(objects.filteredSetUsingPredicate(predicate) as! Set<NSManagedObject>, fromCloud: true)
            }
        }
    }
    
    /**
     Notifies deleted watchers from cloud changes.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func notifyDeletedWatchersFromCloud(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        if let objectIDs = info[NSDeletedObjectsKey] as? NSSet {
            let objects = NSMutableSet()
            managedObjectContext.performBlockAndWait { [unowned self, unowned objects] in
                (objectIDs.allObjects as! [NSManagedObjectID]).forEach { (objectID: NSManagedObjectID) in
                    objects.addObject(self.managedObjectContext.objectWithID(objectID))
                }
                self.delegateToDeletedWatchers(objects.filteredSetUsingPredicate(predicate) as! Set<NSManagedObject>, fromCloud: true)
            }
        }
    }
    
    /**
     Passes the handle to the inserted notification delegates.
     - Parameter set: A Set of NSManagedObjects to pass.
     */
    private func delegateToInsertedWatchers(set: Set<NSManagedObject>, fromCloud: Bool) {
        set.forEach { [unowned self] (managedObject: NSManagedObject) in
            switch String.fromCString(object_getClassName(managedObject))! {
            case "ManagedEntity_ManagedEntity_":
                self.delegate?.graphDidInsertEntity?(self, entity: Entity(managedNode: managedObject as! ManagedEntity), fromCloud: fromCloud)
                
            case "ManagedEntityGroup_ManagedEntityGroup_":
                let group = managedObject as! ManagedEntityGroup
                let node = group.node
                let name = group.name
                self.delegate?.graphDidAddEntityToGroup?(self, entity: Entity(managedNode: node), group: name, fromCloud: fromCloud)
                
            case "ManagedEntityProperty_ManagedEntityProperty_":
                let property = managedObject as! ManagedEntityProperty
                let node = property.node
                let name = property.name
                let object = property.object
                self.delegate?.graphDidInsertEntityProperty?(self, entity: Entity(managedNode: node), property: name, value: object, fromCloud: fromCloud)
                
            case "ManagedAction_ManagedAction_":
                self.delegate?.graphDidInsertAction?(self, action: Action(managedNode: managedObject as! ManagedAction), fromCloud: fromCloud)
                
            case "ManagedActionGroup_ManagedActionGroup_":
                let group: ManagedActionGroup = managedObject as! ManagedActionGroup
                let node = group.node
                let name = group.name
                self.delegate?.graphDidAddActionToGroup?(self, action: Action(managedNode: node), group: name, fromCloud: fromCloud)
                
            case "ManagedActionProperty_ManagedActionProperty_":
                let property = managedObject as! ManagedActionProperty
                let node = property.node
                let name = property.name
                let object = property.object
                self.delegate?.graphDidInsertActionProperty?(self, action: Action(managedNode: node), property: name, value: object, fromCloud: fromCloud)
                
            case "ManagedRelationship_ManagedRelationship_":
                self.delegate?.graphDidInsertRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship), fromCloud: fromCloud)
                
            case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                let group = managedObject as! ManagedRelationshipGroup
                let node = group.node
                let name = group.name
                self.delegate?.graphDidAddRelationshipToGroup?(self, relationship: Relationship(managedNode: node), group: name, fromCloud: fromCloud)
                
            case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                let property = managedObject as! ManagedRelationshipProperty
                let node = property.node
                let name = property.name
                let object = property.object
                self.delegate?.graphDidInsertRelationshipProperty?(self, relationship: Relationship(managedNode: node), property: name, value: object, fromCloud: fromCloud)
                
            default:
                assert(false, "[Graph Error: Graph observed an object that is invalid.]")
            }
        }
    }
    
    /**
     Passes the handle to the updated notification delegates.
     - Parameter set: A Set of NSManagedObjects to pass.
     */
    private func delegateToUpdatedWatchers(set: Set<NSManagedObject>, fromCloud: Bool) {
        set.forEach { [unowned self] (managedObject: NSManagedObject) in
            switch String.fromCString(object_getClassName(managedObject))! {
            case "ManagedEntityProperty_ManagedEntityProperty_":
                let property = managedObject as! ManagedEntityProperty
                let node = property.node
                let name = property.name
                let object = property.object
                self.delegate?.graphDidUpdateEntityProperty?(self, entity: Entity(managedNode: node), property: name, value: object, fromCloud: fromCloud)
                
            case "ManagedActionProperty_ManagedActionProperty_":
                let property = managedObject as! ManagedActionProperty
                let node = property.node
                let name = property.name
                let object = property.object
                self.delegate?.graphDidUpdateActionProperty?(self, action: Action(managedNode: node), property: name, value: object, fromCloud: fromCloud)
                
            case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                let property = managedObject as! ManagedRelationshipProperty
                let node = property.node
                let name = property.name
                let object = property.object
                self.delegate?.graphDidUpdateRelationshipProperty?(self, relationship: Relationship(managedNode: node), property: name, value: object, fromCloud: fromCloud)
                
            case "ManagedAction_ManagedAction_":
                self.delegate?.graphDidUpdateAction?(self, action: Action(managedNode: managedObject as! ManagedAction), fromCloud: fromCloud)
                
            case "ManagedRelationship_ManagedRelationship_":
                self.delegate?.graphDidUpdateRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship), fromCloud: fromCloud)
                
            default:
                assert(false, "[Graph Error: Graph observed an object that is invalid.]")
            }
        }
    }
    
    /**
     Passes the handle to the deleted notification delegates.
     - Parameter set: A Set of NSManagedObjects to pass.
     */
    private func delegateToDeletedWatchers(set: Set<NSManagedObject>, fromCloud: Bool) {
        set.forEach { [unowned self] (managedObject: NSManagedObject) in
            switch String.fromCString(object_getClassName(managedObject))! {
            case "ManagedEntity_ManagedEntity_":
                self.delegate?.graphWillDeleteEntity?(self, entity: Entity(managedNode: managedObject as! ManagedEntity), fromCloud: fromCloud)
                
            case "ManagedEntityProperty_ManagedEntityProperty_":
                let property = managedObject as! ManagedEntityProperty
                let node = property.node
                let name = property.name
                let object = property.object
                self.delegate?.graphWillDeleteEntityProperty?(self, entity: Entity(managedNode: node), property: name, value: object, fromCloud: fromCloud)
                
            case "ManagedEntityGroup_ManagedEntityGroup_":
                let group = managedObject as! ManagedEntityGroup
                let node = group.node
                let name = group.name
                self.delegate?.graphWillRemoveEntityFromGroup?(self, entity: Entity(managedNode: node), group: name, fromCloud: fromCloud)
                
            case "ManagedAction_ManagedAction_":
                self.delegate?.graphWillDeleteAction?(self, action: Action(managedNode: managedObject as! ManagedAction), fromCloud: fromCloud)
                
            case "ManagedActionProperty_ManagedActionProperty_":
                let property = managedObject as! ManagedActionProperty
                let node = property.node
                let name = property.name
                let object = property.object
                self.delegate?.graphWillDeleteActionProperty?(self, action: Action(managedNode: node), property: name, value: object, fromCloud: fromCloud)
                
            case "ManagedActionGroup_ManagedActionGroup_":
                let group = managedObject as! ManagedActionGroup
                let node = group.node
                let name = group.name
                self.delegate?.graphWillRemoveActionFromGroup?(self, action: Action(managedNode: node), group: name, fromCloud: fromCloud)
                
            case "ManagedRelationship_ManagedRelationship_":
                self.delegate?.graphWillDeleteRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship), fromCloud: fromCloud)
                
            case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                let property = managedObject as! ManagedRelationshipProperty
                let node = property.node
                let name = property.name
                let object = property.object
                self.delegate?.graphWillDeleteRelationshipProperty?(self, relationship: Relationship(managedNode: node), property: name, value: object, fromCloud: fromCloud)
                
            case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                let group = managedObject as! ManagedRelationshipGroup
                let node = group.node
                let name = group.name
                self.delegate?.graphWillRemoveRelationshipFromGroup?(self, relationship: Relationship(managedNode: node), group: name, fromCloud: fromCloud)
                
            default:
                assert(false, "[Graph Error: Graph observed an object that is invalid.]")
            }
        }
    }
    
    /**
     Watch for an Entity type.
     - Parameter type: An Entity type to watch for.
    */
    private func watch(Entity type: String) {
        addWatcher(
            "type",
            index: ModelIdentifier.entityIndexName,
            value: type,
            entityDescriptionName: ModelIdentifier.entityDescriptionName,
            managedObjectClassName: ModelIdentifier.entityObjectClassName)
    }
    
    /**
     Watch for an Entity group.
     - Parameter name: An Entity group name to watch for.
     */
    private func watch(EntityGroup name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.entityGroupIndexName,
            value: name,
            entityDescriptionName: ModelIdentifier.entityGroupDescriptionName,
            managedObjectClassName: ModelIdentifier.entityGroupObjectClassName)
    }
    
    /**
     Watch for an Entity property.
     - Parameter name: An Entity property to watch for.
     */
    private func watch(EntityProperty name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.entityPropertyIndexName,
            value: name,
            entityDescriptionName: ModelIdentifier.entityPropertyDescriptionName,
            managedObjectClassName: ModelIdentifier.entityPropertyObjectClassName)
    }
    
    /**
     Watch for a Relationship type.
     - Parameter type: A Relationship type to watch for.
     */
    private func watch(Relationship type: String) {
        addWatcher(
            "type",
            index: ModelIdentifier.relationshipIndexName,
            value: type,
            entityDescriptionName: ModelIdentifier.relationshipDescriptionName,
            managedObjectClassName: ModelIdentifier.relationshipObjectClassName)
    }
    
    /**
     Watch for a Relationship group.
     - Parameter name: A Relationship group name to watch for.
     */
    private func watch(RelationshipGroup name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.relationshipGroupIndexName,
            value: name,
            entityDescriptionName: ModelIdentifier.relationshipGroupDescriptionName,
            managedObjectClassName: ModelIdentifier.relationshipGroupObjectClassName)
    }
    
    /**
     Watch for a Relationship property.
     - Parameter name: An Entity property to watch for.
     */
    private func watch(RelationshipProperty name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.relationshipPropertyIndexName,
            value: name,
            entityDescriptionName: ModelIdentifier.relationshipPropertyDescriptionName,
            managedObjectClassName: ModelIdentifier.relationshipPropertyObjectClassName)
    }
    
    /**
     Watch for an Action type.
     - Parameter type: An Action type to watch for.
     */
    private func watch(Action type: String) {
        addWatcher(
            "type",
            index: ModelIdentifier.actionIndexName,
            value: type,
            entityDescriptionName: ModelIdentifier.actionDescriptionName,
            managedObjectClassName: ModelIdentifier.actionObjectClassName)
    }
    
    /**
     Watch for an Action group.
     - Parameter name: An Action group name to watch for.
     */
    private func watch(ActionGroup name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.actionGroupIndexName,
            value: name,
            entityDescriptionName: ModelIdentifier.actionGroupDescriptionName,
            managedObjectClassName: ModelIdentifier.actionGroupObjectClassName)
    }
    
    /**
     Watch for an Action property.
     - Parameter name: An Action property to watch for.
     */
    private func watch(ActionProperty name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.actionPropertyIndexName,
            value: name,
            entityDescriptionName: ModelIdentifier.actionPropertyDescriptionName,
            managedObjectClassName: ModelIdentifier.actionPropertyObjectClassName)
    }
    
    /**
     Checks if the Watch API is watching a certain facet.
     - Parameter key: A key for top level organization.
     - Parameter index: A Model index.
     - Returns: A boolean for the result, true if watching, false
     otherwise.
    */
    private func isWatching(key key: String, index: String) -> Bool {
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
    private func addWatcher(key: String, index: String, value: String, entityDescriptionName: String, managedObjectClassName: String) {
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
    private func addPredicateToObserve(entityDescription: NSEntityDescription, predicate: NSPredicate) {
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
        
        guard let poc = moc.parentContext else {
            return
        }
        
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: #selector(notifyInsertedWatchers(_:)), name: NSManagedObjectContextDidSaveNotification, object: poc)
        defaultCenter.addObserver(self, selector: #selector(notifyUpdatedWatchers(_:)), name: NSManagedObjectContextDidSaveNotification, object: poc)
        defaultCenter.addObserver(self, selector: #selector(notifyDeletedWatchers(_:)), name: NSManagedObjectContextDidSaveNotification, object: moc)
    }
}

