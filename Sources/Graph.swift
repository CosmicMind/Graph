/*
 * Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>.
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

internal struct GraphRegistry {
    static var dispatchToken: dispatch_once_t = 0
    static var privateContexts: [String: NSManagedObjectContext]!
    static var mainContexts: [String: NSManagedObjectContext]!
    static var contexts: [String: NSManagedObjectContext]!
}

@objc(GraphDelegate)
public protocol GraphDelegate {
    optional func graphDidInsertEntity(graph: Graph, entity: Entity)
    optional func graphDidDeleteEntity(graph: Graph, entity: Entity)
    optional func graphDidInsertEntityGroup(graph: Graph, entity: Entity, group: String)
    optional func graphDidDeleteEntityGroup(graph: Graph, entity: Entity, group: String)
    optional func graphDidInsertEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject)
    optional func graphDidUpdateEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject)
    optional func graphDidDeleteEntityProperty(graph: Graph, entity: Entity, property: String, value: AnyObject)
}

@objc(Graph)
public class Graph: NSObject {
    /// Storage name.
    private(set) var name: String!
	
	/// Storage type.
	private(set) var type: String!
	
    /// Storage location.
    private(set) var location: NSURL!
    
    /// Worker context.
    public private(set) var context: NSManagedObjectContext!
    
    /// A reference to the watch predicate.
    public internal(set) var watchPredicate: NSPredicate?
    
    /// A reference to cache the watch values.
    public internal(set) lazy var watchers = [String: [String]]()
    
    /// A reference to a delagte object.
    public weak var delegate: GraphDelegate?
    
    /// Number of items to return.
    public var batchSize: Int = 0 // 0 == no limit
    
    /// Start the return results from this offset.
    public var batchOffset: Int = 0
    
    /**
     Initializer to named Graph with optional type and location.
     - Parameter name: A name for the Graph.
     - Parameter type: Type of Graph storage.
     - Parameter location: A location for storage.
    */
	public required init(name: String = Storage.name, type: String = Storage.type, location: NSURL = Storage.location) {
        super.init()
        self.name = name
		self.type = type
		self.location = location
        prepareGraphRegistry()
        prepareContext()
    }
    
    /// Deinitializer that removes the Graph from NSNotificationCenter.
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Performs a save.
     - Parameter completion: An Optional completion block that is
     executed when the save operation is completed.
     */
    public func save(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        guard context.hasChanges else {
            return
        }
        
        context.performBlock { [weak self] in
            if let moc = self?.context {
                do {
                    try moc.save()
                    
                    guard let mainContext = moc.parentContext else {
                        return
                    }
                    
                    guard mainContext.hasChanges else {
                        return
                    }
                    
                    mainContext.performBlock {
                        do {
                            try mainContext.save()
                            
                            guard let privateContext = mainContext.parentContext else {
                                return
                            }
                            
                            guard privateContext.hasChanges else {
                                return
                            }
                            
                            privateContext.performBlock {
                                do {
                                    try privateContext.save()
                                    
                                    dispatch_sync(dispatch_get_main_queue()) {
                                        completion?(success: true, error: nil)
                                    }
                                } catch let e as NSError {
                                    dispatch_sync(dispatch_get_main_queue()) {
                                        completion?(success: false, error: e)
                                    }
                                }
                            }
                        } catch let e as NSError {
                            dispatch_sync(dispatch_get_main_queue()) {
                                completion?(success: false, error: e)
                            }
                        }
                    }
                } catch let e as NSError {
                    dispatch_sync(dispatch_get_main_queue()) {
                        completion?(success: false, error: e)
                    }
                }
            }
        }
    }
    
    /**
     Handler for save notifications. Context merges are made within this handler.
     - Parameter notification: NSNotification reference.
    */
    @objc internal func handleContextDidSave(notification: NSNotification) {
        dispatch_sync(dispatch_get_main_queue()) { [weak self] in
            self?.notifyWatchers(notification)
        }
    }
    
    /// Prepares the registry.
    private func prepareGraphRegistry() {
        dispatch_once(&GraphRegistry.dispatchToken) {
            GraphRegistry.privateContexts = [String: NSManagedObjectContext]()
            GraphRegistry.mainContexts = [String: NSManagedObjectContext]()
            GraphRegistry.contexts = [String: NSManagedObjectContext]()
        }
    }
    
    /// Prapres the context.
    private func prepareContext() {
        guard let moc = GraphRegistry.contexts[name] else {
            let privateContext = Context.createManagedContext(.PrivateQueueConcurrencyType)
            privateContext.persistentStoreCoordinator = Coordinator.createPersistentStoreCoordinator(name, type: type, location: location)
            GraphRegistry.privateContexts[name] = privateContext
            
            let mainContext = Context.createManagedContext(.MainQueueConcurrencyType, parentContext: privateContext)
            GraphRegistry.mainContexts[name] = mainContext
            
            context = Context.createManagedContext(.PrivateQueueConcurrencyType, parentContext: mainContext)
            GraphRegistry.contexts[name] = context
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleContextDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: privateContext)
            return
        }
        
        context = moc
    }
}

