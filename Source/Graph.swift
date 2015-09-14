//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import CoreData

private struct GraphPersistentStoreCoordinator {
	private static var onceToken: dispatch_once_t = 0
	private static var persistentStoreCoordinator: NSPersistentStoreCoordinator?
}

private struct GraphMainManagedObjectContext {
	private static var onceToken: dispatch_once_t = 0
	private static var managedObjectContext: NSManagedObjectContext?
}

private struct GraphPrivateManagedObjectContext {
	private static var onceToken: dispatch_once_t = 0
	private static var managedObjectContext: NSManagedObjectContext?
}

private struct GraphManagedObjectModel {
	private static var onceToken: dispatch_once_t = 0
	private static var managedObjectModel: NSManagedObjectModel?
}

internal struct GraphUtility {
	internal static let storeName: String = "GraphKit.sqlite"

	internal static let entityIndexName: String = "ManagedEntity"
	internal static let entityDescriptionName: String = entityIndexName
	internal static let entityObjectClassName: String = entityIndexName
	internal static let entityGroupIndexName: String = "ManagedEntityGroup"
	internal static let entityGroupObjectClassName: String = entityGroupIndexName
	internal static let entityGroupDescriptionName: String = entityGroupIndexName
	internal static let entityPropertyIndexName: String = "EntityProperty"
	internal static let entityPropertyObjectClassName: String = entityPropertyIndexName
	internal static let entityPropertyDescriptionName: String = entityPropertyIndexName

	internal static let actionIndexName: String = "ManagedAction"
	internal static let actionDescriptionName: String = actionIndexName
	internal static let actionObjectClassName: String = actionIndexName
	internal static let actionGroupIndexName: String = "ManagedActionGroup"
	internal static let actionGroupObjectClassName: String = actionGroupIndexName
	internal static let actionGroupDescriptionName: String = actionGroupIndexName
	internal static let actionPropertyIndexName: String = "ActionProperty"
	internal static let actionPropertyObjectClassName: String = actionPropertyIndexName
	internal static let actionPropertyDescriptionName: String = actionPropertyIndexName

	internal static let bondIndexName: String = "ManagedBond"
	internal static let bondDescriptionName: String = bondIndexName
	internal static let bondObjectClassName: String = bondIndexName
	internal static let bondGroupIndexName: String = "ManagedBondGroup"
	internal static let bondGroupObjectClassName: String = bondGroupIndexName
	internal static let bondGroupDescriptionName: String = bondGroupIndexName
	internal static let bondPropertyIndexName: String = "BondProperty"
	internal static let bondPropertyObjectClassName: String = bondPropertyIndexName
	internal static let bondPropertyDescriptionName: String = bondPropertyIndexName
}

public protocol GraphDelegate {
	func graphDidInsertEntity(graph: Graph, entity: Entity)
	func graphDidDeleteEntity(graph: Graph, entity: Entity)
	func graphDidInsertManagedEntityGroup(graph: Graph, entity: Entity, group: String)
	func graphDidDeleteManagedEntityGroup(graph: Graph, entity: Entity, group: String)
	func graphDidInsertEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject)
	func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject)
	func graphDidDeleteEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject)

	func graphDidInsertAction(graph: Graph, action: Action)
	func graphDidUpdateAction(graph: Graph, action: Action)
	func graphDidDeleteAction(graph: Graph, action: Action)
	func graphDidInsertManagedActionGroup(graph: Graph, action: Action, group: String)
	func graphDidDeleteManagedActionGroup(graph: Graph, action: Action, group: String)
	func graphDidInsertActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
	func graphDidUpdateActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
	func graphDidDeleteActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)

	func graphDidInsertBond(graph: Graph, bond: Bond)
	func graphDidDeleteBond(graph: Graph, bond: Bond)
	func graphDidInsertManagedBondGroup(graph: Graph, bond: Bond, group: String)
	func graphDidDeleteManagedBondGroup(graph: Graph, bond: Bond, group: String)
	func graphDidInsertBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject)
	func graphDidUpdateBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject)
	func graphDidDeleteBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject)
}

