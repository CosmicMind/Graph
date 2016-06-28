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

/// Storage Search API.
public extension Storage {
    /**
     Searches for Entities that fall into any of the specified facets.
     - Parameter types: An Array of Entity types.
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Entities.
     */
    public func searchForEntity(types types: [String]? = nil, groups: [String]? = nil, properties: [(key: String, value: AnyObject?)]? = nil) -> [Entity] {
        var nodes = [AnyObject]()
        var toFilter: Bool = false
        
        if let v = types {
            if let n = search(ModelIdentifier.entityDescriptionName, types: v) {
                nodes.appendContentsOf(n)
            }
        }
        
        if let v = groups {
            if let n = search(ModelIdentifier.entityGroupDescriptionName, groups: v) {
                toFilter = 0 < nodes.count
                nodes.appendContentsOf(n)
            }
        }
        
        if let v = properties {
            if let n = search(ModelIdentifier.entityPropertyDescriptionName, properties: v) {
                toFilter = 0 < nodes.count
                nodes.appendContentsOf(n)
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
                } else if let v = managedObjectContext.parentContext!.parentContext!.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedEntity {
                    if nil == seen.updateValue(true, forKey: v.id) {
                        nodes[i] = Entity(managedNode: v)
                        i -= 1
                        continue
                    }
                }
                nodes.removeAtIndex(i)
                i -= 1
            }
            return nodes as! [Entity]
        }
        