/// Graph Watch API.
public extension Graph {
    /**
     :name:	watchForEntity(types: groups: properties)
     */
    public func watchForEntity(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<String>? = nil) {
        if let v: Array<String> = types {
            for x in v {
                watch(Entity: x)
            }
        }
        
        if let v: Array<String> = groups {
            for x in v {
                watch(EntityGroup: x)
            }
        }
        
        if let v: Array<String> = properties {
            for x in v {
                watch(EntityProperty: x)
            }
        }
    }
    
    //
    //	:name:	watch(Entity)
    //
    internal func watch(Entity type: String) {
        addWatcher("type", value: type, index: ModelIdentifier.entityIndexName, entityDescriptionName: ModelIdentifier.entityDescriptionName, managedObjectClassName: ModelIdentifier.entityObjectClassName)
    }
    
    //
    //	:name:	watch(EntityGroup)
    //
    internal func watch(EntityGroup name: String) {
        addWatcher("name", value: name, index: ModelIdentifier.entityGroupIndexName, entityDescriptionName: ModelIdentifier.entityGroupDescriptionName, managedObjectClassName: ModelIdentifier.entityGroupObjectClassName)
    }
    
    //
    //	:name:	watch(EntityProperty)
    //
    internal func watch(EntityProperty name: String) {
        addWatcher("name", value: name, index: ModelIdentifier.entityPropertyIndexName, entityDescriptionName: ModelIdentifier.entityPropertyDescriptionName, managedObjectClassName: ModelIdentifier.entityPropertyObjectClassName)
    }
    
    //
    //	:name:	addPredicateToObserve
    //
    internal func addPredicateToObserve(entityDescription: NSEntityDescription, predicate: NSPredicate) {
        let entityPredicate = NSPredicate(format: "entity.name == %@", entityDescription.name! as NSString)
        let predicates = [entityPredicate, predicate]
        let finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        watchPredicate = nil == watchPredicate ? finalPredicate : NSCompoundPredicate(orPredicateWithSubpredicates: [watchPredicate!, finalPredicate])
    }
    
    //
    //	:name:	isWatching
    //
    internal func isWatching(key: String, index: String) -> Bool {
        guard var watcher = watchers[key] else {
            watchers[key] = [String](arrayLiteral: index)
            return false
        }
        guard watcher.contains(index) else {
            return false
        }
        watcher.append(index)
        return true
    }
    
    //
    //	:name:	addWatcher
    //
    internal func addWatcher(key: String, value: String, index: String, entityDescriptionName: String, managedObjectClassName: String) {
        guard !isWatching(key, index: index) else {
            return
        }
        
        let entityDescription = NSEntityDescription()
        entityDescription.name = entityDescriptionName
        entityDescription.managedObjectClassName = managedObjectClassName
        
        let predicate = NSPredicate(format: "%K LIKE %@", key as NSString, value as NSString)
        addPredicateToObserve(entityDescription, predicate: predicate)
    }
    
