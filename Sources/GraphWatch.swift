//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>.
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

public extension Graph {
	/**
		:name:	watchForEntity(types: groups: properties)
	*/
	public func watchForEntity(types types: Array<String>, groups: Array<String>? = nil, properties: Array<String>? = nil) {
		// types
		for i in types {
			watch(Entity: i)
		}
		
		// groups
		if let n: Array<String> = groups {
			for i in n {
				watch(EntityGroup: i)
			}
		}
		
		// properties
		if let n: Array<String> = properties {
			for i in n {
				watch(EntityProperty: i)
			}
		}
	}
	
	/**
		:name:	watchForAction(types: groups: properties)
	*/
	public func watchForAction(types types: Array<String>, groups: Array<String>? = nil, properties: Array<String>? = nil) {
		// types
		for i in types {
			watch(Action: i)
		}
		
		// groups
		if let n: Array<String> = groups {
			for i in n {
				watch(ActionGroup: i)
			}
		}
		
		// properties
		if let n: Array<String> = properties {
			for i in n {
				watch(ActionProperty: i)
			}
		}
	}
	
	/**
		:name:	watchForBond(types: groups: properties)
	*/
	public func watchForBond(types types: Array<String>, groups: Array<String>? = nil, properties: Array<String>? = nil) {
		// types
		for i in types {
			watch(Bond: i)
		}
		
		// groups
		if let n: Array<String> = groups {
			for i in n {
				watch(BondGroup: i)
			}
		}
		
		// properties
		if let n: Array<String> = properties {
			for i in n {
				watch(BondProperty: i)
			}
		}
	}
	
	//
	//	:name:	watch(Entity)
	//
	internal func watch(Entity type: String) {
		addWatcher("type", value: type, index: GraphUtility.entityIndexName, entityDescriptionName: GraphUtility.entityDescriptionName, managedObjectClassName: GraphUtility.entityObjectClassName)
	}
	
