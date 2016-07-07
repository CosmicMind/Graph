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

public struct GraphDefaults {
    /// Datastore name.
    static let name: String = "default"
    
    /// Graph type.
    static let type: String = NSSQLiteStoreType
    
    /// URL reference to where the Graph datastore will live.
    static var location: NSURL {
        return File.path(.DocumentDirectory, path: "CosmicMind/Graph/")!
    }
}

@objc(Graph)
public class Graph: NSObject {
    /// Graph rouute/
    public internal(set) var route: String!
    
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
    
    /**
     A reference to the graph completion handler.
     - Parameter success: A boolean indicating if the cloud connection
     is possible or not.
     */
    internal var completion: ((supported: Bool, error: NSError?) -> Void)?
    
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
    public init(name: String = GraphDefaults.name, type: String = GraphDefaults.type, location: NSURL = GraphDefaults.location) {
        super.init()
        route = "Local/\(name)"
        self.name = name
        self.type = type
        self.location = location
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
    public init(cloud: String, completion: ((supported: Bool, error: NSError?) -> Void)? = nil) {
        super.init()
        route = "Cloud/\(cloud)"
        name = cloud
        type = NSSQLiteStoreType
        location = GraphDefaults.location
        self.completion = completion
        prepareGraphContextRegistry()
        prepareManagedObjectContext(enableCloud: true)
    }
}