        return nodes.map {
            if let n = $0 as? ManagedEntity {
                return Entity(managedNode: n)
            }
            return Entity(managedNode: managedObjectContext.parentContext!.parentContext!.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedEntity)
        } as [Entity]
    }
    
    /**
     Searches for Relationships that fall into any of the specified facets.
     - Parameter types: An Array of Relationship types.
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Relationships.
     */
    public func searchForRelationship(types types: [String]? = nil, groups: [String]? = nil, properties: [(key: String, value: AnyObject?)]? = nil) -> [Relationship] {
        var nodes = [AnyObject]()
        var toFilter: Bool = false
        
        if let v = types {
            if let n = search(ModelIdentifier.relationshipDescriptionName, types: v) {
                nodes.appendContentsOf(n)
            }
        }
        
        if let v = groups {
            if let n = search(ModelIdentifier.relationshipGroupDescriptionName, groups: v) {
                toFilter = 0 < nodes.count
                nodes.appendContentsOf(n)
            }
        }
        
        if let v = properties {
            if let n = search(ModelIdentifier.relationshipPropertyDescriptionName, properties: v) {
                toFilter = 0 < nodes.count
                nodes.appendContentsOf(n)
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
                } else if let v = managedObjectContext.parentContext!.parentContext!.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedRelationship {
                    if nil == seen.updateValue(true, forKey: v.id) {
                        nodes[i] = Relationship(managedNode: v)
                        i -= 1
                        continue
                    }
                }
                nodes.removeAtIndex(i)
                i -= 1
            }
            return nodes as! [Relationship]
        }
        
        return nodes.map {
            if let n = $0 as? ManagedRelationship {
                return Relationship(managedNode: n)
            }
            return Relationship(managedNode: managedObjectContext.parentContext!.parentContext!.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedRelationship)
        } as [Relationship]
    }
    
    /**
     Searches for Actions that fall into any of the specified facets.
     - Parameter types: An Array of Action types.
     - Parameter groups: An Array of groups.
     - Parameter properties: An Array of property tuples.
     - Returns: An Array of Actions.
     */
    public func searchForAction(types types: [String]? = nil, groups: [String]? = nil, properties: [(key: String, value: AnyObject?)]? = nil) -> [Action] {
        var nodes = [AnyObject]()
        var toFilter: Bool = false
        
        if let v = types {
            if let n = search(ModelIdentifier.actionDescriptionName, types: v) {
                nodes.appendContentsOf(n)
            }
        }
        
        if let v = groups {
            if let n = search(ModelIdentifier.actionGroupDescriptionName, groups: v) {
                toFilter = 0 < nodes.count
                nodes.appendContentsOf(n)
            }
        }
        
        if let v = properties {
            if let n = search(ModelIdentifier.actionPropertyDescriptionName, properties: v) {
                toFilter = 0 < nodes.count
                nodes.appendContentsOf(n)
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
                } else if let v = managedObjectContext.parentContext!.parentContext!.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedAction {
                    if nil == seen.updateValue(true, forKey: v.id) {
                        nodes[i] = Action(managedNode: v)
                        i -= 1
                        continue
                    }
                }
                nodes.removeAtIndex(i)
                i -= 1
            }
            return nodes as! [Action]
        }
        
        return nodes.map {
            if let n = $0 as? ManagedAction {
                return Action(managedNode: n)
            }
            return Action(managedNode: managedObjectContext.parentContext!.parentContext!.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedAction)
        } as [Action]
    }
    
    /**
     Searches based on type value.
     - Parameter typeDescriptionName: An entity type description.
     - Parameter types: An Array of types.
     - Returns: An optional Array of AnyObjects.
     */
    internal func search(typeDescriptionName: String, types: [String]) -> [AnyObject]? {
        var typesPredicate = [NSPredicate]()
        
        for v in types {
            typesPredicate.append(NSPredicate(format: "type LIKE[cd] %@", v))
        }
        
        let entityDescription = NSEntityDescription.entityForName(typeDescriptionName, inManagedObjectContext: managedObjectContext.parentContext!.parentContext!)!
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: typesPredicate)
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        
        return try? managedObjectContext.parentContext!.parentContext!.executeFetchRequest(request)
    }
    
    /**
     Searches based on group value.
     - Parameter groupDescriptionName: An entity type description.
     - Parameter groups: An Array of groups.
     - Returns: An optional Array of AnyObjects.
     */
    internal func search(groupDescriptionName: String, groups: [String]) -> [AnyObject]? {
        var groupsPredicate = [NSPredicate]()
        
        for v in groups {
            groupsPredicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
        }
        
        let entityDescription = NSEntityDescription.entityForName(groupDescriptionName, inManagedObjectContext: managedObjectContext.parentContext!.parentContext!)!
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.resultType = .DictionaryResultType
        request.propertiesToFetch = ["node"]
        request.returnsDistinctResults = true
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: groupsPredicate)
        request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
        
        return try? managedObjectContext.parentContext!.parentContext!.executeFetchRequest(request)
    }
    
    /**
     Searches based on property value.
     - Parameter propertyDescriptionName: An entity type description.
     - Parameter properties: An Array of property tuples.
     - Returns: An optional Array of AnyObjects.
     */
    internal func search(propertyDescriptionName: String, properties: [(key: String, value: AnyObject?)]) -> [AnyObject]? {
        var propertiesPredicate = [NSPredicate]()
        
        for (k, v) in properties {
            if let x = v {
                if let a = x as? String {
                    propertiesPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name LIKE[cd] %@", k), NSPredicate(format: "object = %@", a)]))
                } else if let a: NSNumber = x as? NSNumber {
                    propertiesPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name LIKE[cd] %@", k), NSPredicate(format: "object = %@", a)]))
                }
            } else {
                propertiesPredicate.append(NSPredicate(format: "name LIKE[cd] %@", k))
            }
        }
        
        let entityDescription = NSEntityDescription.entityForName(propertyDescriptionName, inManagedObjectContext: managedObjectContext.parentContext!.parentContext!)!
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.resultType = .DictionaryResultType
        request.propertiesToFetch = ["node"]
        request.returnsDistinctResults = true
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: propertiesPredicate)
        request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
        
        return try? managedObjectContext.parentContext!.parentContext!.executeFetchRequest(request)
    }
}
