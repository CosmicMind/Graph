///*
// * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
// * All rights reserved.
// *
// * Redistribution and use in source and binary forms, with or without
// * modification, are permitted provided that the following conditions are met:
// *
// *	*	Redistributions of source code must retain the above copyright notice, this
// *		list of conditions and the following disclaimer.
// *
// *	*	Redistributions in binary form must reproduce the above copyright notice,
// *		this list of conditions and the following disclaimer in the documentation
// *		and/or other materials provided with the distribution.
// *
// *	*	Neither the name of CosmicMind nor the names of its
// *		contributors may be used to endorse or promote products derived from
// *		this software without specific prior written permission.
// *
// * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// */
//
//import CoreData
//
//@objc(SearchCondition)
//public enum SearchCondition: Int {
//    case or
//    case and
//}
//
//public protocol Searchable {
//    /// Element type.
//    associatedtype Element: Node
//    
//    /**
//     A synchronous request that returns an Array of Elements or executes a
//     callback with an Array of Elements passed in as the first argument.
//     - Parameter completeion: An optional completion block.
//     - Returns: An Array of Elements.
//     */
//    func sync(completion: (([Element]) -> Void)?) -> [Element]
//    
//    /**
//     An asynchronous request that executes a callback with an Array of Elements
//     passed in as the first argument.
//     - Parameter completion: An optional completion block.
//     */
//    func async(completion: (([Element]) -> Void))
//}
//
///// Search.
//public class Search<T: Node>: Searchable {
//    public typealias Element = T
//    
//    /**
//     A synchronous request that returns an Array of Elements or executes a
//     callback with an Array of Elements passed in as the first argument.
//     - Parameter completeion: An optional completion block.
//     - Returns: An Array of Elements.
//     */
//    public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
//        return [T]()
//    }
//    
//    /**
//     An asynchronous request that executes a callback with an Array of Elements
//     passed in as the first argument.
//     - Parameter completion: An optional completion block.
//     */
//    public func async(completion: (([T]) -> Void)) {}
//    
//    /// A Graph instance.
//    internal private(set) var graph: Graph
//    
//    /// A reference to the type.
//    public private(set) var types: [String]?
//    
//    /// A reference to the tags.
//    public private(set) var tags: [String]?
//    
//    /// A SearchCondition value for tags.
//    public private(set) var tagsSearchCondition = SearchCondition.and
//    
//    /// A reference to the groups.
//    public private(set) var groups: [String]?
//    
//    /// A SearchCondition value for groups.
//    public private(set) var groupsSearchCondition = SearchCondition.and
//    
//    /// A reference to the properties.
//    public var properties: [String]?
//    
//    /// A SearchCondition value for properties.
//    public var propertiesSearchCondition = SearchCondition.and
//    
//    /**
//     An initializer that accepts a NodeClass and Graph
//     instance.
//     - Parameter graph: A Graph instance.
//     - Parameter nodeClass: A NodeClass value.
//     */
//    internal init(graph: Graph) {
//        self.graph = graph
//    }
//    
//    /**
//     Clears the search parameters.
//     - Returns: A Search instance.
//     */
//    @discardableResult
//    public func clear() -> Search {
//        types = nil
//        tags = nil
//        tagsSearchCondition = .and
//        groups = nil
//        groupsSearchCondition = .and
//        properties = nil
//        propertiesSearchCondition = .and
//        return self
//    }
//    
//    /**
//     Searches nodes with given types.
//     - Parameter types: A parameter list of Strings.
//     - Returns: A Search instance.
//     */
//    @discardableResult
//    public func `for`(types: String...) -> Search {
//        return self.for(types: types)
//    }
//    
//    /**
//     Searches nodes with given types.
//     - Parameter types: An Array of Strings.
//     - Returns: A Search instance.
//     */
//    @discardableResult
//    public func `for`(types: [String]) -> Search {
//        self.types = types
//        return self
//    }
//    
//    /**
//     Searches nodes with given tags.
//     - Parameter tags: A parameter list of Strings.
//     - Returns: A Search instance.
//     */
//    @discardableResult
//    public func has(tags: String...) -> Search {
//        return has(tags: tags)
//    }
//    
//    /**
//     Searches nodes with given tags.
//     - Parameter tags: An Array of Strings.
//     - Returns: A Search instance.
//     */
//    @discardableResult
//    public func has(tags: [String], using condition: SearchCondition = .and) -> Search {
//        self.tags = tags
//        tagsSearchCondition = condition
//        return self
//    }
//    
//    /**
//     Searches nodes with given groups.
//     - Parameter groups: A parameter list of Strings.
//     - Returns: A Search instance.
//     */
//    @discardableResult
//    public func member(of groups: String...) -> Search {
//        return member(of: groups)
//    }
//    
//    /**
//     Searches nodes with given groups.
//     - Parameter groups: An Array of Strings.
//     - Returns: A Search instance.
//     */
//    @discardableResult
//    public func member(of groups: [String], using condition: SearchCondition = .and) -> Search {
//        self.groups = groups
//        groupsSearchCondition = condition
//        return self
//    }
//    
//    /**
//     Watches nodes with given properties.
//     - Parameter properties: A parameter list of Strings.
//     - Returns: A Search instance.
//     */
//    @discardableResult
//    public func `where`(properties: String...) -> Search {
//        return self.where(properties: properties)
//    }
//    
//    /**
//     Watches nodes with given properties.
//     - Parameter groups: An Array of Strings.
//     - Returns: A Search instance.
//     */
//    @discardableResult
//    public func `where`(properties: [String], using condition: SearchCondition = .and) -> Search {
//        self.properties = properties
//        propertiesSearchCondition = condition
//        return self
//    }
//    
//    /**
//     Executes the synchronous process on the main thread.
//     - Parameter nodes: An Array of Elements.
//     - Parameter completion: An optional completion block.
//     - Returns: An Array of Elements.
//     */
//    @discardableResult
//    internal func executeSynchronousRequest(nodes: [T], completion: (([T]) -> Void)? = nil) -> [T] {
//        guard let c = completion else {
//            return nodes
//        }
//
//        if Thread.isMainThread {
//            c(nodes)
//        } else {
//            DispatchQueue.main.async { [n = nodes, c = c] in
//                c(n)
//            }
//        }
//
//        return nodes
//    }
//}
//
//extension Search where T: Entity  {
//    /**
//     A synchronous request that returns an Array of Entities or executes a
//     callback with an Array of Entities passed in as the first argument.
//     - Parameter completeion: An optional completion block.
//     - Returns: An Array of Entities.
//     */
//    @discardableResult
//    public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
//        return executeSynchronousRequest(nodes: searchForEntity(types: types, tags: tags, groups: groups, properties: properties) as! [T], completion: completion)
//    }
//    
//    /**
//     An asynchronous request that executes a callback with an Array of Entities
//     passed in as the first argument.
//     - Parameter completion: An optional completion block.
//     */
//    public func async(completion: @escaping (([T]) -> Void)) {
//        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
//            guard let s = self else {
//                return
//            }
//    
//            let n = s.searchForEntity(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! [T]
//            
//            DispatchQueue.main.async { [n = n, completion = completion] in
//                completion(n)
//            }
//        }
//    }
//}
//
//extension Search where T: Relationship  {
//    /**
//     A synchronous request that returns an Array of Relationships or executes a
//     callback with an Array of Relationships passed in as the first argument.
//     - Parameter completeion: An optional completion block.
//     - Returns: An Array of Relationships.
//     */
//    @discardableResult
//    public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
//        return executeSynchronousRequest(nodes: searchForRelationship(types: types, tags: tags, groups: groups, properties: properties) as! [T], completion: completion)
//    }
//    
//    /**
//     An asynchronous request that executes a callback with an Array of Relationships
//     passed in as the first argument.
//     - Parameter completion: An optional completion block.
//     */
//    public func async(completion: @escaping (([T]) -> Void)) {
//        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
//            guard let s = self else {
//                return
//            }
//            
//            let n = s.searchForRelationship(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! [T]
//            
//            DispatchQueue.main.async { [n = n, completion = completion] in
//                completion(n)
//            }
//        }
//    }
//}
//
//extension Search where T: Action  {
//    /**
//     A synchronous request that returns an Array of Actions or executes a
//     callback with an Array of Actions passed in as the first argument.
//     - Parameter completeion: An optional completion block.
//     - Returns: An Array of Actions.
//     */
//    @discardableResult
//    public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
//        return executeSynchronousRequest(nodes: searchForAction(types: types, tags: tags, groups: groups, properties: properties) as! [T], completion: completion)
//    }
//    
//    /**
//     An asynchronous request that executes a callback with an Array of Actions
//     passed in as the first argument.
//     - Parameter completion: An optional completion block.
//     */
//    public func async(completion: @escaping (([T]) -> Void)) {
//        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
//            guard let s = self else {
//                return
//            }
//            
//            let n = s.searchForAction(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! [T]
//            
//            DispatchQueue.main.async { [n = n, completion = completion] in
//                completion(n)
//            }
//        }
//    }
//}
//
//extension Search {
//    internal func search<T: ManagedNode>(types: [String], entity name: String) -> Set<T> {
//        var set = Set<T>()
//        search(forEntityName: name, types: types)?.forEach {
//            guard let n = $0 as? T else {
//                return
//            }
//            
//            set.insert(n)
//        }
//        return set
//    }
//    
//    internal func search<T: ManagedNode, U: ManagedTag>(tags: [String], entity name: String, _: U.Type) -> Set<T> {
//        var set = Set<T>()
//        
//        guard let moc = graph.managedObjectContext else {
//            return set
//        }
//        
//        search(forEntityName: name, tags: tags)?.forEach { [weak self, weak moc, tags = tags] in
//            guard let s = self else {
//                return
//            }
//            
//            var n: T?
//            moc?.performAndWait { [q = $0] in
//                n = (q as? U)?.node as? T
//            }
//            
//            guard let q = n else {
//                return
//            }
//            
//            guard .and == s.tagsSearchCondition else {
//                set.insert(q)
//                return
//            }
//            
//            guard q.has(tags: tags) else {
//                return
//            }
//            
//            set.insert(q)
//        }
//        return set
//    }
//    
//    internal func search<T: ManagedNode, U: ManagedGroup>(groups: [String], entity name: String, _: U.Type) -> Set<T> {
//        var set = Set<T>()
//        
//        guard let moc = graph.managedObjectContext else {
//            return set
//        }
//        
//        search(forEntityName: name, groups: groups)?.forEach { [weak self, weak moc, groups = groups] in
//            guard let s = self else {
//                return
//            }
//            
//            var n: T?
//            moc?.performAndWait { [q = $0] in
//                n = (q as? U)?.node as? T
//            }
//            
//            guard let q = n else {
//                return
//            }
//            
//            guard .and == s.groupsSearchCondition else {
//                set.insert(q)
//                return
//            }
//            
//            let g = q.groups
//            for group in groups {
//                guard g.contains(group) else {
//                    return
//                }
//            }
//            
//            set.insert(q)
//        }
//        return set
//    }
//    
//    internal func search<T: ManagedNode, U: ManagedProperty>(properties: [String], entity name: String, _: U.Type) -> Set<T> {
//        var set = Set<T>()
//        
//        guard let moc = graph.managedObjectContext else {
//            return set
//        }
//        
//        search(forEntityName: name, properties: properties)?.forEach { [weak self, weak moc, properties = properties] in
//            guard let s = self else {
//                return
//            }
//            
//            var n: T?
//            moc?.performAndWait { [q = $0] in
//                n = (q as? U)?.node as? T
//            }
//            
//            guard let q = n else {
//                return
//            }
//            
//            guard .and == s.propertiesSearchCondition else {
//                set.insert(q)
//                return
//            }
//            
//            let k = q.properties.keys
//            for property in properties {
//                guard k.contains(property) else {
//                    return
//                }
//            }
//            
//            set.insert(q)
//        }
//        return set
//    }
//    
//    internal func executeResultSet<T: ManagedNode>(typeSet: Set<T>?, tagSet: Set<T>?, groupSet: Set<T>?, propertySet: Set<T>?) -> Set<T>? {
//        var set: Set<T>?
//        
//        if let v = typeSet {
//            set = v
//        }
//        
//        if let v = tagSet {
//            if let _ = set {
//                set?.formIntersection(v)
//            } else {
//                set = v
//            }
//        }
//        
//        if let v = groupSet {
//            if let _ = set {
//                set?.formIntersection(v)
//            } else {
//                set = v
//            }
//        }
//        
//        if let v = propertySet {
//            if let _ = set {
//                set?.formIntersection(v)
//            } else {
//                set = v
//            }
//        }
//        
//        return set
//    }
//    
//    /**
//     Searches for Entities that fall into any of the specified facets.
//     - Parameter types: An Array of Entity types.
//     - Parameter tags: An Array of tags.
//     - Parameter groups: An Array of Strings.
//     - Parameter properties: An Array of property tuples.
//     - Returns: An Array of Entities.
//     */
//    internal func searchForEntity(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) -> [Entity] {
//        var typeSet: Set<ManagedEntity>?
//        var tagSet: Set<ManagedEntity>?
//        var groupSet: Set<ManagedEntity>?
//        var propertySet: Set<ManagedEntity>?
//        
//        if let v = types {
//            typeSet = search(types: v, entity: ModelIdentifier.entityName)
//        }
//        
//        if let v = tags {
//            tagSet = search(tags: v, entity: ModelIdentifier.entityTagName, ManagedEntityTag.self)
//        }
//        
//        if let v = groups {
//            groupSet = search(groups: v, entity: ModelIdentifier.entityGroupName, ManagedEntityGroup.self)
//        }
//        
//        if let v = properties {
//            propertySet = search(properties: v, entity: ModelIdentifier.entityPropertyName, ManagedEntityProperty.self)
//        }
//        
//        var nodes = [Entity]()
//        executeResultSet(typeSet: typeSet, tagSet: tagSet, groupSet: groupSet, propertySet: propertySet)?.forEach {
//            nodes.append(Entity(managedNode: $0))
//        }
//        return nodes
//    }
//    
//    /**
//     Searches for Entities that fall into any of the specified facets.
//     - Parameter types: An Array of Entity types.
//     - Parameter tags: An Array of tags.
//     - Parameter groups: An Array of Strings.
//     - Parameter properties: An Array of property tuples.
//     - Returns: An Array of Relationships.
//     */
//    internal func searchForRelationship(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) -> [Relationship] {
//        var typeSet: Set<ManagedRelationship>?
//        var tagSet: Set<ManagedRelationship>?
//        var groupSet: Set<ManagedRelationship>?
//        var propertySet: Set<ManagedRelationship>?
//        
//        if let v = types {
//            typeSet = search(types: v, entity: ModelIdentifier.relationshipName)
//        }
//        
//        if let v = tags {
//            tagSet = search(tags: v, entity: ModelIdentifier.relationshipTagName, ManagedRelationshipTag.self)
//        }
//        
//        if let v = groups {
//            groupSet = search(groups: v, entity: ModelIdentifier.relationshipGroupName, ManagedRelationshipGroup.self)
//        }
//        
//        if let v = properties {
//            propertySet = search(properties: v, entity: ModelIdentifier.relationshipPropertyName, ManagedRelationshipProperty.self)
//        }
//        
//        var nodes = [Relationship]()
//        executeResultSet(typeSet: typeSet, tagSet: tagSet, groupSet: groupSet, propertySet: propertySet)?.forEach {
//            nodes.append(Relationship(managedNode: $0))
//        }
//        return nodes
//    }
//    
//    /**
//     Searches for Entities that fall into any of the specified facets.
//     - Parameter types: An Array of Entity types.
//     - Parameter tags: An Array of tags.
//     - Parameter groups: An Array of Strings.
//     - Parameter properties: An Array of property tuples.
//     - Returns: An Array of Actions.
//     */
//    internal func searchForAction(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) -> [Action] {
//        var typeSet: Set<ManagedAction>?
//        var tagSet: Set<ManagedAction>?
//        var groupSet: Set<ManagedAction>?
//        var propertySet: Set<ManagedAction>?
//        
//        if let v = types {
//            typeSet = search(types: v, entity: ModelIdentifier.actionName)
//        }
//        
//        if let v = tags {
//            tagSet = search(tags: v, entity: ModelIdentifier.actionTagName, ManagedActionTag.self)
//        }
//        
//        if let v = groups {
//            groupSet = search(groups: v, entity: ModelIdentifier.actionGroupName, ManagedActionGroup.self)
//        }
//        
//        if let v = properties {
//            propertySet = search(properties: v, entity: ModelIdentifier.actionPropertyName, ManagedActionProperty.self)
//        }
//        
//        var nodes = [Action]()
//        executeResultSet(typeSet: typeSet, tagSet: tagSet, groupSet: groupSet, propertySet: propertySet)?.forEach {
//            nodes.append(Action(managedNode: $0))
//        }
//        return nodes
//    }
//    
//    /**
//     Searches based on type value.
//     - Parameter forEntityName: An entity type name.
//     - Parameter types: An Array of Strings.
//     - Returns: An optional Array of ManagedNode objects.
//     */
//    internal func search(forEntityName: String, types: [String]) -> [ManagedNode]? {
//        guard let moc = graph.managedObjectContext else {
//            return nil
//        }
//        
//        var predicate = [NSPredicate]()
//        
//        for v in types {
//            predicate.append(NSPredicate(format: "type LIKE[cd] %@", v))
//        }
//        
//        let request = NSFetchRequest<ManagedNode>()
//        request.entity = NSEntityDescription.entity(forEntityName: forEntityName, in: moc)!
//        request.fetchBatchSize = graph.batchSize
//        request.fetchOffset = graph.batchOffset
//        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
//        
//        var result: [AnyObject]?
//        moc.performAndWait { [unowned moc, unowned request] in
//            do {
//                if #available(iOS 10.0, OSX 10.12, *) {
//                    result = try request.execute()
//                } else {
//                    result = try moc.fetch(request)
//                }
//            } catch {}
//        }
//        return result as? [ManagedNode]
//    }
//    
//    /**
//     Searches based on tag value.
//     - Parameter forEntityName: An entity type name.
//     - Parameter tags: An Array of Strings.
//     - Returns: An optional Array of ManagedTag objects.
//     */
//    internal func search(forEntityName: String, tags: [String]) -> [ManagedTag]? {
//        guard let moc = graph.managedObjectContext else {
//            return nil
//        }
//        
//        var predicate = [NSPredicate]()
//        
//        for v in tags {
//            predicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
//        }
//        
//        let request = NSFetchRequest<ManagedTag>()
//        request.entity = NSEntityDescription.entity(forEntityName: forEntityName, in: moc)!
//        request.fetchBatchSize = graph.batchSize
//        request.fetchOffset = graph.batchOffset
//        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
//        
//        var result: [AnyObject]?
//        moc.performAndWait { [unowned request] in
//            do {
//                if #available(iOS 10.0, OSX 10.12, *) {
//                    result = try request.execute()
//                } else {
//                    result = try moc.fetch(request)
//                }
//            } catch {}
//        }
//        return result as? [ManagedTag]
//    }
//    
//    /**
//     Searches based on group value.
//     - Parameter forEntityName: An entity type name.
//     - Parameter groups: An Array of Strings.
//     - Returns: An optional Array of ManagedGroup objects.
//     */
//    internal func search(forEntityName: String, groups: [String]) -> [ManagedGroup]? {
//        guard let moc = graph.managedObjectContext else {
//            return nil
//        }
//        
//        var predicate = [NSPredicate]()
//        
//        for v in groups {
//            predicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
//        }
//        
//        let request = NSFetchRequest<ManagedGroup>()
//        request.entity = NSEntityDescription.entity(forEntityName: forEntityName, in: moc)!
//        request.fetchBatchSize = graph.batchSize
//        request.fetchOffset = graph.batchOffset
//        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
//        
//        var result: [AnyObject]?
//        moc.performAndWait { [unowned request] in
//            do {
//                if #available(iOS 10.0, OSX 10.12, *) {
//                    result = try request.execute()
//                } else {
//                    result = try moc.fetch(request)
//                }
//            } catch {}
//        }
//        return result as? [ManagedGroup]
//    }
//    
//    /**
//     Searches based on property value.
//     - Parameter forEntityName: An entity type name.
//     - Parameter properties: An Array of ManagedProperty objects.
//     - Returns: An optional Array of ManagedProperty objects.
//     */
//    internal func search(forEntityName: String, properties: [String]) -> [ManagedProperty]? {
//        guard let moc = graph.managedObjectContext else {
//            return nil
//        }
//        
//        var predicate = [NSPredicate]()
//        
//        for v in properties {
//            predicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
//        }
//        
//        let request = NSFetchRequest<ManagedProperty>()
//        request.entity = NSEntityDescription.entity(forEntityName: forEntityName, in: moc)!
//        request.fetchBatchSize = graph.batchSize
//        request.fetchOffset = graph.batchOffset
//        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
//        
//        var result: [AnyObject]?
//        moc.performAndWait { [unowned request] in
//            do {
//                if #available(iOS 10.0, OSX 10.12, *) {
//                    result = try request.execute()
//                } else {
//                    result = try moc.fetch(request)
//                }
//            } catch {}
//        }
//        return result as? [ManagedProperty]
//    }
//}

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

