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

public enum NodeClass: Int {
  case entity = 1
  case relationship = 2
  case action = 3
  
  /**
   An initializer that accepts a node type.
   - Parameter _ nodeType: A reference to a node type.
   */
  init?(nodeType: Node.Type){
    switch nodeType {
    case is Entity.Type:
      self = .entity
    case is Relationship.Type:
      self = .relationship
    case is Action.Type:
      self = .action
    default:
      return nil
    }
  }
  
  /// Model identifier for node class.
  var identifier: String {
    switch self {
    case .entity:
      return ModelIdentifier.entityName
    case .relationship:
      return ModelIdentifier.relationshipName
    case .action:
      return ModelIdentifier.actionName
    }
  }
}


extension CodingUserInfoKey {
  /// CodingUserInfoKey for passing Graph instance or name to decoding context.
  public static let graph = CodingUserInfoKey(rawValue: "graph")!
}


@dynamicMemberLookup
public class Node: NSObject, Codable {
  /// A reference to managed node.
  let node: ManagedNode
  
  /// CodingKeys for encoding and decoding
  private enum CodingKeys: String, CodingKey {
    case type
    case tags
    case groups
    case properties
    case createdDate
  }
  
  /**
   Encodes this value into the given encoder.
   - Parameter to encoder: The encoder to write data to.
   */
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(type, forKey: .type)
    try container.encode(tags, forKey: .tags)
    try container.encode(groups, forKey: .groups)
    try container.encode(AnyCodable(properties), forKey: .properties)
    try container.encode(createdDate, forKey: .createdDate)
  }
  
  /**
   Creates a new instance by decoding from the given decoder.
   - Parameter decoder: The decoder to read data from.
   */
  public required convenience init(from decoder: Decoder) throws {
    let graphInfo = decoder.userInfo[.graph]
    let graph = graphInfo as? Graph ?? Graph(name: graphInfo as? String ?? GraphStoreDescription.name)
    
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let type = try values.decode(String.self, forKey: .type)
    let tags = try values.decodeIfPresent([String].self, forKey: .tags) ?? []
    let groups = try values.decodeIfPresent([String].self, forKey: .groups) ?? []
    let properties = try values.decodeIfPresent(AnyCodable.self, forKey: .properties)?.unwrap()
    let createdDate = try values.decodeIfPresent(Date.self, forKey: .createdDate) ?? Date()
    
    let node = Swift.type(of: self).createNode(type, graph: graph)
    self.init(managedNode: node)
    node.add(tags: tags)
    node.add(to: groups)
    
    node.performAndWait { node in
      node.createdDate = createdDate
    }
    
    guard let p = properties as? [String: Any] else {
      return
    }
    
    p.forEach {
      self[$0.key] = $0.value
    }
  }
  
  /**
   Initializer that accepts a ManagedAction.
   - Parameter managedNode: A reference to a ManagedAction.
   */
  required init(managedNode: ManagedNode) {
    node = managedNode
  }
  
  /**
   Initializer that accepts a type and graph. The graph
   indicates which graph to save to.
   - Parameter _ type: A reference to a type.
   - Parameter graph: A reference to a Graph instance by name.
   */
  @nonobjc
  public convenience init(_ type: String, graph: String) {
    self.init(type, graph: Graph(name: graph))
  }
  
  /**
   Initializer that accepts a type and graph. The graph
   indicates which graph to save to.
   - Parameter _ type: A reference to a type.
   - Parameter graph: A reference to a Graph instance.
   */
  public convenience init(_ type: String, graph: Graph) {
    let node = Swift.type(of: self).createNode(type, graph: graph)
    self.init(managedNode: node)
  }
  
  /**
   Initializer that accepts a type value.
   - Parameter _ type: A reference to a type.
   */
  public convenience init(_ type: String) {
    self.init(type, graph: GraphStoreDescription.name)
  }
  
  /// Generic creation of the managed node type.
  class func createNode(_ type: String, in context: NSManagedObjectContext) -> ManagedNode {
    fatalError("Must be implemented by subclasses")
  }
  
  private class func createNode(_ type: String, graph: Graph) -> ManagedNode {
    var node: ManagedNode!
    graph.managedObjectContext.performAndWait {
      node = createNode(type, in: graph.managedObjectContext)
    }
    return node
  }
  
  /// A reference to the type.
  public var type: String {
    return node.performAndWait { $0.type }
  }
  
  /// A reference to the hash.
  public override var hash: Int {
    return node.hash
  }
  
  /// A reference to the ID.
  public var id: String {
    return node.id
  }
  
  /// A reference to the createDate.
  public var createdDate: Date {
    return node.performAndWait { $0.createdDate }
  }
  
  /// A reference to tags.
  public var tags: [String] {
    return node.tags
  }
  
  /// A reference to groups.
  public var groups: [String] {
    return node.groups
  }
  
  /**
   Access properties using the subscript operator.
   - Parameter name: A property name value.
   - Returns: The optional Any value.
   */
  public subscript(name: String) -> Any? {
    get {
      return node[name]
    }
    set(value) {
      node[name] = value
    }
  }
  
  /**
   Access properties using the dynamic property subscript operator.
   - Parameter dynamicMember member: A property name value.
   - Returns: The optional Any value.
   */
  public subscript(dynamicMember member: String) -> Any? {
    get {
      return self[member]
    }
    set(value) {
      self[member] = value
    }
  }
  
  /// A reference to the properties Dictionary.
  public var properties: [String: Any] {
    return node.properties
  }
  
  /**
   Adds given tags to a Node.
   - Parameter tags: A list of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func add(tags: String...) -> Self {
    return add(tags: tags)
  }
  
  /**
   Adds given tags to a Node.
   - Parameter tags: An Array of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func add(tags: [String]) -> Self {
    node.add(tags: tags)
    return self
  }
  
  /**
   Checks if the Node has the given tags.
   - Parameter tags: A list of Strings.
   - Returns: A boolean of the result, true if has the
   given tags, false otherwise.
   */
  public func has(tags: String...) -> Bool {
    return has(tags: tags)
  }
  
  /**
   Checks if the Node has the given tags.
   - Parameter tags: An Array of Strings.
   - Parameter using condition: A SearchCondition value.
   - Returns: A boolean of the result, true if has the
   given tags, false otherwise.
   */
  public func has(tags: [String], using condition: SearchCondition = .and) -> Bool {
    return node.has(tags: tags, using: condition)
  }
  
  /**
   Removes given tags from a Node.
   - Parameter tags: A list of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func remove(tags: String...) -> Self {
    return remove(tags: tags)
  }
  
  /**
   Removes given tags from a Node.
   - Parameter tags: An Array of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func remove(tags: [String]) -> Self {
    node.remove(tags: tags)
    return self
  }
  
  /**
   Adds given tags to a Node or removes them, based on their
   previous state.
   - Parameter tags: A list of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func toggle(tags: String...) -> Self {
    return toggle(tags: tags)
  }
  
  /**
   Adds given tags to a Node or removes them, based on their
   previous state.
   - Parameter tags: An Array of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func toggle(tags: [String]) -> Self {
    var a : [String] = []
    var r : [String] = []
    tags.forEach { [unowned self] in
      if self.node.has(tags: $0) {
        r.append($0)
      } else {
        a.append($0)
      }
    }
    node.add(tags: a)
    node.remove(tags: r)
    return self
  }
  
  /**
   Adds given groups to a Node.
   - Parameter to groups: A list of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func add(to groups: String...) -> Self {
    return add(to: groups)
  }
  
  /**
   Adds given groups to a Node.
   - Parameter to groups: An Array of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func add(to groups: [String]) -> Self {
    node.add(to: groups)
    return self
  }
  
  /**
   Checks if the Node is a member of the given groups.
   - Parameter of groups: A list of Strings.
   - Returns: A boolean of the result, true if has the
   given groups, false otherwise.
   */
  public func member(of groups: String...) -> Bool {
    return member(of: groups)
  }
  
  /**
   Checks if the Node has a the given tags.
   - Parameter of groups: An Array of Strings.
   - Parameter using condition: A SearchCondition value.
   - Returns: A boolean of the result, true if has the
   given groups, false otherwise.
   */
  public func member(of groups: [String], using condition: SearchCondition = .and) -> Bool {
    return node.member(of: groups, using: condition)
  }
  
  /**
   Removes given groups from a Node.
   - Parameter from groups: A list of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func remove(from groups: String...) -> Self {
    return remove(from: groups)
  }
  
  /**
   Removes given groups from a Node.
   - Parameter from groups: An Array of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func remove(from groups: [String]) -> Self {
    node.remove(from: groups)
    return self
  }
  
  /**
   Adds given groups to a Node or removes them, based on their
   previous state.
   - Parameter groups: A list of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func toggle(groups: String...) -> Self {
    return toggle(groups: groups)
  }
  
  /**
   Adds given groups to a Node or removes them, based on their
   previous state.
   - Parameter groups: An Array of Strings.
   - Returns: The Node.
   */
  @discardableResult
  public func toggle(groups: [String]) -> Self {
    var a : [String] = []
    var r : [String] = []
    groups.forEach { [unowned self] in
      if self.node.member(of: $0) {
        r.append($0)
      } else {
        a.append($0)
      }
    }
    node.add(to: a)
    node.remove(from: r)
    return self
  }
  
  /// Marks the Node for deletion.
  public func delete() {
    node.delete()
  }
}


extension Node : Comparable {
  static public func ==(left: Node, right: Node) -> Bool {
    return left.id == right.id
  }
  
  static public func <(left: Node, right: Node) -> Bool {
    return left.id < right.id
  }
}

