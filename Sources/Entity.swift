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

@objc(Entity)
public class Entity: Node {
  /// A reference to the managedNode.
  internal var managedNode: ManagedEntity {
    return node as! ManagedEntity
  }
  
  
  /// A string representation of the Entity.
  public override var description: String {
    return "[nodeClass: \(nodeClass), id: \(id), type: \(type), tags: \(tags), groups: \(groups), properties: \(properties), createdDate: \(createdDate)]"
  }
  
  /// A reference to the nodeClass.
  public var nodeClass: NodeClass {
    return .entity
  }
  
  /**
   Retrieves all the Actions that are given.
   - Parameter types: A list of Strings.
   - Returns: An Array of Actions.
   */
  public func action(types: String...) -> [Action] {
    return action(types: types)
  }
  
  /**
   Retrieves all the Actions that are given.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Actions.
   */
  public func action(types: [String]) -> [Action] {
    return actions.filter {
      types.contains($0.type)
    }
  }
  
  /// A reference to all the Actions that the Entity is a part of.
  public var actions: [Action] {
    var s = managedNode.actionSubjectSet
    s.formUnion(managedNode.actionObjectSet)
    return s.map { Action(managedNode: $0) }
  }
  
  /**
   An Array of Actions the Entity belongs to when it's part of the
   subject set.
   */
  public var actionsWhenSubject: [Action] {
    return managedNode.actionSubjectSet.map { Action(managedNode: $0) }
  }
  
  /**
   An Array of Actions the Entity belongs to when it's part of the
   object set.
   */
  public var actionsWhenObject: [Action] {
    return managedNode.actionObjectSet.map { Action(managedNode: $0) }
  }
  
  /**
   Retrieves all the Relationships that are given.
   - Parameter types: A list of Strings.
   - Returns: An Array of Relationships.
   */
  public func relationship(types: String...) -> [Relationship] {
    return relationship(types: types)
  }
  
  /**
   Retrieves all the Relationships that are given.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Relationships.
   */
  public func relationship(types: [String]) -> [Relationship] {
    return self.relationships.filter { [types = types] (relationship) -> Bool in
      return types.contains(relationship.type)
    }
  }
  
  /// A reference to all the Relationships that the Entity is a part of.
  public var relationships: [Relationship] {
    var s = managedNode.relationshipSubjectSet
    s.formUnion(managedNode.relationshipObjectSet)
    return s.map { Relationship(managedNode: $0) }
  }
  
  /**
   An Array of Relationships the Entity belongs to when it's part of the
   subject set.
   */
  public var relationshipsWhenSubject: [Relationship] {
    return managedNode.performAndWait {
      $0.relationshipSubjectSet.map { Relationship(managedNode: $0) }
    }
  }
  
  /**
   An Array of Relationships the Entity belongs to when it's part of the
   object set.
   */
  public var relationshipsWhenObject: [Relationship] {
    return managedNode.performAndWait {
      $0.relationshipObjectSet.map { Relationship(managedNode: $0) }
    }
  }
  
  /// Generic creation of the managed node type.
  override class func createNode(_ type: String, in context: NSManagedObjectContext) -> ManagedNode {
    return ManagedEntity(type, managedObjectContext: context)
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
    return id == (object as? Entity)?.id
  }
  
  /**
   Sets the Entity as the subject of the Relationship and the
   passed in Entity as the object of the Relationship.
   - Parameters:
   - to entity: An Entity
   */
  public func relate(to entity: Entity) {
    let relationship = Relationship(managedNode: ManagedRelationship(type, managedObjectContext: managedNode.managedObjectContext!))
    relationship.subject = self
    relationship.object = entity
  }
  
  /**
   Sets the Entity as the subject of the Relationship.
   - Parameter relationship type: A String.
   - Returns: A Relationship.
   */
  @discardableResult
  public func `is`(relationship type: String) -> Relationship {
    let relationship = Relationship(managedNode: ManagedRelationship(type, managedObjectContext: managedNode.managedObjectContext!))
    relationship.subject = self
    return relationship
  }
  
  /**
   Sets the Entity as to the subjects set of an Action.
   - Parameter action type: A String.
   - Returns: A Action.
   */
  @discardableResult
  public func will(action type: String) -> Action {
    let action = Action(managedNode: ManagedAction(type, managedObjectContext: managedNode.managedObjectContext!))
    action.add(subjects: self)
    return action
  }
  
  /**
   Sets the Entity as to the subjects set of an Action.
   - Parameter action type: A String.
   - Returns: A Action.
   */
  @discardableResult
  public func did(action type: String) -> Action {
    return will(action: type)
  }
}
