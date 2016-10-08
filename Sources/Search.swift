/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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

public protocol Searchable {
    /// Element type.
    associatedtype Element
    
    /**
     A synchronous request that returns an Array of Elements or executes a
     callback with an Array of Elements passed in as the first argument.
     - Parameter completeion: An optional completion block.
     - Returns: An Array of Elements.
     */
    func sync(completion: (([Element]) -> Void)?) -> [Element]
    
    /**
     An asynchronous request that executes a callback with an Array of Elements
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    func async(completion: (([Element]) -> Void))
}

/// Search.
public class Search<T: Node>: Searchable {
    public typealias Element = T
    
    /**
     A synchronous request that returns an Array of Elements or executes a
     callback with an Array of Elements passed in as the first argument.
     - Parameter completeion: An optional completion block.
     - Returns: An Array of Elements.
     */
    public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
        return [T]()
    }
    
    /**
     An asynchronous request that executes a callback with an Array of Elements
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    public func async(completion: (([T]) -> Void)) {}
    
    /// A Graph instance.
    internal private(set) var graph: Graph
    
    /// A reference to the type.
    public var types: [String]
    
    /// A reference to the tags.
    public var tags: [String]
    
    /// A reference to the groups.
    public var groups: [String]
    
    /// A reference to the properties.
    public var properties: [(name: String, value: Any?)]
    
    /**
     An initializer that accepts a NodeClass and Graph
     instance.
     - Parameter graph: A Graph instance.
     - Parameter nodeClass: A NodeClass value.
     */
    internal init(graph: Graph) {
        self.graph = graph
        types = []
        tags = []
        groups = []
        properties = []
    }
    
    /**
     Clears the search parameters.
     - Returns: A Search instance.
     */
    @discardableResult
    public func clear() -> Search {
        types.removeAll()
        tags.removeAll()
        groups.removeAll()
        properties.removeAll()
        return self
    }
    
    /**
     Searches nodes with given types.
     - Parameter types: An Array of Strings.
     - Returns: A Search instance.
     */
    @discardableResult
    public func `for`(types: [String]) -> Search {
        self.types = types
        return self
    }
    
    /**
     Searches nodes with given tags.
     - Parameter tags: An Array of Strings.
     - Returns: A Search instance.
     */
    @discardableResult
    public func has(tags: [String]) -> Search {
        self.tags = tags
        return self
    }
    
    /**
     Searches nodes with given groups.
     - Parameter groups: An Array of Strings.
     - Returns: A Search instance.
     */
    @discardableResult
    public func member(of groups: [String]) -> Search {
        self.groups = groups
        return self
    }
    
    /**
     Watches nodes with given properties.
     - Parameter properties: An Array of Strings.
     - Returns: A Search instance.
     */
    @discardableResult
    public func `where`(properties: [(name: String, value: Any?)]) -> Search {
        self.properties = properties
        return self
    }
}

extension Search where T: Entity  {
    /**
     A synchronous request that returns an Array of Entities or executes a
     callback with an Array of Entities passed in as the first argument.
     - Parameter completeion: An optional completion block.
     - Returns: An Array of Entities.
     */
    @discardableResult
    public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
        let n = graph.searchForEntity(types: types, tags: tags, groups: groups, properties: properties) as! [T]
        
        guard let c = completion else {
            return n
        }
        
        if Thread.isMainThread {
            c(n)
        } else {
            DispatchQueue.main.async { [n = n, c = c] in
                c(n)
            }
        }
        
