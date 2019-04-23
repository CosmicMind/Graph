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

@objc(ManagedAction)
internal class ManagedAction: ManagedNode {
  @NSManaged internal var subjectSet: Set<ManagedEntity>
  @NSManaged internal var objectSet: Set<ManagedEntity>
  
  /**
   Initializer that accepts a type and a NSManagedObjectContext.
   - Parameter type: A reference to the Action type.
   - Parameter managedObjectContext: A reference to the NSManagedObejctContext.
   */
  convenience init(_ type: String, managedObjectContext: NSManagedObjectContext) {
    self.init(identifier: ModelIdentifier.actionName, type: type, managedObjectContext: managedObjectContext)
    nodeClass = NodeClass.action.rawValue
    subjectSet = []
    objectSet = []
  }
  
  /// Generic creation of the managed tag type.
  override class func createTag(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedActionTag(name: name, node: node, managedObjectContext: managedObjectContext)
  }
  
  /// Generic creation of the managed group type.
  override class func createGroup(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedActionGroup(name: name, node: node, managedObjectContext: managedObjectContext)
  }
  
  /// Generic creation of the managed property type.
  override class func createProperty(name: String, object: Any, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedActionProperty(name: name, object: object, node: node, managedObjectContext: managedObjectContext)
  }
  
  /// Generic cast to the managed tag type.
  override class func asTag(_ tag: ManagedTag) -> ManagedTag? {
    return tag as? ManagedActionTag
  }
  
  /// Generic cast to the managed group type.
  override class func asGroup(_ group: ManagedGroup) -> ManagedGroup? {
    return group as? ManagedActionGroup
  }
  
  /// Generic cast to the managed property type.
  override class func asProperty(_ property: ManagedProperty) -> ManagedProperty? {
    return property as? ManagedActionProperty
  }
  
  /**
   Adds a ManagedEntity to the subjectSet.
   - Parameter subject managedEntity: A ManagedEntity to add.
   */
  func add(subject managedEntity: ManagedEntity) {
    performAndWait { [unowned managedEntity] in
      _ = $0.subjectSet.insert(managedEntity)
    }
  }
  
  /**
   Removes a ManagedEntity from the subjectSet.
   - Parameter subject managedEntity: A ManagedEntity to remove.
   */
  func remove(subject managedEntity: ManagedEntity) {
    performAndWait { [unowned managedEntity] in
      _ = $0.subjectSet.remove(managedEntity)
    }
  }
  
  /**
   Adds a ManagedEntity to the objectSet.
   - Parameter object managedEntity: A ManagedEntity to add.
   */
  func add(object managedEntity: ManagedEntity) {
    performAndWait { [unowned managedEntity] in
      _ = $0.objectSet.insert(managedEntity)
    }
  }
  
  /**
   Removes a ManagedEntity from the objectSet.
   - Parameter object managedEntity: A ManagedEntity to remove.
   */
  func remove(object managedEntity: ManagedEntity) {
    performAndWait { [unowned managedEntity] in
      _ = $0.objectSet.remove(managedEntity)
    }
  }
  
  /// Marks the Action for deletion and clears all its relationships.
  override func delete() {
    performAndWait { action in
      action.propertySet.forEach {
        ($0 as? ManagedActionProperty)?.delete()
      }
      
      action.tagSet.forEach {
        ($0 as? ManagedActionTag)?.delete()
      }
      
      action.groupSet.forEach {
        ($0 as? ManagedActionGroup)?.delete()
      }
    }
    
    super.delete()
  }
}
