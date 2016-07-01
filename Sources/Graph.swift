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
    static var privateManagedObjectContextss: [String: NSManagedObjectContext]!
    static var mainManagedObjectContexts: [String: NSManagedObjectContext]!
    static var workerManagedObjectContexts: [String: NSManagedObjectContext]!
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
    public init(name: String = GraphDefaults.name, cloud: Bool = false, type: String = GraphDefaults.type, location: NSURL = GraphDefaults.location) {
        super.init()
        self.name = name
        self.type = type
        self.location = location
        prepareGraphRegistry()
        prepareManagedObjectContext()
    }
    
    /**
     Initializer to named Graph with optional type and location.
     - Parameter name: A name for the Graph.
     - Parameter type: Graph type.
     - Parameter location: A location for storage.
     - Parameter completion: An Optional completion block that is
     executed to determine if iCloud support is available or not.
     */
    public init(cloud: Bool, name: String = GraphDefaults.name, location: NSURL = GraphDefaults.location, completion: ((cloud: Bool, error: NSError?) -> Void)? = nil) {
        super.init()
        self.name = name
        self.type = GraphDefaults.type
        self.location = location
        self.completion = completion
        prepareGraphRegistry()
        prepareCloudManagedObjectContext()
    }
    
    /// Prepares the registry.
    internal func prepareGraphRegistry() {
        dispatch_once(&GraphRegistry.dispatchToken) {
            GraphRegistry.privateManagedObjectContextss = [String: NSManagedObjectContext]()
            GraphRegistry.mainManagedObjectContexts = [String: NSManagedObjectContext]()
            GraphRegistry.workerManagedObjectContexts = [String: NSManagedObjectContext]()
        }
    }
    
    /// Prapres the managedObjectContext.
    internal func prepareManagedObjectContext() {
        guard let moc = GraphRegistry.workerManagedObjectContexts[name] else {
            let privateManagedObjectContexts = Context.createManagedContext(.PrivateQueueConcurrencyType)
            privateManagedObjectContexts.persistentStoreCoordinator = Coordinator.createPersistentStoreCoordinator(name: name, type: type, location: location)
            
            do {
                switch type {
                case NSSQLiteStoreType:
                    location = location.URLByAppendingPathComponent("Graph.sqlite")
                default:break
                }
                try privateManagedObjectContexts.persistentStoreCoordinator?.addPersistentStoreWithType(type, configuration: nil, URL: location, options: nil)
            } catch {
                fatalError("[Graph Error: There was an error creating or loading the application's saved data.]")
            }
            
            GraphRegistry.privateManagedObjectContextss[self.name] = privateManagedObjectContexts
            
            let mainContext = Context.createManagedContext(.MainQueueConcurrencyType, parentContext: privateManagedObjectContexts)
            GraphRegistry.mainManagedObjectContexts[self.name] = mainContext
            
            self.managedObjectContext = Context.createManagedContext(.PrivateQueueConcurrencyType, parentContext: mainContext)
            GraphRegistry.workerManagedObjectContexts[self.name] = self.managedObjectContext
            
            return
        }
        
        managedObjectContext = moc
    }
    
    /// Prapres the managedObjectContext.
    internal func prepareCloudManagedObjectContext() {
        guard let moc = GraphRegistry.workerManagedObjectContexts[name] else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
                if let s = self {
                    var options = [NSObject: AnyObject]()
                    var cloud: Bool = false
                    if let cloudURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil) {
                        cloud = true
                        
                        options[NSMigratePersistentStoresAutomaticallyOption] = 1
                        options[NSInferMappingModelAutomaticallyOption] = 1
                        options[NSPersistentStoreUbiquitousContentNameKey] = s.name
//                        options[NSPersistentStoreUbiquitousContentURLKey] = cloudURL.URLByAppendingPathComponent("\(s.name)")
                        
                        print(options)
                    }
                   
                    let privateManagedObjectContexts = Context.createManagedContext(.PrivateQueueConcurrencyType)
                    privateManagedObjectContexts.persistentStoreCoordinator = Coordinator.createPersistentStoreCoordinator(name: s.name, type: s.type, location: s.location, options: options)
                    
                    GraphRegistry.privateManagedObjectContextss[s.name] = privateManagedObjectContexts
                    
                    let mainContext = Context.createManagedContext(.MainQueueConcurrencyType, parentContext: privateManagedObjectContexts)
                    GraphRegistry.mainManagedObjectContexts[s.name] = mainContext
                    
                    s.managedObjectContext = Context.createManagedContext(.PrivateQueueConcurrencyType, parentContext: mainContext)
                    GraphRegistry.workerManagedObjectContexts[s.name] = s.managedObjectContext
                    
                    if cloud {
                        s.prepareNotificationCenter()
                    }
                    
                    do {
                        switch s.type {
                        case NSSQLiteStoreType:
                            s.location = s.location.URLByAppendingPathComponent("Graph.sqlite")
                        default:break
                        }
                        try privateManagedObjectContexts.persistentStoreCoordinator?.addPersistentStoreWithType(s.type, configuration: nil, URL: s.location, options: options)
                    } catch {
                        fatalError("[Graph Error: There was an error creating or loading the application's saved data.]")
                    }
                    
                    if let loc = privateManagedObjectContexts.persistentStoreCoordinator?.persistentStores.first?.URL {
                        s.location = loc
                    }
                    print(s.location)
                    
                    s.completion?(cloud: cloud, error: cloud ? nil : GraphError(message: "[Graph Error: iCloud is not supported.]"))
                }
            }
            return
        }
        
        managedObjectContext = moc
    }
    
    /**
     Prepares the persistentStoreCoordinator to observe
     changes from iCloud.
     */
    internal func prepareNotificationCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleCloudWillChange(_:)), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: managedObjectContext!.parentContext!.parentContext!.persistentStoreCoordinator)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleCloudDidChange(_:)), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: managedObjectContext!.parentContext!.parentContext!.persistentStoreCoordinator)
    }
    
    /**
     Handler for cloud change notifications.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func handleCloudWillChange(notification: NSNotification) {
        managedObjectContext!.parentContext!.parentContext!.reset()
        print("RESET MANAGED OBJECT CONTEXT")
        
        /// Send delegate call here to disable usage with graph.
//        if NSThread.isMainThread() {
//            mergeChanges(notification)
//        } else {
//            dispatch_sync(dispatch_get_main_queue()) { [weak self] in
//                self?.mergeChanges(notification)
//            }
//        }
    }
    
    /**
     Handler for cloud change notifications.
     - Parameter notification: NSNotification reference.
     */
    @objc
    internal func handleCloudDidChange(notification: NSNotification) {
        print("CHANGED MANAGED OBJECT CONTEXT")
        
        /// send delegate call here to enable usage with graph.
        //        if NSThread.isMainThread() {
        //            mergeChanges(notification)
        //        } else {
        //            dispatch_sync(dispatch_get_main_queue()) { [weak self] in
        //                self?.mergeChanges(notification)
        //            }
        //        }
        //        guard let privateContext = managedObjectContext!.parentContext!.parentContext else {
        //            return
        //        }
        //        privateContext.performBlock {
        //            privateContext.mergeChangesFromContextDidSaveNotification(notification)
        //        }
    }

    /**
     Performs a save.
     - Parameter completion: An Optional completion block that is
     executed when the save operation is completed.
     */
    public func async(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        guard managedObjectContext.hasChanges else {
            GraphCompletionCallback(
                success: false,
                error: GraphError(message: "[Graph Error: Worker ManagedObjectContext does not have any changes."),
                completion: completion)
            return
        }
        
        managedObjectContext.performBlock { [weak self] in
            do {
                try self?.managedObjectContext.save()
                
                guard let mainContext = self?.managedObjectContext.parentContext else {
                    GraphCompletionCallback(
                        success: false,
                        error: GraphError(message: "[Graph Error: Main ManagedObjectContext does not exist."),
                        completion: completion)
                    return
                }
                
                guard mainContext.hasChanges else {
                    GraphCompletionCallback(
                        success: false,
                        error: GraphError(message: "[Graph Error: Main ManagedObjectContext does not have any changes."),
                        completion: completion)
                    return
                }
                
                mainContext.performBlock {
                    do {
                        try mainContext.save()
                        
                        guard let privateManagedObjectContexts = mainContext.parentContext else {
                            GraphCompletionCallback(
                                success: false,
                                error: GraphError(message: "[Graph Error: Private ManagedObjectContext does not exist."),
                                completion: completion)
                            return
                        }
                        
                        guard privateManagedObjectContexts.hasChanges else {
                            GraphCompletionCallback(
                                success: false,
                                error: GraphError(message: "[Graph Error: Private ManagedObjectContext does not have any changes."),
                                completion: completion)
                            return
                        }
                        
                        privateManagedObjectContexts.performBlock {
                            do {
                                try privateManagedObjectContexts.save()
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
        guard managedObjectContext.hasChanges else {
            GraphCompletionCallback(
                success: false,
                error: GraphError(message: "[Graph Error: Worker ManagedObjectContext does not have any changes."),
                completion: completion)
            return
        }
        
        managedObjectContext.performBlockAndWait { [weak self] in
            do {
                try self?.managedObjectContext.save()
                
                guard let mainContext = self?.managedObjectContext.parentContext else {
                    GraphCompletionCallback(
                        success: false,
                        error: GraphError(message: "[Graph Error: Main ManagedObjectContext does not exist."),
                        completion: completion)
                    return
                }
                
                guard mainContext.hasChanges else {
                    GraphCompletionCallback(
                        success: false,
                        error: GraphError(message: "[Graph Error: Main ManagedObjectContext does not have any changes."),
                        completion: completion)
                    return
                }
                
                mainContext.performBlockAndWait {
                    do {
                        try mainContext.save()
                        
                        guard let privateManagedObjectContexts = mainContext.parentContext else {
                            GraphCompletionCallback(
                                success: false,
                                error: GraphError(message: "[Graph Error: Private ManagedObjectContext does not exist."),
                                completion: completion)
                            return
                        }
                        
                        guard privateManagedObjectContexts.hasChanges else {
                            GraphCompletionCallback(
                                success: false,
                                error: GraphError(message: "[Graph Error: Private ManagedObjectContext does not have any changes."),
                                completion: completion)
                            return
                        }
                        
                        privateManagedObjectContexts.performBlockAndWait {
                            do {
                                try privateManagedObjectContexts.save()
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
}
