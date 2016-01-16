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
*	*	Neither the name of GraphKit nor the names of its
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

internal struct GraphPersistentStoreCoordinator {
	internal static var onceToken: dispatch_once_t = 0
	internal static var persistentStoreCoordinator: NSPersistentStoreCoordinator?
}

internal struct GraphPrivateManagedObjectContext {
	internal static var onceToken: dispatch_once_t = 0
	internal static var managedObjectContext: NSManagedObjectContext?
}

internal struct GraphMainManagedObjectContext {
	internal static var onceToken: dispatch_once_t = 0
	internal static var managedObjectContext: NSManagedObjectContext?
}

internal struct GraphManagedObjectModel {
	internal static var onceToken: dispatch_once_t = 0
	internal static var managedObjectModel: NSManagedObjectModel?
}

internal struct GraphUtility {
	internal static let storeName: String = "GraphKit.sqlite"

	internal static let entityIndexName: String = "ManagedEntity"
	internal static let entityDescriptionName: String = entityIndexName
	internal static let entityObjectClassName: String = entityIndexName
	internal static let entityGroupIndexName: String = "ManagedEntityGroup"
	internal static let entityGroupObjectClassName: String = entityGroupIndexName
	internal static let entityGroupDescriptionName: String = entityGroupIndexName
	internal static let entityPropertyIndexName: String = "ManagedEntityProperty"
	internal static let entityPropertyObjectClassName: String = entityPropertyIndexName
	internal static let entityPropertyDescriptionName: String = entityPropertyIndexName

	internal static let actionIndexName: String = "ManagedAction"
	internal static let actionDescriptionName: String = actionIndexName
	internal static let actionObjectClassName: String = actionIndexName
	internal static let actionGroupIndexName: String = "ManagedActionGroup"
	internal static let actionGroupObjectClassName: String = actionGroupIndexName
	internal static let actionGroupDescriptionName: String = actionGroupIndexName
	internal static let actionPropertyIndexName: String = "ManagedActionProperty"
	internal static let actionPropertyObjectClassName: String = actionPropertyIndexName
	internal static let actionPropertyDescriptionName: String = actionPropertyIndexName

	internal static let relationshipIndexName: String = "ManagedRelationship"
	internal static let relationshipDescriptionName: String = relationshipIndexName
	internal static let relationshipObjectClassName: String = relationshipIndexName
	internal static let relationshipGroupIndexName: String = "ManagedRelationshipGroup"
	internal static let relationshipGroupObjectClassName: String = relationshipGroupIndexName
	internal static let relationshipGroupDescriptionName: String = relationshipGroupIndexName
	internal static let relationshipPropertyIndexName: String = "ManagedRelationshipProperty"
	internal static let relationshipPropertyObjectClassName: String = relationshipPropertyIndexName
	internal static let relationshipPropertyDescriptionName: String = relationshipPropertyIndexName
}

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

@objc(Graph)
public class Graph : NSObject {
	/**
		:name:	batchSize
	*/
	public var batchSize: Int = 0 // 0 == no limit
	
	/**
		:name:	batchOffset
	*/
	public var batchOffset: Int = 0
	
	//
	//	:name:	watchers
	//
	internal lazy var watchers: Dictionary<String, Array<String>> = Dictionary<String, Array<String>>()
	
	//
	//	:name:	materPredicate
	//
	internal var masterPredicate: NSPredicate?
	
	//
	//	:name:	deinit
	//
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	/**
		:name:	delegate
	*/
	public weak var delegate: GraphDelegate?

	/**
	Performs an asynchronous save to the PersistentStoreCoordinator.
	On this save, the worker context is saved with a waiting call, 
	and since the actual file sync save is done by the parent context, 
	the save seems near instant and the heavly task of saving is
	left for the parent context that runs on a private queue. This
	save method is generally used throughout application run time.
	- Parameter completion: An Optional completion block that is
	executed when the save operation is completed.
	*/
	public func asyncSave(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
		if let w: NSManagedObjectContext = worker {
			if w.hasChanges {
				if let p: NSManagedObjectContext = privateContext {
					var error: NSError?
					var saved: Bool = false
					w.performBlockAndWait {
						do {
							try w.save()
							saved = true
						} catch let e as NSError {
							error = e
						}
					}
					if saved {
						if p.hasChanges {
							p.performBlock {
								do {
									try p.save()
									dispatch_async(dispatch_get_main_queue()) {
										completion?(success: true, error: nil)
									}
								} catch let e as NSError {
									dispatch_async(dispatch_get_main_queue()) {
										completion?(success: false, error: e)
									}
								}
							}
						}
					} else {
						dispatch_async(dispatch_get_main_queue()) {
							completion?(success: false, error: error)
						}
					}
				}
			}
		}
	}
	
