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
