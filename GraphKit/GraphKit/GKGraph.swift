/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*
* GKGraph
*
* Manages Nodes in the persistent layer, as well as, offers watchers to monitor
* changes in the persistent layer.
*/

import CoreData

struct GKGraphUtility {
    static let storeName: String = "GraphKit-0-1-0.sqlite"

    static let entityIndexName: String = "GKManagedEntity"
    static let entityDescriptionName: String = "GKManagedEntity"
    static let entityObjectClassName: String = "GKManagedEntity"
    static let entityGroupIndexName: String = "GKEntityGroup"
    static let entityGroupObjectClassName: String = "GKEntityGroup"
    static let entityGroupDescriptionName: String = "GKEntityGroup"
    static let entityPropertyIndexName: String = "GKEntityProperty"
    static let entityPropertyObjectClassName: String = "GKEntityProperty"
    static let entityPropertyDescriptionName: String = "GKEntityProperty"

    static let actionIndexName: String = "GKManagedAction"
    static let actionDescriptionName: String = "GKManagedAction"
    static let actionObjectClassName: String = "GKManagedAction"
    static let actionGroupIndexName: String = "GKActionGroup"
    static let actionGroupObjectClassName: String = "GKActionGroup"
    static let actionGroupDescriptionName: String = "GKActionGroup"
    static let actionPropertyIndexName: String = "GKActionProperty"
    static let actionPropertyObjectClassName: String = "GKActionProperty"
    static let actionPropertyDescriptionName: String = "GKActionProperty"

    static let bondIndexName: String = "GKManagedBond"
    static let bondDescriptionName: String = "GKManagedBond"
    static let bondObjectClassName: String = "GKManagedBond"
    static let bondGroupIndexName: String = "GKBondGroup"
    static let bondGroupObjectClassName: String = "GKBondGroup"
    static let bondGroupDescriptionName: String = "GKBondGroup"
    static let bondPropertyIndexName: String = "GKBondProperty"
    static let bondPropertyObjectClassName: String = "GKBondProperty"
    static let bondPropertyDescriptionName: String = "GKBondProperty"
}

@objc(GKGraphDelegate)
public protocol GKGraphDelegate {
    optional func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!)
    optional func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!)
    optional func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!, group: String!)
    optional func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!, group: String!)
    optional func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!, property: String!, value: AnyObject!)
    optional func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!, property: String!, value: AnyObject!)
    optional func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!, property: String!, value: AnyObject!)

    optional func graph(graph: GKGraph!, didInsertAction action: GKAction!)
    optional func graph(graph: GKGraph!, didDeleteAction action: GKAction!)
    optional func graph(graph: GKGraph!, didInsertAction action: GKAction!, group: String!)
    optional func graph(graph: GKGraph!, didDeleteAction action: GKAction!, group: String!)
    optional func graph(graph: GKGraph!, didInsertAction entity: GKAction!, property: String!, value: AnyObject!)
    optional func graph(graph: GKGraph!, didUpdateAction entity: GKAction!, property: String!, value: AnyObject!)
    optional func graph(graph: GKGraph!, didDeleteAction entity: GKAction!, property: String!, value: AnyObject!)

    optional func graph(graph: GKGraph!, didInsertBond bond: GKBond!)
    optional func graph(graph: GKGraph!, didDeleteBond bond: GKBond!)
    optional func graph(graph: GKGraph!, didInsertBond bond: GKBond!, group: String!)
    optional func graph(graph: GKGraph!, didDeleteBond bond: GKBond!, group: String!)
    optional func graph(graph: GKGraph!, didInsertBond entity: GKBond!, property: String!, value: AnyObject!)
    optional func graph(graph: GKGraph!, didUpdateBond entity: GKBond!, property: String!, value: AnyObject!)
    optional func graph(graph: GKGraph!, didDeleteBond entity: GKBond!, property: String!, value: AnyObject!)
}

@objc(GKGraph)
public class GKGraph: NSObject {
    var watching: Dictionary<String, Array<String>>
    var masterPredicate: NSPredicate?
    var batchSize: Int = 20

    public weak var delegate: GKGraphDelegate?

    /**
    * init
    * Initializer for the Object.
    */
    override public init() {
        watching = Dictionary<String, Array<String>>()
        super.init()
    }

    /**
    * deinit
    * Deinitializes the Object, mainly removing itself as an observer for NSNotifications.
    */
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /**
    * save
    * Updates the persistent layer by processing all the changes in the Graph.
    * @param        completion: (success: Bool, error: NSError?) -> ())
    */
    public func save(completion: (success: Bool, error: NSError?) -> ()) {
        managedObjectContext.performBlockAndWait {
            if !self.managedObjectContext.hasChanges {
                completion(success: true, error: nil)
                return
            }

            let (failed, error): (Bool, NSError?) = self.validateConstraints()
            if failed {
                completion(success: failed, error: error)
                println("[GraphKit Error: Constraints are not satisfied.]")
                return
            }

            var saveError: NSError?
            completion(success: self.managedObjectContext.save(&saveError), error: error)
            assert(nil == error, "[GraphKit Error: Saving to internal context.]")
        }
    }

    /**
    * watch(Entity)
    * Attaches the Graph instance to NotificationCenter in order to observe changes for an Entity with the spcified type.
    * @param        type: String!
    */
    public func watch(Entity type: String!) {
        addWatcher("type", value: type, index: GKGraphUtility.entityIndexName, entityDescriptionName: GKGraphUtility.entityDescriptionName, managedObjectClassName: GKGraphUtility.entityObjectClassName)
    }

