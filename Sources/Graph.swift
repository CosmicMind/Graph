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
