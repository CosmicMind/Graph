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

import Foundation

@objc(Entity)
public class Entity: Node {
  /// A reference to the managedNode.
  internal let managedNode: ManagedEntity
  
  /// A reference to the managedNode for base class.
  override var node: ManagedNode {
    return managedNode
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
  
  /**
   Initializer that accepts a ManagedEntity.
   - Parameter managedNode: A reference to a ManagedEntity.
   */
  internal init(managedNode: ManagedEntity) {
    self.managedNode = managedNode
  }
  
  /**
   Initializer that accepts a type and graph. The graph
   indicates which graph to save to.
   - Parameter _ type: A reference to a type.
   - Parameter graph: A reference to a Graph instance by name.
   */
  @nonobjc
  public convenience init(_ type: String, graph: String) {
    let context = Graph(name: graph).managedObjectContext
    var managedNode: ManagedEntity?
    context?.performAndWait {
      managedNode = ManagedEntity(type, managedObjectContext: context!)
    }
    self.init(managedNode: managedNode!)
  }
  
  /**
   Initializer that accepts a type and graph. The graph
   indicates which graph to save to.
   - Parameter _ type: A reference to a type.
   - Parameter graph: A reference to a Graph instance.
   */
  public convenience init(_ type: String, graph: Graph) {
    let context = graph.managedObjectContext
    var managedNode: ManagedEntity?
    context?.performAndWait {
      managedNode = ManagedEntity(type, managedObjectContext: context!)
    }
    self.init(managedNode: managedNode!)
  }
  
  /**
   Initializer that accepts a type value.
   - Parameter _ type: A reference to a type.
   */
  public convenience init(_ type: String) {
    self.init(type, graph: GraphStoreDescription.name)
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