    /**
    * watch(EntityGroup)
    * Attaches the Graph instance to NotificationCenter in order to observe changes for an Entity with the specified group name.
    * @param        name: String!
    */
    public func watch(EntityGroup name: String!) {
        addWatcher("name", value: name, index: GKGraphUtility.entityGroupIndexName, entityDescriptionName: GKGraphUtility.entityGroupDescriptionName, managedObjectClassName: GKGraphUtility.entityGroupObjectClassName)
    }

    /**
    * watch(EntityProperty)
    * Attaches the Graph instance to NotificationCenter in order to observe changes for an Entity with the specified property name.
    * @param        name: String!
    */
    public func watch(EntityProperty name: String!) {
        addWatcher("name", value: name, index: GKGraphUtility.entityPropertyIndexName, entityDescriptionName: GKGraphUtility.entityPropertyDescriptionName, managedObjectClassName: GKGraphUtility.entityPropertyObjectClassName)
    }

    /**
    * watch(Action)
    * Attaches the Graph instance to NotificationCenter in order to Observe changes for an Action with the spcified type.
    */
    public func watch(Action type: String!) {
        addWatcher("type", value: type, index: GKGraphUtility.actionIndexName, entityDescriptionName: GKGraphUtility.actionDescriptionName, managedObjectClassName: GKGraphUtility.actionObjectClassName)
    }

    /**
    * watch(ActionGroup)
    * Attaches the Graph instance to NotificationCenter in order to observe changes for an Action with the specified group name.
    * @param        name: String!
    */
    public func watch(ActionGroup name: String!) {
        addWatcher("name", value: name, index: GKGraphUtility.actionGroupIndexName, entityDescriptionName: GKGraphUtility.actionGroupDescriptionName, managedObjectClassName: GKGraphUtility.actionGroupObjectClassName)
    }

    /**
    * watch(ActionProperty)
    * Attaches the Graph instance to NotificationCenter in order to observe changes for an Action with the specified property name.
    * @param        name: String!
    */
    public func watch(ActionProperty name: String!) {
        addWatcher("name", value: name, index: GKGraphUtility.actionPropertyIndexName, entityDescriptionName: GKGraphUtility.actionPropertyDescriptionName, managedObjectClassName: GKGraphUtility.actionPropertyObjectClassName)
    }

    /**
    * watch(Bond)
    * Attaches the Graph instance to NotificationCenter in order to Observe changes for an Bond with the spcified type.
    */
    public func watch(Bond type: String!) {
        addWatcher("type", value: type, index: GKGraphUtility.bondIndexName, entityDescriptionName: GKGraphUtility.bondDescriptionName, managedObjectClassName: GKGraphUtility.bondObjectClassName)
    }

    /**
    * watch(BondGroup)
    * Attaches the Graph instance to NotificationCenter in order to observe changes for an Bond with the specified group name.
    * @param        name: String!
    */
    public func watch(BondGroup name: String!) {
        addWatcher("name", value: name, index: GKGraphUtility.bondGroupIndexName, entityDescriptionName: GKGraphUtility.bondGroupDescriptionName, managedObjectClassName: GKGraphUtility.bondGroupObjectClassName)
    }

    /**
    * watch(BondProperty)
    * Attaches the Graph instance to NotificationCenter in order to observe changes for an Bond with the specified property name.
    * @param        name: String!
    */
    public func watch(BondProperty name: String!) {
        addWatcher("name", value: name, index: GKGraphUtility.bondPropertyIndexName, entityDescriptionName: GKGraphUtility.bondPropertyDescriptionName, managedObjectClassName: GKGraphUtility.bondPropertyObjectClassName)
    }

