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
  
  /**
   An initializer that accepts a NodeClass and Graph
   instance.
   - Parameter graph: A Graph instance.
   */
  public init(graph: Graph = Graph()) {
    self.graph = graph
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
  
  /**
   Apply provided predicate to Search.
   - Parameter _ predicate: A Predicate.
   - Returns: A Search instance.
   */
  @discardableResult
  public func `where`(_ predicate: Predicate) -> Search {
    self.predicate = self.predicate.map {
      $0 || predicate
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
    
    guard let identifier = NodeClass(nodeType: T.self)?.identifier else {
      fatalError("[Graph Error: Unsupported type for Search]")
    }
    
    let request = NSFetchRequest<ManagedNode>()
    request.entity = NSEntityDescription.entity(forEntityName: identifier, in: moc)!
    request.fetchBatchSize = graph.batchSize
    request.fetchOffset = graph.batchOffset
    request.predicate = predicate.removingPropertyCases()
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
    
    var array: [T] = []
    moc.performAndWait {
      array = (result as? [ManagedNode] ?? []).compactMap {
        guard predicate.evaluate(with: $0) else {
          return nil
        }
        
        return T(managedNode: $0)
      }
    }
    
    return array
  }
}

/**
 An operator to compound given two Search<T> instances
 into a single Search<T>.
 - Parameter left: A Search<T>.
 - Parameter right: A Search<T>.
 - Returns: A new Search<T>.
 */
public func +<T>(left: Search<T>, right: Search<T>) -> Search<T> {
  guard left.graph == right.graph else {
    fatalError("[Graph Error: `Search`s for different Graph instances should not be combined.]")
  }
  
  return Search<T>(graph: left.graph)
    .where(left.predicate)
    .where(right.predicate)
}

/**
 An operator to merge right Search<T> into left Search<T>.
 - Parameter left: An inout Search<T>.
 - Parameter right: A Search<T>.
 */
public func +=<T>(left: inout Search<T>, right: Search<T>) {
  left = left + right
}

private extension NSPredicate {
  /**
   Create a new NSPredicate by recursively replacing property predicates
   with TRUEPREDICATE to allow matching all possible nodes.
   - Returns: An NSPredicate.
   */
  func removingPropertyCases() -> NSPredicate {
    let reducedFormat = predicateFormat
      .replacing("(N[NOT ]+T )?SUBQUERY\\(propertySet.+?\\)\\.@count > 0")
      .replacing("TRUEPREDICATE AND TRUEPREDICATE")
      .replacing("TRUEPREDICATE OR TRUEPREDICATE")
      .replacing("NOT TRUEPREDICATE")
    
    let reducedPredicate = NSPredicate(format: reducedFormat)
    
    guard reducedPredicate == self else {
      return reducedPredicate.removingPropertyCases()
    }
    
    return reducedPredicate
  }
}

private extension String {
  /**
   Create a new string replacing the matched pattern with TRUEPREDICATE.
   - Parameter _ pattern: A String.
   - Returns: A new string replaced the matched pattern with TRUEPREDICATE.
   */
  func replacing(_ pattern: String) -> String {
    let regex = try! NSRegularExpression(pattern: pattern)
    return regex.stringByReplacingMatches(in: self, options: [],
                                          range: NSRange(location: 0, length: count),
                                          withTemplate: "TRUEPREDICATE")
  }
}
