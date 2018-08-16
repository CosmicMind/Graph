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

public enum SearchCondition: Int {
  case or
  case and
}
/// Search.
public class Search<T: Node> {
  
  /// A Graph instance.
  internal private(set) var graph: Graph
  
  /// A reference to search predicate.
  internal private(set) var predicate: Predicate!
  
  private var identifier: String
  
  /**
   An initializer that accepts a NodeClass and Graph
   instance.
   - Parameter graph: A Graph instance.
   */
  public init(graph: Graph = Graph()) {
    self.graph = graph
    switch T.self {
    case is Entity.Type:
      identifier = ModelIdentifier.entityName
    case is Relationship.Type:
      identifier = ModelIdentifier.relationshipName
    case is Action.Type:
      identifier = ModelIdentifier.actionName
    default:
      fatalError()
    }
  }
  
  /**
   Clears the search parameters.
   - Returns: A Search instance.
   */
  @discardableResult
  public func clear() -> Search {
    predicate = nil
    return self
  }
  
  @discardableResult
  public func `where`(_ predicate: Predicate) -> Search {
    self.predicate = self.predicate.map {
      $0 && predicate
    } ?? predicate
    
    return self
  }
  
  /**
   A synchronous request that returns an Array of Relationships or executes a
   callback with an Array of Relationships passed in as the first argument.
   - Parameter completeion: An optional completion block.
   - Returns: An Array of Relationships.
   */
  @discardableResult
  public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
    return executeSynchronousRequest(nodes: search(), completion: completion)
  }
  
  /**
   An asynchronous request that executes a callback with an Array of Relationships
   passed in as the first argument.
   - Parameter completion: An optional completion block.
   */
  public func async(completion: @escaping (([T]) -> Void)) {
    DispatchQueue.global(qos: .background).async {
      self.sync(completion: completion)
    }
  }
}

private extension Search {
  
  /**
   Executes the synchronous process on the main thread.
   - Parameter nodes: An Array of Elements.
   - Parameter completion: An optional completion block.
   - Returns: An Array of Elements.
   */
  @discardableResult
  func executeSynchronousRequest(nodes: [T], completion: (([T]) -> Void)? = nil) -> [T] {
    guard let c = completion else {
      return nodes
    }
    
    if Thread.isMainThread {
      c(nodes)
      
    } else {
      DispatchQueue.main.async {
        c(nodes)
      }
    }
    
    return nodes
  }

  /**
   Searches based on property value.
   - Returns: An Array of ManagedNode objects.
   */
  func search() -> [T] {
    guard let moc = graph.managedObjectContext else {
      return []
    }
    
    guard let predicate = predicate?.predicate else {
      return []
    }
    
    let request = NSFetchRequest<ManagedNode>()
    request.entity = NSEntityDescription.entity(forEntityName: identifier, in: moc)!
    request.fetchBatchSize = graph.batchSize
    request.fetchOffset = graph.batchOffset
    request.predicate = predicate
    
    var result: [AnyObject]?
    
    moc.performAndWait { [unowned request] in
      do {
        if #available(iOS 10.0, OSX 10.12, *) {
          result = try request.execute()
        } else {
          result = try moc.fetch(request)
        }
      } catch {}
    }
    
    return (result as? [ManagedNode] ?? []).map {
      T(managedNode: $0)
    }
  }
}

public func +<T>(left: Search<T>, right: Search<T>) -> Search<T> {
  guard left.graph == right.graph else {
    fatalError("[Graph Error: `Search`s for different Graph instances should not be combined.]")
  }
  
  return Search<T>(graph: left.graph)
    .where(left.predicate)
    .where(right.predicate)
}

public func +=<T>(left: inout Search<T>, right: Search<T>) {
  left = left + right
}
