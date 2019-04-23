/*
 * Copyright (C) 2015 - 2019, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(GraphSource)
public enum GraphSource: Int {
  case cloud
  case local
}

@objc(GraphNodeDelegate)
public protocol GraphNodeDelegate {}

@objc(GraphEntityDelegate)
public protocol GraphEntityDelegate: GraphNodeDelegate {
  /**
   A delegation method that is executed when an Entity is inserted.
   - Parameter graph: A Graph instance.
   - Parameter inserted entity: An Entity instance.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, inserted entity: Entity, source: GraphSource)
  
  /**
   A delegation method that is executed when an Entity is deleted.
   - Parameter graph: A Graph instance.
   - Parameter deleted entity: An Entity instance.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, deleted entity: Entity, source: GraphSource)
  
  /**
   A delegation method that is executed when an Entity added a property and value.
   - Parameter graph: A Graph instance.
   - Parameter entity: An Entity instance.
   - Parameter added property: A String.
   - Parameter with value: Any object.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, entity: Entity, added property: String, with value: Any, source: GraphSource)
  
  /**
   A delegation method that is executed when an Entity updated a property and value.
   - Parameter graph: A Graph instance.
   - Parameter entity: An Entity instance.
   - Parameter updated property: A String.
   - Parameter with value: Any object.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, entity: Entity, updated property: String, with value: Any, source: GraphSource)
  
  /**
   A delegation method that is executed when an Entity removed a property and value.
   - Parameter graph: A Graph instance.
   - Parameter entity: An Entity instance.
   - Parameter removed property: A String.
   - Parameter with value: Any object.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, entity: Entity, removed property: String, with value: Any, source: GraphSource)
  
  /**
   A delegation method that is executed when an Entity added a tag.
   - Parameter graph: A Graph instance.
   - Parameter entity: An Entity instance.
   - Parameter added tag: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, entity: Entity, added tag: String, source: GraphSource)
  
  /**
   A delegation method that is executed when an Entity removed a tag.
   - Parameter graph: A Graph instance.
   - Parameter entity: An Entity instance.
   - Parameter removed tag: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, entity: Entity, removed tag: String, source: GraphSource)
  
  /**
   A delegation method that is executed when an Entity was added to a group.
   - Parameter graph: A Graph instance.
   - Parameter entity: An Entity instance.
   - Parameter addedTo group: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, entity: Entity, addedTo group: String, source: GraphSource)
  
  /**
   A delegation method that is executed when an Entity was removed from a group.
   - Parameter graph: A Graph instance.
   - Parameter entity: An Entity instance.
   - Parameter removedFrom group: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, entity: Entity, removedFrom group: String, source: GraphSource)
}

@objc(GraphRelationshipDelegate)
public protocol GraphRelationshipDelegate: GraphNodeDelegate {
  /**
   A delegation method that is executed when a Relationship is inserted.
   - Parameter graph: A Graph instance.
   - Parameter inserted relationship: A Relationship instance.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, inserted relationship: Relationship, source: GraphSource)
  
  /**
   A delegation method that is executed when a Relationship is updated.
   - Parameter graph: A Graph instance.
   - Parameter updated relationship: A Relationship instance.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, updated relationship: Relationship, source: GraphSource)
  
  /**
   A delegation method that is executed when a Relationship is deleted.
   - Parameter graph: A Graph instance.
   - Parameter deleted relationship: A Relationship instance.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, deleted relationship: Relationship, source: GraphSource)
  
  /**
   A delegation method that is executed when a Relationship added a property and value.
   - Parameter graph: A Graph instance.
   - Parameter relationship: A Relationship instance.
   - Parameter added property: A String.
   - Parameter with value: Any object.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, relationship: Relationship, added property: String, with value: Any, source: GraphSource)
  
  /**
   A delegation method that is executed when a Relationship updated a property and value.
   - Parameter graph: A Graph instance.
   - Parameter relationship: A Relationship instance.
   - Parameter updated property: A String.
   - Parameter with value: Any object.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, relationship: Relationship, updated property: String, with value: Any, source: GraphSource)
  
  /**
   A delegation method that is executed when a Relationship removed a property and value.
   - Parameter graph: A Graph instance.
   - Parameter relationship: A Relationship instance.
   - Parameter removed property: A String.
   - Parameter with value: Any object.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, relationship: Relationship, removed property: String, with value: Any, source: GraphSource)
  
  /**
   A delegation method that is executed when a Relationship added a tag.
   - Parameter graph: A Graph instance.
   - Parameter relationship: A Relationship instance.
   - Parameter added tag: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, relationship: Relationship, added tag: String, source: GraphSource)
  
  /**
   A delegation method that is executed when a Relationship removed a tag.
   - Parameter graph: A Graph instance.
   - Parameter relationship: A Relationship instance.
   - Parameter removed tag: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, relationship: Relationship, removed tag: String, source: GraphSource)
  
  /**
   A delegation method that is executed when a Relationship was added to a group.
   - Parameter graph: A Graph instance.
   - Parameter relationship: A Relationship instance.
   - Parameter addedTo group: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, relationship: Relationship, addedTo group: String, source: GraphSource)
  
  /**
   A delegation method that is executed when a Relationship was removed from a group.
   - Parameter graph: A Graph instance.
   - Parameter relationship: A Relationship instance.
   - Parameter removedFrom group: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, relationship: Relationship, removedFrom group: String, source: GraphSource)
}

@objc(GraphActionDelegate)
public protocol GraphActionDelegate: GraphNodeDelegate {
  /**
   A delegation method that is executed when an Action is inserted.
   - Parameter graph: A Graph instance.
   - Parameter inserted action: An Action instance.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, inserted action: Action, source: GraphSource)
  
  /**
   A delegation method that is executed when an Action is deleted.
   - Parameter graph: A Graph instance.
   - Parameter deleted action: An Action instance.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, deleted action: Action, source: GraphSource)
  
  /**
   A delegation method that is executed when an Action added a property and value.
   - Parameter graph: A Graph instance.
   - Parameter action: An Action instance.
   - Parameter added property: A String.
   - Parameter with value: Any object.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, action: Action, added property: String, with value: Any, source: GraphSource)
  
  /**
   A delegation method that is executed when an Action updated a property and value.
   - Parameter graph: A Graph instance.
   - Parameter action: An Action instance.
   - Parameter updated property: A String.
   - Parameter with value: Any object.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, action: Action, updated property: String, with value: Any, source: GraphSource)
  
  /**
   A delegation method that is executed when an Action removed a property and value.
   - Parameter graph: A Graph instance.
   - Parameter action: An Action instance.
   - Parameter removed property: A String.
   - Parameter with value: Any object.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, action: Action, removed property: String, with value: Any, source: GraphSource)
  
  /**
   A delegation method that is executed when an Action added a tag.
   - Parameter graph: A Graph instance.
   - Parameter action: An Action instance.
   - Parameter added tag: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, action: Action, added tag: String, source: GraphSource)
  
  /**
   A delegation method that is executed when an Action removed a tag.
   - Parameter graph: A Graph instance.
   - Parameter action: An Action instance.
   - Parameter removed tag: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, action: Action, removed tag: String, source: GraphSource)
  
  /**
   A delegation method that is executed when an Action was added to a group.
   - Parameter graph: A Graph instance.
   - Parameter action: An Action instance.
   - Parameter addedTo group: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, action: Action, addedTo group: String, source: GraphSource)
  
  /**
   A delegation method that is executed when an Action was removed from a group.
   - Parameter graph: A Graph instance.
   - Parameter action: An Action instance.
   - Parameter removedFrom group: A String.
   - Parameter source: A GraphSource value.
   */
  @objc
  optional func graph(_ graph: Graph, action: Action, removedFrom group: String, source: GraphSource)
}

