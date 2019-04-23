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
