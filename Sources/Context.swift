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

internal struct GraphContextRegistry {
    static var dispatchToken: dispatch_once_t = 0
    static var added: [String: Bool]!
    static var supported: [String: Bool]!
    static var privateManagedObjectContexts: [String: NSManagedObjectContext]!
    static var managedObjectContexts: [String: NSManagedObjectContext]!
}

internal struct Context {
    /**
     Creates a NSManagedContext. The method will ensure that  any workerManagedObjectContexts that have
     a concurrency type of .MainQueueConcurrencyType are always created on the main 
     thread.
     - Parameter concurrencyType: A concurrency type to use.
     - Parameter parentContext: An optional parent context.
    */
    static func createManagedContext(concurrencyType: NSManagedObjectContextConcurrencyType, parentContext: NSManagedObjectContext? = nil) -> NSManagedObjectContext {
        var moc: NSManagedObjectContext!
        
        let makeContext = { [weak parentContext] in
            moc = NSManagedObjectContext(concurrencyType: concurrencyType)
            moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let pmoc = parentContext {
                moc.parentContext = pmoc
            }
        }
        
        if concurrencyType == .MainQueueConcurrencyType && !NSThread.isMainThread() {
            dispatch_sync(dispatch_get_main_queue()) {
                makeContext()
            }
        } else {
            makeContext()
        }
        
        return moc
    }
}

/// NSManagedObjectContext extension.
public extension Graph {
    /// Prepares the registry.
    internal func prepareGraphContextRegistry() {
        dispatch_once(&GraphContextRegistry.dispatchToken) {
            GraphContextRegistry.added = [String: Bool]()
            GraphContextRegistry.supported = [String: Bool]()
            GraphContextRegistry.privateManagedObjectContexts = [String: NSManagedObjectContext]()
            GraphContextRegistry.managedObjectContexts = [String: NSManagedObjectContext]()
        }
    }
    
    /**
     Prapres the managedObjectContext.
     - Parameter iCloud: A boolean to enable iCloud.
     */
    internal func prepareManagedObjectContext(enableCloud enableCloud: Bool) {
        guard let moc = GraphContextRegistry.managedObjectContexts[route] else {
            let supported = enableCloud && nil != NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)
            GraphContextRegistry.supported[route] = supported
            
            location = location.URLByAppendingPathComponent(route)
            
            let poc = Context.createManagedContext(.PrivateQueueConcurrencyType)
            poc.persistentStoreCoordinator = Coordinator.createPersistentStoreCoordinator(type: type, location: location)
            
            if NSSQLiteStoreType == type {
                location = location.URLByAppendingPathComponent("Graph.sqlite")
            }
            
            GraphContextRegistry.privateManagedObjectContexts[route] = poc
            
            managedObjectContext = Context.createManagedContext(.MainQueueConcurrencyType, parentContext: poc)
            GraphContextRegistry.managedObjectContexts[route] = managedObjectContext
            
            if supported {
                preparePersistentStoreCoordinatorNotificationHandlers()
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
                    dispatch_sync(dispatch_get_main_queue()) { [weak self] in
                        self?.addPersistentStore(supported: true)
                    }
                }
            } else {
                addPersistentStore(supported: false)
            }
            
            return
        }
        
        managedObjectContext = moc
        location = moc.parentContext?.persistentStoreCoordinator?.persistentStores.first?.URL
        
        guard let callback = completion else {
            return
        }
        
        guard let supported = GraphContextRegistry.supported[route] else {
            return
        }
        
        guard true == GraphContextRegistry.added[route] else {
            preparePersistentStoreCoordinatorNotificationHandlers()
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self, supported = supported] in
            dispatch_sync(dispatch_get_main_queue()) { [weak self, supported = supported] in
                guard let s = self else {
                    return
                }
                s.completion?(supported: supported, error: supported ? nil : GraphError(message: "[Graph Error: iCloud is not supported.]"))
                s.delegate?.graphDidPrepareCloudStorage?(s)
            }
        }
    }
}