public protocol Watchable {
  /// Element type.
  associatedtype Element: Node
}

public struct Watcher {
  /// A weak reference to the stored object.
  private weak var object: AnyObject?
  
  /// A reference to the weak Watch<T> instance.
  public var watch: Watch<Node>? {
    return object as? Watch<Node>
  }
  
  /**
   An initializer that takes in an object instance.
   - Parameter watch: A Watch<T> instance.
   */
  public init (object: AnyObject) {
    self.object = object
  }
}

/// Watch.
public class Watch<T: Node>: Watchable {
  public typealias Element = T
  
  /// A Graph instance.
  public fileprivate(set) var graph: Graph
  
  /// A reference to a delagte object.
  public weak var delegate: GraphNodeDelegate?
  
  /// A reference to watch predicate.
  internal private(set) var predicate: Predicate!
  
  /**
   A boolean indicating if the Watch instance is
   currently watching.
   */
  public fileprivate(set) var isRunning = false
  
  /// Deinitializer.
  deinit {
    removeFromObservation()
  }
  
  /**
   An initializer that accepts a NodeClass and Graph
   instance.
   - Parameter graph: A Graph instance.
   */
  public init(graph: Graph = Graph()) {
    self.graph = graph
    prepare()
  }
  
  /**
   Clears the search parameters.
   - Returns: A Watch instance.
   */
  @discardableResult
  public func clear() -> Watch {
    predicate = nil
    return self
  }
  
