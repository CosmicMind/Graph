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

public struct GraphStoreDescription {
    /// Datastore name.
    static let name: String = "default"

    /// Graph type.
    static let type: String = NSSQLiteStoreType

    /// URL reference to where the Graph datastore will live.
    static var location: URL {
        return File.path(.applicationSupportDirectory, path: "CosmicMind/Graph/")!
    }
}

@objc(GraphDelegate)
public protocol GraphDelegate {
    /**
     A delegation method that is executed when a graph instance
     will prepare cloud storage.
     - Parameter graph: A Graph instance.
     - Parameter transition: A GraphCloudStorageTransition value.
     */
    @objc
    optional func graphWillPrepareCloudStorage(graph: Graph, transition: GraphCloudStorageTransition)

    /**
     A delegation method that is executed when a graph instance
     did prepare cloud storage.
     - Parameter graph: A Graph instance.
     */
    @objc
    optional func graphDidPrepareCloudStorage(graph: Graph)

    /**
     A delegation method that is executed when a graph instance
     will update from cloud storage.
     - Parameter graph: A Graph instance.
     */
    @objc
    optional func graphWillUpdateFromCloudStorage(graph: Graph)

    /**
     A delegation method that is executed when a graph instance
     did update from cloud storage.
     - Parameter graph: A Graph instance.
     */
    @objc
    optional func graphDidUpdateFromCloudStorage(graph: Graph)
}

@objc(Graph)
public class Graph: NSObject {
    /// Graph location.
    internal var location: URL

    /// Graph rouute/
    public internal(set) var route: String

    /// Graph name.
    public internal(set) var name: String

    /// Graph type.
    public internal(set) var type: String

    /// Worker managedObjectContext.
    public internal(set) var managedObjectContext: NSManagedObjectContext!

    /// Number of items to return.
    public var batchSize = 0 // 0 == no limit

    /// Start the return results from this offset.
    public var batchOffset = 0

    /// Watch instances.
    public internal(set) lazy var watchers : [Watcher] = []

    public weak var delegate: GraphDelegate?

    /**
     A reference to the graph completion handler.
     - Parameter success: A boolean indicating if the cloud connection
     is possible or not.
     */
    internal var completion: ((Bool, Error?) -> Void)?

    /// Deinitializer that removes the Graph from NSNotificationCenter.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /**
     Initializer to named Graph with optional type and location.
     - Parameter name: A name for the Graph.
     - Parameter type: Graph type.
     - Parameter location: A location for storage.
     executed to determine if iCloud support is available or not.
     */
    public init(name: String? = nil, type: String? = nil) {
        self.name = name ?? GraphStoreDescription.name
        self.type = type ?? GraphStoreDescription.type
        self.location = GraphStoreDescription.location
        route = "Local/\(self.name)"
        super.init()
        prepareGraphContextRegistry()
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
    public init(cloud name: String, completion: ((Bool, Error?) -> Void)? = nil) {
        route = "Cloud/\(name)"
        self.name = name
        type = NSSQLiteStoreType
        location = GraphStoreDescription.location
        super.init()
        self.completion = completion
        prepareGraphContextRegistry()
        prepareManagedObjectContext(enableCloud: true)
    }
}
