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
*	*	Neither the name of Graph nor the names of its
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

public extension Graph {
	/**
		:name:	watchForEntity(types: groups: properties)
	*/
	public func watchForEntity(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<String>? = nil) {
		if let v: Array<String> = types {
			for x in v {
				watch(Entity: x)
			}
		}
		
		if let v: Array<String> = groups {
			for x in v {
				watch(EntityGroup: x)
			}
		}
		
		if let v: Array<String> = properties {
			for x in v {
				watch(EntityProperty: x)
			}
		}
	}
	
	/**
		:name:	watchForAction(types: groups: properties)
	*/
	public func watchForAction(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<String>? = nil) {
		if let v: Array<String> = types {
			for x in v {
				watch(Action: x)
			}
		}
		
		if let v: Array<String> = groups {
			for x in v {
				watch(ActionGroup: x)
			}
		}
		
		if let v: Array<String> = properties {
			for x in v {
				watch(ActionProperty: x)
			}
		}
	}
	
	/**
		:name:	watchForRelationship(types: groups: properties)
	*/
	public func watchForRelationship(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<String>? = nil) {
		if let v: Array<String> = types {
			for x in v {
				watch(Relationship: x)
			}
		}
		
		if let v: Array<String> = groups {
			for x in v {
				watch(RelationshipGroup: x)
			}
		}
		
		if let v: Array<String> = properties {
			for x in v {
				watch(RelationshipProperty: x)
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
	//	:name:	watch(Relationship)
	//
	internal func watch(Relationship type: String) {
		addWatcher("type", value: type, index: GraphUtility.relationshipIndexName, entityDescriptionName: GraphUtility.relationshipDescriptionName, managedObjectClassName: GraphUtility.relationshipObjectClassName)
	}
	
	//
	//	:name:	watch(RelationshipGroup)
	//
	internal func watch(RelationshipGroup name: String) {
		addWatcher("name", value: name, index: GraphUtility.relationshipGroupIndexName, entityDescriptionName: GraphUtility.relationshipGroupDescriptionName, managedObjectClassName: GraphUtility.relationshipGroupObjectClassName)
	}
	
	//
	//	:name:	watch(RelationshipProperty)
	//
	internal func watch(RelationshipProperty name: String) {
		addWatcher("name", value: name, index: GraphUtility.relationshipPropertyIndexName, entityDescriptionName: GraphUtility.relationshipPropertyDescriptionName, managedObjectClassName: GraphUtility.relationshipPropertyObjectClassName)
	}
	
	//
	//	:name:	managedObjectContextDidSave
	//
	internal func managedObjectContextDidSave(notification: NSNotification) {
		if NSThread.isMainThread() {
			notifyWatchers(notification)
		} else {
			dispatch_sync(dispatch_get_main_queue()) { [unowned self] in
				self.notifyWatchers(notification)
			}
		}
	}
	
	//
	//	:name:	prepareForObservation
	//
	internal func prepareForObservation() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: Graph.context)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(managedObjectContextDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: Graph.context)
	}
	
	//
	//	:name:	addPredicateToObserve
	//
	internal func addPredicateToObserve(entityDescription: NSEntityDescription, predicate: NSPredicate) {
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
			watchers[key] = Array<String>(arrayLiteral: index)
			return false
		}
		if watchers[key]!.contains(index) {
			return true
		}
		watchers[key]!.append(index)
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
			addPredicateToObserve(entityDescription, predicate: predicate)
			prepareForObservation()
		}
	}
	
	/**
	Notifies watchers of changes within the ManagedObjectContext.
	- Parameter notification: An NSNotification passed from the context
	save operation.
	*/
	private func notifyWatchers(notification: NSNotification) {
		let moc: NSManagedObjectContext = Graph.context!
		moc.mergeChangesFromContextDidSaveNotification(notification)
		
		let userInfo: [NSObject : AnyObject]? = notification.userInfo
		
		// inserts
		if let insertedSet: NSSet = userInfo?[NSInsertedObjectsKey] as? NSSet {
			let	inserted: NSMutableSet = insertedSet.mutableCopy() as! NSMutableSet
			
			inserted.filterUsingPredicate(masterPredicate!)
			
			if 0 < inserted.count {
				for node: NSManagedObject in inserted.allObjects as! [NSManagedObject] {
					switch String.fromCString(object_getClassName(node))! {
					case "ManagedEntity_ManagedEntity_":
						delegate?.graphDidInsertEntity?(self, entity: Entity(object: node as! ManagedEntity))
					case "ManagedEntityGroup_ManagedEntityGroup_":
						let group: ManagedEntityGroup = node as! ManagedEntityGroup
						delegate?.graphDidInsertEntityGroup?(self, entity: Entity(object: group.node), group: group.name)
					case "ManagedEntityProperty_ManagedEntityProperty_":
						let property: ManagedEntityProperty = node as! ManagedEntityProperty
						delegate?.graphDidInsertEntityProperty?(self, entity: Entity(object: property.node), property: property.name, value: property.object)
					case "ManagedAction_ManagedAction_":
						delegate?.graphDidInsertAction?(self, action: Action(object: node as! ManagedAction))
					case "ManagedActionGroup_ManagedActionGroup_":
						let group: ManagedActionGroup = node as! ManagedActionGroup
						delegate?.graphDidInsertActionGroup?(self, action: Action(object: group.node), group: group.name)
					case "ManagedActionProperty_ManagedActionProperty_":
						let property: ManagedActionProperty = node as! ManagedActionProperty
						delegate?.graphDidInsertActionProperty?(self, action: Action(object: property.node), property: property.name, value: property.object)
					case "ManagedRelationship_ManagedRelationship_":
						delegate?.graphDidInsertRelationship?(self, relationship: Relationship(object: node as! ManagedRelationship))
					case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
						let group: ManagedRelationshipGroup = node as! ManagedRelationshipGroup
						delegate?.graphDidInsertRelationshipGroup?(self, relationship: Relationship(object: group.node), group: group.name)
					case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
						let property: ManagedRelationshipProperty = node as! ManagedRelationshipProperty
						delegate?.graphDidInsertRelationshipProperty?(self, relationship: Relationship(object: property.node), property: property.name, value: property.object)
					default:
						assert(false, "[Graph Error: Graph observed an object that is invalid.]")
					}
				}
			}
		}
		
		// updates
		if let updatedSet: NSSet = userInfo?[NSUpdatedObjectsKey] as? NSSet {
			let	updated: NSMutableSet = updatedSet.mutableCopy() as! NSMutableSet
			updated.filterUsingPredicate(masterPredicate!)
			
			if 0 < updated.count {
				for node: NSManagedObject in updated.allObjects as! [NSManagedObject] {
					switch String.fromCString(object_getClassName(node))! {
					case "ManagedEntityProperty_ManagedEntityProperty_":
						let property: ManagedEntityProperty = node as! ManagedEntityProperty
						delegate?.graphDidUpdateEntityProperty?(self, entity: Entity(object: property.node), property: property.name, value: property.object)
					case "ManagedActionProperty_ManagedActionProperty_":
						let property: ManagedActionProperty = node as! ManagedActionProperty
						delegate?.graphDidUpdateActionProperty?(self, action: Action(object: property.node), property: property.name, value: property.object)
					case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
						let property: ManagedRelationshipProperty = node as! ManagedRelationshipProperty
						delegate?.graphDidUpdateRelationshipProperty?(self, relationship: Relationship(object: property.node), property: property.name, value: property.object)
					case "ManagedAction_ManagedAction_":
						delegate?.graphDidUpdateAction?(self, action: Action(object: node as! ManagedAction))
					default:
						assert(false, "[Graph Error: Graph observed an object that is invalid.]")
					}
				}
			}
		}
		
		// deletes
		if let deletedSet: NSSet = userInfo?[NSDeletedObjectsKey] as? NSSet {
			let	deleted: NSMutableSet = deletedSet.mutableCopy() as! NSMutableSet
			deleted.filterUsingPredicate(masterPredicate!)
			
			if 0 < deleted.count {
				for node: NSManagedObject in deleted.allObjects as! [NSManagedObject] {
					switch String.fromCString(object_getClassName(node))! {
					case "ManagedEntity_ManagedEntity_":
						delegate?.graphDidDeleteEntity?(self, entity: Entity(object: node as! ManagedEntity))
					case "ManagedEntityProperty_ManagedEntityProperty_":
						let property: ManagedEntityProperty = node as! ManagedEntityProperty
						delegate?.graphDidDeleteEntityProperty?(self, entity: Entity(object: property.node), property: property.name, value: property.object)
					case "ManagedEntityGroup_ManagedEntityGroup_":
						let group: ManagedEntityGroup = node as! ManagedEntityGroup
						delegate?.graphDidDeleteEntityGroup?(self, entity: Entity(object: group.node), group: group.name)
					case "ManagedAction_ManagedAction_":
						delegate?.graphDidDeleteAction?(self, action: Action(object: node as! ManagedAction))
					case "ManagedActionProperty_ManagedActionProperty_":
						let property: ManagedActionProperty = node as! ManagedActionProperty
						delegate?.graphDidDeleteActionProperty?(self, action: Action(object: property.node), property: property.name, value: property.object)
					case "ManagedActionGroup_ManagedActionGroup_":
						let group: ManagedActionGroup = node as! ManagedActionGroup
						delegate?.graphDidDeleteActionGroup?(self, action: Action(object: group.node), group: group.name)
					case "ManagedRelationship_ManagedRelationship_":
						delegate?.graphDidDeleteRelationship?(self, relationship: Relationship(object: node as! ManagedRelationship))
					case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
						let property: ManagedRelationshipProperty = node as! ManagedRelationshipProperty
						delegate?.graphDidDeleteRelationshipProperty?(self, relationship: Relationship(object: property.node), property: property.name, value: property.object)
					case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
						let group: ManagedRelationshipGroup = node as! ManagedRelationshipGroup
						delegate?.graphDidDeleteRelationshipGroup?(self, relationship: Relationship(object: group.node), group: group.name)
					default:
						assert(false, "[Graph Error: Graph observed an object that is invalid.]")
					}
				}
			}
		}
	}
}