	/**
	Performs a synchronous save to the PersistentStoreCoordinator.
	On this save, the worker context is saved with a waiting call,
	the parent context is passed the save instruction from the 
	worker, and rather than save asynchronously, it is saved with
	a waiting call that is also synchronous. This save should be
	used when saving data before an application terminates.
	- Parameter completion: An Optional completion block that is
	executed when the save operation is completed.
	*/
	public func syncSave(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
		if let w: NSManagedObjectContext = worker {
			if w.hasChanges {
				if let p: NSManagedObjectContext = privateContext {
					var error: NSError?
					var saved: Bool = false
					w.performBlockAndWait {
						do {
							try w.save()
							saved = true
						} catch let e as NSError {
							error = e
						}
					}
					if saved {
						if p.hasChanges {
							p.performBlockAndWait {
								do {
									try p.save()
									dispatch_async(dispatch_get_main_queue()) {
										completion?(success: true, error: nil)
									}
								} catch let e as NSError {
									dispatch_async(dispatch_get_main_queue()) {
										completion?(success: false, error: e)
									}
								}
							}
						}
					} else {
						dispatch_async(dispatch_get_main_queue()) {
							completion?(success: false, error: error)
						}
					}
				}
			}
		}
	}
	
	/**
	Clears all persisted data.
	- Parameter completion: An Optional completion block that is
	executed when the save operation is completed.
	*/
	func clear(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
		for entity in searchForEntity(types: ["*"]) {
			entity.delete()
		}
		
		for action in searchForAction(types: ["*"]) {
			action.delete()
		}
		
		for relationship in searchForRelationship(types: ["*"]) {
			relationship.delete()
		}
		
		syncSave(completion)
	}
	
	/**
	:name:	worker
	*/
	internal var worker: NSManagedObjectContext? {
		dispatch_once(&GraphMainManagedObjectContext.onceToken) { [unowned self] in
			GraphMainManagedObjectContext.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			GraphMainManagedObjectContext.managedObjectContext?.parentContext = self.privateContext
		}
		return GraphMainManagedObjectContext.managedObjectContext
	}
	
	/**
	:name:	privateContext
	*/
	internal var privateContext: NSManagedObjectContext? {
		dispatch_once(&GraphPrivateManagedObjectContext.onceToken) { [unowned self] in
			GraphPrivateManagedObjectContext.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			GraphPrivateManagedObjectContext.managedObjectContext?.persistentStoreCoordinator = self.persistentStoreCoordinator
		}
		return GraphPrivateManagedObjectContext.managedObjectContext
	}