    /**
     Notifies watchers of changes within the ManagedObjectContext.
     - Parameter notification: An NSNotification passed from the context
     save operation.
     */
    internal func notifyWatchers(notification: NSNotification) {
        let userInfo = notification.userInfo
        
        if let insertedSet = userInfo?[NSInsertedObjectsKey] as? NSSet {
            let	inserted = insertedSet.mutableCopy() as! NSMutableSet
            
            inserted.filterUsingPredicate(watchPredicate!)
            
            if 0 < inserted.count {
                for node in inserted.allObjects as! [NSManagedObject] {
                    switch String.fromCString(object_getClassName(node))! {
                    case "ManagedEntity_ManagedEntity_":
                        delegate?.graphDidInsertEntity?(self, entity: Entity(managedEntity: node as! ManagedEntity))
                    case "ManagedEntityGroup_ManagedEntityGroup_":
                        let group = node as! ManagedEntityGroup
                        delegate?.graphDidInsertEntityGroup?(self, entity: Entity(managedEntity: group.node), group: group.name)
                    case "ManagedEntityProperty_ManagedEntityProperty_":
                        let property = node as! ManagedEntityProperty
                        delegate?.graphDidInsertEntityProperty?(self, entity: Entity(managedEntity: property.node), property: property.name, value: property.object)
                    default:
                        assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                    }
                }
            }
        }
        
        if let updatedSet = userInfo?[NSUpdatedObjectsKey] as? NSSet {
            let	updated = updatedSet.mutableCopy() as! NSMutableSet
            updated.filterUsingPredicate(watchPredicate!)
            
            if 0 < updated.count {
                for node: NSManagedObject in updated.allObjects as! [NSManagedObject] {
                    switch String.fromCString(object_getClassName(node))! {
                    case "ManagedEntityProperty_ManagedEntityProperty_":
                        let property = node as! ManagedEntityProperty
                        delegate?.graphDidUpdateEntityProperty?(self, entity: Entity(managedEntity: property.node), property: property.name, value: property.object)
                    default:
                        assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                    }
                }
            }
        }
        
        if let deletedSet = userInfo?[NSDeletedObjectsKey] as? NSSet {
            let	deleted = deletedSet.mutableCopy() as! NSMutableSet
            deleted.filterUsingPredicate(watchPredicate!)
            
            if 0 < deleted.count {
                for node in deleted.allObjects as! [NSManagedObject] {
                    switch String.fromCString(object_getClassName(node))! {
                    case "ManagedEntity_ManagedEntity_":
                        delegate?.graphDidDeleteEntity?(self, entity: Entity(managedEntity: node as! ManagedEntity))
                    case "ManagedEntityProperty_ManagedEntityProperty_":
                        let property = node as! ManagedEntityProperty
                        delegate?.graphDidDeleteEntityProperty?(self, entity: Entity(managedEntity: property.node), property: property.name, value: property.object)
                    case "ManagedEntityGroup_ManagedEntityGroup_":
                        let group = node as! ManagedEntityGroup
                        delegate?.graphDidDeleteEntityGroup?(self, entity: Entity(managedEntity: group.node), group: group.name)
                    default:
                        assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                    }
                }
            }
        }
    }
}

/// Graph Search API.
public extension Graph {
    /**
     :name:	searchForEntity(types: groups: properties)
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
                        nodes[i] = Entity(managedEntity: v)
                        i -= 1
                        continue
                    }
                } else if let v = context.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedEntity {
                    if nil == seen.updateValue(true, forKey: v.id) {
                        nodes[i] = Entity(managedEntity: v)
                        i -= 1
                        continue
                    }
                }
                nodes.removeAtIndex(i)
                i -= 1
            }
            return nodes as! [Entity]
        } else {
            return nodes.map {
                if let v: ManagedEntity = $0 as? ManagedEntity {
                    return Entity(managedEntity: v)
                }
                return Entity(managedEntity: context.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedEntity)
            } as [Entity]
        }
    }
    
    internal func search(typeDescriptionName: String, types: [String]) -> [AnyObject]? {
        var typesPredicate = [NSPredicate]()
        
        for v in types {
            typesPredicate.append(NSPredicate(format: "type LIKE[cd] %@", v))
        }
        
        let entityDescription = NSEntityDescription.entityForName(typeDescriptionName, inManagedObjectContext: context.parentContext!.parentContext!)!
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: typesPredicate)
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        
        return try? context.parentContext!.parentContext!.executeFetchRequest(request)
    }
    
    internal func search(groupDescriptionName: String, groups: [String]) -> [AnyObject]? {
        var groupsPredicate = [NSPredicate]()
        
        for v in groups {
            groupsPredicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
        }
        
        let entityDescription = NSEntityDescription.entityForName(groupDescriptionName, inManagedObjectContext: context.parentContext!.parentContext!)!
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.resultType = .DictionaryResultType
        request.propertiesToFetch = ["node"]
        request.returnsDistinctResults = true
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: groupsPredicate)
        request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
        
        return try? context.parentContext!.parentContext!.executeFetchRequest(request)
    }
    
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
        
        let entityDescription = NSEntityDescription.entityForName(propertyDescriptionName, inManagedObjectContext: context.parentContext!.parentContext!)!
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.fetchBatchSize = batchSize
        request.fetchOffset = batchOffset
        request.resultType = .DictionaryResultType
        request.propertiesToFetch = ["node"]
        request.returnsDistinctResults = true
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: propertiesPredicate)
        request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
        
        return try? context.parentContext!.parentContext!.executeFetchRequest(request)
    }
}