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

import CoreData

@objc(GraphDelegate)
public protocol GraphDelegate {
    optional func graphDidInsertEntity(graph: Graph, entity: Entity)
    optional func graphDidDeleteEntity(graph: Graph, entity: Entity)
    optional func graphDidInsertEntityGroup(graph: Graph, entity: Entity, group: String)
    optional func graphDidDeleteEntityGroup(graph: Graph, entity: Entity, group: String)
    optional func graphDidInsertEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject)
    optional func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject)
    optional func graphDidDeleteEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject)
    
    optional func graphDidInsertAction(graph: Graph, action: Action)
    optional func graphDidUpdateAction(graph: Graph, action: Action)
    optional func graphDidDeleteAction(graph: Graph, action: Action)
    optional func graphDidInsertActionGroup(graph: Graph, action: Action, group: String)
    optional func graphDidDeleteActionGroup(graph: Graph, action: Action, group: String)
    optional func graphDidInsertActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
    optional func graphDidUpdateActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
    optional func graphDidDeleteActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
    
    optional func graphDidInsertRelationship(graph: Graph, relationship: Relationship)
    optional func graphDidDeleteRelationship(graph: Graph, relationship: Relationship)
    optional func graphDidInsertRelationshipGroup(graph: Graph, relationship: Relationship, group: String)
    optional func graphDidDeleteRelationshipGroup(graph: Graph, relationship: Relationship, group: String)
    optional func graphDidInsertRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject)
    optional func graphDidUpdateRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject)
    optional func graphDidDeleteRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject)
}

