/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import CoreData

internal struct GraphContextRegistry {
  static var dispatchToken = false
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
internal extension Graph {
  /// Prepares the registry.
  func prepareGraphContextRegistry() {
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
  func prepareManagedObjectContext(enableCloud: Bool) {
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
  func prepareSQLite() {
    if NSSQLiteStoreType == type {
      location = location.appendingPathComponent("Graph.sqlite")
    }
  }
}

@available(iOS 10.0, OSX 10.12, *)
fileprivate extension Graph {
  func prepareContextContainer() {
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
