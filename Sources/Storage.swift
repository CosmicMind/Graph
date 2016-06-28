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

internal struct StorageRegistry {
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
internal func StorageCompletionCallback(success success: Bool, error: NSError?, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
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
internal func StorageError(message message: String, domain: String = "io.cosmicmind.graph") -> NSError {
    var info = [String: AnyObject]()
    info[NSLocalizedDescriptionKey] = message
    info[NSLocalizedFailureReasonErrorKey] = message
    let error = NSError(domain: domain, code: 0001, userInfo: info)
    info[NSUnderlyingErrorKey] = error
    return error
}

public struct StorageConstants {
    /// Datastore name.
    static let name: String = "default"
    
    /// Storage type.
    static let type: String = NSSQLiteStoreType
    
    /// URL reference to where the datastore will live.
    static var location: NSURL {
        return File.path(.DocumentDirectory, path: "Graph/")!
    }
}

@objc(Storage)
public class Storage: NSObject {
    /// Storage name.
    public internal(set) var name: String!
    
    /// Storage type.
    public internal(set) var type: String!
    
    /// Storage location.
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
    
    /// Deinitializer that removes the Storage from NSNotificationCenter.
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Performs a save.
     - Parameter completion: An Optional completion block that is
     executed when the save operation is completed.
     */
    public func async(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        guard managedObjectContext.hasChanges else {
            StorageCompletionCallback(
                success: false,
                error: StorageError(message: "[Storage Error: Worker ManagedObjectContext does not have any changes."),
                completion: completion)
            return
        }
        
        managedObjectContext.performBlock { [weak self] in
            do {
                try self?.managedObjectContext.save()
                
                guard let mainContext = self?.managedObjectContext.parentContext else {
                    StorageCompletionCallback(
                        success: false,
                        error: StorageError(message: "[Storage Error: Main ManagedObjectContext does not exist."),
                        completion: completion)
                    return
                }
                
                guard mainContext.hasChanges else {
                    StorageCompletionCallback(
                        success: false,
                        error: StorageError(message: "[Storage Error: Main ManagedObjectContext does not have any changes."),
                        completion: completion)
                    return
                }
                
                mainContext.performBlock {
                    do {
                        try mainContext.save()
                        
                        guard let privateManagedObjectContexts = mainContext.parentContext else {
                            StorageCompletionCallback(
                                success: false,
                                error: StorageError(message: "[Storage Error: Private ManagedObjectContext does not exist."),
                                completion: completion)
                            return
                        }
                        
                        guard privateManagedObjectContexts.hasChanges else {
                            StorageCompletionCallback(
                                success: false,
                                error: StorageError(message: "[Storage Error: Private ManagedObjectContext does not have any changes."),
                                completion: completion)
                            return
                        }
                        
                        privateManagedObjectContexts.performBlock {
                            do {
                                try privateManagedObjectContexts.save()
                                StorageCompletionCallback(success: true, error: nil, completion: completion)
                            } catch let e as NSError {
                                StorageCompletionCallback(success: false, error: e, completion: completion)
                            }
                        }
                    } catch let e as NSError {
                        StorageCompletionCallback(success: false, error: e, completion: completion)
                    }
                }
            } catch let e as NSError {
                StorageCompletionCallback(success: false, error: e, completion: completion)
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
            StorageCompletionCallback(
                success: false,
                error: StorageError(message: "[Storage Error: Worker ManagedObjectContext does not have any changes."),
                completion: completion)
            return
        }
        
        managedObjectContext.performBlockAndWait { [weak self] in
            do {
                try self?.managedObjectContext.save()
                
                guard let mainContext = self?.managedObjectContext.parentContext else {
                    StorageCompletionCallback(
                        success: false,
                        error: StorageError(message: "[Storage Error: Main ManagedObjectContext does not exist."),
                        completion: completion)
                    return
                }
                
                guard mainContext.hasChanges else {
                    StorageCompletionCallback(
                        success: false,
                        error: StorageError(message: "[Storage Error: Main ManagedObjectContext does not have any changes."),
                        completion: completion)
                    return
                }
                
                mainContext.performBlockAndWait {
                    do {
                        try mainContext.save()
                        
                        guard let privateManagedObjectContexts = mainContext.parentContext else {
                            StorageCompletionCallback(
                                success: false,
                                error: StorageError(message: "[Storage Error: Private ManagedObjectContext does not exist."),
                                completion: completion)
                            return
                        }
                        
                        guard privateManagedObjectContexts.hasChanges else {
                            StorageCompletionCallback(
                                success: false,
                                error: StorageError(message: "[Storage Error: Private ManagedObjectContext does not have any changes."),
                                completion: completion)
                            return
                        }
                        
                        privateManagedObjectContexts.performBlockAndWait {
                            do {
                                try privateManagedObjectContexts.save()
                                StorageCompletionCallback(success: true, error: nil, completion: completion)
                            } catch let e as NSError {
                                StorageCompletionCallback(success: false, error: e, completion: completion)
                            }
                        }
                    } catch let e as NSError {
                        StorageCompletionCallback(success: false, error: e, completion: completion)
                    }
                }
            } catch let e as NSError {
                StorageCompletionCallback(success: false, error: e, completion: completion)
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
    
    /// Prepares the registry.
    internal func prepareStorageRegistry() {
        dispatch_once(&StorageRegistry.dispatchToken) {
            StorageRegistry.privateManagedObjectContextss = [String: NSManagedObjectContext]()
            StorageRegistry.mainManagedObjectContexts = [String: NSManagedObjectContext]()
            StorageRegistry.workerManagedObjectContexts = [String: NSManagedObjectContext]()
        }
    }
    
    /// Prapres the managedObjectContext.
    internal func prepareManagedObjectContext() {}
}