    /**
    * searchForEntityGroups
    * Retrieves all the unique Group Names for Entity Nodes.
    * @return       Array<String, int>
    */
    public func searchForEntityGroups() -> Dictionary<String, Array<GKEntity>> {
        let entries: Array<AnyObject> = search(GKGraphUtility.entityGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", "*" as NSString));
        var nodes: Dictionary<String, Array<GKEntity>> = Dictionary<String, Array<GKEntity>>()
        for group: GKEntityGroup in entries as Array<GKEntityGroup> {
            if (nil == nodes[group.name]) {
                nodes[group.name] = Array<GKEntity>(arrayLiteral: GKEntity(entity: group.node as GKManagedEntity))
            } else {
				nodes[group.name]!.append(GKEntity(entity: group.node as GKManagedEntity))
            }
        }
        return nodes
    }

    /**
    * search(Entity)
    * Searches the Graph for Entity Objects with the following type LIKE ?.
    * @param        type: String!
    * @return       Array<GKEntity>!
    */
    public func search(Entity type: String!) -> Array<GKEntity>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.entityDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type as NSString));
        var nodes: Array<GKEntity> = Array<GKEntity>()
        for entity: GKManagedEntity in entries as Array<GKManagedEntity> {
            nodes.append(GKEntity(entity: entity))
        }
        return nodes
    }

    /**
    * search(EntityGroup)
    * Searches the Graph for Entity Group Objects with the following name LIKE ?.
    * @param        name: String!
    * @return       Array<GKEntity>!
    */
    public func search(EntityGroup name: String!) -> Array<GKEntity>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.entityGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString));
        var nodes: Array<GKEntity> = Array<GKEntity>()
        for group: GKEntityGroup in entries as Array<GKEntityGroup> {
            nodes.append(GKEntity(entity: group.node as GKManagedEntity))
        }
        return nodes
    }

    /**
    * search(EntityProperty)
    * Searches the Graph for Entity Property Objects with the following name LIKE ?.
    * @param        name: String!
    * @return       Array<GKEntity>!
    */
    public func search(EntityProperty name: String!) -> Array<GKEntity>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString));
        var nodes: Array<GKEntity> = Array<GKEntity>()
        for property: GKEntityProperty in entries as Array<GKEntityProperty> {
            nodes.append(GKEntity(entity: property.node as GKManagedEntity))
        }
        return nodes
    }

    /**
    * search(EntityProperty)
    * Searches the Graph for Entity Property Objects with the following name == ? and value == ?.
    * @param        name: String!
    * @param        value: String!
    * @return       Array<GKEntity>!
    */
    public func search(EntityProperty name: String!, value: String!) -> Array<GKEntity>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSString));
        var nodes: Array<GKEntity> = Array<GKEntity>()
        for property: GKEntityProperty in entries as Array<GKEntityProperty> {
            nodes.append(GKEntity(entity: property.node as GKManagedEntity))
        }
        return nodes
    }

    /**
    * search(EntityProperty)
    * Searches the Graph for Entity Property Objects with the following name == ? and value == ?.
    * @param        name: String!
    * @param        value: String!
    * @return       Array<GKEntity>!
    */
    public func search(EntityProperty name: String!, value: Int!) -> Array<GKEntity>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSNumber));
        var nodes: Array<GKEntity> = Array<GKEntity>()
        for property: GKEntityProperty in entries as Array<GKEntityProperty> {
            nodes.append(GKEntity(entity: property.node as GKManagedEntity))
        }
        return nodes
    }

    /**
    * search(Action)
    * Searches the Graph for Action Objects with the following type LIKE ?.
    * @param        type: String!
    * @return       Array<GKAction>!
    */
    public func search(Action type: String!) -> Array<GKAction>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.actionDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type as NSString));
        var nodes: Array<GKAction> = Array<GKAction>()
        for action: GKManagedAction in entries as Array<GKManagedAction> {
            nodes.append(GKAction(action: action))
        }
        return nodes
    }

    /**
    * search(ActionGroup)
    * Searches the Graph for Action Group Objects with the following name LIKE ?.
    * @param        name: String!
    * @return       Array<GKAction>!
    */
    public func search(ActionGroup name: String!) -> Array<GKAction>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.actionGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString));
        var nodes: Array<GKAction> = Array<GKAction>()
        for group: GKActionGroup in entries as Array<GKActionGroup> {
            nodes.append(GKAction(action: group.node as GKManagedAction))
        }
        return nodes
    }

    /**
    * search(ActionProperty)
    * Searches the Graph for Action Property Objects with the following name LIKE ?.
    * @param        name: String!
    * @return       Array<GKAction>!
    */
    public func search(ActionProperty name: String!) -> Array<GKAction>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString));
        var nodes: Array<GKAction> = Array<GKAction>()
        for property: GKActionProperty in entries as Array<GKActionProperty> {
            nodes.append(GKAction(action: property.node as GKManagedAction))
        }
        return nodes
    }

    /**
    * search(ActionProperty)
    * Searches the Graph for Action Property Objects with the following name == ? and value == ?.
    * @param        name: String!
    * @param        value: String!
    * @return       Array<GKAction>!
    */
    public func search(ActionProperty name: String!, value: String!) -> Array<GKAction>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSString));
        var nodes: Array<GKAction> = Array<GKAction>()
        for property: GKActionProperty in entries as Array<GKActionProperty> {
            nodes.append(GKAction(action: property.node as GKManagedAction))
        }
        return nodes
    }

    /**
    * search(ActionProperty)
    * Searches the Graph for Action Property Objects with the following name == ? and value == ?.
    * @param        name: String!
    * @param        value: String!
    * @return       Array<GKAction>!
    */
    public func search(ActionProperty name: String!, value: Int!) -> Array<GKAction>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSNumber));
        var nodes: Array<GKAction> = Array<GKAction>()
        for property: GKActionProperty in entries as Array<GKActionProperty> {
            nodes.append(GKAction(action: property.node as GKManagedAction))
        }
        return nodes
    }

    /**
    * search(Bond)
    * Searches the Graph for Bond Objects with the following type LIKE ?.
    * @param        type: String!
    * @return       Array<GKBond>!
    */
    public func search(Bond type: String!) -> Array<GKBond>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.bondDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type as NSString));
        var nodes: Array<GKBond> = Array<GKBond>()
        for bond: GKManagedBond in entries as Array<GKManagedBond> {
            nodes.append(GKBond(bond: bond))
        }
        return nodes
    }

    /**
    * search(BondGroup)
    * Searches the Graph for Bond Group Objects with the following name LIKE ?.
    * @param        name: String!
    * @return       Array<GKBond>!
    */
    public func search(BondGroup name: String!) -> Array<GKBond>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.bondGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString));
        var nodes: Array<GKBond> = Array<GKBond>()
        for group: GKBondGroup in entries as Array<GKBondGroup> {
            nodes.append(GKBond(bond: group.node as GKManagedBond))
        }
        return nodes
    }

    /**
    * search(BondProperty)
    * Searches the Graph for Bond Property Objects with the following name LIKE ?.
    * @param        name: String!
    * @return       Array<GKBond>!
    */
    public func search(BondProperty name: String!) -> Array<GKBond>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString));
        var nodes: Array<GKBond> = Array<GKBond>()
        for property: GKBondProperty in entries as Array<GKBondProperty> {
            nodes.append(GKBond(bond: property.node as GKManagedBond))
        }
        return nodes
    }

    /**
    * search(BondProperty)
    * Searches the Graph for Bond Property Objects with the following name == ? and value == ?.
    * @param        name: String!
    * @param        value: String!
    * @return       Array<GKBond>!
    */
    public func search(BondProperty name: String!, value: String!) -> Array<GKBond>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSString));
        var nodes: Array<GKBond> = Array<GKBond>()
        for property: GKBondProperty in entries as Array<GKBondProperty> {
            nodes.append(GKBond(bond: property.node as GKManagedBond))
        }
        return nodes
    }

    /**
    * search(BondProperty)
    * Searches the Graph for Bond Property Objects with the following name == ? and value == ?.
    * @param        name: String!
    * @param        value: String!
    * @return       Array<GKBond>!
    */
    public func search(BondProperty name: String!, value: Int!) -> Array<GKBond>! {
        let entries: Array<AnyObject> = search(GKGraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSNumber));
        var nodes: Array<GKBond> = Array<GKBond>()
        for property: GKBondProperty in entries as Array<GKBondProperty> {
            nodes.append(GKBond(bond: property.node as GKManagedBond))
        }
        return nodes
    }

    /**
    * managedObjectContextDidSave
    * The callback that NotificationCenter uses when changes occur in the Graph.
    * @param        notification: NSNotification
    */
    public func managedObjectContextDidSave(notification: NSNotification) {
        let incomingManagedObjectContext: NSManagedObjectContext = notification.object as NSManagedObjectContext
        let incomingPersistentStoreCoordinator: NSPersistentStoreCoordinator = incomingManagedObjectContext.persistentStoreCoordinator!

        let userInfo = notification.userInfo

        // inserts
        let insertedSet: NSSet = userInfo?[NSInsertedObjectsKey] as NSSet
        let	inserted: NSMutableSet = insertedSet.mutableCopy() as NSMutableSet

        inserted.filterUsingPredicate(masterPredicate!)

        if 0 < inserted.count {
            let nodes: Array<NSManagedObject> = inserted.allObjects as [NSManagedObject]
            for node: NSManagedObject in nodes {
                let className = String.fromCString(object_getClassName(node))
                if nil == className {
                    println("[GraphKit Error: Cannot get Object Class name.]")
                    continue
                }
                switch(className!) {
                case "GKManagedEntity_GKManagedEntity_":
                    delegate?.graph?(self, didInsertEntity: GKEntity(entity: node as GKManagedEntity))
                    break
				case "GKEntityGroup_GKEntityGroup_":
					let group: GKEntityGroup = node as GKEntityGroup
					delegate?.graph?(self, didInsertEntity: GKEntity(entity: group.node as GKManagedEntity), group: group.name)
					break
				case "GKEntityProperty_GKEntityProperty_":
                    let property: GKEntityProperty = node as GKEntityProperty
                    delegate?.graph?(self, didInsertEntity: GKEntity(entity: property.node as GKManagedEntity), property: property.name, value: property.value)
                    break
                case "GKManagedAction_GKManagedAction_":
                    delegate?.graph?(self, didInsertAction: GKAction(action: node as GKManagedAction))
                    break
				case "GKActionGroup_GKActionGroup_":
					let group: GKActionGroup = node as GKActionGroup
					delegate?.graph?(self, didInsertAction: GKAction(action: group.node as GKManagedAction), group: group.name)
					break
				case "GKActionProperty_GKActionProperty_":
                    let property: GKActionProperty = node as GKActionProperty
                    delegate?.graph?(self, didInsertAction: GKAction(action: property.node as GKManagedAction), property: property.name, value: property.value)
                    break
                case "GKManagedBond_GKManagedBond_":
                    delegate?.graph?(self, didInsertBond: GKBond(bond: node as GKManagedBond))
                    break
				case "GKBondGroup_GKBondGroup_":
					let group: GKBondGroup = node as GKBondGroup
					delegate?.graph?(self, didInsertBond: GKBond(bond: group.node as GKManagedBond), group: group.name)
					break
				case "GKBondProperty_GKBondProperty_":
                    let property: GKBondProperty = node as GKBondProperty
                    delegate?.graph?(self, didInsertBond: GKBond(bond: property.node as GKManagedBond), property: property.name, value: property.value)
                    break
                default:
                    assert(false, "[GraphKit Error: GKGraph observed an object that is invalid.]")
                }
            }
        }

        // updates
        let updatedSet: NSSet = userInfo?[NSUpdatedObjectsKey] as NSSet
        let	updated: NSMutableSet = updatedSet.mutableCopy() as NSMutableSet
        updated.filterUsingPredicate(masterPredicate!)

        if 0 < updated.count {
            let nodes: Array<NSManagedObject> = updated.allObjects as [NSManagedObject]
            for node: NSManagedObject in nodes {
                let className = String.fromCString(object_getClassName(node))
                if nil == className {
                    println("[GraphKit Error: Cannot get Object Class name.]")
                    continue
                }
                switch(className!) {
                case "GKEntityProperty_GKEntityProperty_":
                    let property: GKEntityProperty = node as GKEntityProperty
                    delegate?.graph?(self, didUpdateEntity: GKEntity(entity: property.node as GKManagedEntity), property: property.name, value: property.value)
                    break
                case "GKActionProperty_GKActionProperty_":
                    let property: GKActionProperty = node as GKActionProperty
                    delegate?.graph?(self, didUpdateAction: GKAction(action: property.node as GKManagedAction), property: property.name, value: property.value)
                    break
                case "GKBondProperty_GKBondProperty_":
                    let property: GKBondProperty = node as GKBondProperty
                    delegate?.graph?(self, didUpdateBond: GKBond(bond: property.node as GKManagedBond), property: property.name, value: property.value)
                    break
                default:
                    assert(false, "[GraphKit Error: GKGraph observed an object that is invalid.]")
                }
            }
        }

        // deletes
        let deletedSet: NSSet? = userInfo?[NSDeletedObjectsKey] as? NSSet

        if nil == deletedSet? {
            return
        }

        var	deleted: NSMutableSet = deletedSet!.mutableCopy() as NSMutableSet
        deleted.filterUsingPredicate(masterPredicate!)

        if 0 < deleted.count {
            let nodes: Array<NSManagedObject> = deleted.allObjects as [NSManagedObject]
            for node: NSManagedObject in nodes {
                let className = String.fromCString(object_getClassName(node))
                if nil == className {
                    println("[GraphKit Error: Cannot get Object Class name.]")
                    continue
                }
                switch(className!) {
                case "GKManagedEntity_GKManagedEntity_":
                    delegate?.graph?(self, didDeleteEntity: GKEntity(entity: node as GKManagedEntity))
                    break
                case "GKEntityProperty_GKEntityProperty_":
                    let property: GKEntityProperty = node as GKEntityProperty
                    delegate?.graph?(self, didDeleteEntity: GKEntity(entity: property.node as GKManagedEntity), property: property.name, value: property.value)
                    break
                case "GKEntityGroup_GKEntityGroup_":
                    let group: GKEntityGroup = node as GKEntityGroup
                    delegate?.graph?(self, didDeleteEntity: GKEntity(entity: group.node as GKManagedEntity), group: group.name)
                    break
                case "GKManagedAction_GKManagedAction_":
                    delegate?.graph?(self, didDeleteAction: GKAction(action: node as GKManagedAction))
                    break
                case "GKActionProperty_GKActionProperty_":
                    let property: GKActionProperty = node as GKActionProperty
                    delegate?.graph?(self, didDeleteAction: GKAction(action: property.node as GKManagedAction), property: property.name, value: property.value)
                    break
                case "GKActionGroup_GKActionGroup_":
                    let group: GKActionGroup = node as GKActionGroup
                    delegate?.graph?(self, didDeleteAction: GKAction(action: group.node as GKManagedAction), group: group.name)
                    break
                case "GKManagedBond_GKManagedBond_":
                    delegate?.graph?(self, didDeleteBond: GKBond(bond: node as GKManagedBond))
                    break
                case "GKBondProperty_GKBondProperty_":
                    let property: GKBondProperty = node as GKBondProperty
                    delegate?.graph?(self, didDeleteBond: GKBond(bond: property.node as GKManagedBond), property: property.name, value: property.value)
                    break
                case "GKBondGroup_GKBondGroup_":
                    let group: GKBondGroup = node as GKBondGroup
                    delegate?.graph?(self, didDeleteBond: GKBond(bond: group.node as GKManagedBond), group: group.name)
                    break
                default:
                    assert(false, "[GraphKit Error: GKGraph observed an object that is invalid.]")
                }
            }
        }
    }

    // make thread safe by creating this asynchronously
    var managedObjectContext: NSManagedObjectContext {
        struct GKGraphManagedObjectContext {
            static var onceToken: dispatch_once_t = 0
            static var managedObjectContext: NSManagedObjectContext!
        }
        dispatch_once(&GKGraphManagedObjectContext.onceToken) {
            GKGraphManagedObjectContext.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            GKGraphManagedObjectContext.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        }
        return GKGraphManagedObjectContext.managedObjectContext
    }

    internal var managedObjectModel: NSManagedObjectModel {
        struct GKGraphManagedObjectModel {
            static var onceToken: dispatch_once_t = 0
            static var managedObjectModel: NSManagedObjectModel!
        }
        dispatch_once(&GKGraphManagedObjectModel.onceToken) {
            GKGraphManagedObjectModel.managedObjectModel = NSManagedObjectModel()

            var entityDescription: NSEntityDescription = NSEntityDescription()
            var entityProperties: Array<AnyObject> = Array<AnyObject>()
            entityDescription.name = GKGraphUtility.entityDescriptionName
            entityDescription.managedObjectClassName = GKGraphUtility.entityObjectClassName

            var actionDescription: NSEntityDescription = NSEntityDescription()
            var actionProperties: Array<AnyObject> = Array<AnyObject>()
            actionDescription.name = GKGraphUtility.actionDescriptionName
            actionDescription.managedObjectClassName = GKGraphUtility.actionObjectClassName

            var bondDescription: NSEntityDescription = NSEntityDescription()
            var bondProperties: Array<AnyObject> = Array<AnyObject>()
            bondDescription.name = GKGraphUtility.bondDescriptionName
            bondDescription.managedObjectClassName = GKGraphUtility.bondObjectClassName

            var entityPropertyDescription: NSEntityDescription = NSEntityDescription()
            var entityPropertyProperties: Array<AnyObject> = Array<AnyObject>()
            entityPropertyDescription.name = GKGraphUtility.entityPropertyDescriptionName
            entityPropertyDescription.managedObjectClassName = GKGraphUtility.entityPropertyObjectClassName

            var actionPropertyDescription: NSEntityDescription = NSEntityDescription()
            var actionPropertyProperties: Array<AnyObject> = Array<AnyObject>()
            actionPropertyDescription.name = GKGraphUtility.actionPropertyDescriptionName
            actionPropertyDescription.managedObjectClassName = GKGraphUtility.actionPropertyObjectClassName

            var bondPropertyDescription: NSEntityDescription = NSEntityDescription()
            var bondPropertyProperties: Array<AnyObject> = Array<AnyObject>()
            bondPropertyDescription.name = GKGraphUtility.bondPropertyDescriptionName
            bondPropertyDescription.managedObjectClassName = GKGraphUtility.bondPropertyObjectClassName

            var entityGroupDescription: NSEntityDescription = NSEntityDescription()
            var entityGroupProperties: Array<AnyObject> = Array<AnyObject>()
            entityGroupDescription.name = GKGraphUtility.entityGroupDescriptionName
            entityGroupDescription.managedObjectClassName = GKGraphUtility.entityGroupObjectClassName

            var actionGroupDescription: NSEntityDescription = NSEntityDescription()
            var actionGroupProperties: Array<AnyObject> = Array<AnyObject>()
            actionGroupDescription.name = GKGraphUtility.actionGroupDescriptionName
            actionGroupDescription.managedObjectClassName = GKGraphUtility.actionGroupObjectClassName

            var bondGroupDescription: NSEntityDescription = NSEntityDescription()
            var bondGroupProperties: Array<AnyObject> = Array<AnyObject>()
            bondGroupDescription.name = GKGraphUtility.bondGroupDescriptionName
            bondGroupDescription.managedObjectClassName = GKGraphUtility.bondGroupObjectClassName

            var nodeClass: NSAttributeDescription = NSAttributeDescription()
            nodeClass.name = "nodeClass"
            nodeClass.attributeType = .StringAttributeType
            nodeClass.optional = false
            entityProperties.append(nodeClass.copy() as NSAttributeDescription)
            actionProperties.append(nodeClass.copy() as NSAttributeDescription)
            bondProperties.append(nodeClass.copy() as NSAttributeDescription)

            var type: NSAttributeDescription = NSAttributeDescription()
            type.name = "type"
            type.attributeType = .StringAttributeType
            type.optional = false
            entityProperties.append(type.copy() as NSAttributeDescription)
            actionProperties.append(type.copy() as NSAttributeDescription)
            bondProperties.append(type.copy() as NSAttributeDescription)

            var createdDate: NSAttributeDescription = NSAttributeDescription()
            createdDate.name = "createdDate"
            createdDate.attributeType = .DateAttributeType
            createdDate.optional = false
            entityProperties.append(createdDate.copy() as NSAttributeDescription)
            actionProperties.append(createdDate.copy() as NSAttributeDescription)
            bondProperties.append(createdDate.copy() as NSAttributeDescription)

            var propertyName: NSAttributeDescription = NSAttributeDescription()
            propertyName.name = "name"
            propertyName.attributeType = .StringAttributeType
            propertyName.optional = false
            entityPropertyProperties.append(propertyName.copy() as NSAttributeDescription)
            actionPropertyProperties.append(propertyName.copy() as NSAttributeDescription)
            bondPropertyProperties.append(propertyName.copy() as NSAttributeDescription)

            var propertyValue: NSAttributeDescription = NSAttributeDescription()
            propertyValue.name = "value"
            propertyValue.attributeType = .TransformableAttributeType
            propertyValue.attributeValueClassName = "AnyObject"
            propertyValue.optional = false
            propertyValue.storedInExternalRecord = true
            entityPropertyProperties.append(propertyValue.copy() as NSAttributeDescription)
            actionPropertyProperties.append(propertyValue.copy() as NSAttributeDescription)
            bondPropertyProperties.append(propertyValue.copy() as NSAttributeDescription)

            var propertyRelationship: NSRelationshipDescription = NSRelationshipDescription()
            propertyRelationship.name = "node"
            propertyRelationship.minCount = 1
            propertyRelationship.maxCount = 1
            propertyRelationship.deleteRule = .NoActionDeleteRule

            var propertySetRelationship: NSRelationshipDescription = NSRelationshipDescription()
            propertySetRelationship.name = "propertySet"
            propertySetRelationship.minCount = 0
            propertySetRelationship.maxCount = 0
            propertySetRelationship.deleteRule = .CascadeDeleteRule
            propertyRelationship.inverseRelationship = propertySetRelationship
            propertySetRelationship.inverseRelationship = propertyRelationship

            propertyRelationship.destinationEntity = entityDescription
            propertySetRelationship.destinationEntity = entityPropertyDescription
            entityPropertyProperties.append(propertyRelationship.copy() as NSRelationshipDescription)
            entityProperties.append(propertySetRelationship.copy() as NSRelationshipDescription)

            propertyRelationship.destinationEntity = actionDescription
            propertySetRelationship.destinationEntity = actionPropertyDescription
            actionPropertyProperties.append(propertyRelationship.copy() as NSRelationshipDescription)
            actionProperties.append(propertySetRelationship.copy() as NSRelationshipDescription)

            propertyRelationship.destinationEntity = bondDescription
            propertySetRelationship.destinationEntity = bondPropertyDescription
            bondPropertyProperties.append(propertyRelationship.copy() as NSRelationshipDescription)
            bondProperties.append(propertySetRelationship.copy() as NSRelationshipDescription)

            var group: NSAttributeDescription = NSAttributeDescription()
            group.name = "name"
            group.attributeType = .StringAttributeType
            group.optional = false
            entityGroupProperties.append(group.copy() as NSAttributeDescription)
			actionGroupProperties.append(group.copy() as NSAttributeDescription)
			bondGroupProperties.append(group.copy() as NSAttributeDescription)

            var groupRelationship: NSRelationshipDescription = NSRelationshipDescription()
            groupRelationship.name = "node"
            groupRelationship.minCount = 1
            groupRelationship.maxCount = 1
            groupRelationship.deleteRule = .NoActionDeleteRule

            var groupSetRelationship: NSRelationshipDescription = NSRelationshipDescription()
            groupSetRelationship.name = "groupSet"
            groupSetRelationship.minCount = 0
            groupSetRelationship.maxCount = 0
            groupSetRelationship.deleteRule = .CascadeDeleteRule
            groupRelationship.inverseRelationship = groupSetRelationship
            groupSetRelationship.inverseRelationship = groupRelationship

            groupRelationship.destinationEntity = entityDescription
            groupSetRelationship.destinationEntity = entityGroupDescription
            entityGroupProperties.append(groupRelationship.copy() as NSRelationshipDescription)
            entityProperties.append(groupSetRelationship.copy() as NSRelationshipDescription)

            groupRelationship.destinationEntity = actionDescription
            groupSetRelationship.destinationEntity = actionGroupDescription
            actionGroupProperties.append(groupRelationship.copy() as NSRelationshipDescription)
            actionProperties.append(groupSetRelationship.copy() as NSRelationshipDescription)

            groupRelationship.destinationEntity = bondDescription
            groupSetRelationship.destinationEntity = bondGroupDescription
            bondGroupProperties.append(groupRelationship.copy() as NSRelationshipDescription)
            bondProperties.append(groupSetRelationship.copy() as NSRelationshipDescription)

            // Inverse relationship for Subjects -- B.
            var subjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
            subjectRelationship.name = "subjectSet"
            subjectRelationship.minCount = 0
            subjectRelationship.maxCount = 0
            subjectRelationship.deleteRule = .NoActionDeleteRule
            subjectRelationship.destinationEntity = entityDescription

            var actionSubjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
            actionSubjectRelationship.name = "actionSubjectSet"
            actionSubjectRelationship.minCount = 0
            actionSubjectRelationship.maxCount = 0
            actionSubjectRelationship.deleteRule = .NoActionDeleteRule
            actionSubjectRelationship.destinationEntity = actionDescription

            actionSubjectRelationship.inverseRelationship = subjectRelationship
            subjectRelationship.inverseRelationship = actionSubjectRelationship

            entityProperties.append(actionSubjectRelationship.copy() as NSRelationshipDescription)
            actionProperties.append(subjectRelationship.copy() as NSRelationshipDescription)
            // Inverse relationship for Subjects -- E.

            // Inverse relationship for Objects -- B.
            var objectRelationship: NSRelationshipDescription = NSRelationshipDescription()
            objectRelationship.name = "objectSet"
            objectRelationship.minCount = 0
            objectRelationship.maxCount = 0
            objectRelationship.deleteRule = .NoActionDeleteRule
            objectRelationship.destinationEntity = entityDescription

            var actionObjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
            actionObjectRelationship.name = "actionObjectSet"
            actionObjectRelationship.minCount = 0
            actionObjectRelationship.maxCount = 0
            actionObjectRelationship.deleteRule = .NoActionDeleteRule
            actionObjectRelationship.destinationEntity = actionDescription
            actionObjectRelationship.inverseRelationship = objectRelationship
            objectRelationship.inverseRelationship = actionObjectRelationship

            entityProperties.append(actionObjectRelationship.copy() as NSRelationshipDescription)
            actionProperties.append(objectRelationship.copy() as NSRelationshipDescription)
            // Inverse relationship for Objects -- E.

            // Inverse relationship for Subjects -- B.
            subjectRelationship = NSRelationshipDescription()
            subjectRelationship.name = "subject"
            subjectRelationship.minCount = 1
            subjectRelationship.maxCount = 1
            subjectRelationship.deleteRule = .NoActionDeleteRule
            subjectRelationship.destinationEntity = entityDescription

            var bondSubjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
            bondSubjectRelationship.name = "bondSubjectSet"
            bondSubjectRelationship.minCount = 0
            bondSubjectRelationship.maxCount = 0
            bondSubjectRelationship.deleteRule = .NoActionDeleteRule
            bondSubjectRelationship.destinationEntity = bondDescription

            bondSubjectRelationship.inverseRelationship = subjectRelationship
            subjectRelationship.inverseRelationship = bondSubjectRelationship

            entityProperties.append(bondSubjectRelationship.copy() as NSRelationshipDescription)
            bondProperties.append(subjectRelationship.copy() as NSRelationshipDescription)
            // Inverse relationship for Subjects -- E.

            // Inverse relationship for Objects -- B.
            objectRelationship = NSRelationshipDescription()
            objectRelationship.name = "object"
            objectRelationship.minCount = 1
            objectRelationship.maxCount = 1
            objectRelationship.deleteRule = .NoActionDeleteRule
            objectRelationship.destinationEntity = entityDescription

            var bondObjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
            bondObjectRelationship.name = "bondObjectSet"
            bondObjectRelationship.minCount = 0
            bondObjectRelationship.maxCount = 0
            bondObjectRelationship.deleteRule = .NoActionDeleteRule
            bondObjectRelationship.destinationEntity = bondDescription
            bondObjectRelationship.inverseRelationship = objectRelationship
            objectRelationship.inverseRelationship = bondObjectRelationship

            entityProperties.append(bondObjectRelationship.copy() as NSRelationshipDescription)
            bondProperties.append(objectRelationship.copy() as NSRelationshipDescription)
            // Inverse relationship for Objects -- E.

            entityDescription.properties = entityProperties
            entityGroupDescription.properties = entityGroupProperties
            entityPropertyDescription.properties = entityPropertyProperties
            
            actionDescription.properties = actionProperties
            actionGroupDescription.properties = actionGroupProperties
            actionPropertyDescription.properties = actionPropertyProperties
            
            bondDescription.properties = bondProperties
            bondGroupDescription.properties = bondGroupProperties
            bondPropertyDescription.properties = bondPropertyProperties

            GKGraphManagedObjectModel.managedObjectModel.entities = [
                    entityDescription,
                    entityGroupDescription,
                    entityPropertyDescription,
            
                    actionDescription,
                    actionGroupDescription,
                    actionPropertyDescription,
                    
                    bondDescription,
                    bondGroupDescription,
                    bondPropertyDescription
            ]
        }
        return GKGraphManagedObjectModel.managedObjectModel!
    }

    internal var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        struct GKGraphPersistentStoreCoordinator {
            static var onceToken: dispatch_once_t = 0
            static var persistentStoreCoordinator: NSPersistentStoreCoordinator!
        }
        dispatch_once(&GKGraphPersistentStoreCoordinator.onceToken) {
            let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent(GKGraphUtility.storeName)
            var error: NSError?
            GKGraphPersistentStoreCoordinator.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            var options: Dictionary = [NSReadOnlyPersistentStoreOption: false, NSSQLitePragmasOption: ["journal_mode": "DELETE"]];
            if nil == GKGraphPersistentStoreCoordinator.persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options as NSDictionary, error: &error) {
                assert(nil == error, "[GraphKit Error: Saving to internal context.]")
            }
        }
        return GKGraphPersistentStoreCoordinator.persistentStoreCoordinator!
    }

    internal var applicationDocumentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex - 1] as NSURL
    }

    /**
    * prepareForObservation
    * Ensures NotificationCenter is watching the callback selector for this Graph.
    */
    internal func prepareForObservation() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: managedObjectContext)
    }

    /**
    * addPredicateToContextWatcher
    * Adds the given predicate to the master predicate, which holds all watchers for the Graph.
    * @param        entityDescription: NSEntityDescription!
    * @param        predicate: NSPredicate!
    */
    internal func addPredicateToContextWatcher(entityDescription: NSEntityDescription!, predicate: NSPredicate!) {
        var entityPredicate: NSPredicate = NSPredicate(format: "entity.name == %@", entityDescription.name!)!
        var predicates: Array<NSPredicate> = [entityPredicate, predicate]
        let finalPredicate: NSPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(predicates)
        masterPredicate = nil != masterPredicate ? NSCompoundPredicate.orPredicateWithSubpredicates([masterPredicate!, finalPredicate]) : finalPredicate
    }

    /**
    * validateConstraints
    * Validates any constraints are not being violated when saving.
    * @return Bool, NSError, false if passing with no Error, true if failed with error.
    */
    internal func validateConstraints() -> (Bool, NSError?) {
        var result: (failed: Bool, error: NSError?) = (false, nil)
        return result
    }

    /**
    * isWatching
    * A sanity check if the Graph is already watching the specified index and key.
    * @param        key: String!
    * @param        index: String!
    * @return       Bool, true if watching, false otherwise.
    */
    internal func isWatching(key: String!, index: String!) -> Bool {
        var watch: Array<String> = nil != watching[index] ? watching[index]! as Array<String> : Array<String>()
        for item: String in watch {
            if item == key {
                return true
            }
        }
        watch.append(key)
        watching[index] = watch
        return false
    }

    /**
    * addWatcher
    * Adds a watcher to the Graph.
    * @param        key: String!
    * @param        value: String!
    * @param        index: String!
    * @param        entityDescriptionName: Srting!
    */
    internal func addWatcher(key: String!, value: String!, index: String!, entityDescriptionName: String!, managedObjectClassName: String!) {
        if true == isWatching(value, index: index) {
            return
        }
        var entityDescription: NSEntityDescription = NSEntityDescription()
        entityDescription.name = entityDescriptionName
        entityDescription.managedObjectClassName = managedObjectClassName
        var predicate: NSPredicate = NSPredicate(format: "%K LIKE %@", key as NSString, value as NSString)!
        addPredicateToContextWatcher(entityDescription, predicate: predicate)
        prepareForObservation()
    }

    /**
    * search
    * Executes a search through CoreData.
    * @param        entityDescriptorName: NSString!
    * @param        predicate: NSPredicate!
    * @return       Array<AnyObject>!
    */
    internal func search(entityDescriptorName: NSString!, predicate: NSPredicate!) -> Array<AnyObject>! {
        let request: NSFetchRequest = NSFetchRequest()
        let entity: NSEntityDescription = managedObjectModel.entitiesByName[entityDescriptorName] as NSEntityDescription
        request.entity = entity
        request.predicate = predicate
        request.fetchBatchSize = batchSize

        var error: NSError?
        var nodes: Array<AnyObject> = Array<AnyObject>()

        managedObjectContext.performBlockAndWait {
            if let result: Array<AnyObject> = self.managedObjectContext.executeFetchRequest(request, error: &error) {
                assert(nil == error, "[GraphKit Error: Fecthing nodes.]")
                for item: AnyObject in result {
                    nodes.append(item)
                }
            }
        }
        return nodes
    }
}
