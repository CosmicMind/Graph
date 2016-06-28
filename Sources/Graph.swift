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

internal struct GraphStorageRegistry {
    static var dispatchToken: dispatch_once_t = 0
    static var privateManagedObjectContextss: [String: NSManagedObjectContext]!
    static var mainManagedObjectContexts: [String: NSManagedObjectContext]!
    static var workerManagedObjectContexts: [String: NSManagedObjectContext]!
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
    
    optional func graphDidInsertRelationship(graph: Graph, relationship: Relationship)
    optional func graphDidUpdateRelationship(graph: Graph, relationship: Relationship)
    optional func graphDidDeleteRelationship(graph: Graph, relationship: Relationship)
    optional func graphDidInsertRelationshipGroup(graph: Graph, relationship: Relationship, group: String)
    optional func graphDidDeleteRelationshipGroup(graph: Graph, relationship: Relationship, group: String)
    optional func graphDidInsertRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject)
    optional func graphDidUpdateRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject)
    optional func graphDidDeleteRelationshipProperty(graph: Graph, relationship: Relationship, property: String, value: AnyObject)
    
    optional func graphDidInsertAction(graph: Graph, action: Action)
    optional func graphDidUpdateAction(graph: Graph, action: Action)
    optional func graphDidDeleteAction(graph: Graph, action: Action)
    optional func graphDidInsertActionGroup(graph: Graph, action: Action, group: String)
    optional func graphDidDeleteActionGroup(graph: Graph, action: Action, group: String)
    optional func graphDidInsertActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
    optional func graphDidUpdateActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
    optional func graphDidDeleteActionProperty(graph: Graph, action: Action, property: String, value: AnyObject)
}

@objc(Graph)
public class Graph: Storage {
    /// A reference to a delagte object.
    public weak var delegate: GraphDelegate?
    
    /**
     Initializer to named Graph with optional type and location.
     - Parameter name: A name for the Graph.
     - Parameter type: Type of Graph storage.
     - Parameter location: A location for storage.
    */
    public init(name: String = StorageConstants.name, type: String = StorageConstants.type, location: NSURL = StorageConstants.graph) {
        super.init()
        self.name = name
		self.type = type
		self.location = location
        prepareStorageRegistry()
        prepareManagedObjectContext()
    }
    
    /// Prepares the registry.
    internal func prepareStorageRegistry() {
        dispatch_once(&GraphStorageRegistry.dispatchToken) {
            GraphStorageRegistry.privateManagedObjectContextss = [String: NSManagedObjectContext]()
            GraphStorageRegistry.mainManagedObjectContexts = [String: NSManagedObjectContext]()
            GraphStorageRegistry.workerManagedObjectContexts = [String: NSManagedObjectContext]()
        }
    }
    
    /// Prapres the managedObjectContext.
    internal func prepareManagedObjectContext() {
        guard let moc = GraphStorageRegistry.workerManagedObjectContexts[name] else {
            let privateManagedObjectContexts = Context.createManagedContext(.PrivateQueueConcurrencyType)
            privateManagedObjectContexts.persistentStoreCoordinator = Coordinator.createLocalPersistentStoreCoordinator(name, type: type, location: location)
            GraphStorageRegistry.privateManagedObjectContextss[name] = privateManagedObjectContexts
            
            let mainContext = Context.createManagedContext(.MainQueueConcurrencyType, parentContext: privateManagedObjectContexts)
            GraphStorageRegistry.mainManagedObjectContexts[name] = mainContext
        
            managedObjectContext = Context.createManagedContext(.PrivateQueueConcurrencyType, parentContext: mainContext)
            GraphStorageRegistry.workerManagedObjectContexts[name] = managedObjectContext
            
            return
        }
        
        managedObjectContext = moc
    }
}

