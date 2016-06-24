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
    
    optional func graphDidInsertAction(graph: Graph, action: Action)
    optional func graphDidUpdateAction(graph: Graph, action: Action)
    optional func graphDidDeleteAction(graph: Graph, action: Action)
    optional func graphDidInsertActionGroup(graph: Graph, action: Action, group: String)
    optional func graphDidDeleteActionGroup(graph: Graph, action: Action, group: String)
    optional func graphDidInsertActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
    optional func graphDidUpdateActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
    optional func graphDidDeleteActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
    
    optional func graphDidInsertRelationship(graph: Graph, relationship: Relationship)
    optional func graphDidDeleteRelationship(graph: Graph, relationship: Relationship)
    optional func graphDidInsertRelationshipGroup(graph: Graph, relationship: Relationship, group: String)
    optional func graphDidDeleteRelationshipGroup(graph: Graph, relationship: Relationship, group: String)
    optional func graphDidInsertRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject)
    optional func graphDidUpdateRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject)
    optional func graphDidDeleteRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject)
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
     Clears all persisted data.
     - Parameter completion: An Optional completion block that is
     executed when the save operation is completed.
     */
    public func clear(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        for entity in searchForEntity(types: ["*"]) {
            entity.delete()
        }
        
        for action in searchForAction(types: ["*"]) {
            action.delete()
        }
        
        for relationship in searchForRelationship(types: ["*"]) {
            relationship.delete()
        }
        
        save(completion)
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
