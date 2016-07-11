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

/**
 Cloud stroage transition types for when changes happen
 to the iCloud account directly.
 */
@objc(GraphCloudStorageTransition)
public enum GraphCloudStorageTransition: Int {
    case accountAdded
    case accountRemoved
    case contentRemoved
    case initialImportCompleted
}

internal struct Coordinator {
	/**
     Creates a NSPersistentStoreCoordinator.
     - Parameter name: Storage name.
     - Parameter type: Storage type.
     - Parameter location: Storage location.
     - Parameter options: Additional options.
     - Returns: An instance of NSPersistentStoreCoordinator.
	*/
    static func createPersistentStoreCoordinator(type type: String, location: NSURL, options: [NSObject: AnyObject]? = nil) -> NSPersistentStoreCoordinator {
        var coordinator: NSPersistentStoreCoordinator?
        File.createDirectoryAtPath(location, withIntermediateDirectories: true, attributes: nil) { (success: Bool, error: NSError?) in
            if let e = error {
                fatalError("[Graph Error: \(e.localizedDescription)]")
            }
            coordinator = NSPersistentStoreCoordinator(managedObjectModel: Model.createManagedObjectModel())
        }
        return coordinator!
    }
}

/// NSPersistentStoreCoordinator extension.
public extension Graph {
    /**
     Adds the persistentStore to the persistentStoreCoordinator.
     - Parameter supported: A boolean indicating whether cloud
     storage is supported.
     */
    internal func addPersistentStore(supported supported: Bool) {
        guard let moc = managedObjectContext else {
            return
        }
        
        var options: [NSObject: AnyObject]?
        
        if supported {
            options = [NSObject: AnyObject]()
            options?[NSPersistentStoreUbiquitousContentNameKey] = name
        }
        
        do {
            try moc.persistentStoreCoordinator?.addPersistentStoreWithType(type, configuration: nil, URL: location, options: options)
            location = moc.persistentStoreCoordinator?.persistentStores.first?.URL
            if !supported {
                completion?(supported: false, error: GraphError(message: "[Graph Error: iCloud is not supported.]"))
            }
        } catch let e as NSError {
            fatalError("[Graph Error: \(e.localizedDescription)]")
        }
    }
    
    /// Prepares the persistentStoreCoordinator notification handlers.
    internal func preparePersistentStoreCoordinatorNotificationHandlers() {
        guard let moc = managedObjectContext else {
            return
        }
        
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: #selector(persistentStoreWillChange(_:)), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc.persistentStoreCoordinator)
        defaultCenter.addObserver(self, selector: #selector(persistentStoreDidChange(_:)), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: moc.persistentStoreCoordinator)
        defaultCenter.addObserver(self, selector: #selector(persistentStoreDidImportUbiquitousContentChanges(_:)), name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc.persistentStoreCoordinator)
    }
    
    internal func persistentStoreWillChange(notification: NSNotification) {
        guard let moc = managedObjectContext else {
            return
        }
        
        moc.performBlockAndWait { [weak self, weak moc] in
            if true == moc?.hasChanges {
                self?.sync()
            }
            self?.reset()
        }
        
        guard let type = notification.userInfo?[NSPersistentStoreUbiquitousTransitionTypeKey] as? NSPersistentStoreUbiquitousTransitionType else {
            return
        }
        
        var t: GraphCloudStorageTransition
        
        switch type {
        case .AccountAdded:
            t = .accountAdded
        case .AccountRemoved:
            t = .accountRemoved
        case .ContentRemoved:
            t = .contentRemoved
        case .InitialImportCompleted:
            t = .initialImportCompleted
        }
        
        self.delegate?.graphWillPrepareCloudStorage?(self, transition: t)
    }
    
    internal func persistentStoreDidChange(notification: NSNotification) {
        GraphContextRegistry.added[self.route] = true

        self.completion?(supported: true, error: nil)
        self.delegate?.graphDidPrepareCloudStorage?(self)
    }
    
    internal func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification) {
        guard let moc = managedObjectContext else {
            return
        }
        
        moc.performBlock { [weak self, weak moc, notification = notification] in
            guard let s = self else {
                return
            }
            
            s.delegate?.graphWillUpdateFromCloudStorage?(s)
            
            moc?.mergeChangesFromContextDidSaveNotification(notification)
            
            s.notifyInsertedWatchersFromCloud(notification)
            s.notifyUpdatedWatchersFromCloud(notification)
            s.notifyDeletedWatchersFromCloud(notification)
            
            s.delegate?.graphDidUpdateFromCloudStorage?(s)
        }
    }
}
