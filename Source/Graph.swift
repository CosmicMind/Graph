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
* Graph
*
* Manages Nodes in the persistent layer, as well as, offers watchers to monitor
* changes in the persistent layer.
*/

import CoreData

private struct GraphPersistentStoreCoordinator {
	static var onceToken: dispatch_once_t = 0
	static var persistentStoreCoordinator: NSPersistentStoreCoordinator?
}

private struct GraphMainManagedObjectContext {
	static var onceToken: dispatch_once_t = 0
	static var managedObjectContext: NSManagedObjectContext?
}

private struct GraphPrivateManagedObjectContext {
	static var onceToken: dispatch_once_t = 0
	static var managedObjectContext: NSManagedObjectContext?
}

private struct GraphManagedObjectModel {
	static var onceToken: dispatch_once_t = 0
	static var managedObjectModel: NSManagedObjectModel?
}

internal struct GraphUtility {
	static let storeName: String = "GraphKit.sqlite"
	
	static let entityIndexName: String = "ManagedEntity"
	static let entityDescriptionName: String = "ManagedEntity"
	static let entityObjectClassName: String = "ManagedEntity"
	static let entityGroupIndexName: String = "EntityGroup"
	static let entityGroupObjectClassName: String = "EntityGroup"
	static let entityGroupDescriptionName: String = "EntityGroup"
	static let entityPropertyIndexName: String = "EntityProperty"
	static let entityPropertyObjectClassName: String = "EntityProperty"
	static let entityPropertyDescriptionName: String = "EntityProperty"
	
	static let actionIndexName: String = "ManagedAction"
	static let actionDescriptionName: String = "ManagedAction"
	static let actionObjectClassName: String = "ManagedAction"
	static let actionGroupIndexName: String = "ActionGroup"
	static let actionGroupObjectClassName: String = "ActionGroup"
	static let actionGroupDescriptionName: String = "ActionGroup"
	static let actionPropertyIndexName: String = "ActionProperty"
	static let actionPropertyObjectClassName: String = "ActionProperty"
	static let actionPropertyDescriptionName: String = "ActionProperty"
	
	static let bondIndexName: String = "ManagedBond"
	static let bondDescriptionName: String = "ManagedBond"
	static let bondObjectClassName: String = "ManagedBond"
	static let bondGroupIndexName: String = "BondGroup"
	static let bondGroupObjectClassName: String = "BondGroup"
	static let bondGroupDescriptionName: String = "BondGroup"
	static let bondPropertyIndexName: String = "BondProperty"
	static let bondPropertyObjectClassName: String = "BondProperty"
	static let bondPropertyDescriptionName: String = "BondProperty"
}

@objc(GraphDelegate)
public protocol GraphDelegate {
	optional func graph(graph: Graph, didInsertEntity entity: Entity)
	optional func graph(graph: Graph, didDeleteEntity entity: Entity)
	optional func graph(graph: Graph, didInsertEntity entity: Entity, group: String!)
	optional func graph(graph: Graph, didInsertEntity entity: Entity, property: String, value: AnyObject)
	optional func graph(graph: Graph, didUpdateEntity entity: Entity, property: String, value: AnyObject)
	
	optional func graph(graph: Graph, didInsertAction action: Action)
	optional func graph(graph: Graph, didUpdateAction action: Action)
	optional func graph(graph: Graph, didDeleteAction action: Action)
	optional func graph(graph: Graph, didInsertAction action: Action, group: String)
	optional func graph(graph: Graph, didInsertAction entity: Action, property: String, value: AnyObject)
	optional func graph(graph: Graph, didUpdateAction entity: Action, property: String, value: AnyObject)
	
	optional func graph(graph: Graph, didInsertBond bond: Bond)
	optional func graph(graph: Graph, didDeleteBond bond: Bond)
	optional func graph(graph: Graph, didInsertBond bond: Bond, group: String)
	optional func graph(graph: Graph, didInsertBond entity: Bond, property: String, value: AnyObject)
	optional func graph(graph: Graph, didUpdateBond entity: Bond, property: String, value: AnyObject)
}

@objc(Graph)
public class Graph: NSObject {
	public var batchSize: Int = 20
	public var batchOffset: Int = 0
	
	internal var watching: Tree<String, Array<String>>
	internal var masterPredicate: NSPredicate?
	
	public weak var delegate: GraphDelegate?
	
