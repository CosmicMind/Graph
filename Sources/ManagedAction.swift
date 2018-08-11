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
      performAndWait { action in
        let property = action.propertySet.first {
          ($0 as? ManagedActionProperty)?.name == name
        }
        
        guard let object = value else {
          property?.delete()
          return
        }
        
        guard let p = property else {
          guard let moc = managedObjectContext else {
            return
          }
          _ = ManagedActionProperty(name: name, object: object, node: action, managedObjectContext: moc)
          return
        }
        p.object = object
      }
    }
  }
  
  /**
   Adds a tag to the ManagedAction.
   - Parameter tag: An Array of Strings.
   */
  internal func add(tags: [String]) {
    guard let moc = managedObjectContext else {
      return
    }
    
    performAndWait { [unowned moc] action in
      for name in tags {
        guard !action.has(tags: name) else {
          continue
        }
        
        _ = ManagedActionTag(name: name, node: action, managedObjectContext: moc)
      }
    }
  }
  
  /**
   Removes a tag from a ManagedAction.
   - Parameter tags: An Array of Strings.
   */
  internal func remove(tags: [String]) {
    performAndWait { action in
      tags.forEach { name in
        action.tagSet.forEach {
          if let t = $0 as? ManagedActionTag, name == t.name {
            t.delete()
          }
        }
      }
    }
  }
  
  /**
   Adds the ManagedAction to a given group.
   - Parameter to groups: An Array of Strings.
   */
  internal func add(to groups: [String]) {
    guard let moc = managedObjectContext else {
      return
    }
    
    performAndWait { [unowned moc] relationship in
      for name in groups {
        guard !relationship.member(of: name) else {
          continue
        }
        
        _ = ManagedActionGroup(name: name, node: relationship, managedObjectContext: moc)
      }
    }
  }
  
  /**
   Removes the ManagedAction from a given group.
   - Parameter from groups: An Array of Strings.
   */
  internal func remove(from groups: [String]) {
    performAndWait { action in
      groups.forEach { name in
        action.groupSet.forEach {
          if let g = $0 as? ManagedActionGroup, name == g.name {
            g.delete()
          }
        }
      }
    }
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
