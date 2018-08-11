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
  internal convenience init(_ type: String, managedObjectContext: NSManagedObjectContext) {
    self.init(identifier: ModelIdentifier.entityName, type: type, managedObjectContext: managedObjectContext)
    nodeClass = NodeClass.entity.rawValue
    actionSubjectSet = []
    actionObjectSet = []
    relationshipSubjectSet = []
    relationshipObjectSet = []
  }
  
  /**
   Access properties using the subscript operator.
   - Parameter name: A property name value.
   - Returns: The optional Any value.
   */
  internal override subscript(name: String) -> Any? {
    get {
      return super[name]
    }
    set(value) {
      performAndWait { entity in
        let property = entity.propertySet.first {
          ($0 as? ManagedEntityProperty)?.name == name
        }
        
        guard let object = value else {
          property?.delete()
          return
        }
        
        guard let p = property else {
          guard let moc = managedObjectContext else {
            return
          }
          _ = ManagedEntityProperty(name: name, object: object, node: entity, managedObjectContext: moc)
          return
        }
        p.object = object
      }
    }
  }
  
  /**
   Adds a tag to the ManagedEntity.
   - Parameter tag: An Array of Strings.
   */
  internal func add(tags: [String]) {
    guard let moc = managedObjectContext else {
      return
    }
    
    performAndWait { [unowned moc] entity in
      for name in tags {
        guard !entity.has(tags: name) else {
          continue
        }
        
        _ = ManagedEntityTag(name: name, node: entity, managedObjectContext: moc)
      }
    }
  }
  
  /**
   Removes a tag from a ManagedEntity.
   - Parameter tags: An Array of Strings.
   */
  internal func remove(tags: [String]) {
    performAndWait { entity in
      tags.forEach { name in
        entity.tagSet.forEach {
          if let t = $0 as? ManagedEntityTag, name == t.name {
            t.delete()
          }
        }
      }
    }
  }
  
  /**
   Adds the ManagedEntity to a given group.
   - Parameter to groups: An Array of Strings.
   */
  internal func add(to groups: [String]) {
    guard let moc = managedObjectContext else {
      return
    }
    
    performAndWait { [unowned moc] entity in
      for name in groups {
        guard !entity.member(of: name) else {
          continue
        }
        
        _ = ManagedEntityGroup(name: name, node: entity, managedObjectContext: moc)
      }
    }
  }
  
  /**
   Removes the ManagedEntity from a given group.
   - Parameter from groups: An Array of Strings.
   */
  internal func remove(from groups: [String]) {
    performAndWait { entity in
      groups.forEach { name in
        entity.groupSet.forEach {
          if let g = $0 as? ManagedEntityGroup, name == g.name {
            g.delete()
          }
        }
      }
    }
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