        return n
    }
    
    /**
     An asynchronous request that executes a callback with an Array of Entities
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    public func async(completion: @escaping (([T]) -> Void)) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
    
            let n = s.graph.searchForEntity(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! [T]
            
            DispatchQueue.main.async { [n = n, completion = completion] in
                completion(n)
            }
        }
    }
}

extension Search where T: Relationship  {
    /**
     A synchronous request that returns an Array of Relationships or executes a
     callback with an Array of Relationships passed in as the first argument.
     - Parameter completeion: An optional completion block.
     - Returns: An Array of Relationships.
     */
    @discardableResult
    public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
        let n = graph.searchForRelationship(types: types, tags: tags, groups: groups, properties: properties) as! [T]
        
        guard let c = completion else {
            return n
        }
        
        if Thread.isMainThread {
            c(n)
        } else {
            DispatchQueue.main.async { [n = n, c = c] in
                c(n)
            }
        }
        
        return n
    }
    
    /**
     An asynchronous request that executes a callback with an Array of Relationships
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    public func async(completion: @escaping (([T]) -> Void)) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            let n = s.graph.searchForRelationship(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! [T]
            
            DispatchQueue.main.async { [n = n, completion = completion] in
                completion(n)
            }
        }
    }
}

extension Search where T: Action  {
    /**
     A synchronous request that returns an Array of Actions or executes a
     callback with an Array of Actions passed in as the first argument.
     - Parameter completeion: An optional completion block.
     - Returns: An Array of Actions.
     */
    @discardableResult
    public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
        let n = graph.searchForAction(types: types, tags: tags, groups: groups, properties: properties) as! [T]
        
        guard let c = completion else {
            return n
        }
        
        if Thread.isMainThread {
            c(n)
        } else {
            DispatchQueue.main.async { [n = n, c = c] in
                c(n)
            }
        }
        
        return n
    }
    
    /**
     An asynchronous request that executes a callback with an Array of Actions
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    public func async(completion: @escaping (([T]) -> Void)) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            let n = s.graph.searchForAction(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! [T]
            
            DispatchQueue.main.async { [n = n, completion = completion] in
                completion(n)
            }
        }
    }
}

/// Storage Search API.
extension Graph {
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of Strings.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Entities.
     */
    internal func searchForEntity(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [(name: String, value: Any?)]? = nil) -> [Entity] {
        guard let moc = managedObjectContext else {
            return [Entity]()
        }
        
        var nodes = [AnyObject]()
        var toFilter: Bool = false
        
        if let v = types {
            if let n = search(forEntityName: ModelIdentifier.entityName, types: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = tags {
            if let n = search(forEntityName: ModelIdentifier.entityTagName, tags: v) {
                toFilter = 0 < nodes.count
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = groups {
            if let n = search(forEntityName: ModelIdentifier.entityGroupName, groups: v) {
                toFilter = 0 < nodes.count
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = properties {
            if let n = search(forEntityName: ModelIdentifier.entityPropertyName, properties: v) {
                toFilter = 0 < nodes.count
                nodes.append(contentsOf: n)
            }
        }
        
        if toFilter {
            var seen = [String: Bool]()
            var i: Int = nodes.count - 1
            while 0 <= i {
                if let v = nodes[i] as? ManagedEntity {
                    if nil == seen.updateValue(true, forKey: v.id) {
                        nodes[i] = Entity(managedNode: v)
                        i -= 1
                        continue
                    }
                } else {
                    let n = nodes[i]["node"]
                    var c: Bool? = false
                    var weakNodes: [Any]? = nodes
                    moc.performAndWait { [unowned moc] in
                        if let v = moc.object(with: n! as! NSManagedObjectID) as? ManagedEntity {
                            if nil == seen.updateValue(true, forKey: v.id) {
                                weakNodes?[i] = Entity(managedNode: v)
                                i -= 1
                                c = true
                            }
                        }
                    }
                    if true == c {
                        continue
                    }
                }
                nodes.remove(at: i)
                i -= 1
            }
            return nodes as! [Entity]
        }
        
        return nodes.map { [weak moc] in
            guard let n = $0 as? ManagedEntity else {
                var managedNode: NSManagedObject?
                let n = $0["node"]
                moc?.performAndWait { [weak moc] in
                    managedNode = moc?.object(with: n! as! NSManagedObjectID)
                }
                return Entity(managedNode: managedNode as! ManagedEntity)
            }
            return Entity(managedNode: n)
        } as [Entity]
    }
    
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of Strings.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Relationships.
     */
    internal func searchForRelationship(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [(name: String, value: Any?)]? = nil) -> [Relationship] {
        guard let moc = managedObjectContext else {
            return [Relationship]()
        }
        
        var nodes = [AnyObject]()
        var toFilter: Bool = false
        
        if let v = types {
            if let n = search(forEntityName: ModelIdentifier.relationshipName, types: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = tags {
            if let n = search(forEntityName: ModelIdentifier.relationshipTagName, tags: v) {
                toFilter = 0 < nodes.count
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = groups {
            if let n = search(forEntityName: ModelIdentifier.relationshipGroupName, groups: v) {
                toFilter = 0 < nodes.count
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = properties {
            if let n = search(forEntityName: ModelIdentifier.relationshipPropertyName, properties: v) {
                toFilter = 0 < nodes.count
                nodes.append(contentsOf: n)
            }
        }
        
        if toFilter {
            var seen = [String: Bool]()
            var i: Int = nodes.count - 1
            while 0 <= i {
                if let v = nodes[i] as? ManagedRelationship {
                    if nil == seen.updateValue(true, forKey: v.id) {
                        nodes[i] = Relationship(managedNode: v)
                        i -= 1
                        continue
                    }
                } else {
                    let n = nodes[i]["node"]
                    var c: Bool? = false
                    var weakNodes: [Any]? = nodes
                    moc.performAndWait { [unowned moc] in
                        if let v = moc.object(with: n! as! NSManagedObjectID) as? ManagedRelationship {
                            if nil == seen.updateValue(true, forKey: v.id) {
                                weakNodes?[i] = Relationship(managedNode: v)
                                i -= 1
                                c = true
                            }
                        }
                    }
                    if true == c {
                        continue
                    }
                }
                nodes.remove(at: i)
                i -= 1
            }
            return nodes as! [Relationship]
        }
        
        return nodes.map { [weak moc] in
            guard let n = $0 as? ManagedRelationship else {
                var managedNode: NSManagedObject?
                let n = $0["node"]
                moc?.performAndWait { [weak moc] in
                    managedNode = moc?.object(with: n! as! NSManagedObjectID)
                }
                return Relationship(managedNode: managedNode as! ManagedRelationship)
            }
            return Relationship(managedNode: n)
        } as [Relationship]
    }
    
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of Strings.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Actions.
     */
    internal func searchForAction(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [(name: String, value: Any?)]? = nil) -> [Action] {
        guard let moc = managedObjectContext else {
            return [Action]()
        }
        
        var nodes = [AnyObject]()
        var toFilter: Bool = false
        
        if let v = types {
            if let n = search(forEntityName: ModelIdentifier.actionName, types: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = tags {
            if let n = search(forEntityName: ModelIdentifier.actionTagName, tags: v) {
                toFilter = 0 < nodes.count
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = groups {
            if let n = search(forEntityName: ModelIdentifier.actionGroupName, groups: v) {
                toFilter = 0 < nodes.count
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = properties {
            if let n = search(forEntityName: ModelIdentifier.actionPropertyName, properties: v) {
                toFilter = 0 < nodes.count
                nodes.append(contentsOf: n)
            }
        }
        
        if toFilter {
            var seen = [String: Bool]()
            var i: Int = nodes.count - 1
            while 0 <= i {
                if let v = nodes[i] as? ManagedAction {
                    if nil == seen.updateValue(true, forKey: v.id) {
                        nodes[i] = Action(managedNode: v)
                        i -= 1
                        continue
                    }
                } else {
                    let n = nodes[i]["node"]
                    var c: Bool? = false
                    var weakNodes: [Any]? = nodes
                    moc.performAndWait { [unowned moc] in
                        if let v = moc.object(with: n! as! NSManagedObjectID) as? ManagedAction {
                            if nil == seen.updateValue(true, forKey: v.id) {
                                weakNodes?[i] = Action(managedNode: v)
                                i -= 1
                                c = true
                            }
                        }
                    }
                    if true == c {
                        continue
                    }
                }
                nodes.remove(at: i)
                i -= 1
            }
            return nodes as! [Action]
        }
        
        return nodes.map { [weak moc] in
            guard let n = $0 as? ManagedAction else {
                var managedNode: NSManagedObject?
                let n = $0["node"]
                moc?.performAndWait { [weak moc] in
                    managedNode = moc?.object(with: n! as! NSManagedObjectID)
                }
                return Action(managedNode: managedNode as! ManagedAction)
            }
            return Action(managedNode: n)
        } as [Action]
    }
    
    /**
     Searches based on property value.
     - Parameter forEntityName: An entity type name.
     - Parameter properties: An Array of property tuples.
     - Returns: An optional Array of Anys.
     */
    internal func search(forEntityName: String, properties: [(name: String, value: Any?)]) -> [AnyObject]? {
        guard let moc = managedObjectContext else {
            return nil
        }
        
        var predicate = [NSPredicate]()
        
        for (k, v) in properties {
            if let x = v {
                if let a = x as? String {
                    predicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name LIKE[cd] %@", k), NSPredicate(format: "object = %@", a)]))
                } else if let a: NSNumber = x as? NSNumber {
                    predicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name LIKE[cd] %@", k), NSPredicate(format: "object = %@", a)]))
                }
            } else {
                predicate.append(NSPredicate(format: "name LIKE[cd] %@", k))
            }
        }
        
        let request = NSFetchRequest<ManagedProperty>()
        request.entity = NSEntityDescription.entity(forEntityName: forEntityName, in: moc)!
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["node"]
        request.returnsDistinctResults = true
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
        request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
        
        var result: [AnyObject]?
        moc.performAndWait { [unowned request] in
            do {
                if #available(iOS 10.0, OSX 10.12, *) {
                    result = try request.execute()
                } else {
                    result = try moc.fetch(request)
                }
            } catch {
                result = [AnyObject]()
            }
        }
        return result!
    }
    
    /**
     Searches based on type value.
     - Parameter forEntityName: An entity type name.
     - Parameter types: An Array of types.
     - Returns: An optional Array of Anys.
     */
    internal func search(forEntityName: String, types: [String]) -> [AnyObject]? {
        guard let moc = managedObjectContext else {
            return nil
        }
        
        var predicate = [NSPredicate]()
        
        for v in types {
            predicate.append(NSPredicate(format: "type LIKE[cd] %@", v))
        }
        
        let request = NSFetchRequest<ManagedNode>()
        request.entity = NSEntityDescription.entity(forEntityName: forEntityName, in: moc)!
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        
        var result: [AnyObject]?
        moc.performAndWait { [unowned moc, unowned request] in
            do {
                if #available(iOS 10.0, OSX 10.12, *) {
                    result = try request.execute()
                } else {
                    result = try moc.fetch(request)
                }
            } catch {
                result = [AnyObject]()
            }
        }
        return result!
    }
    
    /**
     Searches based on tag value.
     - Parameter forEntityName: An entity type name.
     - Parameter tags: An Array of tags.
     - Returns: An optional Array of Anys.
     */
    internal func search(forEntityName: String, tags: [String]) -> [AnyObject]? {
        guard let moc = managedObjectContext else {
            return nil
        }
        
        var predicate = [NSPredicate]()
        
        for v in tags {
            predicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
        }
        
        let request = NSFetchRequest<ManagedTag>()
        request.entity = NSEntityDescription.entity(forEntityName: forEntityName, in: moc)!
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["node"]
        request.returnsDistinctResults = true
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
        request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
        
        var result: [AnyObject]?
        moc.performAndWait { [unowned request] in
            do {
                if #available(iOS 10.0, OSX 10.12, *) {
                    result = try request.execute()
                } else {
                    result = try moc.fetch(request)
                }
            } catch {
                result = [AnyObject]()
            }
        }
        return result!
    }
    
    /**
     Searches based on group value.
     - Parameter forEntityName: An entity type name.
     - Parameter groups: An Array of tags.
     - Returns: An optional Array of Anys.
     */
    internal func search(forEntityName: String, groups: [String]) -> [AnyObject]? {
        guard let moc = managedObjectContext else {
            return nil
        }
        
        var predicate = [NSPredicate]()
        
        for v in groups {
            predicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
        }
        
        let request = NSFetchRequest<ManagedGroup>()
        request.entity = NSEntityDescription.entity(forEntityName: forEntityName, in: moc)!
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["node"]
        request.returnsDistinctResults = true
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
        request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
        
        var result: [AnyObject]?
        moc.performAndWait { [unowned request] in
            do {
                if #available(iOS 10.0, OSX 10.12, *) {
                    result = try request.execute()
                } else {
                    result = try moc.fetch(request)
                }
            } catch {
                result = [AnyObject]()
            }
        }
        return result!
    }
}
