/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

public struct FocusStoreDescription {
    /// Datastore name.
    static let name: String = "default"

    /// Focus type.
    static let type: String = NSSQLiteStoreType

    /// URL reference to where the Focus datastore will live.
    static var location: URL {
        return File.path(.applicationSupportDirectory, path: "CosmicMind/Focus/")!
    }
}

@objc(FocusDelegate)
public protocol FocusDelegate {
    /**
     A delegation method that is executed when a focus instance
     will prepare cloud storage.
     - Parameter focus: A Focus instance.
     - Parameter transition: A FocusCloudStorageTransition value.
     */
    @objc
    optional func focusWillPrepareCloudStorage(focus: Focus, transition: FocusCloudStorageTransition)

    /**
     A delegation method that is executed when a focus instance
     did prepare cloud storage.
     - Parameter focus: A Focus instance.
     */
    @objc
    optional func focusDidPrepareCloudStorage(focus: Focus)

    /**
     A delegation method that is executed when a focus instance
     will update from cloud storage.
     - Parameter focus: A Focus instance.
     */
    @objc
    optional func focusWillUpdateFromCloudStorage(focus: Focus)

    /**
     A delegation method that is executed when a focus instance
     did update from cloud storage.
     - Parameter focus: A Focus instance.
     */
    @objc
    optional func focusDidUpdateFromCloudStorage(focus: Focus)
}

@objc(Focus)
public class Focus: NSObject {
    /// Focus location.
    internal var location: URL

    /// Focus rouute/
    public internal(set) var route: String

    /// Focus name.
    public internal(set) var name: String

    /// Focus type.
    public internal(set) var type: String

    /// Worker managedObjectContext.
    public internal(set) var managedObjectContext: NSManagedObjectContext!

    /// Number of items to return.
    public var batchSize = 0 // 0 == no limit

    /// Start the return results from this offset.
    public var batchOffset = 0

    /// Watch instances.
    public internal(set) lazy var watchers : [Watcher] = []

    public weak var delegate: FocusDelegate?

    /**
     A reference to the focus completion handler.
     - Parameter success: A boolean indicating if the cloud connection
     is possible or not.
     */
    internal var completion: ((Bool, Error?) -> Void)?

    /// Deinitializer that removes the Focus from NSNotificationCenter.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /**
     Initializer to named Focus with optional type and location.
     - Parameter name: A name for the Focus.
     - Parameter type: Focus type.
     - Parameter location: A location for storage.
     executed to determine if iCloud support is available or not.
     */
    public init(name: String = FocusStoreDescription.name, type: String = FocusStoreDescription.type) {
        route = "Local/\(name)"
        self.name = name
        self.type = type
        self.location = FocusStoreDescription.location
        super.init()
        prepareFocusContextRegistry()
        prepareManagedObjectContext(enableCloud: false)
    }

    /**
     Initializer to named Focus with optional type and location.
     - Parameter cloud: A name for the Focus.
     - Parameter type: Focus type.
     - Parameter location: A location for storage.
     - Parameter completion: An Optional completion block that is
     executed to determine if iCloud support is available or not.
     */
    public init(cloud name: String, completion: ((Bool, Error?) -> Void)? = nil) {
        route = "Cloud/\(name)"
        self.name = name
        type = NSSQLiteStoreType
        location = FocusStoreDescription.location
        super.init()
        self.completion = completion
        prepareFocusContextRegistry()
        prepareManagedObjectContext(enableCloud: true)
    }
}
