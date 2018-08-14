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

import Foundation

public enum NodeClass: Int {
  case entity = 1
  case relationship = 2
  case action = 3
}

@dynamicMemberLookup
public class Node: NSObject {
  /// A reference to managed node.
  let node: ManagedNode
  
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
    let node = Swift.type(of: self).createNode(type, in: graph.managedObjectContext)
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
  
  /// A reference to the type.
  public var type: String {
    return node.performAndWait { $0.type }
  }
  
  /// A reference to the hash.
  public override var hash: Int {
    return node.hash
  }
  
  /// A reference to the hashValue.
  public override var hashValue: Int {
    return node.hashValue
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
  static public func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.id == rhs.id
  }
  
  static public func <(lhs: Node, rhs: Node) -> Bool {
    return lhs.id < rhs.id
  }
}

