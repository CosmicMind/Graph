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

internal struct GraphRegistry {
    static var dispatchToken: dispatch_once_t = 0
    static var cloud: [String: Bool]!
    static var privateContexts: [String: NSManagedObjectContext]!
    static var mainManagedObjectContexts: [String: NSManagedObjectContext]!
    static var managedObjectContexts: [String: NSManagedObjectContext]!
}

/**
 A helper method to ensure that the completion callback
 is always called on the main thread.
 - Parameter success: A boolean of whether the process
 was successful or not.
 - Parameter error: An optional error object to pass.
 - Parameter completion: An Optional completion block.
 */
internal func GraphCompletionCallback(success success: Bool, error: NSError?, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
    if NSThread.isMainThread() {
        completion?(success: success, error: error)
    } else {
        dispatch_sync(dispatch_get_main_queue()) {
            completion?(success: success, error: error)
        }
    }
}

/**
 A helper method to construct error messages.
 - Parameter message: The message to pass.
 - Returns: An NSError object.
 */
internal func GraphError(message message: String, domain: String = "io.cosmicmind.graph") -> NSError {
    var info = [String: AnyObject]()
    info[NSLocalizedDescriptionKey] = message
    info[NSLocalizedFailureReasonErrorKey] = message
    let error = NSError(domain: domain, code: 0001, userInfo: info)
    info[NSUnderlyingErrorKey] = error
    return error
}

public struct GraphDefaults {
    /// Datastore name.
    static let name: String = "default"
    
    /// Graph type.
    static let type: String = NSSQLiteStoreType
    
    /// URL reference to where the Graph datastore will live.
    static var location: NSURL {
        return File.path(.DocumentDirectory, path: "Graph/")!
    }
}

@objc(Graph)
public class Graph: NSObject {
    /// Graph name.
    public internal(set) var name: String!
    
    /// Graph type.
    public internal(set) var type: String!
    
    /// Graph location.
    public internal(set) var location: NSURL!
    
    /// Worker managedObjectContext.
    public internal(set) var managedObjectContext: NSManagedObjectContext!
    
    /// A reference to the watch predicate.
    public internal(set) var watchPredicate: NSPredicate?
    
    /// A reference to cache the watch values.
    public internal(set) lazy var watchers = [String: [String]]()
    
    /// Number of items to return.
    public var batchSize: Int = 0 // 0 == no limit
    
    /// Start the return results from this offset.
    public var batchOffset: Int = 0
    
    /// A reference to a delagte object.
    public weak var delegate: GraphDelegate?
    
    /// A reference to the graph completion handler.
    internal var completion: ((cloud: Bool, error: NSError?) -> Void)?
    
    /// Deinitializer that removes the Graph from NSNotificationCenter.
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Initializer to named Graph with optional type and location.
     - Parameter name: A name for the Graph.
     - Parameter type: Graph type.
     - Parameter location: A location for storage.
     executed to determine if iCloud support is available or not.
     */
    public init(name: String = GraphDefaults.name, type: String = GraphDefaults.type, location: NSURL = GraphDefaults.location) {
        super.init()
        self.name = name
        self.type = type
        self.location = location
        prepareGraphRegistry()
        prepareManagedObjectContext(enableCloud: false)
    }
    
    /**
     Initializer to named Graph with optional type and location.
     - Parameter cloud: A name for the Graph.
     - Parameter type: Graph type.
     - Parameter location: A location for storage.
     - Parameter completion: An Optional completion block that is
     executed to determine if iCloud support is available or not.
     */
    public init(cloud: String, completion: ((cloud: Bool, error: NSError?) -> Void)? = nil) {
        super.init()
        name = cloud
        type = NSSQLiteStoreType
        location = GraphDefaults.location
        self.completion = completion
        prepareGraphRegistry()
        prepareManagedObjectContext(enableCloud: true)
    }
    