  @discardableResult
  public func `where`(_ predicate: Predicate) -> Watch {
    self.predicate = self.predicate.map {
      $0 || predicate
      } ?? predicate
    return self
  }
  
  /**
   Resumes the watcher.
   - Returns: A Watch instance.
   */
  @discardableResult
  public func resume() -> Watch {
    guard !isRunning else {
      return self
    }
    
    isRunning = true
    
    addForObservation()
    return self
  }
  
  /**
   Pauses the watcher.
   - Returns: A Watch instance.
   */
  @discardableResult
  public func pause() -> Watch {
    isRunning = false
    
    removeFromObservation()
    return self
  }
  
  /**
   Notifies inserted watchers from local changes.
   - Parameter notification: NSNotification reference.
   */
  @objc
  internal func notifyInsertedWatchers(_ notification: Notification) {
    guard let objects = notification.userInfo?[NSInsertedObjectsKey] as? NSSet else {
      return
    }
    
    delegateToInsertedWatchers(filtered(objects), source: .local)
  }
  
  /**
   Notifies updated watchers from local changes.
   - Parameter notification: NSNotification reference.
   */
  @objc
  internal func notifyUpdatedWatchers(_ notification: Notification) {
    guard let objects = notification.userInfo?[NSUpdatedObjectsKey] as? NSSet else {
      return
    }
    
    delegateToUpdatedWatchers(filtered(objects), source: .local)
  }
  
  /**
   Notifies deleted watchers from local changes.
   - Parameter notification: NSNotification reference.
   */
  @objc
  internal func notifyDeletedWatchers(_ notification: Notification) {
    guard let objects = notification.userInfo?[NSDeletedObjectsKey] as? NSSet else {
      return
    }
    
    delegateToDeletedWatchers(filtered(objects), source: .local)
  }
  
  /**
   Notifies inserted watchers from cloud changes.
   - Parameter notification: NSNotification reference.
   */
  @objc
  internal func notifyInsertedWatchersFromCloud(_ notification: Notification) {
    guard let objectIDs = notification.userInfo?[NSInsertedObjectsKey] as? NSSet else {
      return
    }
    
    guard let moc = graph.managedObjectContext else {
      return
    }
    
    let objects = NSMutableSet()
    (objectIDs.allObjects as! [NSManagedObjectID]).forEach { [unowned moc] (objectID: NSManagedObjectID) in
      objects.add(moc.object(with: objectID))
    }
    
    delegateToInsertedWatchers(filtered(objects), source: .cloud)
  }
  
  /**
   Notifies updated watchers from cloud changes.
   - Parameter notification: NSNotification reference.
   */
  @objc
  internal func notifyUpdatedWatchersFromCloud(_ notification: Notification) {
    guard let objectIDs = notification.userInfo?[NSUpdatedObjectsKey] as? NSSet else {
      return
    }
    
    guard let moc = graph.managedObjectContext else {
      return
    }
    
    let objects = NSMutableSet()
    (objectIDs.allObjects as! [NSManagedObjectID]).forEach { [unowned moc] (objectID: NSManagedObjectID) in
      objects.add(moc.object(with: objectID))
    }
    
    delegateToUpdatedWatchers(filtered(objects), source: .cloud)
  }
  
