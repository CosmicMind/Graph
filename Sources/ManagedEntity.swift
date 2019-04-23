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

@objc(ManagedEntity)
internal class ManagedEntity: ManagedNode {
  @NSManaged internal var actionSubjectSet: Set<ManagedAction>
  @NSManaged internal var actionObjectSet:  Set<ManagedAction>
  @NSManaged internal var relationshipSubjectSet: Set<ManagedRelationship>
  @NSManaged internal var relationshipObjectSet: Set<ManagedRelationship>
  
  /**
   Initializer that accepts a type and a NSManagedObjectContext.
   - Parameter type: A reference to the Entity type.
   - Parameter managedObjectContext: A reference to the NSManagedObejctContext.
   */
  convenience init(_ type: String, managedObjectContext: NSManagedObjectContext) {
    self.init(identifier: ModelIdentifier.entityName, type: type, managedObjectContext: managedObjectContext)
    nodeClass = NodeClass.entity.rawValue
    actionSubjectSet = []
    actionObjectSet = []
    relationshipSubjectSet = []
    relationshipObjectSet = []
  }
  
  /// Generic creation of the managed tag type.
  override class func createTag(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedEntityTag(name: name, node: node, managedObjectContext: managedObjectContext)
  }
  
  /// Generic creation of the managed group type.
  override class func createGroup(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedEntityGroup(name: name, node: node, managedObjectContext: managedObjectContext)
  }
  
  /// Generic creation of the managed property type.
  override class func createProperty(name: String, object: Any, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedEntityProperty(name: name, object: object, node: node, managedObjectContext: managedObjectContext)
  }
  
  /// Generic cast to the managed tag type.
  override class func asTag(_ tag: ManagedTag) -> ManagedTag? {
    return tag as? ManagedEntityTag
  }
  
  /// Generic cast to the managed group type.
  override class func asGroup(_ group: ManagedGroup) -> ManagedGroup? {
    return group as? ManagedEntityGroup
  }
  
  /// Generic cast to the managed property type.
  override class func asProperty(_ property: ManagedProperty) -> ManagedProperty? {
    return property as? ManagedEntityProperty
  }
  
  /// Marks the Entity for deletion and clears all its relationships.
  internal override func delete() {
    performAndWait { entity in
      entity.propertySet.forEach {
        $0.delete()
      }
      
      entity.tagSet.forEach {
        $0.delete()
      }
      
      entity.groupSet.forEach {
        $0.delete()
      }
      
      entity.actionSubjectSet.forEach {
        $0.delete()
      }
      
      entity.actionObjectSet.forEach {
        $0.delete()
      }
      
      entity.relationshipSubjectSet.forEach {
        $0.delete()
      }
      
      entity.relationshipObjectSet.forEach {
        $0.delete()
      }
    }
    
    super.delete()
  }
}