    /// Prepares the registry.
    internal func prepareGraphRegistry() {
        dispatch_once(&GraphRegistry.dispatchToken) {
            GraphRegistry.cloud = [String: Bool]()
            GraphRegistry.privateContexts = [String: NSManagedObjectContext]()
            GraphRegistry.mainManagedObjectContexts = [String: NSManagedObjectContext]()
            GraphRegistry.managedObjectContexts = [String: NSManagedObjectContext]()
        }
    }
    
    /**
     Prapres the managedObjectContext.
     - Parameter iCloud: A boolean to enable iCloud.
    */
    internal func prepareManagedObjectContext(enableCloud enableCloud: Bool) {
        guard let moc = GraphRegistry.managedObjectContexts[name] else {
            location = location.URLByAppendingPathComponent(name)
            
            let privateContext = Context.createManagedContext(.PrivateQueueConcurrencyType)
            privateContext.persistentStoreCoordinator = Coordinator.createPersistentStoreCoordinator(type: type, location: location)
            
            var cloud: Bool = enableCloud
            var options: [NSObject: AnyObject]?
            
            if cloud {
                if let _ = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil) {
                    options = [NSObject: AnyObject]()
                    options?[NSMigratePersistentStoresAutomaticallyOption] = 1
                    options?[NSInferMappingModelAutomaticallyOption] = 1
                    options?[NSPersistentStoreUbiquitousContentNameKey] = name
                } else {
                    cloud = false
                }
            }
            
            if NSSQLiteStoreType == type {
                location = location.URLByAppendingPathComponent("Graph.sqlite")
            }
            
            GraphRegistry.privateContexts[name] = privateContext
            
            let mainContext = Context.createManagedContext(.MainQueueConcurrencyType, parentContext: privateContext)
            GraphRegistry.mainManagedObjectContexts[name] = mainContext
            
            managedObjectContext = Context.createManagedContext(.PrivateQueueConcurrencyType, parentContext: mainContext)
            GraphRegistry.managedObjectContexts[name] = managedObjectContext
            
            GraphRegistry.cloud[name] = cloud
            
            if cloud {
                let defaultCenter = NSNotificationCenter.defaultCenter()
                
                defaultCenter.addObserverForName(NSPersistentStoreCoordinatorStoresWillChangeNotification, object: privateContext.persistentStoreCoordinator, queue: NSOperationQueue.mainQueue(), usingBlock: { [weak self] (notification: NSNotification) in
                    self?.managedObjectContext.performBlockAndWait { [weak self] in
                        if true == self?.managedObjectContext.hasChanges {
                            self?.async()
                        } else {
                            self?.managedObjectContext.reset()
                            if NSThread.isMainThread() {
                                self?.delegate?.graphWillPrepareCloudStorage?(self!)
                            } else {
                                dispatch_sync(dispatch_get_main_queue()) {
                                    self?.delegate?.graphWillPrepareCloudStorage?(self!)
                                }
                            }
                        }
                    }
                })
                
                defaultCenter.addObserverForName(NSPersistentStoreCoordinatorStoresDidChangeNotification, object: privateContext.persistentStoreCoordinator, queue: NSOperationQueue.mainQueue(), usingBlock: { [weak self] (notification: NSNotification) in
                    self?.managedObjectContext.performBlockAndWait { [weak self] in
                        if NSThread.isMainThread() {
                            self?.delegate?.graphDidPrepareCloudStorage?(self!)
                        } else {
                            dispatch_sync(dispatch_get_main_queue()) {
                                self?.delegate?.graphDidPrepareCloudStorage?(self!)
                            }
                        }
                    }
                })
                
                defaultCenter.addObserverForName(NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: privateContext.persistentStoreCoordinator, queue: NSOperationQueue.mainQueue(), usingBlock: { [weak self] (notification: NSNotification) in
                    self?.managedObjectContext.performBlockAndWait { [weak self] in
                        self?.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
                        if NSThread.isMainThread() {
                            self?.handleDidModifyFromCloud(notification)
                            self?.handleWillDeleteFromCloud(notification)
                        } else {
                            dispatch_sync(dispatch_get_main_queue()) {
                                self?.handleDidModifyFromCloud(notification)
                                self?.handleWillDeleteFromCloud(notification)
                            }
                        }
                    }
                })
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [unowned self] in
                    dispatch_sync(dispatch_get_main_queue()) { [weak self] in
                        guard let s = self else {
                            return
                        }
                        do {
                            try privateContext.persistentStoreCoordinator?.addPersistentStoreWithType(s.type, configuration: nil, URL: s.location, options: options)
                            s.location = privateContext.persistentStoreCoordinator?.persistentStores.first?.URL
                            s.completion?(cloud: cloud, error: cloud ? nil : GraphError(message: "[Graph Error: iCloud is not supported.]"))
                        } catch {
                            fatalError("[Graph Error: There was an error creating or loading the application's saved data.]")
                        }
                    }
                }
            } else {
                do {
                    try privateContext.persistentStoreCoordinator?.addPersistentStoreWithType(type, configuration: nil, URL: location, options: options)
                    location = privateContext.persistentStoreCoordinator?.persistentStores.first?.URL
                    completion?(cloud: cloud, error: cloud ? nil : GraphError(message: "[Graph Error: iCloud is not supported.]"))
                } catch {
                    fatalError("[Graph Error: There was an error creating or loading the application's saved data.]")
                }
            }
            
