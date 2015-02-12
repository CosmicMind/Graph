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
*/

import CoreData

struct GKGraphUtility {
	static let entityStoreName: String = "GraphKit.sqlite"
	static let entityEntityIndexName: String = "GKManagedEntity"
	static let entityEntityDescriptionName: String = "GKManagedEntity"
	static let managedEntityObjectClassName: String = "GKManagedEntity"
}

@objc(GKGraph)
public class GKGraph : NSObject {
	var watching: Dictionary<String, Array<String>>
	var masterPredicate: NSPredicate?
	
	let entityStoreName: String = GKGraphUtility.entityStoreName
	let entityEntityDescriptionName: String = GKGraphUtility.entityEntityDescriptionName
	let	managedEntityObjectClassName: String = GKGraphUtility.managedEntityObjectClassName
	
	public weak var delegate: GKGraphDelegate?
	
	public override init() {
		watching = Dictionary<String, Array<String>>()
		super.init()
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	// Managed Object Model
	var managedObjectModel: NSManagedObjectModel {
		struct GKGraphManagedObjectModel {
			static var onceToken: dispatch_once_t = 0
			static var managedObjectModel: NSManagedObjectModel!
		}
		dispatch_once(&GKGraphManagedObjectModel.onceToken) { () -> Void in
			GKGraphManagedObjectModel.managedObjectModel = NSManagedObjectModel()
			
			var entityEntityDescription: NSEntityDescription = NSEntityDescription()
			var entityEntityProperties: Array<AnyObject> = Array<AnyObject>()
			entityEntityDescription.name = self.entityEntityDescriptionName
			entityEntityDescription.managedObjectClassName = self.managedEntityObjectClassName
			
			var nodeClass: NSAttributeDescription = NSAttributeDescription()
			nodeClass.name = "nodeClass"
			nodeClass.attributeType = .StringAttributeType
			nodeClass.optional = false
			entityEntityProperties.append(nodeClass)
			
			var type: NSAttributeDescription = NSAttributeDescription()
			type.name = "type"
			type.attributeType = .StringAttributeType
			type.optional = false
			entityEntityProperties.append(type)
			
			var createdDate: NSAttributeDescription = NSAttributeDescription()
			createdDate.name = "createdDate"
			createdDate.attributeType = .DateAttributeType
			createdDate.optional = false
			entityEntityProperties.append(createdDate)
			
			entityEntityDescription.properties = entityEntityProperties
			GKGraphManagedObjectModel.managedObjectModel.entities = [entityEntityDescription]
		}
		
		return GKGraphManagedObjectModel.managedObjectModel!
	}
	
	var persistentStoreCoordinator: NSPersistentStoreCoordinator {
		struct GKGraphPersistentStoreCoordinator {
			static var onceToken: dispatch_once_t = 0
			static var persistentStoreCoordinator: NSPersistentStoreCoordinator!
		}
		dispatch_once(&GKGraphPersistentStoreCoordinator.onceToken) { () -> Void in
			let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.entityStoreName)
			var error: NSError?
			GKGraphPersistentStoreCoordinator.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
			var options: Dictionary = [NSReadOnlyPersistentStoreOption: false, NSSQLitePragmasOption: ["journal_mode": "DELETE"]];
			if nil == GKGraphPersistentStoreCoordinator.persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options as NSDictionary, error: &error) {
				assert(nil == error, "Error saving in private context")
			}
		}
		return GKGraphPersistentStoreCoordinator.persistentStoreCoordinator!
	}
	
	var applicationDocumentsDirectory: NSURL {
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.endIndex - 1] as NSURL
	}
	
	// make thread safe by creating this asynchronously
	var managedObjectContext: NSManagedObjectContext {
		struct GKGraphManagedObjectContext {
			static var onceToken: dispatch_once_t = 0
			static var managedObjectContext: NSManagedObjectContext!
		}
		dispatch_once(&GKGraphManagedObjectContext.onceToken) { () -> Void in
			GKGraphManagedObjectContext.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			GKGraphManagedObjectContext.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
		}
		return GKGraphManagedObjectContext.managedObjectContext
	}
	
	public func save(completionClosure: (succeeded: Bool, error: NSError?) -> ()) {
		managedObjectContext.performBlockAndWait { () -> Void in
			if !self.managedObjectContext.hasChanges {
				completionClosure(succeeded: true, error: nil)
				return
			}
			
			let (result, error): (Bool, NSError?) = self.validateConstraints()
			if !result {
				completionClosure(succeeded: result, error: error)
				println("ERROR: Constraint is not satisfied: \(error)")
				return
			}
			
			var saveError: NSError?
			completionClosure(succeeded: self.managedObjectContext.save(&saveError), error: error)
			assert(nil == error, "Error saving in private context")
		}
	}
	
	public func watch(Entity type: String!) {
		addWatcher("type", value: type, index: GKGraphUtility.entityEntityIndexName, entityDescriptionName: GKGraphUtility.entityEntityDescriptionName, managedObjectClassName: GKGraphUtility.managedEntityObjectClassName)
	}
	
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
					println("ERROR: Cannot get object class name!")
					continue
				}
				
				switch(className!) {
					case "GKManagedEntity_GKManagedEntity_":
						delegate?.graph?(self, didInsertEntity: GKEntity(node: node as GKManagedEntity))
						break
					default:
						assert(false, "GKGraph observed object that is invalid.")
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
					println("ERROR: Cannot get object class name!")
					continue
				}
				
				switch(className!) {
					case "GKManagedEntity_GKManagedEntity_":
						delegate?.graph?(self, didUpdateEntity: GKEntity(node: node as GKManagedEntity))
						break
					default:
						assert(false, "GKGraph observed object that is invalid.")
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
					println("ERROR: Cannot get object class name!")
					continue
				}
				
				switch(className!) {
					case "GKManagedEntity_GKManagedEntity_":
						delegate?.graph?(self, didArchiveEntity: GKEntity(node: node as GKManagedEntity))
						break
					default:
						assert(false, "GKGraph observed object that is invalid.")
				}
			}
		}
	}
	
	private func prepareForObservation() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "managedObjectContextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: managedObjectContext)
	}
	
	private func addPredicateToContextWatcher(entityDescription: NSEntityDescription!, predicate: NSPredicate!) {
		var entityPredicate: NSPredicate = NSPredicate(format: "entity.name == %@", entityDescription.name!)!
		var predicates: Array<NSPredicate> = [entityPredicate, predicate]
		let finalPredicate: NSPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(predicates)
		masterPredicate = nil != masterPredicate ? NSCompoundPredicate.orPredicateWithSubpredicates([masterPredicate!, finalPredicate]) : finalPredicate
	}
	
	private func validateConstraints() -> (Bool, NSError?) {
		var result: (success: Bool, error: NSError?) = (true, nil)
		return result
	}
	
	private func isWatching(key: String!, index: String!) -> Bool {
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
	
	private func addWatcher(key: String!, value: String!, index: String!, entityDescriptionName: String!, managedObjectClassName: String!) {
		if true == isWatching(value, index: index) {
			return
		}
		var entityDescription: NSEntityDescription = NSEntityDescription()
		entityDescription.name = entityDescriptionName
		entityDescription.managedObjectClassName = managedObjectClassName
		var predicate: NSPredicate = NSPredicate(format: "%K == %@", key as NSString, value as NSString)!
		addPredicateToContextWatcher(entityDescription, predicate: predicate)
		prepareForObservation()
	}
}

@objc(GKGraphDelegate)
public protocol GKGraphDelegate {
	optional func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!)
	optional func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!)
	optional func graph(graph: GKGraph!, didArchiveEntity entity: GKEntity!)
}