public extension GraphDelegate {
	func graphDidInsertEntity(graph: Graph, entity: Entity) {}
	func graphDidDeleteEntity(graph: Graph, entity: Entity) {}
	func graphDidInsertManagedEntityGroup(graph: Graph, entity: Entity, group: String) {}
	func graphDidDeleteManagedEntityGroup(graph: Graph, entity: Entity, group: String) {}
	func graphDidInsertEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {}
	func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {}
	func graphDidDeleteEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject) {}
	
	func graphDidInsertAction(graph: Graph, action: Action) {}
	func graphDidUpdateAction(graph: Graph, action: Action) {}
	func graphDidDeleteAction(graph: Graph, action: Action) {}
	func graphDidInsertManagedActionGroup(graph: Graph, action: Action, group: String) {}
	func graphDidDeleteManagedActionGroup(graph: Graph, action: Action, group: String) {}
	func graphDidInsertActionProperty(graph: Graph, action: Action, property: String, value: AnyObject) {}
	func graphDidUpdateActionProperty(graph: Graph, action: Action, property: String, value: AnyObject) {}
	func graphDidDeleteActionProperty(graph: Graph, action: Action, property: String, value: AnyObject) {}
	
	func graphDidInsertBond(graph: Graph, bond: Bond) {}
	func graphDidDeleteBond(graph: Graph, bond: Bond) {}
	func graphDidInsertManagedBondGroup(graph: Graph, bond: Bond, group: String) {}
	func graphDidDeleteManagedBondGroup(graph: Graph, bond: Bond, group: String) {}
	func graphDidInsertBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {}
	func graphDidUpdateBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {}
	func graphDidDeleteBondProperty(graph: Graph, bond: Bond, property: String, value: AnyObject) {}
}

public class Graph {
	public var batchSize: Int = 20
	public var batchOffset: Int = 0

	internal var watching: OrderedDictionary<String, OrderedSet<String>>
	internal var masterPredicate: NSPredicate?

	public var delegate: GraphDelegate?

	/**
		:name:	init
		:description:	Initializer for the Object.
	*/
	public init() {
		watching = OrderedDictionary<String, OrderedSet<String>>()
	}

	//
	//	:name:	deinit
	//
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	/**
		:name:	save
		:description:	Updates the persistent layer by processing all the changes in the Graph.
	*/
	public func save() {
		save(nil)
	}

	/**
		:name:	save
		:description:	Updates the persistent layer by processing all the changes in the Graph.
	*/
	public func save(completion: ((success: Bool, error: NSError?) -> ())?) {
		let w: NSManagedObjectContext? = worker
		let p: NSManagedObjectContext? = privateContext
		if nil != w && nil != p {
			w!.performBlockAndWait {
				var error: NSError?
				var result: Bool?
				do {
					try w!.save()
					result = true
				} catch let e as NSError {
					error = e
					result = false
				}
				dispatch_async(dispatch_get_main_queue()) {
					if false == result {
						completion?(success: false, error: error)
					} else {
						do {
							try p!.save()
							completion?(success: true, error: nil)
						} catch let e as NSError {
							completion?(success: false, error: e)
						}
					}
				}
			}
		}
	}

	/**
		:name:	watch(Entity)
		:description:	Attaches the Graph instance to NotificationCenter in order to observe changes for an Entity with the spcified type.
	*/
	public func watch(Entity type: String) {
		addWatcher("type", value: type, index: GraphUtility.entityIndexName, entityDescriptionName: GraphUtility.entityDescriptionName, managedObjectClassName: GraphUtility.entityObjectClassName)
	}