	//
	//	:name:	watch(EntityGroup)
	//
	internal func watch(EntityGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.entityGroupIndexName, entityDescriptionName: GraphUtility.entityGroupDescriptionName, managedObjectClassName: GraphUtility.entityGroupObjectClassName)
	}
	
	//
	//	:name:	watch(EntityProperty)
	//
	internal func watch(EntityProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.entityPropertyIndexName, entityDescriptionName: GraphUtility.entityPropertyDescriptionName, managedObjectClassName: GraphUtility.entityPropertyObjectClassName)
	}
	
	//
	//	:name:	watch(Action)
	//
	internal func watch(Action type: String) {
		addWatcher("type", value: type, index: GraphUtility.actionIndexName, entityDescriptionName: GraphUtility.actionDescriptionName, managedObjectClassName: GraphUtility.actionObjectClassName)
	}
	
	//
	//	:name:	watch(ActionGroup)
	//
	internal func watch(ActionGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.actionGroupIndexName, entityDescriptionName: GraphUtility.actionGroupDescriptionName, managedObjectClassName: GraphUtility.actionGroupObjectClassName)
	}
	
	//
	//	:name:	watch(ActionProperty)
	//
	internal func watch(ActionProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.actionPropertyIndexName, entityDescriptionName: GraphUtility.actionPropertyDescriptionName, managedObjectClassName: GraphUtility.actionPropertyObjectClassName)
	}
	
	//
	//	:name:	watch(Bond)
	//
	internal func watch(Bond type: String) {
		addWatcher("type", value: type, index: GraphUtility.bondIndexName, entityDescriptionName: GraphUtility.bondDescriptionName, managedObjectClassName: GraphUtility.bondObjectClassName)
	}
	
	//
	//	:name:	watch(BondGroup)
	//
	internal func watch(BondGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.bondGroupIndexName, entityDescriptionName: GraphUtility.bondGroupDescriptionName, managedObjectClassName: GraphUtility.bondGroupObjectClassName)
	}
	
	//
	//	:name:	watch(BondProperty)
	//
	internal func watch(BondProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.bondPropertyIndexName, entityDescriptionName: GraphUtility.bondPropertyDescriptionName, managedObjectClassName: GraphUtility.bondPropertyObjectClassName)
	}
	
	//
	//	:name:	managedObjectContextDidSave
	//
	internal func managedObjectContextDidSave(notification: NSNotification) {
		let userInfo: [NSObject : AnyObject]? = notification.userInfo
		
		// inserts
		if let insertedSet: NSSet = userInfo?[NSInsertedObjectsKey] as? NSSet {
			let	inserted: NSMutableSet = insertedSet.mutableCopy() as! NSMutableSet
			
			inserted.filterUsingPredicate(self.masterPredicate!)
			
			if 0 < inserted.count {
				for node: NSManagedObject in inserted.allObjects as! [NSManagedObject] {
					switch String.fromCString(object_getClassName(node))! {
					case "ManagedEntity_ManagedEntity_":
						self.delegate?.graphDidInsertEntity?(self, entity: Entity(object: node as! ManagedEntity))
					case "ManagedEntityGroup_ManagedEntityGroup_":
						let group: ManagedEntityGroup = node as! ManagedEntityGroup
						self.delegate?.graphDidInsertEntityGroup?(self, entity: Entity(object: group.node), group: group.name)
					case "ManagedEntityProperty_ManagedEntityProperty_":
						let property: ManagedEntityProperty = node as! ManagedEntityProperty
						self.delegate?.graphDidInsertEntityProperty?(self, entity: Entity(object: property.node), property: property.name, value: property.object)
					case "ManagedAction_ManagedAction_":
						self.delegate?.graphDidInsertAction?(self, action: Action(object: node as! ManagedAction))
					case "ManagedActionGroup_ManagedActionGroup_":
						let group: ManagedActionGroup = node as! ManagedActionGroup
						self.delegate?.graphDidInsertActionGroup?(self, action: Action(object: group.node), group: group.name)
					case "ManagedActionProperty_ManagedActionProperty_":
						let property: ManagedActionProperty = node as! ManagedActionProperty
						self.delegate?.graphDidInsertActionProperty?(self, action: Action(object: property.node), property: property.name, value: property.object)
					case "ManagedBond_ManagedBond_":
						self.delegate?.graphDidInsertBond?(self, bond: Bond(object: node as! ManagedBond))
					case "ManagedBondGroup_ManagedBondGroup_":
						let group: ManagedBondGroup = node as! ManagedBondGroup
						self.delegate?.graphDidInsertBondGroup?(self, bond: Bond(object: group.node), group: group.name)
					case "ManagedBondProperty_ManagedBondProperty_":
						let property: ManagedBondProperty = node as! ManagedBondProperty
						self.delegate?.graphDidInsertBondProperty?(self, bond: Bond(object: property.node), property: property.name, value: property.object)
					default:
						assert(false, "[GraphKit Error: Graph observed an object that is invalid.]")
					}
				}
			}
		}
		
		// updates
		if let updatedSet: NSSet = userInfo?[NSUpdatedObjectsKey] as? NSSet {
			let	updated: NSMutableSet = updatedSet.mutableCopy() as! NSMutableSet
			updated.filterUsingPredicate(self.masterPredicate!)
			
			if 0 < updated.count {
				for node: NSManagedObject in updated.allObjects as! [NSManagedObject] {
					switch String.fromCString(object_getClassName(node))! {
					case "ManagedEntityProperty_ManagedEntityProperty_":
						let property: ManagedEntityProperty = node as! ManagedEntityProperty
						self.delegate?.graphDidUpdateEntityProperty?(self, entity: Entity(object: property.node), property: property.name, value: property.object)
					case "ManagedActionProperty_ManagedActionProperty_":
						let property: ManagedActionProperty = node as! ManagedActionProperty
						self.delegate?.graphDidUpdateActionProperty?(self, action: Action(object: property.node), property: property.name, value: property.object)
					case "ManagedBondProperty_ManagedBondProperty_":
						let property: ManagedBondProperty = node as! ManagedBondProperty
						self.delegate?.graphDidUpdateBondProperty?(self, bond: Bond(object: property.node), property: property.name, value: property.object)
					case "ManagedAction_ManagedAction_":
						self.delegate?.graphDidUpdateAction?(self, action: Action(object: node as! ManagedAction))
					default:
						assert(false, "[GraphKit Error: Graph observed an object that is invalid.]")
					}
				}
			}
		}
		
		// deletes
		if let deletedSet: NSSet = userInfo?[NSDeletedObjectsKey] as? NSSet {
			let	deleted: NSMutableSet = deletedSet.mutableCopy() as! NSMutableSet
			deleted.filterUsingPredicate(self.masterPredicate!)
			
			if 0 < deleted.count {
				for node: NSManagedObject in deleted.allObjects as! [NSManagedObject] {
					switch String.fromCString(object_getClassName(node))! {
					case "ManagedEntity_ManagedEntity_":
						self.delegate?.graphDidDeleteEntity?(self, entity: Entity(object: node as! ManagedEntity))
					case "ManagedEntityProperty_ManagedEntityProperty_":
						let property: ManagedEntityProperty = node as! ManagedEntityProperty
						self.delegate?.graphDidDeleteEntityProperty?(self, entity: Entity(object: property.node), property: property.name, value: property.object)
					case "ManagedEntityGroup_ManagedEntityGroup_":
						let group: ManagedEntityGroup = node as! ManagedEntityGroup
						self.delegate?.graphDidDeleteEntityGroup?(self, entity: Entity(object: group.node), group: group.name)
					case "ManagedAction_ManagedAction_":
						self.delegate?.graphDidDeleteAction?(self, action: Action(object: node as! ManagedAction))
					case "ManagedActionProperty_ManagedActionProperty_":
						let property: ManagedActionProperty = node as! ManagedActionProperty
						self.delegate?.graphDidDeleteActionProperty?(self, action: Action(object: property.node), property: property.name, value: property.object)
					case "ManagedActionGroup_ManagedActionGroup_":
						let group: ManagedActionGroup = node as! ManagedActionGroup
						self.delegate?.graphDidDeleteActionGroup?(self, action: Action(object: group.node), group: group.name)
					case "ManagedBond_ManagedBond_":
						self.delegate?.graphDidDeleteBond?(self, bond: Bond(object: node as! ManagedBond))
					case "ManagedBondProperty_ManagedBondProperty_":
						let property: ManagedBondProperty = node as! ManagedBondProperty
						self.delegate?.graphDidDeleteBondProperty?(self, bond: Bond(object: property.node), property: property.name, value: property.object)
					case "ManagedBondGroup_ManagedBondGroup_":
						let group: ManagedBondGroup = node as! ManagedBondGroup
						self.delegate?.graphDidDeleteBondGroup?(self, bond: Bond(object: group.node), group: group.name)
					default:
						assert(false, "[GraphKit Error: Graph observed an object that is invalid.]")
					}
				}
			}
		}
	}
	
	//
	//	:name:	prepareForObservation
	//
	internal func prepareForObservation() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: worker)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: worker)
	}
	
	//
	//	:name:	addPredicateToContextWatcher
	//
	internal func addPredicateToContextWatcher(entityDescription: NSEntityDescription, predicate: NSPredicate) {
		let entityPredicate: NSPredicate = NSPredicate(format: "entity.name == %@", entityDescription.name! as NSString)
		let predicates: Array<NSPredicate> = [entityPredicate, predicate]
		let finalPredicate: NSPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		masterPredicate = nil == masterPredicate ? finalPredicate : NSCompoundPredicate(orPredicateWithSubpredicates: [masterPredicate!, finalPredicate])
	}
	
	//
	//	:name:	isWatching
	//
	internal func isWatching(key: String, index: String) -> Bool {
		if nil == watchers[key] {
			watchers[key] = SortedSet<String>(elements: index)
			return false
		}
		if watchers[key]!.contains(index) {
			return true
		}
		watchers[key]!.insert(index)
		return false
	}
	
	//
	//	:name:	addWatcher
	//
	internal func addWatcher(key: String, value: String, index: String, entityDescriptionName: String, managedObjectClassName: String) {
		if !isWatching(value, index: index) {
			let entityDescription: NSEntityDescription = NSEntityDescription()
			entityDescription.name = entityDescriptionName
			entityDescription.managedObjectClassName = managedObjectClassName
			let predicate: NSPredicate = NSPredicate(format: "%K LIKE %@", key as NSString, value as NSString)
			addPredicateToContextWatcher(entityDescription, predicate: predicate)
			prepareForObservation()
		}
	}
}
