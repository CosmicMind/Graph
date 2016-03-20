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

internal struct GraphPersistentStoreCoordinator {
	internal static var onceToken: dispatch_once_t = 0
	internal static var persistentStoreCoordinator: NSPersistentStoreCoordinator?
}

internal struct GraphPrivateManagedObjectContext {
	internal static var onceToken: dispatch_once_t = 0
	internal static var managedObjectContext: NSManagedObjectContext?
}

internal struct GraphManagedObjectModel {
	internal static var onceToken: dispatch_once_t = 0
	internal static var managedObjectModel: NSManagedObjectModel?
}

internal struct GraphUtility {
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
	/// Graph storage name.
	public static var storeName: String = "Graph.sqlite"
	
	/// Graph storage location path.
	public static var storeURL: NSURL? = File.URL(.DocumentDirectory, path: "Graph/default")
	
	/// Graph storage type.
	public static var storeType: String = NSSQLiteStoreType
	
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
	Performs an asynchronous save.
	- Parameter completion: An Optional completion block that is
	executed when the save operation is completed.
	*/
	public func asyncSave(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
		if let p: NSManagedObjectContext = Graph.context {
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
		}
	}
	
	/**
	Performs a synchronous save.
	- Parameter completion: An Optional completion block that is
	executed when the save operation is completed.
	*/
	public func save(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
		if let p: NSManagedObjectContext = Graph.context {
			if p.hasChanges {
				p.performBlockAndWait {
					do {
						try p.save()
						completion?(success: true, error: nil)
					} catch let e as NSError {
						completion?(success: false, error: e)
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
	public func clear(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
		for entity in searchForEntity(types: ["*"]) {
			entity.delete()
		}
		
		for action in searchForAction(types: ["*"]) {
			action.delete()
		}
		
		for relationship in searchForRelationship(types: ["*"]) {
			relationship.delete()
		}
		
		save(completion)
	}
	
	/**
	:name:	context
	*/
	internal static var context: NSManagedObjectContext? {
		dispatch_once(&GraphPrivateManagedObjectContext.onceToken) {
			GraphPrivateManagedObjectContext.managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
			GraphPrivateManagedObjectContext.managedObjectContext?.undoManager
			GraphPrivateManagedObjectContext.managedObjectContext?.persistentStoreCoordinator = Graph.persistentStoreCoordinator
		}
		return GraphPrivateManagedObjectContext.managedObjectContext
	}

	//
	//	:name:	persistentStoreCoordinator
	//
	internal static var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
		dispatch_once(&GraphPersistentStoreCoordinator.onceToken) {
			File.createDirectory(Graph.storeURL!, withIntermediateDirectories: true, attributes: nil) { (success: Bool, error: NSError?) -> Void in
				if !success {
					if let e: NSError = error {
						fatalError(e.localizedDescription)
					}
				}
				let coordinator = NSPersistentStoreCoordinator(managedObjectModel: Graph.managedObjectModel!)
				do {
					try coordinator.addPersistentStoreWithType(Graph.storeType, configuration: nil, URL: Graph.storeURL!.URLByAppendingPathComponent(Graph.storeName), options: nil)
				} catch {
					fatalError("[Graph Error: There was an error creating or loading the application's saved data.]")
				}
				GraphPersistentStoreCoordinator.persistentStoreCoordinator = coordinator
			}
		}
		return GraphPersistentStoreCoordinator.persistentStoreCoordinator
	}
}