	//
	//	:name:	managedObjectModel
	//
	internal var managedObjectModel: NSManagedObjectModel? {
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
			
			let relationshipDescription: NSEntityDescription = NSEntityDescription()
			var relationshipProperties: Array<AnyObject> = Array<AnyObject>()
			relationshipDescription.name = GraphUtility.relationshipDescriptionName
			relationshipDescription.managedObjectClassName = GraphUtility.relationshipObjectClassName
			
			let entityPropertyDescription: NSEntityDescription = NSEntityDescription()
			var entityPropertyProperties: Array<AnyObject> = Array<AnyObject>()
			entityPropertyDescription.name = GraphUtility.entityPropertyDescriptionName
			entityPropertyDescription.managedObjectClassName = GraphUtility.entityPropertyObjectClassName
			
			let actionPropertyDescription: NSEntityDescription = NSEntityDescription()
			var actionPropertyProperties: Array<AnyObject> = Array<AnyObject>()
			actionPropertyDescription.name = GraphUtility.actionPropertyDescriptionName
			actionPropertyDescription.managedObjectClassName = GraphUtility.actionPropertyObjectClassName
			
			let relationshipPropertyDescription: NSEntityDescription = NSEntityDescription()
			var relationshipPropertyProperties: Array<AnyObject> = Array<AnyObject>()
			relationshipPropertyDescription.name = GraphUtility.relationshipPropertyDescriptionName
			relationshipPropertyDescription.managedObjectClassName = GraphUtility.relationshipPropertyObjectClassName
			
			let entityGroupDescription: NSEntityDescription = NSEntityDescription()
			var entityGroupProperties: Array<AnyObject> = Array<AnyObject>()
			entityGroupDescription.name = GraphUtility.entityGroupDescriptionName
			entityGroupDescription.managedObjectClassName = GraphUtility.entityGroupObjectClassName
			
			let actionGroupDescription: NSEntityDescription = NSEntityDescription()
			var actionGroupProperties: Array<AnyObject> = Array<AnyObject>()
			actionGroupDescription.name = GraphUtility.actionGroupDescriptionName
			actionGroupDescription.managedObjectClassName = GraphUtility.actionGroupObjectClassName
			
			let relationshipGroupDescription: NSEntityDescription = NSEntityDescription()
			var relationshipGroupProperties: Array<AnyObject> = Array<AnyObject>()
			relationshipGroupDescription.name = GraphUtility.relationshipGroupDescriptionName
			relationshipGroupDescription.managedObjectClassName = GraphUtility.relationshipGroupObjectClassName
			
			let nodeClass: NSAttributeDescription = NSAttributeDescription()
			nodeClass.name = "nodeClass"
			nodeClass.attributeType = .Integer64AttributeType
			nodeClass.optional = false
			entityProperties.append(nodeClass.copy() as! NSAttributeDescription)
			actionProperties.append(nodeClass.copy() as! NSAttributeDescription)
			relationshipProperties.append(nodeClass.copy() as! NSAttributeDescription)
			
			let type: NSAttributeDescription = NSAttributeDescription()
			type.name = "type"
			type.attributeType = .StringAttributeType
			type.optional = false
			entityProperties.append(type.copy() as! NSAttributeDescription)
			actionProperties.append(type.copy() as! NSAttributeDescription)
			relationshipProperties.append(type.copy() as! NSAttributeDescription)
			
			let createdDate: NSAttributeDescription = NSAttributeDescription()
			createdDate.name = "createdDate"
			createdDate.attributeType = .DateAttributeType
			createdDate.optional = false
			entityProperties.append(createdDate.copy() as! NSAttributeDescription)
			actionProperties.append(createdDate.copy() as! NSAttributeDescription)
			relationshipProperties.append(createdDate.copy() as! NSAttributeDescription)
			
			let propertyName: NSAttributeDescription = NSAttributeDescription()
			propertyName.name = "name"
			propertyName.attributeType = .StringAttributeType
			propertyName.optional = false
			entityPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
			actionPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
			relationshipPropertyProperties.append(propertyName.copy() as! NSAttributeDescription)
			
			let propertyValue: NSAttributeDescription = NSAttributeDescription()
			propertyValue.name = "object"
			propertyValue.attributeType = .TransformableAttributeType
			propertyValue.attributeValueClassName = "AnyObject"
			propertyValue.optional = false
			propertyValue.storedInExternalRecord = true
			entityPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
			actionPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
			relationshipPropertyProperties.append(propertyValue.copy() as! NSAttributeDescription)
			
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
			
			propertyRelationship.destinationEntity = relationshipDescription
			propertySetRelationship.destinationEntity = relationshipPropertyDescription
			relationshipPropertyProperties.append(propertyRelationship.copy() as! NSRelationshipDescription)
			relationshipProperties.append(propertySetRelationship.copy() as! NSRelationshipDescription)
			
			let group: NSAttributeDescription = NSAttributeDescription()
			group.name = "name"
			group.attributeType = .StringAttributeType
			group.optional = false
			entityGroupProperties.append(group.copy() as! NSAttributeDescription)
			actionGroupProperties.append(group.copy() as! NSAttributeDescription)
			relationshipGroupProperties.append(group.copy() as! NSAttributeDescription)
			
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
			
			groupRelationship.destinationEntity = relationshipDescription
			groupSetRelationship.destinationEntity = relationshipGroupDescription
			relationshipGroupProperties.append(groupRelationship.copy() as! NSRelationshipDescription)
			relationshipProperties.append(groupSetRelationship.copy() as! NSRelationshipDescription)
			
			// Inverse relationship for Subjects -- B.
			let actionSubjectSetRelationship: NSRelationshipDescription = NSRelationshipDescription()
			actionSubjectSetRelationship.name = "subjectSet"
			actionSubjectSetRelationship.minCount = 0
			actionSubjectSetRelationship.maxCount = 0
			actionSubjectSetRelationship.optional = false
			actionSubjectSetRelationship.deleteRule = .NoActionDeleteRule
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
			actionObjectSetRelationship.deleteRule = .NoActionDeleteRule
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
			let relationshipSubjectSetRelationship = NSRelationshipDescription()
			relationshipSubjectSetRelationship.name = "subject"
			relationshipSubjectSetRelationship.minCount = 1
			relationshipSubjectSetRelationship.maxCount = 1
			relationshipSubjectSetRelationship.optional = true
			relationshipSubjectSetRelationship.deleteRule = .NoActionDeleteRule
			relationshipSubjectSetRelationship.destinationEntity = entityDescription
			
			let relationshipSubjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
			relationshipSubjectRelationship.name = "relationshipSubjectSet"
			relationshipSubjectRelationship.minCount = 0
			relationshipSubjectRelationship.maxCount = 0
			relationshipSubjectRelationship.optional = false
			relationshipSubjectRelationship.deleteRule = .CascadeDeleteRule
			relationshipSubjectRelationship.destinationEntity = relationshipDescription
			
			relationshipSubjectRelationship.inverseRelationship = relationshipSubjectSetRelationship
			relationshipSubjectSetRelationship.inverseRelationship = relationshipSubjectRelationship
			
			entityProperties.append(relationshipSubjectRelationship.copy() as! NSRelationshipDescription)
			relationshipProperties.append(relationshipSubjectSetRelationship.copy() as! NSRelationshipDescription)
			// Inverse relationship for Subjects -- E.
			
			// Inverse relationship for Objects -- B.
			let relationshipObjectSetRelationship = NSRelationshipDescription()
			relationshipObjectSetRelationship.name = "object"
			relationshipObjectSetRelationship.minCount = 1
			relationshipObjectSetRelationship.maxCount = 1
			relationshipObjectSetRelationship.optional = true
			relationshipObjectSetRelationship.deleteRule = .NoActionDeleteRule
			relationshipObjectSetRelationship.destinationEntity = entityDescription
			
			let relationshipObjectRelationship: NSRelationshipDescription = NSRelationshipDescription()
			relationshipObjectRelationship.name = "relationshipObjectSet"
			relationshipObjectRelationship.minCount = 0
			relationshipObjectRelationship.maxCount = 0
			relationshipObjectRelationship.optional = false
			relationshipObjectRelationship.deleteRule = .CascadeDeleteRule
			relationshipObjectRelationship.destinationEntity = relationshipDescription
			relationshipObjectRelationship.inverseRelationship = relationshipObjectSetRelationship
			relationshipObjectSetRelationship.inverseRelationship = relationshipObjectRelationship
			
			entityProperties.append(relationshipObjectRelationship.copy() as! NSRelationshipDescription)
			relationshipProperties.append(relationshipObjectSetRelationship.copy() as! NSRelationshipDescription)
			// Inverse relationship for Objects -- E.
			
			entityDescription.properties = entityProperties as! [NSPropertyDescription]
			entityGroupDescription.properties = entityGroupProperties as! [NSPropertyDescription]
			entityPropertyDescription.properties = entityPropertyProperties as! [NSPropertyDescription]
			
			actionDescription.properties = actionProperties as! [NSPropertyDescription]
			actionGroupDescription.properties = actionGroupProperties as! [NSPropertyDescription]
			actionPropertyDescription.properties = actionPropertyProperties as! [NSPropertyDescription]
			
			relationshipDescription.properties = relationshipProperties as! [NSPropertyDescription]
			relationshipGroupDescription.properties = relationshipGroupProperties as! [NSPropertyDescription]
			relationshipPropertyDescription.properties = relationshipPropertyProperties as! [NSPropertyDescription]
			
			GraphManagedObjectModel.managedObjectModel?.entities = [
				entityDescription,
				entityGroupDescription,
				entityPropertyDescription,
				
				actionDescription,
				actionGroupDescription,
				actionPropertyDescription,
				
				relationshipDescription,
				relationshipGroupDescription,
				relationshipPropertyDescription
			]
		}
		return GraphManagedObjectModel.managedObjectModel
	}

	//
	//	:name:	persistentStoreCoordinator
	//
	internal var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
		dispatch_once(&GraphPersistentStoreCoordinator.onceToken) { [unowned self] in
			let directory: String = "GraphKit/default"
			File.createDirectory(File.documentDirectoryPath!, name: directory, withIntermediateDirectories: true, attributes: nil) { (success: Bool, error: NSError?) -> Void in
				if !success {
					if let e: NSError = error {
						fatalError(e.localizedDescription)
					}
				}
				let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
				do {
					try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: File.URL(.DocumentDirectory, path: "\(directory)/\(GraphUtility.storeName)"), options: nil)
				} catch {
					fatalError("[GraphKit Error: There was an error creating or loading the application's saved data.]")
				}
				GraphPersistentStoreCoordinator.persistentStoreCoordinator = coordinator
			}
		}
		return GraphPersistentStoreCoordinator.persistentStoreCoordinator
	}
}