/// Graph Watch API.
public extension Graph {
    /**
     Watches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property typles.
     - Returns: An Array of Entities.
     */
    public func watchForEntity(types types: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) {
        types?.forEach { [weak self] (type: String) in
            self?.watch(Entity: type)
        }
        
        groups?.forEach { [weak self] (group: String) in
            self?.watch(EntityGroup: group)
        }
        
        properties?.forEach { [weak self] (property: String) in
            self?.watch(EntityProperty: property)
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
        types?.forEach { [weak self] (type: String) in
            self?.watch(Relationship: type)
        }
        
        groups?.forEach { [weak self] (group: String) in
            self?.watch(RelationshipGroup: group)
        }
        
        properties?.forEach { [weak self] (property: String) in
            self?.watch(RelationshipProperty: property)
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
        types?.forEach { [weak self] (type: String) in
            self?.watch(Action: type)
        }
        
        groups?.forEach { [weak self] (group: String) in
            self?.watch(ActionGroup: group)
        }
        
        properties?.forEach { [weak self] (property: String) in
            self?.watch(ActionProperty: property)
        }
    }
    
    /**
     Watch for an Entity type.
     - Parameter type: An Entity type to watch for.
    */
    internal func watch(Entity type: String) {
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
    internal func watch(EntityGroup name: String) {
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
    internal func watch(EntityProperty name: String) {
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
    internal func watch(Relationship type: String) {
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
    internal func watch(RelationshipGroup name: String) {
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
    internal func watch(RelationshipProperty name: String) {
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
    internal func watch(Action type: String) {
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
    internal func watch(ActionGroup name: String) {
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
    internal func watch(ActionProperty name: String) {
        addWatcher(
            "name",
            index: ModelIdentifier.actionPropertyIndexName,
            value: name,
            entityDescriptionName: ModelIdentifier.actionPropertyDescriptionName,
            managedObjectClassName: ModelIdentifier.actionPropertyObjectClassName)
    }
    
    /**
     Adds a predicate to watch for.
     - Parameter entityDescription: An NSEntityDescription to watch.
     - Parameter predicate: An NSPredicate.
    */
    internal func addPredicateToObserve(entityDescription: NSEntityDescription, predicate: NSPredicate) {
        let entityPredicate = NSPredicate(format: "entity.name == %@", entityDescription.name! as NSString)
        let predicates = [entityPredicate, predicate]
        let finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        watchPredicate = nil == watchPredicate ? finalPredicate : NSCompoundPredicate(orPredicateWithSubpredicates: [watchPredicate!, finalPredicate])
    }
    
    /**
     Checks if the Watch API is watching a certain facet.
     - Parameter key: A key for top level organization.
     - Parameter index: A Model index.
     - Returns: A boolean for the result, true if watching, false
     otherwise.
    */
    internal func isWatching(key: String, index: String) -> Bool {
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
    internal func addWatcher(key: String, index: String, value: String, entityDescriptionName: String, managedObjectClassName: String) {
        guard !isWatching(key, index: index) else {
            return
        }
        
        let entityDescription = NSEntityDescription()
        entityDescription.name = entityDescriptionName
        entityDescription.managedObjectClassName = managedObjectClassName
        
        let predicate = NSPredicate(format: "%K LIKE %@", key as NSString, value as NSString)
        addPredicateToObserve(entityDescription, predicate: predicate)
        prepareForObservation()
    }
    
    /**
     Handler for save notifications. Context merges are made within this handler.
     - Parameter notification: NSNotification reference.
     */
    internal func handleContextDidSave(notification: NSNotification) {
        if NSThread.isMainThread() {
            notifyWatchers(notification)
        } else {
            dispatch_sync(dispatch_get_main_queue()) { [weak self] in
                self?.notifyWatchers(notification)
            }
        }
    }
    
    /// Prepares the instance for save notifications.   
    internal func prepareForObservation() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: context.parentContext!.parentContext!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleContextDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: context.parentContext!.parentContext!)
    }
    
    /**
     Notifies watchers of changes within the ManagedObjectContext.
     - Parameter notification: An NSNotification passed from the context
     save operation.
     */
    internal func notifyWatchers(notification: NSNotification) {
        guard let prediate = watchPredicate else {
            return
        }
        
        let userInfo: [NSObject : AnyObject]? = notification.userInfo
        
        if let insertedSet = userInfo?[NSInsertedObjectsKey] as? NSSet {
            let	inserted = insertedSet.mutableCopy() as! NSMutableSet
            
            inserted.filterUsingPredicate(prediate)
            
            if 0 < inserted.count {
                for node: NSManagedObject in inserted.allObjects as! [NSManagedObject] {
                    switch String.fromCString(object_getClassName(node))! {
                    case "ManagedEntity_ManagedEntity_":
                        let n = Entity(managedNode: node as! ManagedEntity)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidInsertEntity?(self, entity: n)
                    
                    case "ManagedEntityGroup_ManagedEntityGroup_":
                        let group = node as! ManagedEntityGroup
                        let n = Entity(managedNode: group.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidInsertEntityGroup?(self, entity: n, group: group.name)
                    
                    case "ManagedEntityProperty_ManagedEntityProperty_":
                        let property = node as! ManagedEntityProperty
                        let n = Entity(managedNode: property.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidInsertEntityProperty?(self, entity: n, property: property.name, value: property.object)
                    
                    case "ManagedAction_ManagedAction_":
                        let n = Action(managedNode: node as! ManagedAction)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidInsertAction?(self, action: n)
                        
                    case "ManagedActionGroup_ManagedActionGroup_":
                        let group: ManagedActionGroup = node as! ManagedActionGroup
                        let n = Action(managedNode: group.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidInsertActionGroup?(self, action: n, group: group.name)
                    
                    case "ManagedActionProperty_ManagedActionProperty_":
                        let property = node as! ManagedActionProperty
                        let n = Action(managedNode: property.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidInsertActionProperty?(self, action: n, property: property.name, value: property.object)
                    
                    case "ManagedRelationship_ManagedRelationship_":
                        let n = Relationship(managedNode: node as! ManagedRelationship)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidInsertRelationship?(self, relationship: n)
                    
                    case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                        let group = node as! ManagedRelationshipGroup
                        let n = Relationship(managedNode: group.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidInsertRelationshipGroup?(self, relationship: n, group: group.name)
                    
                    case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                        let property = node as! ManagedRelationshipProperty
                        let n = Relationship(managedNode: property.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidInsertRelationshipProperty?(self, relationship: n, property: property.name, value: property.object)
                    
                    default:
                        assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                    }
                }
            }
        }
        
        if let updatedSet = userInfo?[NSUpdatedObjectsKey] as? NSSet {
            let	updated = updatedSet.mutableCopy() as! NSMutableSet
            
            updated.filterUsingPredicate(prediate)
            
            if 0 < updated.count {
                for node: NSManagedObject in updated.allObjects as! [NSManagedObject] {
                    switch String.fromCString(object_getClassName(node))! {
                    case "ManagedEntityProperty_ManagedEntityProperty_":
                        let property = node as! ManagedEntityProperty
                        let n = Entity(managedNode: property.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidUpdateEntityProperty?(self, entity: n, property: property.name, value: property.object)
                        
                    case "ManagedActionProperty_ManagedActionProperty_":
                        let property = node as! ManagedActionProperty
                        let n = Action(managedNode: property.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidUpdateActionProperty?(self, action: n, property: property.name, value: property.object)
                    
                    case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                        let property = node as! ManagedRelationshipProperty
                        let n = Relationship(managedNode: property.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidUpdateRelationshipProperty?(self, relationship: n, property: property.name, value: property.object)
                    
                    case "ManagedAction_ManagedAction_":
                        let n = Action(managedNode: node as! ManagedAction)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidUpdateAction?(self, action: n)
                    default:
                        assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                    }
                }
            }
        }
        
        if let deletedSet = userInfo?[NSDeletedObjectsKey] as? NSSet {
            let	deleted = deletedSet.mutableCopy() as! NSMutableSet
            
            deleted.filterUsingPredicate(prediate)
            
            if 0 < deleted.count {
                for node: NSManagedObject in deleted.allObjects as! [NSManagedObject] {
                    switch String.fromCString(object_getClassName(node))! {
                    case "ManagedEntity_ManagedEntity_":
                        let n = Entity(managedNode: node as! ManagedEntity)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidDeleteEntity?(self, entity: n)
                        
                    case "ManagedEntityProperty_ManagedEntityProperty_":
                        let property = node as! ManagedEntityProperty
                        let n = Entity(managedNode: property.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidDeleteEntityProperty?(self, entity: n, property: property.name, value: property.object)
                        
                    case "ManagedEntityGroup_ManagedEntityGroup_":
                        let group = node as! ManagedEntityGroup
                        let n = Entity(managedNode: group.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidDeleteEntityGroup?(self, entity: n, group: group.name)
                    
                    case "ManagedAction_ManagedAction_":
                        let n = Action(managedNode: node as! ManagedAction)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidDeleteAction?(self, action: n)
                    
                    case "ManagedActionProperty_ManagedActionProperty_":
                        let property = node as! ManagedActionProperty
                        let n = Action(managedNode: property.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidDeleteActionProperty?(self, action: n, property: property.name, value: property.object)
                    
                    case "ManagedActionGroup_ManagedActionGroup_":
                        let group = node as! ManagedActionGroup
                        let n = Action(managedNode: group.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidDeleteActionGroup?(self, action: n, group: group.name)
                    
                    case "ManagedRelationship_ManagedRelationship_":
                        let n = Relationship(managedNode: node as! ManagedRelationship)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidDeleteRelationship?(self, relationship: n)
                    
                    case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                        let property = node as! ManagedRelationshipProperty
                        let n = Relationship(managedNode: property.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidDeleteRelationshipProperty?(self, relationship: n, property: property.name, value: property.object)
                    
                    case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                        let group = node as! ManagedRelationshipGroup
                        let n = Relationship(managedNode: group.node)
                        n.node.managedNode.context = context
                        
                        delegate?.graphDidDeleteRelationshipGroup?(self, relationship: n, group: group.name)
                    
                    default:
                        assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                    }
                }
            }
        }
    }
}