@objc(SearchCondition)
public enum SearchCondition: Int {
    case or
    case and
}

public protocol Searchable {
    /// Element type.
    associatedtype Element: Node
    
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
    public private(set) var types: [String]?
    
    /// A reference to the tags.
    public private(set) var tags: [String]?
    
    /// A SearchCondition value for tags.
    public private(set) var tagsSearchCondition = SearchCondition.and
    
    /// A reference to the groups.
    public private(set) var groups: [String]?
    
    /// A SearchCondition value for groups.
    public private(set) var groupsSearchCondition = SearchCondition.and
    
    /// A reference to the properties.
    public var properties: [String]?
    
    /// A SearchCondition value for properties.
    public var propertiesSearchCondition = SearchCondition.and
    
    /**
     An initializer that accepts a NodeClass and Graph
     instance.
     - Parameter graph: A Graph instance.
     - Parameter nodeClass: A NodeClass value.
     */
    internal init(graph: Graph) {
        self.graph = graph
    }
    
    /**
     Clears the search parameters.
     - Returns: A Search instance.
     */
    @discardableResult
    public func clear() -> Search {
        types = nil
        tags = nil
        tagsSearchCondition = .and
        groups = nil
        groupsSearchCondition = .and
        properties = nil
        propertiesSearchCondition = .and
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
    public func has(tags: [String], using condition: SearchCondition = .and) -> Search {
        self.tags = tags
        tagsSearchCondition = condition
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
    public func member(of groups: [String], using condition: SearchCondition = .and) -> Search {
        self.groups = groups
        groupsSearchCondition = condition
        return self
    }
    
    /**
     Watches nodes with given properties.
     - Parameter properties: A parameter list of Strings.
     - Returns: A Search instance.
     */
    @discardableResult
    public func `where`(properties: String...) -> Search {
        return self.where(properties: properties)
    }
    
    /**
     Watches nodes with given properties.
     - Parameter groups: An Array of Strings.
     - Returns: A Search instance.
     */
    @discardableResult
    public func `where`(properties: [String], using condition: SearchCondition = .and) -> Search {
        self.properties = properties
        propertiesSearchCondition = condition
        return self
    }
    
    /**
     Executes the synchronous process on the main thread.
     - Parameter nodes: An Array of Elements.
     - Parameter completion: An optional completion block.
     - Returns: An Array of Elements.
     */
    @discardableResult
    internal func executeSynchronousRequest(nodes: [T], completion: (([T]) -> Void)? = nil) -> [T] {
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
    public func sync(completion: (([T]) -> Void)? = nil) -> [T] {
        return executeSynchronousRequest(nodes: searchForEntity(types: types, tags: tags, groups: groups, properties: properties) as! [T], completion: completion)
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
            
            let n = s.searchForEntity(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! [T]
            
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
        return executeSynchronousRequest(nodes: searchForRelationship(types: types, tags: tags, groups: groups, properties: properties) as! [T], completion: completion)
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
            
            let n = s.searchForRelationship(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! [T]
            
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
        return executeSynchronousRequest(nodes: searchForAction(types: types, tags: tags, groups: groups, properties: properties) as! [T], completion: completion)
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
            
            let n = s.searchForAction(types: s.types, tags: s.tags, groups: s.groups, properties: s.properties) as! [T]
            
            DispatchQueue.main.async { [n = n, completion = completion] in
                completion(n)
            }
        }
    }
}

extension Search {
    internal func search<T: ManagedNode>(types: [String], entity name: String) -> Set<T> {
        guard let objects: [T] = search(forEntityName: name, values: types) else {
            return Set<T>()
        }
        
        return Set<T>(objects)
    }
    
    internal func search<T: ManagedNode, U: ManagedTag>(tags: [String], entity name: String, _: U.Type) -> Set<T> {
        var set = Set<T>()
        
        guard let objects: [U] = search(forEntityName: name, values: tags) else {
            return set
        }
        
        guard let moc = graph.managedObjectContext else {
            return set
        }
        
        objects.forEach { [weak self, weak moc, tags = tags] in
            guard let s = self else {
                return
            }
            
            var n: T?
            moc?.performAndWait { [q = $0] in
                n = q.node as? T
            }
            
            guard let q = n else {
                return
            }
            
            guard .and == s.tagsSearchCondition else {
                set.insert(q)
                return
            }
            
            guard q.has(tags: tags) else {
                return
            }
            
            set.insert(q)
        }
        return set
    }
    
    internal func search<T: ManagedNode, U: ManagedGroup>(groups: [String], entity name: String, _: U.Type) -> Set<T> {
        var set = Set<T>()
        
        guard let objects: [U] = search(forEntityName: name, values: groups) else {
            return set
        }
        
        guard let moc = graph.managedObjectContext else {
            return set
        }
        
        objects.forEach { [weak self, weak moc, groups = groups] in
            guard let s = self else {
                return
            }
            
            var n: T?
            moc?.performAndWait { [q = $0] in
                n = q.node as? T
            }
            
            guard let q = n else {
                return
            }
            
            guard .and == s.groupsSearchCondition else {
                set.insert(q)
                return
            }
            
            let g = q.groups
            for group in groups {
                guard g.contains(group) else {
                    return
                }
            }
            
            set.insert(q)
        }
        return set
    }
    
    internal func search<T: ManagedNode, U: ManagedProperty>(properties: [String], entity name: String, _: U.Type) -> Set<T> {
        var set = Set<T>()
        
        guard let objects: [U] = search(forEntityName: name, values: properties) else {
            return set
        }
        
        guard let moc = graph.managedObjectContext else {
            return set
        }
        
        objects.forEach { [weak self, weak moc, properties = properties] in
            guard let s = self else {
                return
            }
            
            var n: T?
            moc?.performAndWait { [q = $0] in
                n = q.node as? T
            }
            
            guard let q = n else {
                return
            }
            
            guard .and == s.propertiesSearchCondition else {
                set.insert(q)
                return
            }
            
            let k = q.properties.keys
            for property in properties {
                guard k.contains(property) else {
                    return
                }
            }
            
            set.insert(q)
        }
        return set
    }
    
    internal func formIntersectionResultSet<T: ManagedNode>(typeSet: Set<T>?, tagSet: Set<T>?, groupSet: Set<T>?, propertySet: Set<T>?) -> Set<T>? {
        var set: Set<T>?
        
        if let v = typeSet {
            set = v
        }
        
        if let v = tagSet {
            if let _ = set {
                set?.formIntersection(v)
            } else {
                set = v
            }
        }
        
        if let v = groupSet {
            if let _ = set {
                set?.formIntersection(v)
            } else {
                set = v
            }
        }
        
        if let v = propertySet {
            if let _ = set {
                set?.formIntersection(v)
            } else {
                set = v
            }
        }
        
        return set
    }
    
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of Strings.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Entities.
     */
    internal func searchForEntity(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) -> [Entity] {
        var typeSet: Set<ManagedEntity>?
        var tagSet: Set<ManagedEntity>?
        var groupSet: Set<ManagedEntity>?
        var propertySet: Set<ManagedEntity>?
        
        if let v = types {
            typeSet = search(types: v, entity: ModelIdentifier.entityName)
        }
        
        if let v = tags {
            tagSet = search(tags: v, entity: ModelIdentifier.entityTagName, ManagedEntityTag.self)
        }
        
        if let v = groups {
            groupSet = search(groups: v, entity: ModelIdentifier.entityGroupName, ManagedEntityGroup.self)
        }
        
        if let v = properties {
            propertySet = search(properties: v, entity: ModelIdentifier.entityPropertyName, ManagedEntityProperty.self)
        }
        
        var nodes = [Entity]()
        formIntersectionResultSet(typeSet: typeSet, tagSet: tagSet, groupSet: groupSet, propertySet: propertySet)?.forEach {
            nodes.append(Entity(managedNode: $0))
        }
        return nodes
    }
    
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of Strings.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Relationships.
     */
    internal func searchForRelationship(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) -> [Relationship] {
        var typeSet: Set<ManagedRelationship>?
        var tagSet: Set<ManagedRelationship>?
        var groupSet: Set<ManagedRelationship>?
        var propertySet: Set<ManagedRelationship>?
        
        if let v = types {
            typeSet = search(types: v, entity: ModelIdentifier.relationshipName)
        }
        
        if let v = tags {
            tagSet = search(tags: v, entity: ModelIdentifier.relationshipTagName, ManagedRelationshipTag.self)
        }
        
        if let v = groups {
            groupSet = search(groups: v, entity: ModelIdentifier.relationshipGroupName, ManagedRelationshipGroup.self)
        }
        
        if let v = properties {
            propertySet = search(properties: v, entity: ModelIdentifier.relationshipPropertyName, ManagedRelationshipProperty.self)
        }
        
        var nodes = [Relationship]()
        formIntersectionResultSet(typeSet: typeSet, tagSet: tagSet, groupSet: groupSet, propertySet: propertySet)?.forEach {
            nodes.append(Relationship(managedNode: $0))
        }
        return nodes
    }
    
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter tags: An Array of tags.
     - Parameter groups: An Array of Strings.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Actions.
     */
    internal func searchForAction(types: [String]? = nil, tags: [String]? = nil, groups: [String]? = nil, properties: [String]? = nil) -> [Action] {
        var typeSet: Set<ManagedAction>?
        var tagSet: Set<ManagedAction>?
        var groupSet: Set<ManagedAction>?
        var propertySet: Set<ManagedAction>?
        
        if let v = types {
            typeSet = search(types: v, entity: ModelIdentifier.actionName)
        }
        
        if let v = tags {
            tagSet = search(tags: v, entity: ModelIdentifier.actionTagName, ManagedActionTag.self)
        }
        
        if let v = groups {
            groupSet = search(groups: v, entity: ModelIdentifier.actionGroupName, ManagedActionGroup.self)
        }
        
        if let v = properties {
            propertySet = search(properties: v, entity: ModelIdentifier.actionPropertyName, ManagedActionProperty.self)
        }
        
        var nodes = [Action]()
        formIntersectionResultSet(typeSet: typeSet, tagSet: tagSet, groupSet: groupSet, propertySet: propertySet)?.forEach {
            nodes.append(Action(managedNode: $0))
        }
        return nodes
    }
    
    /**
     Searches based on property value.
     - Parameter forEntityName: An entity type name.
     - Parameter properties: An Array of ManagedProperty objects.
     - Returns: An optional Array of ManagedProperty objects.
     */
    internal func search<T: ManagedObject>(forEntityName: String, values: [String]) -> [T]? {
        guard let moc = graph.managedObjectContext else {
            return nil
        }
        
        var predicate = [NSPredicate]()
        
        for v in values {
            predicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
        }
        
        let request = NSFetchRequest<T>()
        request.entity = NSEntityDescription.entity(forEntityName: forEntityName, in: moc)!
        request.fetchBatchSize = graph.batchSize
        request.fetchOffset = graph.batchOffset
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
        
        var result: [AnyObject]?
        moc.performAndWait { [unowned request] in
            do {
                if #available(iOS 10.0, OSX 10.12, *) {
                    result = try request.execute()
                } else {
                    result = try moc.fetch(request)
                }
            } catch {}
        }
        return result as? [T]
    }
}