  /**
   Notifies deleted watchers from cloud changes.
   - Parameter notification: NSNotification reference.
   */
  @objc
  internal func notifyDeletedWatchersFromCloud(_ notification: Notification) {
    guard let objectIDs = notification.userInfo?[NSDeletedObjectsKey] as? NSSet else {
      return
    }
    
    guard let moc = graph.managedObjectContext else {
      return
    }
    
    let objects = NSMutableSet()
    (objectIDs.allObjects as! [NSManagedObjectID]).forEach { [unowned moc] (objectID: NSManagedObjectID) in
      objects.add(moc.object(with: objectID))
    }
    
    delegateToDeletedWatchers(filtered(objects), source: .cloud)
  }
}

fileprivate extension Watch {
  /**
   Passes the handle to the inserted notification delegates.
   - Parameter _ set: A Set of AnyHashable objects to pass.
   - Parameter source: A GraphSource value.
   */
  func delegateToInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    delegateToEntityInsertedWatchers(set, source: source)
    delegateToRelationshipInsertedWatchers(set, source: source)
    delegateToActionInsertedWatchers(set, source: source)
  }
  
  /**
   Passes the handle to the inserted notification delegates for Entities.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToEntityInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    set.forEach { [unowned self] in
      guard let n = $0 as? ManagedEntity else {
        return
      }
      
      (self.delegate as? GraphEntityDelegate)?.graph?(self.graph, inserted: Entity(managedNode: n), source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedEntityTag else {
        return
      }
      
      guard let n = o.node as? ManagedEntity else {
        return
      }
      
      (self.delegate as? GraphEntityDelegate)?.graph?(self.graph, entity: Entity(managedNode: n), added: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedEntityGroup else {
        return
      }
      
      guard let n = o.node as? ManagedEntity else {
        return
      }
      
      (self.delegate as? GraphEntityDelegate)?.graph?(self.graph, entity: Entity(managedNode: n), addedTo: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedEntityProperty else {
        return
      }
      
      guard let n = o.node as? ManagedEntity else {
        return
      }
      
      (self.delegate as? GraphEntityDelegate)?.graph?(self.graph, entity: Entity(managedNode: n), added: o.name, with: o.object, source: source)
    }
  }
  
  /**
   Passes the handle to the inserted notification delegates for Relationships.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToRelationshipInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    set.forEach { [unowned self] in
      guard let n = $0 as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, inserted: Relationship(managedNode: n), source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedRelationshipTag else {
        return
      }
      
      guard let n = o.node as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, relationship: Relationship(managedNode: n), added: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedRelationshipGroup else {
        return
      }
      
      guard let n = o.node as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, relationship: Relationship(managedNode: n), addedTo: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedRelationshipProperty else {
        return
      }
      
      guard let n = o.node as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, relationship: Relationship(managedNode: n), added: o.name, with: o.object, source: source)
    }
  }
  
  /**
   Passes the handle to the inserted notification delegates for Actions.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToActionInsertedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    set.forEach { [unowned self] in
      guard let n = $0 as? ManagedAction else {
        return
      }
      
      (self.delegate as? GraphActionDelegate)?.graph?(self.graph, inserted: Action(managedNode: n), source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedActionTag else {
        return
      }
      
      guard let n = o.node as? ManagedAction else {
        return
      }
      
      (self.delegate as? GraphActionDelegate)?.graph?(self.graph, action: Action(managedNode: n), added: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedActionGroup else {
        return
      }
      
      guard let n = o.node as? ManagedAction else {
        return
      }
      
      (self.delegate as? GraphActionDelegate)?.graph?(self.graph, action: Action(managedNode: n), addedTo: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedActionProperty else {
        return
      }
      
      guard let n = o.node as? ManagedAction else {
        return
      }
      
      (self.delegate as? GraphActionDelegate)?.graph?(self.graph, action: Action(managedNode: n), added: o.name, with: o.object, source: source)
    }
  }
  
  /**
   Passes the handle to the updated notification delegates.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    delegateToEntityUpdatedWatchers(set, source: source)
    delegateToRelationshipUpdatedWatchers(set, source: source)
    delegateToActionUpdatedWatchers(set, source: source)
  }
  
  /**
   Passes the handle to the updated notification delegates for Entities.
   - Parameter nodes: An Array of ManagedObjects.
   - Parameter source: A GraphSource value.
   */
  func delegateToEntityUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedEntityProperty else {
        return
      }
      
      guard let n = o.node as? ManagedEntity else {
        return
      }
      
      (self.delegate as? GraphEntityDelegate)?.graph?(self.graph, entity: Entity(managedNode: n), updated: o.name, with: o.object, source: source)
    }
  }
  
  /**
   Passes the handle to the updated notification delegates for Relationships.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToRelationshipUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    set.forEach { [unowned self] in
      guard let n = $0 as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, updated: Relationship(managedNode: n), source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedRelationshipProperty else {
        return
      }
      
      guard let n = o.node as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, relationship: Relationship(managedNode: n), updated: o.name, with: o.object, source: source)
    }
  }
  
  /**
   Passes the handle to the updated notification delegates for Actions.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToActionUpdatedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedActionProperty else {
        return
      }
      
      guard let n = o.node as? ManagedAction else {
        return
      }
      
      (self.delegate as? GraphActionDelegate)?.graph?(self.graph, action: Action(managedNode: n), updated: o.name, with: o.object, source: source)
    }
  }
  
  /**
   Passes the handle to the deleted notification delegates.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    delegateToEntityDeletedWatchers(set, source: source)
    delegateToRelationshipDeletedWatchers(set, source: source)
    delegateToActionDeletedWatchers(set, source: source)
  }
  
  /**
   Passes the handle to the deleted notification delegates for Entities.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToEntityDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedEntityTag else {
        return
      }
      
      guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedEntity else {
        return
      }
      
      (self.delegate as? GraphEntityDelegate)?.graph?(self.graph, entity: Entity(managedNode: n), removed: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedEntityGroup else {
        return
      }
      
      guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedEntity else {
        return
      }
      
      (self.delegate as? GraphEntityDelegate)?.graph?(self.graph, entity: Entity(managedNode: n), removedFrom: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedEntityProperty else {
        return
      }
      
      guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedEntity else {
        return
      }
      
      (self.delegate as? GraphEntityDelegate)?.graph?(self.graph, entity: Entity(managedNode: n), removed: o.name, with: o.object, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let n = $0 as? ManagedEntity else {
        return
      }
      
      (self.delegate as? GraphEntityDelegate)?.graph?(self.graph, deleted: Entity(managedNode: n), source: source)
    }
  }
  
  /**
   Passes the handle to the deleted notification delegates for Relationships.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToRelationshipDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedRelationshipTag else {
        return
      }
      
      guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, relationship: Relationship(managedNode: n), removed: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedRelationshipGroup else {
        return
      }
      
      guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, relationship: Relationship(managedNode: n), removedFrom: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedRelationshipProperty else {
        return
      }
      
      guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, relationship: Relationship(managedNode: n), removed: o.name, with: o.object, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let n = $0 as? ManagedRelationship else {
        return
      }
      
      (self.delegate as? GraphRelationshipDelegate)?.graph?(self.graph, deleted: Relationship(managedNode: n), source: source)
    }
  }
  
  /**
   Passes the handle to the deleted notification delegates for Actions.
   - Parameter _ set: A Set of AnyHashable objects.
   - Parameter source: A GraphSource value.
   */
  func delegateToActionDeletedWatchers(_ set: Set<AnyHashable>, source: GraphSource) {
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedActionTag else {
        return
      }
      
      guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedAction else {
        return
      }
      
      (self.delegate as? GraphActionDelegate)?.graph?(self.graph, action: Action(managedNode: n), removed: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedActionGroup else {
        return
      }
      
      guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedAction else {
        return
      }
      
      (self.delegate as? GraphActionDelegate)?.graph?(self.graph, action: Action(managedNode: n), removedFrom: o.name, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let o = $0 as? ManagedActionProperty else {
        return
      }
      
      guard let n = (.cloud == source ? o.node : o.changedValuesForCurrentEvent()["node"]) as? ManagedAction else {
        return
      }
      
      (self.delegate as? GraphActionDelegate)?.graph?(self.graph, action: Action(managedNode: n), removed: o.name, with: o.object, source: source)
    }
    
    set.forEach { [unowned self] in
      guard let n = $0 as? ManagedAction else {
        return
      }
      
      (self.delegate as? GraphActionDelegate)?.graph?(self.graph, deleted: Action(managedNode: n), source: source)
    }
  }
  
  /// Removes the watcher.
  func removeFromObservation() {
    NotificationCenter.default.removeObserver(self)
  }
  
  /// Prepares the Watch instance.
  func prepare() {
    prepareGraph()
    resume()
  }
  
  /// Prepares the instance for save notifications.
  func addForObservation() {
    guard let moc = graph.managedObjectContext else {
      return
    }
    
    let defaultCenter = NotificationCenter.default
    defaultCenter.addObserver(self, selector: #selector(notifyInsertedWatchers), name: .NSManagedObjectContextDidSave, object: moc)
    defaultCenter.addObserver(self, selector: #selector(notifyUpdatedWatchers), name: .NSManagedObjectContextDidSave, object: moc)
    defaultCenter.addObserver(self, selector: #selector(notifyDeletedWatchers), name: .NSManagedObjectContextObjectsDidChange, object: moc)
  }
  
  /// Prepares graph for watching.
  fileprivate func prepareGraph() {
    graph.watchers.append(Watcher(object: self))
  }
  
  /**
   Filter node objects in the given NSSet based on the Predicate.
   - Parameter _ objects: An NSSet containing subclasses of ManagedObject.
   - Returns: A Set<AnyHashable>.
   */
  private func filtered(_ objects: NSSet) -> Set<AnyHashable> {
    guard let objects = objects as? Set<ManagedObject> else {
      return []
    }
    
    /**
     Check if both old and new states of the provided node
     passes the predicate.
     - Parameter _ node: A ManagedNode.
     - Returns: A Boolean.
     */
    func passesPredicate(_ node: ManagedNode) -> Bool {
      guard node.nodeClass == NodeClass(nodeType: T.self)?.rawValue else {
        return false
      }
      
      var tagSet = node.tagSet
      var groupSet = node.groupSet
      var propertySet = node.propertySet
      
      let oldNodeValues = node.changedValuesForCurrentEvent()
      
      
      if let oldTagSet = oldNodeValues["tagSet"] as? Set<ManagedTag> {
        tagSet.formUnion(oldTagSet)
      }
      
      if let oldGroupSet = oldNodeValues["groupSet"] as? Set<ManagedGroup> {
        groupSet.formUnion(oldGroupSet)
      }
      
      if let oldPropertySet = oldNodeValues["propertySet"] as? Set<ManagedProperty> {
        propertySet.formUnion(oldPropertySet)
      }
      
      let dictionary: [String: Any] = [
        "type": node.type,
        "tagSet": tagSet,
        "groupSet": groupSet,
        "propertySet": propertySet,
      ]
      
      return predicate.predicate.evaluate(with: dictionary)
    }
    
    let nodesThatPass = objects.filter {
      guard let n = $0 as? ManagedNode else {
        return false
      }
      
      return passesPredicate(n)
    }
    
    return nodesThatPass.union(objects.filter {
      guard let n = $0 as? NamedManagedObject else {
        return false
      }
      
      guard let v = n.node == nil ? (n.changedValuesForCurrentEvent()["node"] as? ManagedNode): n.node else {
        return false
      }
      
      return passesPredicate(v)
    })
  }
}
