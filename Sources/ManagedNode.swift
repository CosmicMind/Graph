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

@objc(ManagedNode)
internal class ManagedNode: ManagedObject {
  @NSManaged internal var nodeClass: Int
  @NSManaged internal var type: String
  @NSManaged internal var createdDate: Date
  @NSManaged internal var propertySet: Set<ManagedProperty>
  @NSManaged internal var tagSet: Set<ManagedTag>
  @NSManaged internal var groupSet: Set<ManagedGroup>
  
  /// A reference to the Nodes unique ID.
  internal var id: String {
    guard let moc = managedObjectContext else {
      fatalError("[Graph Error: Cannot obtain permanent objectID]")
    }
    
    return performAndWait { [unowned moc] `self` in
      do {
        try moc.obtainPermanentIDs(for: [self])
      } catch let e as NSError {
        fatalError("[Graph Error: Cannot obtain permanent objectID - \(e.localizedDescription)]")
      }
      return String(stringInterpolationSegment: self.nodeClass) + self.type + self.objectID.uriRepresentation().lastPathComponent
    }
  }
  
  /// A reference to the tags.
  internal var tags: [String] {
    return performAndWait { node in
      node.tagSet.map { $0.name }
    } ?? []
  }
  
  /// A reference to the groups.
  internal var groups: [String] {
    return performAndWait { node in
      node.groupSet.map { $0.name }
    } ?? []
  }
  
  /// A reference to the properties.
  internal var properties: [String: Any] {
    return performAndWait { node in
      var p = [String: Any]()
      node.propertySet.forEach {
        p[$0.name] = $0.object
      }
      return p
    } ?? [:]
  }
  
  /**
   Initializer that accepts an identifier, a type, and a NSManagedObjectContext.
   - Parameter identifier: A model identifier.
   - Parameter type: A reference to the Entity type.
   - Parameter managedObjectContext: A reference to the NSManagedObejctContext.
   */
  internal convenience init(identifier: String, type: String, managedObjectContext: NSManagedObjectContext) {
    self.init(entity: NSEntityDescription.entity(forEntityName: identifier, in: managedObjectContext)!, insertInto: managedObjectContext)
    self.type = type
    createdDate = Date()
    propertySet = []
    tagSet = []
    groupSet = []
  }
  
  /**
   Access properties using the subscript operator.
   - Parameter name: A property name value.
   - Returns: The optional Any value.
   */
  internal subscript(name: String) -> Any? {
    get {
      return performAndWait { node in
        node.propertySet.first {
          $0.name == name
        }?.object
      }
    }
  }
  
  /**
   Checks if the ManagedNode has a given tag.
   - Parameter tag: A tag name.
   - Returns: A boolean of the result, true if has the given tag,
   false otherwise.
   */
  internal func has(tags: String...) -> Bool {
    return has(tags: tags)
  }
  
  /**
   Checks if the ManagedNode has a the given tags.
   - Parameter tags: An Array of Strings.
   - Returns: A boolean of the result, true if has the tags, 
   false otherwise.
   */
  internal func has(tags: [String]) -> Bool {
    let t = self.tags
    for tag in tags {
      guard t.contains(tag) else {
        return false
      }
    }
    return true
  }
  
  /**
   Checks if the ManagedNode is a member of a group.
   - Parameter of groups: A list of Strings.
   - Returns: A boolean of the result, true if a member, false
   otherwise.
   */
  internal func member(of groups: String...) -> Bool {
    return member(of: groups)
  }
  
  /**
   Checks if the ManagedNode is a member of a group.
   - Parameter of groups: An Array of Strings.
   - Returns: A boolean of the result, true if a member, false
   otherwise.
   */
  internal func member(of groups: [String]) -> Bool {
    guard let moc = managedObjectContext else {
      return false
    }
    var result: Bool? = false
    moc.performAndWait { [unowned self, groups = groups] in
      for name in groups {
        for g in self.groupSet {
          if name == g.name {
            result = true
            break
          }
        }
      }
    }
    return result!
  }
}

extension ManagedNode : Comparable {
  static public func ==(lhs: ManagedNode, rhs: ManagedNode) -> Bool {
    return lhs.id == rhs.id
  }
  
  static public func <(lhs: ManagedNode, rhs: ManagedNode) -> Bool {
    return lhs.id < rhs.id
  }
}

