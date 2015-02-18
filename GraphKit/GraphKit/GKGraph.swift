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
    static let entityGroupObjectClassName: String = "GKEntityGroup"
    static let entityGroupDescriptionName: String = "GKEntityGroup"
    static let entityPropertyObjectClassName: String = "GKEntityProperty"
    static let entityPropertyDescriptionName: String = "GKEntityProperty"
    static let actionIndexName: String = "GKManagedAction"
    static let actionDescriptionName: String = "GKManagedAction"
    static let actionObjectClassName: String = "GKManagedAction"
    static let actionGroupObjectClassName: String = "GKActionGroup"
    static let actionGroupDescriptionName: String = "GKActionGroup"
    static let actionPropertyObjectClassName: String = "GKActionProperty"
    static let actionPropertyDescriptionName: String = "GKActionProperty"
}

@objc(GKGraphDelegate)
public protocol GKGraphDelegate {
    optional func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!)
    optional func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!)
    optional func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!)
    optional func graph(graph: GKGraph!, didInsertAction action: GKAction!)
    optional func graph(graph: GKGraph!, didUpdateAction action: GKAction!)
    optional func graph(graph: GKGraph!, didDeleteAction action: GKAction!)
}

@objc(GKGraph)
public class GKGraph : NSObject {
	var watching: Dictionary<String, Array<String>>
	var masterPredicate: NSPredicate?

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
    * Deinitializes the Object, mainly removing itself as an Observer for NSNotifications.
    */
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

    /**
    * watch
    * Attaches the Graph instance to Notification center in order to Observe changes for an Entity with the spcified type.
    */
    public func watch(Entity type: String!) {
        addWatcher("type", value: type, index: GKGraphUtility.entityIndexName, entityDescriptionName: GKGraphUtility.entityDescriptionName, managedObjectClassName: GKGraphUtility.entityObjectClassName)
    }

    /**
    * watch
    * Attaches the Graph instance to Notification center in order to Observe changes for an Action with the spcified type.
    */
    public func watch(Action type: String!) {
        addWatcher("type", value: type, index: GKGraphUtility.actionIndexName, entityDescriptionName: GKGraphUtility.actionDescriptionName, managedObjectClassName: GKGraphUtility.actionObjectClassName)
    }

