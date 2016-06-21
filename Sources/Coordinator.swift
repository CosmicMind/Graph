/*
 * Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>.
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

internal struct StorageSingleton {
    static var dispatchToken: dispatch_once_t = 0
    static var coordinator: NSPersistentStoreCoordinator?
}

internal struct Coordinator {
    /**
     Creates an NSPersistentStoreCoordinator.
     - Parameter type: Storage type.
     - Parameter name: Storage name.
     - Parameter location: Storage location.
     - Returns: An instance of NSPersistentStoreCoordinator.
    */
    static func createPersistentStoreCoordinator(type: String, name: String, location: NSURL) -> NSPersistentStoreCoordinator {
        dispatch_once(&StorageSingleton.dispatchToken) {
            File.createDirectory(location, withIntermediateDirectories: true, attributes: nil) { (success: Bool, error: NSError?) in
                if let e = error {
                    fatalError(e.localizedDescription)
                }
                
                let coordinator = NSPersistentStoreCoordinator(managedObjectModel: Model.createManagedObjectModel())
                do {
                    try coordinator.addPersistentStoreWithType(type, configuration: nil, URL: location.URLByAppendingPathComponent(name), options: nil)
                } catch {
                    fatalError("[Graph Error: There was an error creating or loading the application's saved data.]")
                }
                StorageSingleton.coordinator = coordinator
            }
        }
        return StorageSingleton.coordinator!
    }
}