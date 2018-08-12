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

@objc(ManagedRelationship)
internal class ManagedRelationship: ManagedNode {
  @NSManaged internal var subject: ManagedEntity?
  @NSManaged internal var object: ManagedEntity?
  
  /**
   Initializer that accepts a type and a NSManagedObjectContext.
   - Parameter type: A reference to the Relationship type.
   - Parameter managedObjectContext: A reference to the NSManagedObejctContext.
   */
  internal convenience init(_ type: String, managedObjectContext: NSManagedObjectContext) {
    self.init(identifier: ModelIdentifier.relationshipName, type: type, managedObjectContext: managedObjectContext)
    nodeClass = NodeClass.relationship.rawValue
    subject = nil
    object = nil
  }
  
  internal override class func createTag(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedRelationshipTag(name: name, node: node, managedObjectContext: managedObjectContext)
  }
  
  internal override class func createGroup(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedRelationshipGroup(name: name, node: node, managedObjectContext: managedObjectContext)
  }
  
  internal override class func createProperty(name: String, object: Any, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    _ = ManagedRelationshipProperty(name: name, object: object, node: node, managedObjectContext: managedObjectContext)
  }
  
  internal override class func asTag(_ tag: ManagedTag) -> ManagedTag? {
    return tag as? ManagedRelationshipTag
  }
  
  internal override class func asGroup(_ group: ManagedGroup) -> ManagedGroup? {
    return group as? ManagedRelationshipGroup
  }
  
  internal override class func asProperty(_ property: ManagedProperty) -> ManagedProperty? {
    return property as? ManagedRelationshipProperty
  }
 
  /// Marks the Relationship for deletion and clears all its relationships.
  internal override func delete() {
    performAndWait { relationship in
      relationship.propertySet.forEach {
        ($0 as? ManagedRelationshipProperty)?.delete()
      }
      
      relationship.tagSet.forEach {
        ($0 as? ManagedRelationshipTag)?.delete()
      }
      
      relationship.groupSet.forEach {
        ($0 as? ManagedRelationshipGroup)?.delete()
      }
      
      relationship.subject?.relationshipSubjectSet.remove(self)
      relationship.object?.relationshipObjectSet.remove(self)
    }
    
    super.delete()
  }
}
