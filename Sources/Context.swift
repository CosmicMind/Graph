/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
    static var dispatchToken: Bool = false
    static var added: [String: Bool]!
    static var enableCloud: [String: Bool]!
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
    static func create(_ concurrencyType: NSManagedObjectContextConcurrencyType, parentContext: NSManagedObjectContext? = nil) -> NSManagedObjectContext {
        var moc: NSManagedObjectContext!
        
        let makeContext = { [weak parentContext] in
            moc = NSManagedObjectContext(concurrencyType: concurrencyType)
            moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            moc.undoManager = nil
            
            if let pmoc = parentContext {
                moc.parent = pmoc
            }
        }
        
        if concurrencyType == .mainQueueConcurrencyType && !Thread.isMainThread {
            DispatchQueue.main.sync {
                makeContext()
            }
        } else {
            makeContext()
        }
        
        return moc
    }
}

/// NSManagedObjectContext extension.
extension Graph {
    /// Prepares the registry.
    internal func prepareGraphContextRegistry() {
        guard false == GraphContextRegistry.dispatchToken else {
            return
        }
        
        GraphContextRegistry.dispatchToken = true
        GraphContextRegistry.added = [:]
        GraphContextRegistry.enableCloud = [:]
        GraphContextRegistry.managedObjectContexts = [String: NSManagedObjectContext]()
    }
    
    /**
     Prapres the managedObjectContext.
     - Parameter iCloud: A boolean to enable iCloud.
     */
    internal func prepareManagedObjectContext(enableCloud: Bool) {
        guard let moc = GraphContextRegistry.managedObjectContexts[route] else {
            GraphContextRegistry.enableCloud[route] = enableCloud
            location = GraphStoreDescription.location.appendingPathComponent(route)
            
            managedObjectContext = Context.create(.mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = Coordinator.create(type: type, location: location)
            GraphContextRegistry.managedObjectContexts[route] = managedObjectContext
            
            if enableCloud {
                preparePersistentStoreCoordinatorNotificationHandlers()
                
                managedObjectContext.perform { [weak self] in
                    self?.addPersistentStore(supported: true)
                }
            } else {
                addPersistentStore(supported: false)
            }
            return
        }
        
        managedObjectContext = moc
        
        guard let isCloudEnabled = GraphContextRegistry.enableCloud[route] else {
            return
        }
        
        preparePersistentStoreCoordinatorNotificationHandlers()
        
        managedObjectContext.perform { [weak self, isCloudEnabled = isCloudEnabled] in
            guard let s = self else {
                return
            }
            
            s.completion?(isCloudEnabled, isCloudEnabled ? nil : GraphError(message: "[Graph Error: iCloud is not supported.]"))
            s.delegate?.graphDidPrepareCloudStorage?(graph: s)
        }
    }
    
    /// Prepares the SQLight file if needed.
    internal func prepareSQLite() {
        if NSSQLiteStoreType == type {
            location = location.appendingPathComponent("Graph.sqlite")
        }
    }

    @available(iOS 10.0, OSX 10.12, *)
    fileprivate func prepareContextContainer() {
        self.prepareSQLite()
        
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.shouldAddStoreAsynchronously = false
        storeDescription.url = location
        
        let container = NSPersistentContainer(name: name, storeDescription: storeDescription)
        container.loadPersistentStores { [unowned self] (storeDescription, error) in
            self.managedObjectContext = container.viewContext
            GraphContextRegistry.managedObjectContexts[self.route] = self.managedObjectContext
        }
    }
}
