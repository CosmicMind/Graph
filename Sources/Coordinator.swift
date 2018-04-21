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

    init(type : NSPersistentStoreUbiquitousTransitionType) {
        switch type {
        case .accountAdded:
            self = .accountAdded
        case .accountRemoved:
            self = .accountRemoved
        case .contentRemoved:
            self = .contentRemoved
        case .initialImportCompleted:
            self = .initialImportCompleted
        }
    }
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
    static func create(type: String, location: URL, options: [NSObject: Any]? = nil) -> NSPersistentStoreCoordinator {
        var coordinator: NSPersistentStoreCoordinator?
        
        File.createDirectoryAtPath(location, withIntermediateDirectories: true, attributes: nil) { (success, error) in
            if let e = error {
                fatalError("[Graph Error: \(e.localizedDescription)]")
            }
        
            coordinator = NSPersistentStoreCoordinator(managedObjectModel: Model.create())
        }
        
        return coordinator!
    }
}

/// NSPersistentStoreCoordinator extension.
extension Graph {
    /**
     Adds the persistentStore to the persistentStoreCoordinator.
     - Parameter supported: A boolean indicating whether cloud
     storage is supported.
     */
    internal func addPersistentStore(supported: Bool) {
        guard let moc = managedObjectContext else {
            return
        }
        
        var options: [AnyHashable: Any]?
        
        if supported {
            options = [AnyHashable: Any]()
            options?[NSPersistentStoreUbiquitousContentNameKey] = name
        }
        
        prepareSQLite()
        
        do {
            try moc.persistentStoreCoordinator?.addPersistentStore(ofType: type, configurationName: nil, at: location, options: options)
            
            location = moc.persistentStoreCoordinator!.persistentStores.first!.url!
            
            if !supported {
                completion?(false, GraphError(message: "[Graph Error: iCloud is not supported.]"))
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
        
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(persistentStoreWillChange), name: .NSPersistentStoreCoordinatorStoresWillChange, object: moc.persistentStoreCoordinator)
        defaultCenter.addObserver(self, selector: #selector(persistentStoreDidChange), name: .NSPersistentStoreCoordinatorStoresDidChange, object: moc.persistentStoreCoordinator)
        defaultCenter.addObserver(self, selector: #selector(persistentStoreDidImportUbiquitousContentChanges), name: .NSPersistentStoreDidImportUbiquitousContentChanges, object: moc.persistentStoreCoordinator)
    }
    
    @objc
    internal func persistentStoreWillChange(_ notification: Notification) {
        guard let moc = managedObjectContext else {
            return
        }
        
        moc.performAndWait { [weak self, weak moc] in
            if true == moc?.hasChanges {
                self?.sync()
            }
            self?.reset()
        }
        
        guard let type = (notification as NSNotification).userInfo?[NSPersistentStoreUbiquitousTransitionTypeKey] as? NSPersistentStoreUbiquitousTransitionType else {
            return
        }
        
        let t = GraphCloudStorageTransition(type: type)
        

        delegate?.graphWillPrepareCloudStorage?(graph: self, transition: t)
    }
    
    @objc
    internal func persistentStoreDidChange(_ notification: Notification) {
        GraphContextRegistry.added[route] = true
        
        completion?(true, nil)
        
        delegate?.graphDidPrepareCloudStorage?(graph: self)
    }
    
    @objc
    internal func persistentStoreDidImportUbiquitousContentChanges(_ notification: Notification) {
        guard let moc = managedObjectContext else {
            return
        }
        
        moc.perform { [weak self, weak moc, notification = notification] in
            guard let s = self else {
                return
            }
            
            s.delegate?.graphWillUpdateFromCloudStorage?(graph: s)
            
            s.watchers.forEach { [weak moc] in
                guard let watch = $0.watch else {
                    return
                }
                
                
                moc?.mergeChanges(fromContextDidSave: notification)
                
                watch.notifyInsertedWatchersFromCloud(notification)
                watch.notifyUpdatedWatchersFromCloud(notification)
                watch.notifyDeletedWatchersFromCloud(notification)
            }
            
            s.delegate?.graphDidUpdateFromCloudStorage?(graph: s)
        }
    }
}