public extension Graph {
    /**
     Notifies watchers of changes within the ManagedObjectContext.
     - Parameter notification: An NSNotification passed from the
     managedObjectContext save operation.
     */
    internal override func notifyWatchers(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let predicate = watchPredicate else {
            return
        }
        
        if let insertedSet = info[NSInsertedObjectsKey] as? NSSet {
            let	inserted = insertedSet.mutableCopy() as! NSMutableSet
            
            inserted.filterUsingPredicate(predicate)
            
            (inserted.allObjects as! [NSManagedObject]).forEach { [unowned self] (managedObject: NSManagedObject) in
                switch String.fromCString(object_getClassName(managedObject))! {
                case "ManagedEntity_ManagedEntity_":
                    self.delegate?.graphDidInsertEntity?(self, entity: Entity(managedNode: managedObject as! ManagedEntity))
                    
                case "ManagedEntityGroup_ManagedEntityGroup_":
                    let group = managedObject as! ManagedEntityGroup
                    self.delegate?.graphDidInsertEntityGroup?(self, entity: Entity(managedNode: group.node), group: group.name)
                    
                case "ManagedEntityProperty_ManagedEntityProperty_":
                    let property = managedObject as! ManagedEntityProperty
                    self.delegate?.graphDidInsertEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedAction_ManagedAction_":
                    self.delegate?.graphDidInsertAction?(self, action: Action(managedNode: managedObject as! ManagedAction))
                    
                case "ManagedActionGroup_ManagedActionGroup_":
                    let group: ManagedActionGroup = managedObject as! ManagedActionGroup
                    self.delegate?.graphDidInsertActionGroup?(self, action: Action(managedNode: group.node), group: group.name)
                    
                case "ManagedActionProperty_ManagedActionProperty_":
                    let property = managedObject as! ManagedActionProperty
                    self.delegate?.graphDidInsertActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedRelationship_ManagedRelationship_":
                    self.delegate?.graphDidInsertRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship))
                    
                case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                    let group = managedObject as! ManagedRelationshipGroup
                    self.delegate?.graphDidInsertRelationshipGroup?(self, relationship: Relationship(managedNode: group.node), group: group.name)
                    
                case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                    let property = managedObject as! ManagedRelationshipProperty
                    self.delegate?.graphDidInsertRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object)
                    
                default:
                    assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                }
            }
        }
        
        if let updatedSet = info[NSUpdatedObjectsKey] as? NSSet {
            let	updated = updatedSet.mutableCopy() as! NSMutableSet
            
            updated.filterUsingPredicate(predicate)
            
            (updated.allObjects as! [NSManagedObject]).forEach { [unowned self] (managedObject: NSManagedObject) in
                switch String.fromCString(object_getClassName(managedObject))! {
                case "ManagedEntityProperty_ManagedEntityProperty_":
                    let property = managedObject as! ManagedEntityProperty
                    self.delegate?.graphDidUpdateEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedActionProperty_ManagedActionProperty_":
                    let property = managedObject as! ManagedActionProperty
                    self.delegate?.graphDidUpdateActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                    let property = managedObject as! ManagedRelationshipProperty
                    self.delegate?.graphDidUpdateRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedAction_ManagedAction_":
                    self.delegate?.graphDidUpdateAction?(self, action: Action(managedNode: managedObject as! ManagedAction))
                    
                case "ManagedRelationship_ManagedRelationship_":
                    self.delegate?.graphDidUpdateRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship))
                    
                default:
                    assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                }
            }
        }
        
        if let deletedSet = info[NSDeletedObjectsKey] as? NSSet {
            let	deleted = deletedSet.mutableCopy() as! NSMutableSet
            
            deleted.filterUsingPredicate(predicate)
            
            (deleted.allObjects as! [NSManagedObject]).forEach { [unowned self] (managedObject: NSManagedObject) in
                switch String.fromCString(object_getClassName(managedObject))! {
                case "ManagedEntity_ManagedEntity_":
                    self.delegate?.graphDidDeleteEntity?(self, entity: Entity(managedNode: managedObject as! ManagedEntity))
                    
                case "ManagedEntityProperty_ManagedEntityProperty_":
                    let property = managedObject as! ManagedEntityProperty
                    self.delegate?.graphDidDeleteEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedEntityGroup_ManagedEntityGroup_":
                    let group = managedObject as! ManagedEntityGroup
                    self.delegate?.graphDidDeleteEntityGroup?(self, entity: Entity(managedNode: group.node), group: group.name)
                    
                case "ManagedAction_ManagedAction_":
                    self.delegate?.graphDidDeleteAction?(self, action: Action(managedNode: managedObject as! ManagedAction))
                    
                case "ManagedActionProperty_ManagedActionProperty_":
                    let property = managedObject as! ManagedActionProperty
                    self.delegate?.graphDidDeleteActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedActionGroup_ManagedActionGroup_":
                    let group = managedObject as! ManagedActionGroup
                    self.delegate?.graphDidDeleteActionGroup?(self, action: Action(managedNode: group.node), group: group.name)
                    
                case "ManagedRelationship_ManagedRelationship_":
                    self.delegate?.graphDidDeleteRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship))
                    
                case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                    let property = managedObject as! ManagedRelationshipProperty
                    self.delegate?.graphDidDeleteRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                    let group = managedObject as! ManagedRelationshipGroup
                    self.delegate?.graphDidDeleteRelationshipGroup?(self, relationship: Relationship(managedNode: group.node), group: group.name)
                    
                default:
                    assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                }
            }
        }
    }
}