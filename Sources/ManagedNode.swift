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

@objc(ManagedNode)
internal class ManagedNode: ManagedObject {
  @NSManaged internal var nodeClass: Int
  @NSManaged internal var type: String
  @NSManaged internal var createdDate: Date
  @NSManaged internal var propertySet: Set<ManagedProperty>
  @NSManaged internal var tagSet: Set<ManagedTag>
  @NSManaged internal var groupSet: Set<ManagedGroup>
  
  /// A reference to the Nodes unique ID.
  var id: String {
    guard let moc = managedObjectContext else {
      fatalError("[Graph Error: Cannot obtain permanent objectID]")
    }
    
    return performAndWait { [unowned moc] `self` in
      do {
        try moc.obtainPermanentIDs(for: [self])
      } catch let e as NSError {
        fatalError("[Graph Error: Cannot obtain permanent objectID - \(e.localizedDescription)]")
      }
      return "\(self.nodeClass)" + self.type + self.objectID.uriRepresentation().lastPathComponent
    }
  }
  
  /// A reference to the tags.
  var tags: [String] {
    return performAndWait { node in
      node.tagSet.map { $0.name }
      } ?? []
  }
  
  /// A reference to the groups.
  var groups: [String] {
    return performAndWait { node in
      node.groupSet.map { $0.name }
      } ?? []
  }
  
  /// A reference to the properties.
  internal var properties: [String: Any] {
    return performAndWait { node in
      node.propertySet.reduce(into: [String: Any]()) {
        $0[$1.name] = $1.object
      }
      } ?? [:]
  }
  
  /**
   Initializer that accepts an identifier, a type, and a NSManagedObjectContext.
   - Parameter identifier: A model identifier.
   - Parameter type: A reference to the Node type.
   - Parameter managedObjectContext: A reference to the NSManagedObejctContext.
   */
  convenience init(identifier: String, type: String, managedObjectContext: NSManagedObjectContext) {
    self.init(entity: NSEntityDescription.entity(forEntityName: identifier, in: managedObjectContext)!, insertInto: managedObjectContext)
    self.type = type
    createdDate = Date()
    propertySet = []
    tagSet = []
    groupSet = []
  }
  
  /**
   Adds a tag to the ManagedNode.
   - Parameter tag: An Array of Strings.
   */
  internal func add(tags: [String]) {
    guard let moc = managedObjectContext else {
      return
    }
    
    performAndWait { [unowned moc] node in
      for name in tags {
        guard !node.has(tags: name) else {
          continue
        }
        
        Swift.type(of: self).createTag(name: name, node: node, managedObjectContext: moc)
      }
    }
  }
  
  /**
   Removes a tag from the ManagedNode.
   - Parameter tags: An Array of Strings.
   */
  internal func remove(tags: [String]) {
    performAndWait { node in
      tags.forEach { name in
        node.tagSet.forEach {
          if let t = Swift.type(of: self).asTag($0), name == t.name {
            t.delete()
          }
        }
      }
    }
  }
  
  /**
   Adds the ManagedNode to a given group.
   - Parameter to groups: An Array of Strings.
   */
  internal func add(to groups: [String]) {
    guard let moc = managedObjectContext else {
      return
    }
    
    performAndWait { [unowned moc] node in
      for name in groups {
        guard !node.member(of: name) else {
          continue
        }
        
        Swift.type(of: self).createGroup(name: name, node: node, managedObjectContext: moc)
      }
    }
  }
  
  /**
   Removes the ManagedNode from a given group.
   - Parameter from groups: An Array of Strings.
   */
  internal func remove(from groups: [String]) {
    performAndWait { node in
      groups.forEach { name in
        node.groupSet.forEach {
          if let g = Swift.type(of: self).asGroup($0), name == g.name {
            g.delete()
          }
        }
      }
    }
  }
  
  /// Generic creation of the managed tag type.
  internal class func createTag(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    fatalError("Must be implemented by subclasses")
  }
  
  /// Generic cast to the managed tag type.
  internal class func asTag(_ tag: ManagedTag) -> ManagedTag? {
    fatalError("Must be implemented by subclasses")
  }
  
  /// Generic creation of the managed group type.
  internal class func createGroup(name: String, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    fatalError("Must be implemented by subclasses")
  }
  
  /// Generic cast to the managed group type.
  internal class func asGroup(_ group: ManagedGroup) -> ManagedGroup? {
    fatalError("Must be implemented by subclasses")
  }
  
  /// Generic creation of the managed property type.
  internal class func createProperty(name: String, object: Any, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {
    fatalError("Must be implemented by subclasses")
  }
  
  /// Generic cast to the managed property type.
  internal class func asProperty(_ property: ManagedProperty) -> ManagedProperty? {
    fatalError("Must be implemented by subclasses")
  }
  
  /**
   Access properties using the subscript operator.
   - Parameter name: A property name value.
   - Returns: The optional Any value.
   */
  subscript(name: String) -> Any? {
    get {
      return performAndWait { node in
        node.propertySet.first {
          $0.name == name
          }?.object
      }
    }
    set(value) {
      performAndWait { action in
        let property = action.propertySet.first {
          Swift.type(of: self).asProperty($0)?.name == name
        }
        
        guard let object = value else {
          property?.delete()
          return
        }
        
        guard let p = property else {
          guard let moc = managedObjectContext else {
            return
          }
          
          Swift.type(of: self).createProperty(name: name, object: object, node: action, managedObjectContext: moc)
          return
        }
        
        p.object = object
      }
    }
  }
  
  /**
   Checks if the ManagedNode has a given tag.
   - Parameter tag: A tag name.
   - Returns: A boolean of the result, true if has the given tag,
   false otherwise.
   */
  func has(tags: String...) -> Bool {
    return has(tags: tags)
  }
  
  /**
   Checks if the ManagedNode has a the given tags.
   - Parameter tags: An Array of Strings.
   - Parameter using condition: A SearchCondition value.
   - Returns: A boolean of the result, true if has the tags, 
   false otherwise.
   */
  func has(tags: [String], using condition: SearchCondition = .and) -> Bool {
    let t = Set(self.tags)
    let tags = Set(tags)
    
    switch condition {
    case .and:
      return tags.isSubset(of: t)
    case .or:
      return tags.contains(where: t.contains)
    }
  }
  
  /**
   Checks if the ManagedNode is a member of a group.
   - Parameter of groups: A list of Strings.
   - Returns: A boolean of the result, true if a member, false
   otherwise.
   */
  func member(of groups: String...) -> Bool {
    return member(of: groups)
  }
  
  /**
   Checks if the ManagedNode is a member of a group.
   - Parameter of groups: An Array of Strings.
   - Parameter using condition: A SearchCondition value.
   - Returns: A boolean of the result, true if a member, false
   otherwise.
   */
  func member(of groups: [String], using condition: SearchCondition = .and) -> Bool {
    let g = Set(self.groups)
    let groups = Set(groups)
    
    switch condition {
    case .and:
      return groups.isSubset(of: g)
    case .or:
      return groups.contains(where: g.contains)
    }
  }
}

extension ManagedNode: Comparable {
  static public func ==(left: ManagedNode, right: ManagedNode) -> Bool {
    return left.id == right.id
  }
  
  public static func <(left: ManagedNode, right: ManagedNode) -> Bool {
    return left.id < right.id
  }
}