            return
        }
        
        managedObjectContext = moc
        location = moc.parentContext!.parentContext!.persistentStoreCoordinator?.persistentStores.first?.URL
        
        if let v = completion {
            let cloud = GraphRegistry.cloud[name] ?? false
            v(cloud: cloud, error: cloud ? nil : GraphError(message: "[Graph Error: iCloud is not supported.]"))
        }
    }
    
    /**
     Performs a save.
     - Parameter completion: An Optional completion block that is
     executed when the save operation is completed.
     */
    public func async(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        guard let moc = managedObjectContext else {
            GraphCompletionCallback(
                success: false,
                error: GraphError(message: "[Graph Error: ManagedObjectContext does not exist."),
                completion: completion)
            return
        }
        
        moc.performBlockAndWait {
            do {
                try moc.save()
                
                guard let mainContext = moc.parentContext else {
                    GraphCompletionCallback(
                        success: false,
                        error: GraphError(message: "[Graph Error: Main ManagedObjectContext does not exist."),
                        completion: completion)
                    return
                }
                
                mainContext.performBlock {
                    do {
                        try mainContext.save()
                        
                        guard let privateContext = mainContext.parentContext else {
                            GraphCompletionCallback(
                                success: false,
                                error: GraphError(message: "[Graph Error: Private ManagedObjectContext does not exist."),
                                completion: completion)
                            return
                        }
                        
                        privateContext.performBlock {
                            do {
                                try privateContext.save()
                                GraphCompletionCallback(success: true, error: nil, completion: completion)
                            } catch let e as NSError {
                                GraphCompletionCallback(success: false, error: e, completion: completion)
                            }
                        }
                    } catch let e as NSError {
                        GraphCompletionCallback(success: false, error: e, completion: completion)
                    }
                }
            } catch let e as NSError {
                GraphCompletionCallback(success: false, error: e, completion: completion)
            }
        }
    }
    
    /**
     Performs a synchronous save.
     - Parameter completion: An Optional completion block that is
     executed when the save operation is completed.
     */
    public func sync(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        guard let moc = managedObjectContext else {
            GraphCompletionCallback(
                success: false,
                error: GraphError(message: "[Graph Error: Worker ManagedObjectContext does not exist."),
                completion: completion)
            return
        }
        
        moc.performBlockAndWait {
            do {
                try moc.save()
                
                guard let mainContext = moc.parentContext else {
                    GraphCompletionCallback(
                        success: false,
                        error: GraphError(message: "[Graph Error: Main ManagedObjectContext does not exist."),
                        completion: completion)
                    return
                }
                
                mainContext.performBlockAndWait {
                    do {
                        try mainContext.save()
                        
                        guard let privateContext = mainContext.parentContext else {
                            GraphCompletionCallback(
                                success: false,
                                error: GraphError(message: "[Graph Error: Private ManagedObjectContext does not exist."),
                                completion: completion)
                            return
                        }
                        
                        privateContext.performBlockAndWait {
                            do {
                                try privateContext.save()
                                GraphCompletionCallback(success: true, error: nil, completion: completion)
                            } catch let e as NSError {
                                GraphCompletionCallback(success: false, error: e, completion: completion)
                            }
                        }
                    } catch let e as NSError {
                        GraphCompletionCallback(success: false, error: e, completion: completion)
                    }
                }
            } catch let e as NSError {
                GraphCompletionCallback(success: false, error: e, completion: completion)
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
        
        sync(completion)
    }
    
    /**
     Handler for private ManagedObejctContext save notifications.
     Only insertions and updates are fired on this context.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func handleDidModifyFromCloud(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        if let inserted = info[NSInsertedObjectsKey] as? NSSet {
            var objects = NSMutableSet()
            
            (inserted.allObjects as! [NSManagedObjectID]).forEach { (objectID: NSManagedObjectID) in
                if let e = managedObjectContext.objectWithID(objectID) as? ManagedEntity {
                    objects.addObject(e)
                }
            }
            
            (objects.filteredSetUsingPredicate(predicate) as! Set<NSManagedObject>).forEach { [unowned self] (managedObject: NSManagedObject) in
                switch String.fromCString(object_getClassName(managedObject))! {
                case "ManagedEntity_ManagedEntity_":
                    self.delegate?.graphDidInsertEntity?(self, entity: Entity(managedNode: managedObject as! ManagedEntity), cloud: false)
                    
                case "ManagedEntityGroup_ManagedEntityGroup_":
                    let group = managedObject as! ManagedEntityGroup
                    self.delegate?.graphDidAddEntityToGroup?(self, entity: Entity(managedNode: group.node), group: group.name, cloud: false)
                    
                case "ManagedEntityProperty_ManagedEntityProperty_":
                    let property = managedObject as! ManagedEntityProperty
                    self.delegate?.graphDidInsertEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object, cloud: false)
                    
                case "ManagedAction_ManagedAction_":
                    self.delegate?.graphDidInsertAction?(self, action: Action(managedNode: managedObject as! ManagedAction), cloud: false)
                    
                case "ManagedActionGroup_ManagedActionGroup_":
                    let group: ManagedActionGroup = managedObject as! ManagedActionGroup
                    self.delegate?.graphDidAddActionToGroup?(self, action: Action(managedNode: group.node), group: group.name, cloud: false)
                    
                case "ManagedActionProperty_ManagedActionProperty_":
                    let property = managedObject as! ManagedActionProperty
                    self.delegate?.graphDidInsertActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object, cloud: false)
                    
                case "ManagedRelationship_ManagedRelationship_":
                    self.delegate?.graphDidInsertRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship), cloud: false)
                    
                case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                    let group = managedObject as! ManagedRelationshipGroup
                    self.delegate?.graphDidAddRelationshipToGroup?(self, relationship: Relationship(managedNode: group.node), group: group.name, cloud: false)
                    
                case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                    let property = managedObject as! ManagedRelationshipProperty
                    self.delegate?.graphDidInsertRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object, cloud: false)
                    
                default:
                    assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                }
            }
        }
        
        if let updated = info[NSUpdatedObjectsKey] as? NSSet {
            var objects = NSMutableSet()
            
            (updated.allObjects as! [NSManagedObjectID]).forEach { (objectID: NSManagedObjectID) in
                if let e = managedObjectContext.objectWithID(objectID) as? ManagedEntity {
                    objects.addObject(e)
                }
            }

            (objects.filteredSetUsingPredicate(predicate) as! Set<NSManagedObject>).forEach { [unowned self] (managedObject: NSManagedObject) in
                switch String.fromCString(object_getClassName(managedObject))! {
                case "ManagedEntityProperty_ManagedEntityProperty_":
                    let property = managedObject as! ManagedEntityProperty
                    self.delegate?.graphDidUpdateEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object, cloud: false)
                    
                case "ManagedActionProperty_ManagedActionProperty_":
                    let property = managedObject as! ManagedActionProperty
                    self.delegate?.graphDidUpdateActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object, cloud: false)
                    
                case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                    let property = managedObject as! ManagedRelationshipProperty
                    self.delegate?.graphDidUpdateRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object, cloud: false)
                    
                case "ManagedAction_ManagedAction_":
                    self.delegate?.graphDidUpdateAction?(self, action: Action(managedNode: managedObject as! ManagedAction), cloud: false)
                    
                case "ManagedRelationship_ManagedRelationship_":
                    self.delegate?.graphDidUpdateRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship), cloud: false)
                    
                default:
                    assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                }
            }
        }
    }
    
    /**
     Handler for managedObjectContext save notifications. Only deletions are fired on this context.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func handleWillDeleteFromCloud(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        if let deleted = info[NSDeletedObjectsKey] as? NSSet {
            var objects = NSMutableSet()
            
            (deleted.allObjects as! [NSManagedObjectID]).forEach { (objectID: NSManagedObjectID) in
                if let e = managedObjectContext.objectWithID(objectID) as? ManagedEntity {
                    objects.addObject(e)
                }
            }
            
            (objects.filteredSetUsingPredicate(predicate) as! Set<NSManagedObject>).forEach { [unowned self] (managedObject: NSManagedObject) in
                switch String.fromCString(object_getClassName(managedObject))! {
                case "ManagedEntity_ManagedEntity_":
                    self.delegate?.graphWillDeleteEntity?(self, entity: Entity(managedNode: managedObject as! ManagedEntity), cloud: false)
                    
                case "ManagedEntityProperty_ManagedEntityProperty_":
                    let property = managedObject as! ManagedEntityProperty
                    self.delegate?.graphWillDeleteEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object, cloud: false)
                    
                case "ManagedEntityGroup_ManagedEntityGroup_":
                    let group = managedObject as! ManagedEntityGroup
                    self.delegate?.graphWillRemoveEntityFromGroup?(self, entity: Entity(managedNode: group.node), group: group.name, cloud: false)
                    
                case "ManagedAction_ManagedAction_":
                    self.delegate?.graphWillDeleteAction?(self, action: Action(managedNode: managedObject as! ManagedAction), cloud: false)
                    
                case "ManagedActionProperty_ManagedActionProperty_":
                    let property = managedObject as! ManagedActionProperty
                    self.delegate?.graphWillDeleteActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object, cloud: false)
                    
                case "ManagedActionGroup_ManagedActionGroup_":
                    let group = managedObject as! ManagedActionGroup
                    self.delegate?.graphWillRemoveActionFromGroup?(self, action: Action(managedNode: group.node), group: group.name, cloud: false)
                    
                case "ManagedRelationship_ManagedRelationship_":
                    self.delegate?.graphWillDeleteRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship), cloud: false)
                    
                case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                    let property = managedObject as! ManagedRelationshipProperty
                    self.delegate?.graphWillDeleteRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object, cloud: false)
                    
                case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                    let group = managedObject as! ManagedRelationshipGroup
                    self.delegate?.graphWillRemoveRelationshipFromGroup?(self, relationship: Relationship(managedNode: group.node), group: group.name, cloud: false)
                    
                default:
                    assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                }
            }
        }
    }
}