	/**
		:name:	watch(ManagedEntityGroup)
		:description:	Attaches the Graph instance to NotificationCenter in order to observe changes for an Entity with the specified group name.
	*/
	public func watch(ManagedEntityGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.entityGroupIndexName, entityDescriptionName: GraphUtility.entityGroupDescriptionName, managedObjectClassName: GraphUtility.entityGroupObjectClassName)
	}

	/**
		:name:	watch(EntityProperty)
		:description:	Attaches the Graph instance to NotificationCenter in order to observe changes for an Entity with the specified property name.
	*/
	public func watch(EntityProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.entityPropertyIndexName, entityDescriptionName: GraphUtility.entityPropertyDescriptionName, managedObjectClassName: GraphUtility.entityPropertyObjectClassName)
	}

	/**
		:name:	watch(Action)
		:description:	Attaches the Graph instance to NotificationCenter in order to Observe changes for an Action with the spcified type.
	*/
	public func watch(Action type: String) {
		addWatcher("type", value: type, index: GraphUtility.actionIndexName, entityDescriptionName: GraphUtility.actionDescriptionName, managedObjectClassName: GraphUtility.actionObjectClassName)
	}

	/**
		:name:	watch(ManagedActionGroup)
		:description:	Attaches the Graph instance to NotificationCenter in order to observe changes for an Action with the specified group name.
	*/
	public func watch(ManagedActionGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.actionGroupIndexName, entityDescriptionName: GraphUtility.actionGroupDescriptionName, managedObjectClassName: GraphUtility.actionGroupObjectClassName)
	}

	/**
		:name:	watch(ActionProperty)
		:description:	Attaches the Graph instance to NotificationCenter in order to observe changes for an Action with the specified property name.
	*/
	public func watch(ActionProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.actionPropertyIndexName, entityDescriptionName: GraphUtility.actionPropertyDescriptionName, managedObjectClassName: GraphUtility.actionPropertyObjectClassName)
	}

	/**
		:name:	watch(Bond)
		:description:	Attaches the Graph instance to NotificationCenter in order to Observe changes for an Bond with the spcified type.
	*/
	public func watch(Bond type: String) {
		addWatcher("type", value: type, index: GraphUtility.bondIndexName, entityDescriptionName: GraphUtility.bondDescriptionName, managedObjectClassName: GraphUtility.bondObjectClassName)
	}

	/**
		:name:	watch(ManagedBondGroup)
		:description:	Attaches the Graph instance to NotificationCenter in order to observe changes for an Bond with the specified group name.
	*/
	public func watch(ManagedBondGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.bondGroupIndexName, entityDescriptionName: GraphUtility.bondGroupDescriptionName, managedObjectClassName: GraphUtility.bondGroupObjectClassName)
	}

	/**
		:name:	watch(BondProperty)
		:description:	Attaches the Graph instance to NotificationCenter in order to observe changes for an Bond with the specified property name.
	*/
	public func watch(BondProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.bondPropertyIndexName, entityDescriptionName: GraphUtility.bondPropertyDescriptionName, managedObjectClassName: GraphUtility.bondPropertyObjectClassName)
	}

	/**
		:name:	search(Entity)
		:description:	Searches the Graph for Entity Objects with the following type LIKE ?.
	*/
	public func search(Entity type: String) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type as NSString), sort: [NSSortDescriptor(key: "createdDate", ascending: false)])
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for entity: ManagedEntity in entries as! Array<ManagedEntity> {
			nodes.insert(Entity(entity: entity))
		}
		return nodes
	}

	/**
		:name:	search(ManagedEntityGroup)
		:description:	Searches the Graph for Entity Group Objects with the following name LIKE ?.
	*/
	public func search(ManagedEntityGroup name: String) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for group: ManagedEntityGroup in entries as! Array<ManagedEntityGroup> {
			nodes.insert(Entity(entity: group.node))
		}
		return nodes
	}

	/**
		:name:	search(ManagedEntityGroupMap)
		:description:	Retrieves all the unique Group Names for Entity Nodes with their Entity Objects.
	*/
	public func search(ManagedEntityGroupMap name: String) -> OrderedDictionary<String, OrderedSet<Entity>> {
		let entries: Array<AnyObject> = search(GraphUtility.entityGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let dict: OrderedDictionary<String, OrderedSet<Entity>> = OrderedDictionary<String, OrderedSet<Entity>>()
		for group: ManagedEntityGroup in entries as! Array<ManagedEntityGroup> {
			if nil == dict[group.name] {
				dict[group.name] = OrderedSet<Entity>()
			}
			dict[group.name]!.insert(Entity(entity: group.node))
		}
		return dict
	}

	/**
		:name:	search(EntityProperty)
		:description:	Searches the Graph for Entity Property Objects with the following name LIKE ?.
	*/
	public func search(EntityProperty name: String) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for property: EntityProperty in entries as! Array<EntityProperty> {
			nodes.insert(Entity(entity: property.node))
		}
		return nodes
	}

	/**
		:name:	search(EntityProperty)
		:description:	Searches the Graph for Entity Property Objects with the following name == ? and value == ?.
	*/
	public func search(EntityProperty name: String, value: String) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name as NSString, value as NSString))
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for property: EntityProperty in entries as! Array<EntityProperty> {
			nodes.insert(Entity(entity: property.node))
		}
		return nodes
	}
	
	/**
		:name:	search(EntityProperty)
		:description:	Searches the Graph for Entity Property Objects with the following name == ? and value == ?.
	*/
	public func search(EntityProperty name: String, value: Int) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name as NSString, value as NSNumber))
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for property: EntityProperty in entries as! Array<EntityProperty> {
			nodes.insert(Entity(entity: property.node))
		}
		return nodes
	}

	/**
		:name:	search(Action)
		:description:	Searches the Graph for Action Objects with the following type LIKE ?.
	*/
	public func search(Action type: String) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type as NSString), sort: [NSSortDescriptor(key: "createdDate", ascending: false)])
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for action: ManagedAction in entries as! Array<ManagedAction> {
			nodes.insert(Action(action: action))
		}
		return nodes
	}

	/**
		:name:	search(ManagedActionGroup)
		:description:	Searches the Graph for Action Group Objects with the following name LIKE ?.
	*/
	public func search(ManagedActionGroup name: String) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for group: ManagedActionGroup in entries as! Array<ManagedActionGroup> {
			nodes.insert(Action(action: group.node))
		}
		return nodes
	}

	/**
		:name:	search(ManagedActionGroupMap)
		:description:	Retrieves all the unique Group Names for Action Nodes with their Action Objects.
	*/
	public func search(ManagedActionGroupMap name: String) -> OrderedDictionary<String, OrderedSet<Action>> {
		let entries: Array<AnyObject> = search(GraphUtility.actionGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let dict: OrderedDictionary<String, OrderedSet<Action>> = OrderedDictionary<String, OrderedSet<Action>>()
		for group: ManagedActionGroup in entries as! Array<ManagedActionGroup> {
			if nil == dict[group.name] {
				dict[group.name] = OrderedSet<Action>()
			}
			dict[group.name]!.insert(Action(action: group.node))
		}
		return dict
	}

	/**
		:name:	search(ActionProperty)
		:description:	Searches the Graph for Action Property Objects with the following name LIKE ?.
	*/
	public func search(ActionProperty name: String) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for property: ActionProperty in entries as! Array<ActionProperty> {
			nodes.insert(Action(action: property.node))
		}
		return nodes
	}

	/**
		:name:	search(ActionProperty)
		:description:	Searches the Graph for Action Property Objects with the following name == ? and value == ?.
	*/
	public func search(ActionProperty name: String, value: String) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name as NSString, value as NSString))
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for property: ActionProperty in entries as! Array<ActionProperty> {
			nodes.insert(Action(action: property.node))
		}
		return nodes
	}
	
	/**
		:name:	search(ActionProperty)
		:description:	Searches the Graph for Action Property Objects with the following name == ? and value == ?.
	*/
	public func search(ActionProperty name: String, value: Int) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name as NSString, value as NSNumber))
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for property: ActionProperty in entries as! Array<ActionProperty> {
			nodes.insert(Action(action: property.node))
		}
		return nodes
	}

	/**
		:name:	search(Bond)
		:description:	Searches the Graph for Bond Objects with the following type LIKE ?.
	*/
	public func search(Bond type: String) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type as NSString), sort: [NSSortDescriptor(key: "createdDate", ascending: false)])
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for bond: ManagedBond in entries as! Array<ManagedBond> {
			nodes.insert(Bond(bond: bond))
		}
		return nodes
	}

	/**
		:name:	search(ManagedBondGroup)
		:description:	Searches the Graph for Bond Group Objects with the following name LIKE ?.
	*/
	public func search(ManagedBondGroup name: String) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for group: ManagedBondGroup in entries as! Array<ManagedBondGroup> {
			nodes.insert(Bond(bond: group.node))
		}
		return nodes
	}

	/**
		:name:	search(ManagedBondGroupMap)
		:description:	Retrieves all the unique Group Names for Bond Nodes with their Bond Objects.
	*/
	public func search(ManagedBondGroupMap name: String) -> OrderedDictionary<String, OrderedSet<Bond>> {
		let entries: Array<AnyObject> = search(GraphUtility.bondGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let dict: OrderedDictionary<String, OrderedSet<Bond>> = OrderedDictionary<String, OrderedSet<Bond>>()
		for group: ManagedBondGroup in entries as! Array<ManagedBondGroup> {
			if nil == dict[group.name] {
				dict[group.name] = OrderedSet<Bond>()
			}
			dict[group.name]!.insert(Bond(bond: group.node))
		}
		return dict
	}

	/**
		:name:	search(BondProperty)
		:description:	Searches the Graph for Bond Property Objects with the following name LIKE ?.
	*/
	public func search(BondProperty name: String) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name as NSString))
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for property: BondProperty in entries as! Array<BondProperty> {
			nodes.insert(Bond(bond: property.node))
		}
		return nodes
	}

	/**
		:name:	search(BondProperty)
		:description:	Searches the Graph for Bond Property Objects with the following name == ? and value == ?.
	*/
	public func search(BondProperty name: String, value: String) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name as NSString, value as NSString))
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for property: BondProperty in entries as! Array<BondProperty> {
			nodes.insert(Bond(bond: property.node))
		}
		return nodes
	}
	
	/**
		:name:	search(BondProperty)
		:description:	Searches the Graph for Bond Property Objects with the following name == ? and value == ?.
	*/
	public func search(BondProperty name: String, value: Int) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name as NSString, value as NSNumber))
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for property: BondProperty in entries as! Array<BondProperty> {
			nodes.insert(Bond(bond: property.node))
		}
		return nodes
	}

	//
	//	:name:	managedObjectContextDidSave
	//	:description:	The callback that NotificationCenter uses when changes occur in the Graph.
	//
	public func managedObjectContextDidSave(notification: NSNotification) {
		let userInfo = notification.userInfo

		// inserts
		let insertedSet: NSSet = userInfo?[NSInsertedObjectsKey] as! NSSet
		let	inserted: NSMutableSet = insertedSet.mutableCopy() as! NSMutableSet

		inserted.filterUsingPredicate(masterPredicate!)

		if 0 < inserted.count {
			let nodes: Array<NSManagedObject> = inserted.allObjects as! [NSManagedObject]
			for node: NSManagedObject in nodes {
				let className = String.fromCString(object_getClassName(node))
				switch(className!) {
				case "ManagedEntity_ManagedEntity_":
					delegate?.graphDidInsertEntity(self, entity: Entity(entity: node as! ManagedEntity))
					break
				case "ManagedEntityGroup_ManagedEntityGroup_":
					let group: ManagedEntityGroup = node as! ManagedEntityGroup
					delegate?.graphDidInsertManagedEntityGroup(self, entity: Entity(entity: group.node), group: group.name)
					break
				case "EntityProperty_EntityProperty_":
					let property: EntityProperty = node as! EntityProperty
					delegate?.graphDidInsertEntityProperty(self, entity: Entity(entity: property.node), property: property.name, value: property.object)
					break
				case "ManagedAction_ManagedAction_":
					delegate?.graphDidInsertAction(self, action: Action(action: node as! ManagedAction))
					break
				case "ManagedActionGroup_ManagedActionGroup_":
					let group: ManagedActionGroup = node as! ManagedActionGroup
					delegate?.graphDidInsertManagedActionGroup(self, action: Action(action: group.node), group: group.name)
					break
				case "ActionProperty_ActionProperty_":
					let property: ActionProperty = node as! ActionProperty
					delegate?.graphDidInsertActionProperty(self, action: Action(action: property.node), property: property.name, value: property.object)
					break
				case "ManagedBond_ManagedBond_":
					delegate?.graphDidInsertBond(self, bond: Bond(bond: node as! ManagedBond))
					break
				case "ManagedBondGroup_ManagedBondGroup_":
					let group: ManagedBondGroup = node as! ManagedBondGroup
					delegate?.graphDidInsertManagedBondGroup(self, bond: Bond(bond: group.node), group: group.name)
					break
				case "BondProperty_BondProperty_":
					let property: BondProperty = node as! BondProperty
					delegate?.graphDidInsertBondProperty(self, bond: Bond(bond: property.node), property: property.name, value: property.object)
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
				switch(className!) {
				case "EntityProperty_EntityProperty_":
					let property: EntityProperty = node as! EntityProperty
					delegate?.graphDidUpdateEntityProperty(self, entity: Entity(entity: property.node), property: property.name, value: property.object)
					break
				case "ActionProperty_ActionProperty_":
					let property: ActionProperty = node as! ActionProperty
					delegate?.graphDidUpdateActionProperty(self, action: Action(action: property.node), property: property.name, value: property.object)
					break
				case "BondProperty_BondProperty_":
					let property: BondProperty = node as! BondProperty
					delegate?.graphDidUpdateBondProperty(self, bond: Bond(bond: property.node), property: property.name, value: property.object)
					break
				case "ManagedAction_ManagedAction_":
					delegate?.graphDidUpdateAction(self, action: Action(action: node as! ManagedAction))
					break
				default:
					assert(false, "[GraphKit Error: Graph observed an object that is invalid.]")
				}
			}

		}

		// deletes
		let deletedSet: NSSet? = userInfo?[NSDeletedObjectsKey] as? NSSet

		if nil == deletedSet {
			return
		}

		let	deleted: NSMutableSet = deletedSet!.mutableCopy() as! NSMutableSet
		deleted.filterUsingPredicate(masterPredicate!)

		if 0 < deleted.count {
			let nodes: Array<NSManagedObject> = deleted.allObjects as! [NSManagedObject]
			for node: NSManagedObject in nodes {
				let className = String.fromCString(object_getClassName(node))
				switch(className!) {
				case "ManagedEntity_ManagedEntity_":
					delegate?.graphDidDeleteEntity(self, entity: Entity(entity: node as! ManagedEntity))
					break
				case "EntityProperty_EntityProperty_":
					let property: EntityProperty = node as! EntityProperty
					delegate?.graphDidDeleteEntityProperty(self, entity: Entity(entity: property.node), property: property.name, value: property.object)
					break
				case "ManagedEntityGroup_ManagedEntityGroup_":
					let group: ManagedEntityGroup = node as! ManagedEntityGroup
					delegate?.graphDidDeleteManagedEntityGroup(self, entity: Entity(entity: group.node), group: group.name)
					break
				case "ManagedAction_ManagedAction_":
					delegate?.graphDidDeleteAction(self, action: Action(action: node as! ManagedAction))
					break
				case "ActionProperty_ActionProperty_":
					let property: ActionProperty = node as! ActionProperty
					delegate?.graphDidDeleteActionProperty(self, action: Action(action: property.node), property: property.name, value: property.object)
					break
				case "ManagedActionGroup_ManagedActionGroup_":
					let group: ManagedActionGroup = node as! ManagedActionGroup
					delegate?.graphDidDeleteManagedActionGroup(self, action: Action(action: group.node), group: group.name)
					break
				case "ManagedBond_ManagedBond_":
					delegate?.graphDidDeleteBond(self, bond: Bond(bond: node as! ManagedBond))
					break
				case "BondProperty_BondProperty_":
					let property: BondProperty = node as! BondProperty
					delegate?.graphDidDeleteBondProperty(self, bond: Bond(bond: property.node), property: property.name, value: property.object)
					break
				case "ManagedBondGroup_ManagedBondGroup_":
					let group: ManagedBondGroup = node as! ManagedBondGroup
					delegate?.graphDidDeleteManagedBondGroup(self, bond: Bond(bond: group.node), group: group.name)
					break
				default:break
				}
			}
		}
	}

	/**
		:name:	worker
		:description:	A NSManagedObjectContext that is configured to be thread safe
		for the NSManagedObjects calling on it.
	*/
	internal var worker: NSManagedObjectContext? {
		dispatch_once(&GraphMainManagedObjectContext.onceToken) {
			GraphMainManagedObjectContext.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			GraphMainManagedObjectContext.managedObjectContext?.parentContext = self.privateContext
		}
		return GraphPrivateManagedObjectContext.managedObjectContext
	}

	//
	//	:name:	privateContext
	//
	private var privateContext: NSManagedObjectContext? {
		dispatch_once(&GraphPrivateManagedObjectContext.onceToken) {
			GraphPrivateManagedObjectContext.managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
			GraphPrivateManagedObjectContext.managedObjectContext?.persistentStoreCoordinator = self.persistentStoreCoordinator
		}
		return GraphPrivateManagedObjectContext.managedObjectContext
	}

	//
	//	:name:	managedObjectModel
	//
	private var managedObjectModel: NSManagedObjectModel? {
		dispatch_once(&GraphManagedObjectModel.onceToken) {
			GraphManagedObjectModel.managedObjectModel = NSManagedObjectModel()
			
			let entityDescription: NSEntityDescription = NSEntityDescription()
			var entityProperties: Array<AnyObject> = Array<AnyObject>()
			entityDescription.name = GraphUtility.entityDescriptionName
			entityDescription.managedObjectClassName = GraphUtility.entityObjectClassName
			
			let actionDescription: NSEntityDescription = NSEntityDescription()
			var actionProperties: Array<AnyObject> = Array<AnyObject>()
			actionDescription.name = GraphUtility.actionDescriptionName
			actionDescription.managedObjectClassName = GraphUtility.actionObjectClassName
			
			let bondDescription: NSEntityDescription = NSEntityDescription()
			var bondProperties: Array<AnyObject> = Array<AnyObject>()
			bondDescription.name = GraphUtility.bondDescriptionName
			bondDescription.managedObjectClassName = GraphUtility.bondObjectClassName
			
			let entityPropertyDescription: NSEntityDescription = NSEntityDescription()
			var entityPropertyProperties: Array<AnyObject> = Array<AnyObject>()
			entityPropertyDescription.name = GraphUtility.entityPropertyDescriptionName
			entityPropertyDescription.managedObjectClassName = GraphUtility.entityPropertyObjectClassName
			
			let actionPropertyDescription: NSEntityDescription = NSEntityDescription()
			var actionPropertyProperties: Array<AnyObject> = Array<AnyObject>()
			actionPropertyDescription.name = GraphUtility.actionPropertyDescriptionName
			actionPropertyDescription.managedObjectClassName = GraphUtility.actionPropertyObjectClassName
			
			let bondPropertyDescription: NSEntityDescription = NSEntityDescription()
			var bondPropertyProperties: Array<AnyObject> = Array<AnyObject>()
			bondPropertyDescription.name = GraphUtility.bondPropertyDescriptionName
			bondPropertyDescription.managedObjectClassName = GraphUtility.bondPropertyObjectClassName
			
			let entityGroupDescription: NSEntityDescription = NSEntityDescription()
			var entityGroupProperties: Array<AnyObject> = Array<AnyObject>()
			entityGroupDescription.name = GraphUtility.entityGroupDescriptionName
			entityGroupDescription.managedObjectClassName = GraphUtility.entityGroupObjectClassName
			
			let actionGroupDescription: NSEntityDescription = NSEntityDescription()
			var actionGroupProperties: Array<AnyObject> = Array<AnyObject>()
			actionGroupDescription.name = GraphUtility.actionGroupDescriptionName
			actionGroupDescription.managedObjectClassName = GraphUtility.actionGroupObjectClassName
			
			let bondGroupDescription: NSEntityDescription = NSEntityDescription()
			var bondGroupProperties: Array<AnyObject> = Array<AnyObject>()
			bondGroupDescription.name = GraphUtility.bondGroupDescriptionName
			bondGroupDescription.managedObjectClassName = GraphUtility.bondGroupObjectClassName
			
			let nodeClass: NSAttributeDescription = NSAttributeDescription()
			nodeClass.name = "nodeClass"
			nodeClass.attributeType = .StringAttributeType
			nodeClass.optional = false
			entityProperties.append(nodeClass.copy() as! NSAttributeDescription)
			actionProperties.append(nodeClass.copy() as! NSAttributeDescription)
			bondProperties.append(nodeClass.copy() as! NSAttributeDescription)
			
			let type: NSAttributeDescription = NSAttributeDescription()
			type.name = "type"
			type.attributeType = .StringAttributeType
			type.optional = false
			entityProperties.append(type.copy() as! NSAttributeDescription)
			actionProperties.append(type.copy() as! NSAttributeDescription)
			bondProperties.append(type.copy() as! NSAttributeDescription)
			
			let createdDate: NSAttributeDescription = NSAttributeDescription()
			createdDate.name = "createdDate"
			createdDate.attributeType = .DateAttributeType
			createdDate.optional = false
			entityProperties.append(createdDate.copy() as! NSAttributeDescription)
			actionProperties.append(createdDate.copy() as! NSAttributeDescription)
			bondProperties.append(createdDate.copy() as! NSAttributeDescription)
			
			let propertyName: NSAttributeDescription = NSAttributeDescription()
			propertyName.name = "name"
			propertyName.attributeType = .StringAttributeType
			propertyName.optional = false
			entityPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
			actionPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
			bondPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
			
			let propertyValue: NSAttributeDescription = NSAttributeDescription()
			propertyValue.name = "object"
			propertyValue.attributeType = .TransformableAttributeType
			propertyValue.attributeValueClassName = "AnyObject"
			propertyValue.optional = false
			propertyValue.storedInExternalRecord = true
			entityPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
			actionPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
			bondPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
			
			let propertyRelationship: NSRelationshipDescription = NSRelationshipDescription()
			propertyRelationship.name = "node"
			propertyRelationship.minCount = 1
			propertyRelationship.maxCount = 1
			propertyRelationship.optional = false
			propertyRelationship.deleteRule = .NoActionDeleteRule
			
			let propertySetRelationship: NSRelationshipDescription = NSRelationshipDescription()
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
			
			let group: NSAttributeDescription = NSAttributeDescription()
			group.name = "name"
			group.attributeType = .StringAttributeType
			group.optional = false
			entityGroupProperties.append(group.copy() as! NSAttributeDescription)
			actionGroupProperties.append(group.copy() as! NSAttributeDescription)
			bondGroupProperties.append(group.copy() as! NSAttributeDescription)
			
			let groupRelationship: NSRelationshipDescription = NSRelationshipDescription()
			groupRelationship.name = "node"
			groupRelationship.minCount = 1
			groupRelationship.maxCount = 1
			groupRelationship.optional = false
			groupRelationship.deleteRule = .NoActionDeleteRule
			
			let groupSetRelationship: NSRelationshipDescription = NSRelationshipDescription()
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
			let actionSubjectSetRelationship: NSRelationshipDescription = NSRelationshipDescription()
			actionSubjectSetRelationship.name = "subjectSet"
			actionSubjectSetRelationship.minCount = 0
			actionSubjectSetRelationship.maxCount = 0
			actionSubjectSetRelationship.optional = false
			actionSubjectSetRelationship.deleteRule = .NullifyDeleteRule
			actionSubjectSetRelationship.destinationEntity = entityDescription
			
			let actionSubjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
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
			let actionObjectSetRelationship: NSRelationshipDescription = NSRelationshipDescription()
			actionObjectSetRelationship.name = "objectSet"
			actionObjectSetRelationship.minCount = 0
			actionObjectSetRelationship.maxCount = 0
			actionObjectSetRelationship.optional = false
			actionObjectSetRelationship.deleteRule = .NullifyDeleteRule
			actionObjectSetRelationship.destinationEntity = entityDescription
			
			let actionObjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
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
			let bondSubjectSetRelationship = NSRelationshipDescription()
			bondSubjectSetRelationship.name = "subject"
			bondSubjectSetRelationship.minCount = 1
			bondSubjectSetRelationship.maxCount = 1
			bondSubjectSetRelationship.optional = true
			bondSubjectSetRelationship.deleteRule = .NullifyDeleteRule
			bondSubjectSetRelationship.destinationEntity = entityDescription
			
			let bondSubjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
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
			let bondObjectSetRelationship = NSRelationshipDescription()
			bondObjectSetRelationship.name = "object"
			bondObjectSetRelationship.minCount = 1
			bondObjectSetRelationship.maxCount = 1
			bondObjectSetRelationship.optional = true
			bondObjectSetRelationship.deleteRule = .NullifyDeleteRule
			bondObjectSetRelationship.destinationEntity = entityDescription
			
			let bondObjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
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
			
			entityDescription.properties = entityProperties as! [NSPropertyDescription]
			entityGroupDescription.properties = entityGroupProperties as! [NSPropertyDescription]
			entityPropertyDescription.properties = entityPropertyProperties as! [NSPropertyDescription]
			
			actionDescription.properties = actionProperties as! [NSPropertyDescription]
			actionGroupDescription.properties = actionGroupProperties as! [NSPropertyDescription]
			actionPropertyDescription.properties = actionPropertyProperties as! [NSPropertyDescription]
			
			bondDescription.properties = bondProperties as! [NSPropertyDescription]
			bondGroupDescription.properties = bondGroupProperties as! [NSPropertyDescription]
			bondPropertyDescription.properties = bondPropertyProperties as! [NSPropertyDescription]
			
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

	//
	//	:name:	persistentStoreCoordinator
	//
	private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
		dispatch_once(&GraphPersistentStoreCoordinator.onceToken) {
			let storeURL = self.applicatioDirectory.URLByAppendingPathComponent(GraphUtility.storeName)
			var error: NSError?
			GraphPersistentStoreCoordinator.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
			let options: Dictionary = [NSReadOnlyPersistentStoreOption: false, NSSQLitePragmasOption: ["journal_mode": "DELETE"]];
			do {
				try GraphPersistentStoreCoordinator.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options as [NSObject : AnyObject])
			} catch let e as NSError {
				error = e
				assert(nil != error, "[GraphKit Error: Saving to internal context.]")
			} catch {
				fatalError()
			}
		}
		return GraphPersistentStoreCoordinator.persistentStoreCoordinator
	}

	//
	//	:name:	applicatioDirectory
	//
	private var applicatioDirectory: NSURL {
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.endIndex - 1] 
	}

	//
	//	:name:	prepareForObservation
	//	:description:	Ensures NotificationCenter is watching the callback selector for this Graph.
	//
	private func prepareForObservation() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: privateContext)
	}

	//
	//	:name:	addPredicateToContextWatcher
	//	:description:	Adds the given predicate to the master predicate, which holds all watchers for the Graph.
	//
	private func addPredicateToContextWatcher(entityDescription: NSEntityDescription, predicate: NSPredicate) {
		let entityPredicate: NSPredicate = NSPredicate(format: "entity.name == %@", entityDescription.name!)
		let predicates: Array<NSPredicate> = [entityPredicate, predicate]
		let finalPredicate: NSPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		masterPredicate = nil != masterPredicate ? NSCompoundPredicate(orPredicateWithSubpredicates: [masterPredicate!, finalPredicate]) : finalPredicate
	}

	//
	//	:name:	isWatching
	//	:description:	A sanity check if the Graph is already watching the specified index and key.
	//
	private func isWatching(key: String, index: String) -> Bool {
		if nil == watching[key] {
			watching[key] = OrderedSet<String>(elements: index)
			return false
		}
		if !watching[key]!.contains(index) {
			watching[key]!.insert(index)
			return false
		}
		return true
	}

	//
	//	:name:	addWatcher
	//	:description:	Adds a watcher to the Graph.
	//
	private func addWatcher(key: String, value: String, index: String, entityDescriptionName: String, managedObjectClassName: String) {
		if !isWatching(value, index: index) {
			let entityDescription: NSEntityDescription = NSEntityDescription()
			entityDescription.name = entityDescriptionName
			entityDescription.managedObjectClassName = managedObjectClassName
			let predicate: NSPredicate = NSPredicate(format: "%K LIKE %@", key as NSString, value as NSString)
			addPredicateToContextWatcher(entityDescription, predicate: predicate)
			prepareForObservation()
		}
	}

	//
	//	:name:	search
	//	:description:	Executes a search through CoreData.
	//
	private func search(entityDescriptorName: NSString, predicate: NSPredicate) -> Array<AnyObject> {
		return search(entityDescriptorName, predicate: predicate, sort: nil)
	}

	//
	//	:name:	search
	//	:description:	Executes a search through CoreData.
	//
	private func search(entityDescriptorName: NSString, predicate: NSPredicate, sort: Array<NSSortDescriptor>?) -> Array<AnyObject> {
		let request: NSFetchRequest = NSFetchRequest()
		let entity: NSEntityDescription = managedObjectModel!.entitiesByName[entityDescriptorName as String]!
		request.entity = entity
		request.predicate = predicate
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		request.sortDescriptors = sort

		var nodes: Array<AnyObject> = Array<AnyObject>()

		let moc: NSManagedObjectContext? = worker
		do {
			let result: Array<AnyObject> = try moc!.executeFetchRequest(request)
			for item: AnyObject in result {
				nodes.append(item)
			}
		} catch _ {}
		return nodes
	}
}