	/**
	* init
	* Initializer for the Object.
	*/
	override public init() {
		watching = Tree<String, Array<String>>()
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
	public func save(completion: ((success: Bool, error: NSError?) -> ())?) {
		var w: NSManagedObjectContext? = worker
		var p: NSManagedObjectContext? = privateContext
		if nil != w && nil != p {
			w!.performBlockAndWait {
				var error: NSError?
				if w!.save(&error) {
					p!.performBlockAndWait {
						let result: Bool = p!.save(&error)
						completion?(success: result, error: error)
					}
				} else {
					completion?(success: false, error: error)
				}
			}
		}
	}
	
	/**
	* watch(Entity)
	* Attaches the Graph instance to NotificationCenter in order to observe changes for an Entity with the spcified type.
	* @param        type: String!
	*/
	public func watch(Entity type: String!) {
		addWatcher("type", value: type, index: GraphUtility.entityIndexName, entityDescriptionName: GraphUtility.entityDescriptionName, managedObjectClassName: GraphUtility.entityObjectClassName)
	}
	
	/**
	* watch(EntityGroup)
	* Attaches the Graph instance to NotificationCenter in order to observe changes for an Entity with the specified group name.
	* @param        name: String!
	*/
	public func watch(EntityGroup name: String!) {
		addWatcher("name", value: name, index: GraphUtility.entityGroupIndexName, entityDescriptionName: GraphUtility.entityGroupDescriptionName, managedObjectClassName: GraphUtility.entityGroupObjectClassName)
	}
	
	/**
	* watch(EntityProperty)
	* Attaches the Graph instance to NotificationCenter in order to observe changes for an Entity with the specified property name.
	* @param        name: String!
	*/
	public func watch(EntityProperty name: String!) {
		addWatcher("name", value: name, index: GraphUtility.entityPropertyIndexName, entityDescriptionName: GraphUtility.entityPropertyDescriptionName, managedObjectClassName: GraphUtility.entityPropertyObjectClassName)
	}
	
	/**
	* watch(Action)
	* Attaches the Graph instance to NotificationCenter in order to Observe changes for an Action with the spcified type.
	*/
	public func watch(Action type: String!) {
		addWatcher("type", value: type, index: GraphUtility.actionIndexName, entityDescriptionName: GraphUtility.actionDescriptionName, managedObjectClassName: GraphUtility.actionObjectClassName)
	}
	
	/**
	* watch(ActionGroup)
	* Attaches the Graph instance to NotificationCenter in order to observe changes for an Action with the specified group name.
	* @param        name: String!
	*/
	public func watch(ActionGroup name: String!) {
		addWatcher("name", value: name, index: GraphUtility.actionGroupIndexName, entityDescriptionName: GraphUtility.actionGroupDescriptionName, managedObjectClassName: GraphUtility.actionGroupObjectClassName)
	}
	
	/**
	* watch(ActionProperty)
	* Attaches the Graph instance to NotificationCenter in order to observe changes for an Action with the specified property name.
	* @param        name: String!
	*/
	public func watch(ActionProperty name: String!) {
		addWatcher("name", value: name, index: GraphUtility.actionPropertyIndexName, entityDescriptionName: GraphUtility.actionPropertyDescriptionName, managedObjectClassName: GraphUtility.actionPropertyObjectClassName)
	}
	
	/**
	* watch(Bond)
	* Attaches the Graph instance to NotificationCenter in order to Observe changes for an Bond with the spcified type.
	*/
	public func watch(Bond type: String!) {
		addWatcher("type", value: type, index: GraphUtility.bondIndexName, entityDescriptionName: GraphUtility.bondDescriptionName, managedObjectClassName: GraphUtility.bondObjectClassName)
	}
	
	/**
	* watch(BondGroup)
	* Attaches the Graph instance to NotificationCenter in order to observe changes for an Bond with the specified group name.
	* @param        name: String!
	*/
	public func watch(BondGroup name: String!) {
		addWatcher("name", value: name, index: GraphUtility.bondGroupIndexName, entityDescriptionName: GraphUtility.bondGroupDescriptionName, managedObjectClassName: GraphUtility.bondGroupObjectClassName)
	}
	
	/**
	* watch(BondProperty)
	* Attaches the Graph instance to NotificationCenter in order to observe changes for an Bond with the specified property name.
	* @param        name: String!
	*/
	public func watch(BondProperty name: String!) {
		addWatcher("name", value: name, index: GraphUtility.bondPropertyIndexName, entityDescriptionName: GraphUtility.bondPropertyDescriptionName, managedObjectClassName: GraphUtility.bondPropertyObjectClassName)
	}
	
	/**
	* search(Entity)
	* Searches the Graph for Entity Objects with the following type LIKE ?.
	* @param        type: String
	* @return       Tree<String, Entity>
	*/
	public func search(Entity type: String) -> Tree<String, Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type as NSString), sort: [NSSortDescriptor(key: "createdDate", ascending: false)])
		let nodes: Tree<String, Entity> = Tree<String, Entity>()
		for entity: ManagedEntity in entries as! Array<ManagedEntity> {
			let node: Entity = Entity(entity: entity)
			nodes.insert(node.id, value: node)
		}
		return nodes
	}
	
	/**
	* search(EntityGroup)
	* Searches the Graph for Entity Group Objects with the following name LIKE ?.
	* @param        name: String
	* @return       Tree<String, Entity>
	*/
	public func search(EntityGroup name: String) -> Tree<String, Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: Tree<String, Entity> = Tree<String, Entity>()
		for group: EntityGroup in entries as! Array<EntityGroup> {
			let node: Entity = Entity(entity: group.node)
			nodes.insert(node.id, value: node)
		}
		return nodes
	}
	
	/**
	* search(EntityGroupMap)
	* Retrieves all the unique Group Names for Entity Nodes with their Entity Objects.
	* @param        name: String
	* @return       Tree<String, MultiTree<String, Entity>>
	*/
	public func search(EntityGroupMap name: String) -> Tree<String, MultiTree<String, Entity>> {
		let entries: Array<AnyObject> = search(GraphUtility.entityGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: Tree<String, MultiTree<String, Entity>> = Tree<String, MultiTree<String, Entity>>()
		for group: EntityGroup in entries as! Array<EntityGroup> {
			let node: Entity = Entity(entity: group.node)
			if (nil == nodes[group.name]) {
				let set: MultiTree<String, Entity> = MultiTree<String, Entity>()
				set.insert(node.type, value: node)
				nodes.insert(group.name, value: set)
			} else {
				nodes[group.name]!.insert(node.type, value: node)
			}
		}
		return nodes
	}
	
	/**
	* search(EntityProperty)
	* Searches the Graph for Entity Property Objects with the following name LIKE ?.
	* @param        name: String
	* @return       MultiTree<String, Entity>
	*/
	public func search(EntityProperty name: String) -> MultiTree<String, Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: MultiTree<String, Entity> = MultiTree<String, Entity>()
		for property: EntityProperty in entries as! Array<EntityProperty> {
			let node: Entity = Entity(entity: property.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(EntityProperty)
	* Searches the Graph for Entity Property Objects with the following name == ? and value == ?.
	* @param        name: String
	* @param        value: String
	* @return       MultiTree<String, Entity>
	*/
	public func search(EntityProperty name: String, value: String) -> MultiTree<String, Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSString))
		let nodes: MultiTree<String, Entity> = MultiTree<String, Entity>()
		for property: EntityProperty in entries as! Array<EntityProperty> {
			let node: Entity = Entity(entity: property.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(EntityProperty)
	* Searches the Graph for Entity Property Objects with the following name == ? and value == ?.
	* @param        name: String
	* @param        value: Int
	* @return       MultiTree<String, Entity>
	*/
	public func search(EntityProperty name: String, value: Int) -> MultiTree<String, Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSNumber))
		let nodes: MultiTree<String, Entity> = MultiTree<String, Entity>()
		for property: EntityProperty in entries as! Array<EntityProperty> {
			let node: Entity = Entity(entity: property.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(Action)
	* Searches the Graph for Action Objects with the following type LIKE ?.
	* @param        type: String
	* @return       Tree<String, Action>
	*/
	public func search(Action type: String) -> Tree<String, Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type as NSString), sort: [NSSortDescriptor(key: "createdDate", ascending: false)])
		let nodes: Tree<String, Action> = Tree<String, Action>()
		for action: ManagedAction in entries as! Array<ManagedAction> {
			let node: Action = Action(action: action)
			nodes.insert(node.id, value: node)
		}
		return nodes
	}
	
	/**
	* search(ActionGroup)
	* Searches the Graph for Action Group Objects with the following name LIKE ?.
	* @param        name: String
	* @return       MultiTree<String, Action>
	*/
	public func search(ActionGroup name: String) -> MultiTree<String, Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: MultiTree<String, Action> = MultiTree<String, Action>()
		for group: ActionGroup in entries as! Array<ActionGroup> {
			let node: Action = Action(action: group.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(ActionGroupMap)
	* Retrieves all the unique Group Names for Action Nodes with their Action Objects.
	* @param        name: String
	* @return       Tree<String, MultiTree<String, Action>>
	*/
	public func search(ActionGroupMap name: String) -> Tree<String, MultiTree<String, Action>> {
		let entries: Array<AnyObject> = search(GraphUtility.actionGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: Tree<String, MultiTree<String, Action>> = Tree<String, MultiTree<String, Action>>()
		for group: ActionGroup in entries as! Array<ActionGroup> {
			let node: Action = Action(action: group.node)
			if (nil == nodes[group.name]) {
				let set: MultiTree<String, Action> = MultiTree<String, Action>()
				set.insert(node.type, value: node)
				nodes.insert(group.name, value: set)
			} else {
				nodes[group.name]!.insert(node.type, value: node)
			}
		}
		return nodes
	}
	
	/**
	* search(ActionProperty)
	* Searches the Graph for Action Property Objects with the following name LIKE ?.
	* @param        name: String
	* @return       MultiTree<String, Action>
	*/
	public func search(ActionProperty name: String) -> MultiTree<String, Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: MultiTree<String, Action> = MultiTree<String, Action>()
		for property: ActionProperty in entries as! Array<ActionProperty> {
			let node: Action = Action(action: property.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(ActionProperty)
	* Searches the Graph for Action Property Objects with the following name == ? and value == ?.
	* @param        name: String
	* @param        value: String
	* @return       MultiTree<String, Action>
	*/
	public func search(ActionProperty name: String, value: String) -> MultiTree<String, Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSString))
		let nodes: MultiTree<String, Action> = MultiTree<String, Action>()
		for property: ActionProperty in entries as! Array<ActionProperty> {
			let node: Action = Action(action: property.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(ActionProperty)
	* Searches the Graph for Action Property Objects with the following name == ? and value == ?.
	* @param        name: String
	* @param        value: Int
	* @return       MultiTree<String, Action>
	*/
	public func search(ActionProperty name: String, value: Int) -> MultiTree<String, Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSNumber))
		let nodes: MultiTree<String, Action> = MultiTree<String, Action>()
		for property: ActionProperty in entries as! Array<ActionProperty> {
			let node: Action = Action(action: property.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(Bond)
	* Searches the Graph for Bond Objects with the following type LIKE ?.
	* @param        type: String
	* @return       Tree<String, Bond>
	*/
	public func search(Bond type: String) -> Tree<String, Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type as NSString), sort: [NSSortDescriptor(key: "createdDate", ascending: false)])
		let nodes: Tree<String, Bond> = Tree<String, Bond>()
		for bond: ManagedBond in entries as! Array<ManagedBond> {
			let node: Bond = Bond(bond: bond)
			nodes.insert(node.id, value: node)
		}
		return nodes
	}
	
	/**
	* search(BondGroup)
	* Searches the Graph for Bond Group Objects with the following name LIKE ?.
	* @param        name: String
	* @return       MultiTree<String, Bond>
	*/
	public func search(BondGroup name: String) -> MultiTree<String, Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: MultiTree<String, Bond> = MultiTree<String, Bond>()
		for group: BondGroup in entries as! Array<BondGroup> {
			let node: Bond = Bond(bond: group.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(BondGroupMap)
	* Retrieves all the unique Group Names for Bond Nodes with their Bond Objects.
	* @param        name: String
	* @return       Tree<String, MultiTree<String, Bond>>
	*/
	public func search(BondGroupMap name: String) -> Tree<String, MultiTree<String, Bond>> {
		let entries: Array<AnyObject> = search(GraphUtility.bondGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: Tree<String, MultiTree<String, Bond>> = Tree<String, MultiTree<String, Bond>>()
		for group: BondGroup in entries as! Array<BondGroup> {
			let node: Bond = Bond(bond: group.node)
			if (nil == nodes[group.name]) {
				let set: MultiTree<String, Bond> = MultiTree<String, Bond>()
				set.insert(node.type, value: node)
				nodes.insert(group.name, value: set)
			} else {
				nodes[group.name]!.insert(node.type, value: node)
			}
		}
		return nodes
	}
	
	/**
	* search(BondProperty)
	* Searches the Graph for Bond Property Objects with the following name LIKE ?.
	* @param        name: String
	* @return       MultiTree<String, Bond>
	*/
	public func search(BondProperty name: String) -> MultiTree<String, Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: MultiTree<String, Bond> = MultiTree<String, Bond>()
		for property: BondProperty in entries as! Array<BondProperty> {
			let node: Bond = Bond(bond: property.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(BondProperty)
	* Searches the Graph for Bond Property Objects with the following name == ? and value == ?.
	* @param        name: String
	* @param        value: String
	* @return       MultiTree<String, Bond>
	*/
	public func search(BondProperty name: String, value: String) -> MultiTree<String, Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSString))
		let nodes: MultiTree<String, Bond> = MultiTree<String, Bond>()
		for property: BondProperty in entries as! Array<BondProperty> {
			let node: Bond = Bond(bond: property.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* search(BondProperty)
	* Searches the Graph for Bond Property Objects with the following name == ? and value == ?.
	* @param        name: String
	* @param        value: Int
	* @return       MultiTree<String, Bond>
	*/
	public func search(BondProperty name: String, value: Int) -> MultiTree<String, Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (value == %@)", name as NSString, value as NSNumber))
		let nodes: MultiTree<String, Bond> = MultiTree<String, Bond>()
		for property: BondProperty in entries as! Array<BondProperty> {
			let node: Bond = Bond(bond: property.node)
			nodes.insert(node.type, value: node)
		}
		return nodes
	}
	
	/**
	* managedObjectContextDidSave
	* The callback that NotificationCenter uses when changes occur in the Graph.
	* @param        notification: NSNotification
	*/
	public func managedObjectContextDidSave(notification: NSNotification) {
		let incomingManagedObjectContext: NSManagedObjectContext = notification.object as! NSManagedObjectContext
		let incomingPersistentStoreCoordinator: NSPersistentStoreCoordinator = incomingManagedObjectContext.persistentStoreCoordinator!
		let userInfo = notification.userInfo
		
		// inserts
		let insertedSet: NSSet = userInfo?[NSInsertedObjectsKey] as! NSSet
		let	inserted: NSMutableSet = insertedSet.mutableCopy() as! NSMutableSet
		
		inserted.filterUsingPredicate(masterPredicate!)
		
		if 0 < inserted.count {
			let nodes: Array<NSManagedObject> = inserted.allObjects as! [NSManagedObject]
			for node: NSManagedObject in nodes {
				let className = String.fromCString(object_getClassName(node))
				if nil == className {
					println("[GraphKit Error: Cannot get Object Class name.]")
					continue
				}
				switch(className!) {
				case "ManagedEntity_ManagedEntity_":
					delegate?.graph?(self, didInsertEntity: Entity(entity: node as! ManagedEntity))
					break
				case "EntityGroup_EntityGroup_":
					let group: EntityGroup = node as! EntityGroup
					delegate?.graph?(self, didInsertEntity: Entity(entity: group.node), group: group.name)
					break
				case "EntityProperty_EntityProperty_":
					let property: EntityProperty = node as! EntityProperty
					delegate?.graph?(self, didInsertEntity: Entity(entity: property.node), property: property.name, value: property.value)
					break
				case "ManagedAction_ManagedAction_":
					delegate?.graph?(self, didInsertAction: Action(action: node as! ManagedAction))
					break
				case "ActionGroup_ActionGroup_":
					let group: ActionGroup = node as! ActionGroup
					delegate?.graph?(self, didInsertAction: Action(action: group.node), group: group.name)
					break
				case "ActionProperty_ActionProperty_":
					let property: ActionProperty = node as! ActionProperty
					delegate?.graph?(self, didInsertAction: Action(action: property.node), property: property.name, value: property.value)
					break
				case "ManagedBond_ManagedBond_":
					delegate?.graph?(self, didInsertBond: Bond(bond: node as! ManagedBond))
					break
				case "BondGroup_BondGroup_":
					let group: BondGroup = node as! BondGroup
					delegate?.graph?(self, didInsertBond: Bond(bond: group.node), group: group.name)
					break
				case "BondProperty_BondProperty_":
					let property: BondProperty = node as! BondProperty
					delegate?.graph?(self, didInsertBond: Bond(bond: property.node), property: property.name, value: property.value)
					break
				default:
					assert(false, "[GraphKit Error: Graph observed an object that is invalid.]")
				}
			}
		}
		
		// updates
		let updatedSet: NSSet = userInfo?[NSUpdatedObjectsKey] as! NSSet
		let	updated: NSMutableSet = updatedSet.mutableCopy() as! NSMutableSet
		updated.filterUsingPredicate(masterPredicate!)
		
		if 0 < updated.count {
			let nodes: Array<NSManagedObject> = updated.allObjects as! [NSManagedObject]
			for node: NSManagedObject in nodes {
				let className = String.fromCString(object_getClassName(node))
				if nil == className {
					println("[GraphKit Error: Cannot get Object Class name.]")
					continue
				}
				switch(className!) {
				case "EntityProperty_EntityProperty_":
					let property: EntityProperty = node as! EntityProperty
					delegate?.graph?(self, didUpdateEntity: Entity(entity: property.node), property: property.name, value: property.value)
					break
				case "ActionProperty_ActionProperty_":
					let property: ActionProperty = node as! ActionProperty
					delegate?.graph?(self, didUpdateAction: Action(action: property.node), property: property.name, value: property.value)
					break
				case "BondProperty_BondProperty_":
					let property: BondProperty = node as! BondProperty
					delegate?.graph?(self, didUpdateBond: Bond(bond: property.node), property: property.name, value: property.value)
					break
				case "ManagedAction_ManagedAction_":
					delegate?.graph?(self, didUpdateAction: Action(action: node as! ManagedAction))
					break
				default:
					assert(false, "[GraphKit Error: Graph observed an object that is invalid.]")
				}
			}
			
		}
		
		// deletes
		var deletedSet: NSSet? = userInfo?[NSDeletedObjectsKey] as? NSSet
		
		if nil == deletedSet {
			return
		}
		
		var	deleted: NSMutableSet = deletedSet!.mutableCopy() as! NSMutableSet
		deleted.filterUsingPredicate(masterPredicate!)
		
		if 0 < deleted.count {
			let nodes: Array<NSManagedObject> = deleted.allObjects as! [NSManagedObject]
			for node: NSManagedObject in nodes {
				let className = String.fromCString(object_getClassName(node))
				if nil == className {
					println("[GraphKit Error: Cannot get Object Class name.]")
					continue
				}
				switch(className!) {
				case "ManagedEntity_ManagedEntity_":
					delegate?.graph?(self, didDeleteEntity: Entity(entity: node as! ManagedEntity))
					break
				case "ManagedAction_ManagedAction_":
					delegate?.graph?(self, didDeleteAction: Action(action: node as! ManagedAction))
					break
				case "ManagedBond_ManagedBond_":
					delegate?.graph?(self, didDeleteBond: Bond(bond: node as! ManagedBond))
					break
				default:break
				}
			}
		}
	}
	
	/**
	* worker
	* A NSManagedObjectContext that is configured to be thread safe
	* for the NSManagedObjects calling on it.
	*/
	internal var worker: NSManagedObjectContext? {
		dispatch_once(&GraphMainManagedObjectContext.onceToken) {
			GraphMainManagedObjectContext.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			GraphMainManagedObjectContext.managedObjectContext?.parentContext = self.privateContext
		}
		return GraphPrivateManagedObjectContext.managedObjectContext
	}
	
	// make thread safe by creating this asynchronously
	private var privateContext: NSManagedObjectContext? {
		dispatch_once(&GraphPrivateManagedObjectContext.onceToken) {
			GraphPrivateManagedObjectContext.managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
			GraphPrivateManagedObjectContext.managedObjectContext?.persistentStoreCoordinator = self.persistentStoreCoordinator
		}
		return GraphPrivateManagedObjectContext.managedObjectContext
	}
	
	private var managedObjectModel: NSManagedObjectModel? {
		dispatch_once(&GraphManagedObjectModel.onceToken) {
			GraphManagedObjectModel.managedObjectModel = NSManagedObjectModel()
			
			var entityDescription: NSEntityDescription = NSEntityDescription()
			var entityProperties: Array<AnyObject> = Array<AnyObject>()
			entityDescription.name = GraphUtility.entityDescriptionName
			entityDescription.managedObjectClassName = GraphUtility.entityObjectClassName
			
			var actionDescription: NSEntityDescription = NSEntityDescription()
			var actionProperties: Array<AnyObject> = Array<AnyObject>()
			actionDescription.name = GraphUtility.actionDescriptionName
			actionDescription.managedObjectClassName = GraphUtility.actionObjectClassName
			
			var bondDescription: NSEntityDescription = NSEntityDescription()
			var bondProperties: Array<AnyObject> = Array<AnyObject>()
			bondDescription.name = GraphUtility.bondDescriptionName
			bondDescription.managedObjectClassName = GraphUtility.bondObjectClassName
			
			var entityPropertyDescription: NSEntityDescription = NSEntityDescription()
			var entityPropertyProperties: Array<AnyObject> = Array<AnyObject>()
			entityPropertyDescription.name = GraphUtility.entityPropertyDescriptionName
			entityPropertyDescription.managedObjectClassName = GraphUtility.entityPropertyObjectClassName
			
			var actionPropertyDescription: NSEntityDescription = NSEntityDescription()
			var actionPropertyProperties: Array<AnyObject> = Array<AnyObject>()
			actionPropertyDescription.name = GraphUtility.actionPropertyDescriptionName
			actionPropertyDescription.managedObjectClassName = GraphUtility.actionPropertyObjectClassName
			
			var bondPropertyDescription: NSEntityDescription = NSEntityDescription()
			var bondPropertyProperties: Array<AnyObject> = Array<AnyObject>()
			bondPropertyDescription.name = GraphUtility.bondPropertyDescriptionName
			bondPropertyDescription.managedObjectClassName = GraphUtility.bondPropertyObjectClassName
			
			var entityGroupDescription: NSEntityDescription = NSEntityDescription()
			var entityGroupProperties: Array<AnyObject> = Array<AnyObject>()
			entityGroupDescription.name = GraphUtility.entityGroupDescriptionName
			entityGroupDescription.managedObjectClassName = GraphUtility.entityGroupObjectClassName
			
			var actionGroupDescription: NSEntityDescription = NSEntityDescription()
			var actionGroupProperties: Array<AnyObject> = Array<AnyObject>()
			actionGroupDescription.name = GraphUtility.actionGroupDescriptionName
			actionGroupDescription.managedObjectClassName = GraphUtility.actionGroupObjectClassName
			
			var bondGroupDescription: NSEntityDescription = NSEntityDescription()
			var bondGroupProperties: Array<AnyObject> = Array<AnyObject>()
			bondGroupDescription.name = GraphUtility.bondGroupDescriptionName
			bondGroupDescription.managedObjectClassName = GraphUtility.bondGroupObjectClassName
			
			var nodeClass: NSAttributeDescription = NSAttributeDescription()
			nodeClass.name = "nodeClass"
			nodeClass.attributeType = .StringAttributeType
			nodeClass.optional = false
			entityProperties.append(nodeClass.copy() as! NSAttributeDescription)
			actionProperties.append(nodeClass.copy() as! NSAttributeDescription)
			bondProperties.append(nodeClass.copy() as! NSAttributeDescription)
			
			var type: NSAttributeDescription = NSAttributeDescription()
			type.name = "type"
			type.attributeType = .StringAttributeType
			type.optional = false
			entityProperties.append(type.copy() as! NSAttributeDescription)
			actionProperties.append(type.copy() as! NSAttributeDescription)
			bondProperties.append(type.copy() as! NSAttributeDescription)
			
			var createdDate: NSAttributeDescription = NSAttributeDescription()
			createdDate.name = "createdDate"
			createdDate.attributeType = .DateAttributeType
			createdDate.optional = false
			entityProperties.append(createdDate.copy() as! NSAttributeDescription)
			actionProperties.append(createdDate.copy() as! NSAttributeDescription)
			bondProperties.append(createdDate.copy() as! NSAttributeDescription)
			
			var propertyName: NSAttributeDescription = NSAttributeDescription()
			propertyName.name = "name"
			propertyName.attributeType = .StringAttributeType
			propertyName.optional = false
			entityPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
			actionPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
			bondPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
			
			var propertyValue: NSAttributeDescription = NSAttributeDescription()
			propertyValue.name = "value"
			propertyValue.attributeType = .TransformableAttributeType
			propertyValue.attributeValueClassName = "AnyObject"
			propertyValue.optional = false
			propertyValue.storedInExternalRecord = true
			entityPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
			actionPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
			bondPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
			
			var propertyRelationship: NSRelationshipDescription = NSRelationshipDescription()
			propertyRelationship.name = "node"
			propertyRelationship.minCount = 1
			propertyRelationship.maxCount = 1
			propertyRelationship.optional = false
			propertyRelationship.deleteRule = .NullifyDeleteRule
			
			var propertySetRelationship: NSRelationshipDescription = NSRelationshipDescription()
			propertySetRelationship.name = "propertySet"
			propertySetRelationship.minCount = 0
			propertySetRelationship.maxCount = 0
			propertySetRelationship.optional = false
			propertySetRelationship.deleteRule = .CascadeDeleteRule
			propertyRelationship.inverseRelationship = propertySetRelationship
			propertySetRelationship.inverseRelationship = propertyRelationship
			
			propertyRelationship.destinationEntity = entityDescription
			propertySetRelationship.destinationEntity = entityPropertyDescription
			entityPropertyProperties.append(propertyRelationship.copy() as! NSRelationshipDescription)
			entityProperties.append(propertySetRelationship.copy() as! NSRelationshipDescription)
			
			propertyRelationship.destinationEntity = actionDescription
			propertySetRelationship.destinationEntity = actionPropertyDescription
			actionPropertyProperties.append(propertyRelationship.copy() as! NSRelationshipDescription)
			actionProperties.append(propertySetRelationship.copy() as! NSRelationshipDescription)
			
			propertyRelationship.destinationEntity = bondDescription
			propertySetRelationship.destinationEntity = bondPropertyDescription
			bondPropertyProperties.append(propertyRelationship.copy() as! NSRelationshipDescription)
			bondProperties.append(propertySetRelationship.copy() as! NSRelationshipDescription)
			
			var group: NSAttributeDescription = NSAttributeDescription()
			group.name = "name"
			group.attributeType = .StringAttributeType
			group.optional = false
			entityGroupProperties.append(group.copy() as! NSAttributeDescription)
			actionGroupProperties.append(group.copy() as! NSAttributeDescription)
			bondGroupProperties.append(group.copy() as! NSAttributeDescription)
			
			var groupRelationship: NSRelationshipDescription = NSRelationshipDescription()
			groupRelationship.name = "node"
			groupRelationship.minCount = 1
			groupRelationship.maxCount = 1
			groupRelationship.optional = false
			groupRelationship.deleteRule = .NullifyDeleteRule
			
			var groupSetRelationship: NSRelationshipDescription = NSRelationshipDescription()
			groupSetRelationship.name = "groupSet"
			groupSetRelationship.minCount = 0
			groupSetRelationship.maxCount = 0
			groupSetRelationship.optional = false
			groupSetRelationship.deleteRule = .CascadeDeleteRule
			groupRelationship.inverseRelationship = groupSetRelationship
			groupSetRelationship.inverseRelationship = groupRelationship
			
			groupRelationship.destinationEntity = entityDescription
			groupSetRelationship.destinationEntity = entityGroupDescription
			entityGroupProperties.append(groupRelationship.copy() as! NSRelationshipDescription)
			entityProperties.append(groupSetRelationship.copy() as! NSRelationshipDescription)
			
			groupRelationship.destinationEntity = actionDescription
			groupSetRelationship.destinationEntity = actionGroupDescription
			actionGroupProperties.append(groupRelationship.copy() as! NSRelationshipDescription)
			actionProperties.append(groupSetRelationship.copy() as! NSRelationshipDescription)
			
			groupRelationship.destinationEntity = bondDescription
			groupSetRelationship.destinationEntity = bondGroupDescription
			bondGroupProperties.append(groupRelationship.copy() as! NSRelationshipDescription)
			bondProperties.append(groupSetRelationship.copy() as! NSRelationshipDescription)
			
			// Inverse relationship for Subjects -- B.
			var actionSubjectSetRelationship: NSRelationshipDescription = NSRelationshipDescription()
			actionSubjectSetRelationship.name = "subjectSet"
			actionSubjectSetRelationship.minCount = 0
			actionSubjectSetRelationship.maxCount = 0
			actionSubjectSetRelationship.optional = false
			actionSubjectSetRelationship.deleteRule = .NullifyDeleteRule
			actionSubjectSetRelationship.destinationEntity = entityDescription
			
			var actionSubjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
			actionSubjectRelationship.name = "actionSubjectSet"
			actionSubjectRelationship.minCount = 0
			actionSubjectRelationship.maxCount = 0
			actionSubjectRelationship.optional = false
			actionSubjectRelationship.deleteRule = .CascadeDeleteRule
			actionSubjectRelationship.destinationEntity = actionDescription
			
			actionSubjectRelationship.inverseRelationship = actionSubjectSetRelationship
			actionSubjectSetRelationship.inverseRelationship = actionSubjectRelationship
			
			entityProperties.append(actionSubjectRelationship.copy() as! NSRelationshipDescription)
			actionProperties.append(actionSubjectSetRelationship.copy() as! NSRelationshipDescription)
			// Inverse relationship for Subjects -- E.
			
			// Inverse relationship for Objects -- B.
			var actionObjectSetRelationship: NSRelationshipDescription = NSRelationshipDescription()
			actionObjectSetRelationship.name = "objectSet"
			actionObjectSetRelationship.minCount = 0
			actionObjectSetRelationship.maxCount = 0
			actionObjectSetRelationship.optional = false
			actionObjectSetRelationship.deleteRule = .NullifyDeleteRule
			actionObjectSetRelationship.destinationEntity = entityDescription
			
			var actionObjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
			actionObjectRelationship.name = "actionObjectSet"
			actionObjectRelationship.minCount = 0
			actionObjectRelationship.maxCount = 0
			actionObjectRelationship.optional = false
			actionObjectRelationship.deleteRule = .CascadeDeleteRule
			actionObjectRelationship.destinationEntity = actionDescription
			actionObjectRelationship.inverseRelationship = actionObjectSetRelationship
			actionObjectSetRelationship.inverseRelationship = actionObjectRelationship
			
			entityProperties.append(actionObjectRelationship.copy() as! NSRelationshipDescription)
			actionProperties.append(actionObjectSetRelationship.copy() as! NSRelationshipDescription)
			// Inverse relationship for Objects -- E.
			
			// Inverse relationship for Subjects -- B.
			var bondSubjectSetRelationship = NSRelationshipDescription()
			bondSubjectSetRelationship.name = "subject"
			bondSubjectSetRelationship.minCount = 1
			bondSubjectSetRelationship.maxCount = 1
			bondSubjectSetRelationship.optional = true
			bondSubjectSetRelationship.deleteRule = .NullifyDeleteRule
			bondSubjectSetRelationship.destinationEntity = entityDescription
			
			var bondSubjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
			bondSubjectRelationship.name = "bondSubjectSet"
			bondSubjectRelationship.minCount = 0
			bondSubjectRelationship.maxCount = 0
			bondSubjectRelationship.optional = false
			bondSubjectRelationship.deleteRule = .CascadeDeleteRule
			bondSubjectRelationship.destinationEntity = bondDescription
			
			bondSubjectRelationship.inverseRelationship = bondSubjectSetRelationship
			bondSubjectSetRelationship.inverseRelationship = bondSubjectRelationship
			
			entityProperties.append(bondSubjectRelationship.copy() as! NSRelationshipDescription)
			bondProperties.append(bondSubjectSetRelationship.copy() as! NSRelationshipDescription)
			// Inverse relationship for Subjects -- E.
			
			// Inverse relationship for Objects -- B.
			var bondObjectSetRelationship = NSRelationshipDescription()
			bondObjectSetRelationship.name = "object"
			bondObjectSetRelationship.minCount = 1
			bondObjectSetRelationship.maxCount = 1
			bondObjectSetRelationship.optional = true
			bondObjectSetRelationship.deleteRule = .NullifyDeleteRule
			bondObjectSetRelationship.destinationEntity = entityDescription
			
			var bondObjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
			bondObjectRelationship.name = "bondObjectSet"
			bondObjectRelationship.minCount = 0
			bondObjectRelationship.maxCount = 0
			bondObjectRelationship.optional = false
			bondObjectRelationship.deleteRule = .CascadeDeleteRule
			bondObjectRelationship.destinationEntity = bondDescription
			bondObjectRelationship.inverseRelationship = bondObjectSetRelationship
			bondObjectSetRelationship.inverseRelationship = bondObjectRelationship
			
			entityProperties.append(bondObjectRelationship.copy() as! NSRelationshipDescription)
			bondProperties.append(bondObjectSetRelationship.copy() as! NSRelationshipDescription)
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
			
			GraphManagedObjectModel.managedObjectModel?.entities = [
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
		return GraphManagedObjectModel.managedObjectModel
	}
	
	private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
		dispatch_once(&GraphPersistentStoreCoordinator.onceToken) {
			let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent(GraphUtility.storeName)
			var error: NSError?
			GraphPersistentStoreCoordinator.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
			var options: Dictionary = [NSReadOnlyPersistentStoreOption: false, NSSQLitePragmasOption: ["journal_mode": "DELETE"]];
			if nil == GraphPersistentStoreCoordinator.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options as [NSObject : AnyObject], error: &error) {
				assert(nil == error, "[GraphKit Error: Saving to internal context.]")
			}
		}
		return GraphPersistentStoreCoordinator.persistentStoreCoordinator
	}
	
	private var applicationDocumentsDirectory: NSURL {
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.endIndex - 1] as! NSURL
	}
	
	/**
	* prepareForObservation
	* Ensures NotificationCenter is watching the callback selector for this Graph.
	*/
	private func prepareForObservation() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: privateContext)
	}
	
	/**
	* addPredicateToContextWatcher
	* Adds the given predicate to the master predicate, which holds all watchers for the Graph.
	* @param        entityDescription: NSEntityDescription!
	* @param        predicate: NSPredicate!
	*/
	private func addPredicateToContextWatcher(entityDescription: NSEntityDescription!, predicate: NSPredicate!) {
		var entityPredicate: NSPredicate = NSPredicate(format: "entity.name == %@", entityDescription.name!)
		var predicates: Array<NSPredicate> = [entityPredicate, predicate]
		let finalPredicate: NSPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(predicates)
		masterPredicate = nil != masterPredicate ? NSCompoundPredicate.orPredicateWithSubpredicates([masterPredicate!, finalPredicate]) : finalPredicate
	}
	
	/**
	* ensureWatching
	* A sanity check if the Graph is already watching the specified index and key.
	* @param        key: String!
	* @param        index: String!
	* @return       Bool, true if watching, false otherwise.
	*/
	private func ensureWatching(key: String!, index: String!) -> Bool {
		var watch: Array<String> = nil != watching[index] ? watching[index]! as Array<String> : Array<String>()
		for entry: String in watch {
			if entry == key {
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
		if true == ensureWatching(value, index: index) {
			return
		}
		var entityDescription: NSEntityDescription = NSEntityDescription()
		entityDescription.name = entityDescriptionName
		entityDescription.managedObjectClassName = managedObjectClassName
		var predicate: NSPredicate = NSPredicate(format: "%K LIKE %@", key as NSString, value as NSString)
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
	private func search(entityDescriptorName: NSString!, predicate: NSPredicate!) -> Array<AnyObject>! {
		return search(entityDescriptorName, predicate: predicate, sort: nil)
	}
	
	/**
	* search
	* Executes a search through CoreData.
	* @param        entityDescriptorName: NSString!
	* @param        predicate: NSPredicate!
	* @param		sort: Array<NSSortDescriptor>
	* @return       Array<AnyObject>!
	*/
	private func search(entityDescriptorName: NSString!, predicate: NSPredicate!, sort: Array<NSSortDescriptor>?) -> Array<AnyObject>! {
		let request: NSFetchRequest = NSFetchRequest()
		let entity: NSEntityDescription = managedObjectModel?.entitiesByName[entityDescriptorName] as! NSEntityDescription
		request.entity = entity
		request.predicate = predicate
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		request.sortDescriptors = sort
		
		var error: NSError?
		var nodes: Array<AnyObject> = Array<AnyObject>()
		
		var moc: NSManagedObjectContext? = worker
		if let result: Array<AnyObject> = moc?.executeFetchRequest(request, error: &error) {
			assert(nil == error, "[GraphKit Error: Fecthing nodes.]")
			for item: AnyObject in result {
				nodes.append(item)
			}
		}
		return nodes
	}
}