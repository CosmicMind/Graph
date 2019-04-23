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

@objc(Relationship)
public class Relationship: Node {
  /// A reference to the managedNode.
  internal var managedNode: ManagedRelationship {
    return node as! ManagedRelationship
  }
  
  public override var description: String {
    return "[nodeClass: \(nodeClass), id: \(id), type: \(type), tags: \(tags), groups: \(groups), properties: \(properties), subject: \(String(describing: subject)), object: \(String(describing: object)), createdDate: \(createdDate)]"
  }
  
  /// A reference to the nodeClass.
  public var nodeClass: NodeClass {
    return .relationship
  }
  
  /// A reference to the subject Entity.
  public var subject: Entity? {
    get {
      return managedNode.performAndWait { relationship in
        relationship.subject.map { Entity(managedNode: $0) }
      }
    }
    set(entity) {
      managedNode.managedObjectContext?.performAndWait { [unowned self] in
        if let e = entity?.managedNode {
          self.managedNode.subject?.relationshipSubjectSet.remove(self.managedNode)
          self.managedNode.subject = e
          e.relationshipSubjectSet.insert(self.managedNode)
        } else {
          self.managedNode.subject?.relationshipSubjectSet.remove(self.managedNode)
          self.managedNode.subject = nil
        }
      }
    }
  }
  
  /// A reference to the object Entity.
  public var object: Entity? {
    get {
      return managedNode.performAndWait { relationship in
        relationship.object.map { Entity(managedNode: $0) }
      }
    }
    set(entity) {
      managedNode.managedObjectContext?.performAndWait { [unowned self] in
        if let e = entity?.managedNode {
          self.managedNode.object?.relationshipObjectSet.remove(self.managedNode)
          self.managedNode.object = e
          e.relationshipObjectSet.insert(self.managedNode)
        } else {
          self.managedNode.object?.relationshipObjectSet.remove(self.managedNode)
          self.managedNode.object = nil
        }
      }
    }
  }
  
  /// Generic creation of the managed node type.
  override class func createNode(_ type: String, in context: NSManagedObjectContext) -> ManagedNode {
    return ManagedRelationship(type, managedObjectContext: context)
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
    return id == (object as? Relationship)?.id
  }
  
  /**
   Sets the object of the Relationship.
   - Parameter _ entity: An Entity.
   - Returns: The Relationship.
   */
  @discardableResult
  public func of(_ entity: Entity) -> Relationship {
    self.object = entity
    return self
  }
  
  /**
   Sets the object of the Relationship.
   - Parameter object: An Entity.
   - Returns: The Relationship.
   */
  @discardableResult
  public func `in`(object: Entity) -> Relationship {
    self.object = object
    return self
  }
}

extension Array where Element: Relationship {
  /**
   Finds the given types of subject Entities that are part
   of the relationships in the Array.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func subject(types: String...) -> [Entity] {
    return subject(types: types)
  }
  
  /**
   Finds the given types of subject Entities that are part
   of the relationships in the Array.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func subject(types: [String]) -> [Entity] {
    var s : Set<Entity> = []
    forEach { [types = types] (r) in
      guard let e = r.subject else {
        return
      }
      
      guard types.contains(e.type) else {
        return
      }
      
      s.insert(e)
    }
    return [Entity](s)
  }
  
  /**
   Finds the given types of object Entities that are part
   of the relationships in the Array.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func object(types: String...) -> [Entity] {
    return object(types: types)
  }
  
  /**
   Finds the given types of object Entities that are part
   of the relationships in the Array.
   - Parameter types: An Array of Strings.
   - Returns: An Array of Entities.
   */
  public func object(types: [String]) -> [Entity] {
    var s : Set<Entity> = []
    forEach { [types = types] (r) in
      guard let e = r.subject else {
        return
      }
      
      guard types.contains(e.type) else {
        return
      }
      
      s.insert(e)
    }
    return [Entity](s)
  }
}
