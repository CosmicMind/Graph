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

@objc(ManagedAction)
internal class ManagedAction: ManagedNode {
  @NSManaged internal var subjectSet: Set<ManagedEntity>
  @NSManaged internal var objectSet: Set<ManagedEntity>
  
  /**
   Initializer that accepts a type and a NSManagedObjectContext.
   - Parameter type: A reference to the Action type.
   - Parameter managedObjectContext: A reference to the NSManagedObejctContext.
   */
  internal convenience init(_ type: String, managedObjectContext: NSManagedObjectContext) {
    self.init(identifier: ModelIdentifier.actionName, type: type, managedObjectContext: managedObjectContext)
    nodeClass = NodeClass.action.rawValue
    subjectSet = []
    objectSet = []
  }
  
  /// Generic creation of the managed tag type.
  internal override class func createTag(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
        _ = ManagedActionTag(name: name, node: node, managedObjectContext: managedObjectContext)
  }
  
  /// Generic creation of the managed group type.
  internal override class func createGroup(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedActionGroup(name: name, node: node, managedObjectContext: managedObjectContext)
  }
  
  /// Generic creation of the managed property type.
  internal override class func createProperty(name: String, object: Any, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedActionProperty(name: name, object: object, node: node, managedObjectContext: managedObjectContext)
  }
  
  /// Generic cast to the managed tag type.
  internal override class func asTag(_ tag: ManagedTag) -> ManagedTag? {
    return tag as? ManagedActionTag
  }
  
  /// Generic cast to the managed group type.
  internal override class func asGroup(_ group: ManagedGroup) -> ManagedGroup? {
    return group as? ManagedActionGroup
  }
  
  /// Generic cast to the managed property type.
  internal override class func asProperty(_ property: ManagedProperty) -> ManagedProperty? {
    return property as? ManagedActionProperty
  }
  
  /**
   Adds a ManagedEntity to the subjectSet.
   - Parameter subject managedEntity: A ManagedEntity to add.
   */
  internal func add(subject managedEntity: ManagedEntity) {
    performAndWait { [unowned managedEntity] in
      _ = $0.subjectSet.insert(managedEntity)
    }
  }
  
  /**
   Removes a ManagedEntity from the subjectSet.
   - Parameter subject managedEntity: A ManagedEntity to remove.
   */
  internal func remove(subject managedEntity: ManagedEntity) {
    performAndWait { [unowned managedEntity] in
      _ = $0.subjectSet.remove(managedEntity)
    }
  }
  
  /**
   Adds a ManagedEntity to the objectSet.
   - Parameter object managedEntity: A ManagedEntity to add.
   */
  internal func add(object managedEntity: ManagedEntity) {
    performAndWait { [unowned managedEntity] in
      _ = $0.objectSet.insert(managedEntity)
    }
  }
  
  /**
   Removes a ManagedEntity from the objectSet.
   - Parameter object managedEntity: A ManagedEntity to remove.
   */
  internal func remove(object managedEntity: ManagedEntity) {
    performAndWait { [unowned managedEntity] in
      _ = $0.objectSet.remove(managedEntity)
    }
  }
  
  /// Marks the Action for deletion and clears all its relationships.
  internal override func delete() {
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