    /**
    * save
    * Updates the persistent layer by processing all the changes in the Graph.
    */
	public func save(completion: (success: Bool, error: NSError?) -> ()) {
		managedObjectContext.performBlock {
			if !self.managedObjectContext.hasChanges {
				completion(success: true, error: nil)
				return
			}

			let (success, error): (Bool, NSError?) = self.validateConstraints()
			if !success {
				completion(success: success, error: error)
                println("[GraphKit Error: Constraint is not satisfied.]")
				return
			}

			var saveError: NSError?
			completion(success: self.managedObjectContext.save(&saveError), error: error)
			assert(nil == error, "[GraphKit Error: Saving to private context.]")
		}
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
			let nodes: Array<GKManagedNode> = inserted.allObjects as [GKManagedNode]
			for node: GKManagedNode in nodes {
				let className = String.fromCString(object_getClassName(node))
				if nil == className {
					println("[GraphKit Error: Cannot get Object Class name.]")
					continue
				}
				switch(className!) {
					case "GKManagedEntity_GKManagedEntity_":
						delegate?.graph?(self, didInsertEntity: GKEntity(entity: node as GKManagedEntity))
						break
                    case "GKManagedAction_GKManagedAction_":
						delegate?.graph?(self, didInsertAction: GKAction(action: node as GKManagedAction))
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
			let nodes: Array<GKManagedNode> = updated.allObjects as [GKManagedNode]
			for node: GKManagedNode in nodes {
				let className = String.fromCString(object_getClassName(node))
				if nil == className {
                    println("[GraphKit Error: Cannot get Object Class name.]")
					continue
				}
				switch(className!) {
					case "GKManagedEntity_GKManagedEntity_":
						delegate?.graph?(self, didUpdateEntity: GKEntity(entity: node as GKManagedEntity))
						break
                    case "GKManagedAction_GKManagedAction_":
						delegate?.graph?(self, didUpdateAction: GKAction(action: node as GKManagedAction))
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
			let nodes: Array<GKManagedNode> = deleted.allObjects as [GKManagedNode]
			for node: GKManagedNode in nodes {
				let className = String.fromCString(object_getClassName(node))
				if nil == className {
                    println("[GraphKit Error: Cannot get Object Class name.]")
					continue
				}
				switch(className!) {
					case "GKManagedEntity_GKManagedEntity_":
						delegate?.graph?(self, didDeleteEntity: GKEntity(entity: node as GKManagedEntity))
						break
                    case "GKManagedAction_GKManagedAction_":
						delegate?.graph?(self, didDeleteAction: GKAction(action: node as GKManagedAction))
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

    private var managedObjectModel: NSManagedObjectModel {
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

            var entityPropertyDescription: NSEntityDescription = NSEntityDescription()
            var entityPropertyProperties: Array<AnyObject> = Array<AnyObject>()
            entityPropertyDescription.name = GKGraphUtility.entityPropertyDescriptionName
            entityPropertyDescription.managedObjectClassName = GKGraphUtility.entityPropertyObjectClassName

            var actionPropertyDescription: NSEntityDescription = NSEntityDescription()
            var actionPropertyProperties: Array<AnyObject> = Array<AnyObject>()
            actionPropertyDescription.name = GKGraphUtility.actionPropertyDescriptionName
            actionPropertyDescription.managedObjectClassName = GKGraphUtility.actionPropertyObjectClassName
            
            var entityGroupDescription: NSEntityDescription = NSEntityDescription()
            var entityGroupProperties: Array<AnyObject> = Array<AnyObject>()
            entityGroupDescription.name = GKGraphUtility.entityGroupDescriptionName
            entityGroupDescription.managedObjectClassName = GKGraphUtility.entityGroupObjectClassName

            var actionGroupDescription: NSEntityDescription = NSEntityDescription()
            var actionGroupProperties: Array<AnyObject> = Array<AnyObject>()
            actionGroupDescription.name = GKGraphUtility.actionGroupDescriptionName
            actionGroupDescription.managedObjectClassName = GKGraphUtility.actionGroupObjectClassName

            var nodeClass: NSAttributeDescription = NSAttributeDescription()
            nodeClass.name = "nodeClass"
            nodeClass.attributeType = .StringAttributeType
            nodeClass.optional = false
            entityProperties.append(nodeClass)
            actionProperties.append(nodeClass.copy() as NSAttributeDescription)

            var type: NSAttributeDescription = NSAttributeDescription()
            type.name = "type"
            type.attributeType = .StringAttributeType
            type.optional = false
            entityProperties.append(type)
            actionProperties.append(type.copy() as NSAttributeDescription)

            var createdDate: NSAttributeDescription = NSAttributeDescription()
            createdDate.name = "createdDate"
            createdDate.attributeType = .DateAttributeType
            createdDate.optional = false
            entityProperties.append(createdDate)
            actionProperties.append(createdDate.copy() as NSAttributeDescription)

            var propertySetRelationship: NSRelationshipDescription = NSRelationshipDescription()
            propertySetRelationship.name = "propertySet"
            propertySetRelationship.minCount = 0
            propertySetRelationship.maxCount = 0
            propertySetRelationship.deleteRule = .CascadeDeleteRule
            propertySetRelationship.destinationEntity = entityPropertyDescription
            entityProperties.append(propertySetRelationship.copy() as NSRelationshipDescription)
            propertySetRelationship.destinationEntity = actionPropertyDescription
            actionProperties.append(propertySetRelationship.copy() as NSRelationshipDescription)

            var propertyName: NSAttributeDescription = NSAttributeDescription()
            propertyName.name = "name"
            propertyName.attributeType = .StringAttributeType
            propertyName.optional = false
            entityPropertyProperties.append(propertyName)
            actionPropertyProperties.append(propertyName.copy() as NSAttributeDescription)

            var propertyValue: NSAttributeDescription = NSAttributeDescription()
            propertyValue.name = "value"
            propertyValue.attributeType = .TransformableAttributeType
            propertyValue.attributeValueClassName = "AnyObject"
            propertyValue.optional = false
            propertyValue.storedInExternalRecord = true
            entityPropertyProperties.append(propertyValue)
            actionPropertyProperties.append(propertyValue.copy() as NSAttributeDescription)

            var propertyRelationship: NSRelationshipDescription = NSRelationshipDescription()
            propertyRelationship.name = "node"
            propertyRelationship.minCount = 1
            propertyRelationship.maxCount = 1
            propertyRelationship.deleteRule = .NoActionDeleteRule
            propertyRelationship.destinationEntity = entityDescription
            entityPropertyProperties.append(propertyRelationship.copy() as NSRelationshipDescription)
            propertyRelationship.destinationEntity = actionDescription
            actionPropertyProperties.append(propertyRelationship.copy() as NSRelationshipDescription)
            
            var groupSetRelationship: NSRelationshipDescription = NSRelationshipDescription()
            groupSetRelationship.name = "groupSet"
            groupSetRelationship.minCount = 0
            groupSetRelationship.maxCount = 0
            groupSetRelationship.deleteRule = .CascadeDeleteRule
            groupSetRelationship.destinationEntity = entityGroupDescription
            entityProperties.append(groupSetRelationship.copy() as NSRelationshipDescription)
            groupSetRelationship.destinationEntity = actionGroupDescription
            actionProperties.append(groupSetRelationship.copy() as NSRelationshipDescription)

            var group: NSAttributeDescription = NSAttributeDescription()
            group.name = "name"
            group.attributeType = .StringAttributeType
            group.optional = false
            entityGroupProperties.append(group)
            actionGroupProperties.append(group.copy() as NSAttributeDescription)

            var groupRelationship: NSRelationshipDescription = NSRelationshipDescription()
            groupRelationship.name = "node"
            groupRelationship.minCount = 1
            groupRelationship.maxCount = 1
            groupRelationship.deleteRule = .NoActionDeleteRule
            groupRelationship.destinationEntity = entityDescription
            entityGroupProperties.append(groupRelationship.copy() as NSRelationshipDescription)
            groupRelationship.destinationEntity = actionDescription
            actionGroupProperties.append(groupRelationship.copy() as NSRelationshipDescription)

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

            entityDescription.properties = entityProperties
            entityGroupDescription.properties = entityGroupProperties
            entityPropertyDescription.properties = entityPropertyProperties
            actionDescription.properties = actionProperties
            actionGroupDescription.properties = actionGroupProperties
            actionPropertyDescription.properties = actionPropertyProperties

            GKGraphManagedObjectModel.managedObjectModel.entities = [
                entityDescription,
                entityGroupDescription,
                entityPropertyDescription,
                actionDescription,
                actionGroupDescription,
                actionPropertyDescription
            ]
        }
        return GKGraphManagedObjectModel.managedObjectModel!
    }

    private var persistentStoreCoordinator: NSPersistentStoreCoordinator {
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
                assert(nil == error, "[GraphKit Error: Saving to private context.]")
            }
        }
        return GKGraphPersistentStoreCoordinator.persistentStoreCoordinator!
    }

    private var applicationDocumentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex - 1] as NSURL
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
