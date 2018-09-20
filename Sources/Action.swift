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

@objc(Action)
public class Action: Node {
  /// A reference to the managedNode.
  internal var managedNode: ManagedAction {
    return node as! ManagedAction
  }
  
  public override var description: String {
    return "[nodeClass: \(nodeClass), id: \(id), type: \(type), tags: \(tags), groups: \(groups), properties: \(properties), subjects: \(subjects), objects: \(objects), createdDate: \(createdDate)]"
  }
  
  /// A reference to the nodeClass.
  public var nodeClass: NodeClass {
    return .action
  }
  
  /// An Array of Entity subjects.
  public var subjects: [Entity] {
    return managedNode.performAndWait { action in
      action.subjectSet.map { Entity(managedNode: $0) }
    } ?? []
  }
  
  /// An Array of Entity objects.
  public var objects: [Entity] {
    return managedNode.performAndWait { action in
      action.objectSet.map { Entity(managedNode: $0) }
    } ?? []
  }
  
  /// Generic creation of the managed node type.
  override class func createNode(_ type: String, in context: NSManagedObjectContext) -> ManagedNode {
    return ManagedAction(type, managedObjectContext: context)
  }
  
  /**
   Initializer that accepts a ManagedAction.
   - Parameter managedNode: A reference to a ManagedAction.
   */
  required init(managedNode: ManagedNode) {
    super.init(managedNode: managedNode)
  }
  
  /**
   Checks equality between Entities.
   - Parameter object: A reference to an object to test
   equality against.
   - Returns: A boolean of the result, true if equal, false
   otherwise.
   */
  public override func isEqual(_ object: Any?) -> Bool {
    return id == (object as? Action)?.id
  }
  
  /**
   Adds an Entity to the subject set.
   - Parameter subejct: A list of Entity objects.
   - Returns: The Action.
   */
  @discardableResult
  public func add(subjects: Entity...) -> Action {
    return add(subjects: subjects)
  }
  
  /**
   Adds an Array of Entity objects to the subject set.
   - Parameter subjects: An Array of Entity objects.
   - Returns: The Action.
   */
  @discardableResult
  public func add(subjects: [Entity]) -> Action {
    for s in subjects {
      managedNode.add(subject: s.managedNode)
    }
    return self
  }
  
  /**
   Removes an Entity from the subject set.
   - Parameter subject: A list of Entity objects.
   - Returns: The Action.
   */
  @discardableResult
  public func remove(subjects: Entity...) -> Action {
    return remove(subjects: subjects)
  }
  
  /**
   Removes an Array of Entity objects from the subject set.
   - Parameter subjects: An Array of Entity objects.
   - Returns: The Action.
   */
  @discardableResult
  public func remove(subjects: [Entity]) -> Action {
    for s in subjects {
      managedNode.remove(subject: s.managedNode)
    }
    return self
  }
  
  /**
   Adds an Entity to the object set.
   - Parameter object: A list of Entity objects.
   - Returns: The Action.
   */
  @discardableResult
  public func add(objects: Entity...) -> Action {
    return add(objects: objects)
  }
  
  /**
   Adds an Array of Entity objects to the objects set.
   - Parameter subjects: An Array of Entity objects.
   - Returns: The Action.
   */
  @discardableResult
  public func add(objects: [Entity]) -> Action {
    for o in objects {
      managedNode.add(object: o.managedNode)
    }
    return self
  }
  
  /**
   Removes an Entity from the object set.
   - Parameter object: A list of Entity objects.
   - Returns: The Action.
   */
  @discardableResult
  public func remove(objects: Entity...) -> Action {
    return remove(objects: objects)
  }
  
  /**
   Removes an Array of Entity objects from the subject set.
   - Parameter objects: An Array of Entity objects.
   - Returns: The Action.
   */
  @discardableResult
  public func remove(objects: [Entity]) -> Action {
    for o in objects {
      managedNode.remove(object: o.managedNode)
    }
    return self
  }
  
  /**
   Adds an Entity to the objects set.
   - Parameter objects: A list of Entity objects..
   - Returns: The Action.
   */
  @discardableResult
  public func what(objects: Entity...) -> Action {
    return what(objects: objects)
  }
  
  /**
   Adds an Array of Entity objects to the objects set.
   - Parameter objects: An Array of Entity objects.
   - Returns: The Action.
   */
  @discardableResult
  public func what(objects: [Entity]) -> Action {
    return add(objects: objects)
  }
}

extension Action {
  /**
   Finds the given types of subject Entities that are part
   of the Action.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func subject(types: String...) -> [Entity] {
    return subject(types: types)
  }
  
  /**
   Finds the given types of subject Entities that are part
   of the Action.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func subject(types: [String]) -> [Entity] {
    var s = Set<Entity>()
    subjects.forEach { [types = types] (e) in
      guard types.contains(e.type) else {
        return
      }
      
      s.insert(e)
    }
    return [Entity](s)
  }
  
  /**
   Finds the given types of object Entities that are part
   of the Action.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func object(types: String...) -> [Entity] {
    return object(types: types)
  }
  
  /**
   Finds the given types of object Entities that are part
   of the Action.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func object(types: [String]) -> [Entity] {
    var s = Set<Entity>()
    objects.forEach { [types = types] (e) in
      guard types.contains(e.type) else {
        return
      }
      
      s.insert(e)
    }
    return [Entity](s)
  }
}

extension Array where Element: Action {
  /**
   Finds the given types of subject Entities that are part
   of the Actions in the Array.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func subject(types: String...) -> [Entity] {
    return subject(types: types)
  }
  
  /**
   Finds the given types of subject Entities that are part
   of the Actions in the Array.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func subject(types: [String]) -> [Entity] {
    var s = Set<Entity>()
    forEach { [types = types] (a) in
      a.subject(types: types).forEach {
        s.insert($0)
      }
    }
    return [Entity](s)
  }
  
  /**
   Finds the given types of object Entities that are part
   of the Actions in the Array.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func object(types: String...) -> [Entity] {
    return object(types: types)
  }
  
  /**
   Finds the given types of object Entities that are part
   of the Actions in the Array.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func object(types: [String]) -> [Entity] {
    var s = Set<Entity>()
    forEach { [types = types] (a) in
      a.object(types: types).forEach {
        s.insert($0)
      }
    }
    return [Entity](s)
  }
}
