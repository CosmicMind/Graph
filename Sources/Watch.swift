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
        if let v = types {
            for x in v {
                watch(Relationship: x)
            }
        }
        
        if let v = groups {
            for x in v {
                watch(RelationshipGroup: x)
            }
        }
        
        if let v = properties {
            for x in v {
                watch(RelationshipProperty: x)
            }
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
        if let v = types {
            for x in v {
                watch(Action: x)
            }
        }
        
        if let v = groups {
            for x in v {
                watch(ActionGroup: x)
            }
        }
        
        if let v = properties {
            for x in v {
                watch(ActionProperty: x)
            }
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
        print(watchPredicate)
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
        print(predicate)
        addPredicateToObserve(entityDescription, predicate: predicate)
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
        
        print("Inserted", userInfo)
        
        if let insertedSet = userInfo?[NSInsertedObjectsKey] as? NSSet {
            let	inserted = insertedSet.mutableCopy() as! NSMutableSet
            
            inserted.filterUsingPredicate(prediate)
            
            if 0 < inserted.count {
                for node: NSManagedObject in inserted.allObjects as! [NSManagedObject] {
                    switch String.fromCString(object_getClassName(node))! {
                    case "ManagedEntity_ManagedEntity_":
                        delegate?.graphDidInsertEntity?(self, entity: Entity(managedNode: node as! ManagedEntity))
                    case "ManagedEntityGroup_ManagedEntityGroup_":
                        let group: ManagedEntityGroup = node as! ManagedEntityGroup
                        delegate?.graphDidInsertEntityGroup?(self, entity: Entity(managedNode: group.node), group: group.name)
                    case "ManagedEntityProperty_ManagedEntityProperty_":
                        let property: ManagedEntityProperty = node as! ManagedEntityProperty
                        delegate?.graphDidInsertEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object)
                    case "ManagedAction_ManagedAction_":
                        delegate?.graphDidInsertAction?(self, action: Action(managedNode: node as! ManagedAction))
                    case "ManagedActionGroup_ManagedActionGroup_":
                        let group: ManagedActionGroup = node as! ManagedActionGroup
                        delegate?.graphDidInsertActionGroup?(self, action: Action(managedNode: group.node), group: group.name)
                    case "ManagedActionProperty_ManagedActionProperty_":
                        let property: ManagedActionProperty = node as! ManagedActionProperty
                        delegate?.graphDidInsertActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object)
                    case "ManagedRelationship_ManagedRelationship_":
                        delegate?.graphDidInsertRelationship?(self, relationship: Relationship(managedNode: node as! ManagedRelationship))
                    case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                        let group: ManagedRelationshipGroup = node as! ManagedRelationshipGroup
                        delegate?.graphDidInsertRelationshipGroup?(self, relationship: Relationship(managedNode: group.node), group: group.name)
                    case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                        let property: ManagedRelationshipProperty = node as! ManagedRelationshipProperty
                        delegate?.graphDidInsertRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object)
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
                        let property: ManagedEntityProperty = node as! ManagedEntityProperty
                        delegate?.graphDidUpdateEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object)
                    case "ManagedActionProperty_ManagedActionProperty_":
                        let property: ManagedActionProperty = node as! ManagedActionProperty
                        delegate?.graphDidUpdateActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object)
                    case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                        let property: ManagedRelationshipProperty = node as! ManagedRelationshipProperty
                        delegate?.graphDidUpdateRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object)
                    case "ManagedAction_ManagedAction_":
                        delegate?.graphDidUpdateAction?(self, action: Action(managedNode: node as! ManagedAction))
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
                        delegate?.graphDidDeleteEntity?(self, entity: Entity(managedNode: node as! ManagedEntity))
                    case "ManagedEntityProperty_ManagedEntityProperty_":
                        let property: ManagedEntityProperty = node as! ManagedEntityProperty
                        delegate?.graphDidDeleteEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object)
                    case "ManagedEntityGroup_ManagedEntityGroup_":
                        let group: ManagedEntityGroup = node as! ManagedEntityGroup
                        delegate?.graphDidDeleteEntityGroup?(self, entity: Entity(managedNode: group.node), group: group.name)
                    case "ManagedAction_ManagedAction_":
                        delegate?.graphDidDeleteAction?(self, action: Action(managedNode: node as! ManagedAction))
                    case "ManagedActionProperty_ManagedActionProperty_":
                        let property: ManagedActionProperty = node as! ManagedActionProperty
                        delegate?.graphDidDeleteActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object)
                    case "ManagedActionGroup_ManagedActionGroup_":
                        let group: ManagedActionGroup = node as! ManagedActionGroup
                        delegate?.graphDidDeleteActionGroup?(self, action: Action(managedNode: group.node), group: group.name)
                    case "ManagedRelationship_ManagedRelationship_":
                        delegate?.graphDidDeleteRelationship?(self, relationship: Relationship(managedNode: node as! ManagedRelationship))
                    case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                        let property: ManagedRelationshipProperty = node as! ManagedRelationshipProperty
                        delegate?.graphDidDeleteRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object)
                    case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                        let group: ManagedRelationshipGroup = node as! ManagedRelationshipGroup
                        delegate?.graphDidDeleteRelationshipGroup?(self, relationship: Relationship(managedNode: group.node), group: group.name)
                    default:
                        assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                    }
                }
            }
        }
    }
}
