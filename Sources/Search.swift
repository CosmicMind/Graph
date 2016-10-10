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
    associatedtype Element: Node
    
    /**
     A synchronous request that returns an Array of Elements or executes a
     callback with an Array of Elements passed in as the first argument.
     - Parameter completeion: An optional completion block.
     - Returns: An Array of Elements.
     */
    func sync(completion: ((Set<Element>) -> Void)?) -> Set<Element>
    
    /**
     An asynchronous request that executes a callback with an Array of Elements
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    func async(completion: ((Set<Element>) -> Void))
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
    public func sync(completion: ((Set<T>) -> Void)? = nil) -> Set<T> {
        return Set<T>()
    }
    
    /**
     An asynchronous request that executes a callback with an Array of Elements
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    public func async(completion: ((Set<T>) -> Void)) {}
    
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
     - Parameter types: A parameter list of Strings.
     - Returns: A Search instance.
     */
    @discardableResult
    public func `for`(types: String...) -> Search {
        return self.for(types: types)
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
     - Parameter tags: A parameter list of Strings.
     - Returns: A Search instance.
     */
    @discardableResult
    public func has(tags: String...) -> Search {
        return has(tags: tags)
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
     - Parameter groups: A parameter list of Strings.
     - Returns: A Search instance.
     */
    @discardableResult
    public func member(of groups: String...) -> Search {
        return member(of: groups)
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
     - Parameter properties: A Dictionary of [String: Any?] values..
     - Returns: A Search instance.
     */
    @discardableResult
    public func `where`(properties: [String: Any?]) -> Search {
        var p = [(name: String, value: Any?)]()
        for x in properties {
            p.append((x.key, x.value))
        }
        return self.where(properties: p)
    }
    
    /**
     Watches nodes with given properties.
     - Parameter properties: A parameter list of tuples, (name: String, value: Any?).
     - Returns: A Search instance.
     */
    @discardableResult
    public func `where`(properties: (name: String, value: Any?)...) -> Search {
        return self.where(properties: properties)
    }
    
    /**
     Watches nodes with given properties.
     - Parameter properties: An Array of tuples, (name: String, value: Any?).
     - Returns: A Search instance.
     */
    @discardableResult
    public func `where`(properties: [(name: String, value: Any?)]) -> Search {
        self.properties = properties
        return self
    }
    
    /**
     Executes the synchronous process on the main thread.
     - Parameter nodes: An Array of Elements.
     - Parameter completion: An optional completion block.
     - Returns: An Array of Elements.
     */
    @discardableResult
    internal func executeSynchronousRequest(nodes: Set<T>, completion: ((Set<T>) -> Void)? = nil) -> Set<T> {
        guard let c = completion else {
            return nodes
        }

        if Thread.isMainThread {
            c(nodes)
        } else {
            DispatchQueue.main.async { [n = nodes, c = c] in
                c(n)
            }
        }

        return nodes
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
    public func sync(completion: ((Set<T>) -> Void)? = nil) -> Set<T> {
        return executeSynchronousRequest(nodes: graph.searchForEntity(types: types, tags: tags, groups: groups, properties: properties) as! Set<T>, completion: completion)
    }
    
    /**
     An asynchronous request that executes a callback with an Array of Entities
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    public func async(completion: @escaping ((Set<T>) -> Void)) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
    
            let n = s.graph.searchForEntity(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! Set<T>
            
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
    public func sync(completion: ((Set<T>) -> Void)? = nil) -> Set<T> {
        return executeSynchronousRequest(nodes: graph.searchForRelationship(types: types, tags: tags, groups: groups, properties: properties) as! Set<T>, completion: completion)
    }
    
    /**
     An asynchronous request that executes a callback with an Array of Relationships
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    public func async(completion: @escaping ((Set<T>) -> Void)) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            let n = s.graph.searchForRelationship(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! Set<T>
            
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
    public func sync(completion: ((Set<T>) -> Void)? = nil) -> Set<T> {
        return executeSynchronousRequest(nodes: graph.searchForAction(types: types, tags: tags, groups: groups, properties: properties) as! Set<T>, completion: completion)
    }
    
    /**
     An asynchronous request that executes a callback with an Array of Actions
     passed in as the first argument.
     - Parameter completion: An optional completion block.
     */
    public func async(completion: @escaping ((Set<T>) -> Void)) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            let n = s.graph.searchForAction(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! Set<T>
            
            DispatchQueue.main.async { [n = n, completion = completion] in
                completion(n)
            }
        }
    }
}

extension Graph {
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of Strings.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Entities.
     */
    internal func searchForEntity(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [(name: String, value: Any?)]? = nil) -> Set<Entity> {
        guard let moc = managedObjectContext else {
            return Set<Entity>()
        }
        
        var nodes = [AnyObject]()
        
        if let v = types {
            if let n = search(forEntityName: ModelIdentifier.entityName, types: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = tags {
            if let n = search(forEntityName: ModelIdentifier.entityTagName, tags: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = groups {
            if let n = search(forEntityName: ModelIdentifier.entityGroupName, groups: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = properties {
            if let n = search(forEntityName: ModelIdentifier.entityPropertyName, properties: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        var set = Set<Entity>()
        nodes.forEach { [weak moc] in
            guard let n = $0 as? ManagedEntity else {
                var managedNode: NSManagedObject?
                let n = $0["node"]
                moc?.performAndWait { [weak moc] in
                    managedNode = moc?.object(with: n! as! NSManagedObjectID)
                }
                set.insert(Entity(managedNode: managedNode as! ManagedEntity))
                return
            }
            set.insert(Entity(managedNode: n))
        }
        return set
    }
    
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of Strings.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Relationships.
     */
    internal func searchForRelationship(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [(name: String, value: Any?)]? = nil) -> Set<Relationship> {
        guard let moc = managedObjectContext else {
            return Set<Relationship>()
        }
        
        var nodes = [AnyObject]()
        
        if let v = types {
            if let n = search(forEntityName: ModelIdentifier.relationshipName, types: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = tags {
            if let n = search(forEntityName: ModelIdentifier.relationshipTagName, tags: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = groups {
            if let n = search(forEntityName: ModelIdentifier.relationshipGroupName, groups: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = properties {
            if let n = search(forEntityName: ModelIdentifier.relationshipPropertyName, properties: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        var set = Set<Relationship>()
        nodes.forEach { [weak moc] in
            guard let n = $0 as? ManagedRelationship else {
                var managedNode: NSManagedObject?
                let n = $0["node"]
                moc?.performAndWait { [weak moc] in
                    managedNode = moc?.object(with: n! as! NSManagedObjectID)
                }
                set.insert(Relationship(managedNode: managedNode as! ManagedRelationship))
                return
            }
            set.insert(Relationship(managedNode: n))
        }
        return set
    }
    
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of Strings.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Actions.
     */
    internal func searchForAction(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [(name: String, value: Any?)]? = nil) -> Set<Action> {
        guard let moc = managedObjectContext else {
            return Set<Action>()
        }

        var nodes = [AnyObject]()
        
        if let v = types {
            if let n = search(forEntityName: ModelIdentifier.actionName, types: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = tags {
            if let n = search(forEntityName: ModelIdentifier.actionTagName, tags: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = groups {
            if let n = search(forEntityName: ModelIdentifier.actionGroupName, groups: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        if let v = properties {
            if let n = search(forEntityName: ModelIdentifier.actionPropertyName, properties: v) {
                nodes.append(contentsOf: n)
            }
        }
        
        var set = Set<Action>()
        nodes.forEach { [weak moc] in
            guard let n = $0 as? ManagedAction else {
                var managedNode: NSManagedObject?
                let n = $0["node"]
                moc?.performAndWait { [weak moc] in
                    managedNode = moc?.object(with: n! as! NSManagedObjectID)
                }
                set.insert(Action(managedNode: managedNode as! ManagedAction))
                return
            }
            set.insert(Action(managedNode: n))
        }
        return set
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
