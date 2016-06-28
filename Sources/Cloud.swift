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

@objc(CloudDelegate)
public protocol CloudDelegate {
    optional func cloudDidInsertEntity(cloud: Cloud, entity: Entity)
    optional func cloudDidDeleteEntity(cloud: Cloud, entity: Entity)
    optional func cloudDidInsertEntityGroup(cloud: Cloud, entity: Entity, group: String)
    optional func cloudDidDeleteEntityGroup(cloud: Cloud, entity: Entity, group: String)
    optional func cloudDidInsertEntityProperty(cloud: Cloud, entity: Entity, property: String, value: AnyObject)
    optional func cloudDidUpdateEntityProperty(cloud: Cloud, entity: Entity, property: String, value: AnyObject)
    optional func cloudDidDeleteEntityProperty(cloud: Cloud, entity: Entity, property: String, value: AnyObject)
    
    optional func cloudDidInsertRelationship(cloud: Cloud, relationship: Relationship)
    optional func cloudDidUpdateRelationship(cloud: Cloud, relationship: Relationship)
    optional func cloudDidDeleteRelationship(cloud: Cloud, relationship: Relationship)
    optional func cloudDidInsertRelationshipGroup(cloud: Cloud, relationship: Relationship, group: String)
    optional func cloudDidDeleteRelationshipGroup(cloud: Cloud, relationship: Relationship, group: String)
    optional func cloudDidInsertRelationshipProperty(cloud: Cloud, relationship: Relationship, property: String, value: AnyObject)
    optional func cloudDidUpdateRelationshipProperty(cloud: Cloud, relationship: Relationship, property: String, value: AnyObject)
    optional func cloudDidDeleteRelationshipProperty(cloud: Cloud, relationship: Relationship, property: String, value: AnyObject)
    
    optional func cloudDidInsertAction(cloud: Cloud, action: Action)
    optional func cloudDidUpdateAction(cloud: Cloud, action: Action)
    optional func cloudDidDeleteAction(cloud: Cloud, action: Action)
    optional func cloudDidInsertActionGroup(cloud: Cloud, action: Action, group: String)
    optional func cloudDidDeleteActionGroup(cloud: Cloud, action: Action, group: String)
    optional func cloudDidInsertActionProperty(cloud: Cloud, action: Action, property: String, value: AnyObject)
    optional func cloudDidUpdateActionProperty(cloud: Cloud, action: Action, property: String, value: AnyObject)
    optional func cloudDidDeleteActionProperty(cloud: Cloud, action: Action, property: String, value: AnyObject)
}

@objc(Cloud)
public class Cloud: Storage {
    /// A reference to a delagte object.
    public weak var delegate: CloudDelegate?
    
    /// A reference to the cloud completion handler.
    internal var completion: ((success: Bool, error: NSError?) -> Void)?
    
    /**
     Initializer to named Graph with optional type and location.
     - Parameter name: A name for the Graph.
     - Parameter location: A location for storage.
     - Parameter completion: An Optional completion block that is
     executed to determine if iCloud support is available or not.
     */
    public init(name: String = StorageConstants.name, location: NSURL = StorageConstants.location, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        super.init()
        self.name = name
        self.type = NSSQLiteStoreType
        self.location = location
        self.completion = completion
        prepareStorageRegistry()
        prepareManagedObjectContext()
    }
    
    /// Prapres the managedObjectContext.
    internal override func prepareManagedObjectContext() {
        guard let moc = StorageRegistry.workerManagedObjectContexts[name] else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
                if let s = self {
                    let privateManagedObjectContexts = Context.createManagedContext(.PrivateQueueConcurrencyType)
                    privateManagedObjectContexts.persistentStoreCoordinator = Coordinator.createCloudPersistentStoreCoordinator(s.name, type: s.type, location: s.location) { [weak self] (success: Bool, error: NSError?) in
                        if let s = self {
                            StorageRegistry.privateManagedObjectContextss[s.name] = privateManagedObjectContexts
                            
                            let mainContext = Context.createManagedContext(.MainQueueConcurrencyType, parentContext: privateManagedObjectContexts)
                            StorageRegistry.mainManagedObjectContexts[s.name] = mainContext
                            
                            s.managedObjectContext = Context.createManagedContext(.PrivateQueueConcurrencyType, parentContext: mainContext)
                            StorageRegistry.workerManagedObjectContexts[s.name] = s.managedObjectContext
                            
                            s.completion?(success: success, error: error)
                        }
                    }
                }
            }
            return
        }
        
        managedObjectContext = moc
    }
}

public extension Cloud {
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
                    self.delegate?.cloudDidInsertEntity?(self, entity: Entity(managedNode: managedObject as! ManagedEntity))
                    
                case "ManagedEntityGroup_ManagedEntityGroup_":
                    let group = managedObject as! ManagedEntityGroup
                    self.delegate?.cloudDidInsertEntityGroup?(self, entity: Entity(managedNode: group.node), group: group.name)
                    
                case "ManagedEntityProperty_ManagedEntityProperty_":
                    let property = managedObject as! ManagedEntityProperty
                    self.delegate?.cloudDidInsertEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedAction_ManagedAction_":
                    self.delegate?.cloudDidInsertAction?(self, action: Action(managedNode: managedObject as! ManagedAction))
                    
                case "ManagedActionGroup_ManagedActionGroup_":
                    let group: ManagedActionGroup = managedObject as! ManagedActionGroup
                    self.delegate?.cloudDidInsertActionGroup?(self, action: Action(managedNode: group.node), group: group.name)
                    
                case "ManagedActionProperty_ManagedActionProperty_":
                    let property = managedObject as! ManagedActionProperty
                    self.delegate?.cloudDidInsertActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedRelationship_ManagedRelationship_":
                    self.delegate?.cloudDidInsertRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship))
                    
                case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                    let group = managedObject as! ManagedRelationshipGroup
                    self.delegate?.cloudDidInsertRelationshipGroup?(self, relationship: Relationship(managedNode: group.node), group: group.name)
                    
                case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                    let property = managedObject as! ManagedRelationshipProperty
                    self.delegate?.cloudDidInsertRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object)
                    
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
                    self.delegate?.cloudDidUpdateEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedActionProperty_ManagedActionProperty_":
                    let property = managedObject as! ManagedActionProperty
                    self.delegate?.cloudDidUpdateActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                    let property = managedObject as! ManagedRelationshipProperty
                    self.delegate?.cloudDidUpdateRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedAction_ManagedAction_":
                    self.delegate?.cloudDidUpdateAction?(self, action: Action(managedNode: managedObject as! ManagedAction))
                    
                case "ManagedRelationship_ManagedRelationship_":
                    self.delegate?.cloudDidUpdateRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship))
                    
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
                    self.delegate?.cloudDidDeleteEntity?(self, entity: Entity(managedNode: managedObject as! ManagedEntity))
                    
                case "ManagedEntityProperty_ManagedEntityProperty_":
                    let property = managedObject as! ManagedEntityProperty
                    self.delegate?.cloudDidDeleteEntityProperty?(self, entity: Entity(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedEntityGroup_ManagedEntityGroup_":
                    let group = managedObject as! ManagedEntityGroup
                    self.delegate?.cloudDidDeleteEntityGroup?(self, entity: Entity(managedNode: group.node), group: group.name)
                    
                case "ManagedAction_ManagedAction_":
                    self.delegate?.cloudDidDeleteAction?(self, action: Action(managedNode: managedObject as! ManagedAction))
                    
                case "ManagedActionProperty_ManagedActionProperty_":
                    let property = managedObject as! ManagedActionProperty
                    self.delegate?.cloudDidDeleteActionProperty?(self, action: Action(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedActionGroup_ManagedActionGroup_":
                    let group = managedObject as! ManagedActionGroup
                    self.delegate?.cloudDidDeleteActionGroup?(self, action: Action(managedNode: group.node), group: group.name)
                    
                case "ManagedRelationship_ManagedRelationship_":
                    self.delegate?.cloudDidDeleteRelationship?(self, relationship: Relationship(managedNode: managedObject as! ManagedRelationship))
                    
                case "ManagedRelationshipProperty_ManagedRelationshipProperty_":
                    let property = managedObject as! ManagedRelationshipProperty
                    self.delegate?.cloudDidDeleteRelationshipProperty?(self, relationship: Relationship(managedNode: property.node), property: property.name, value: property.object)
                    
                case "ManagedRelationshipGroup_ManagedRelationshipGroup_":
                    let group = managedObject as! ManagedRelationshipGroup
                    self.delegate?.cloudDidDeleteRelationshipGroup?(self, relationship: Relationship(managedNode: group.node), group: group.name)
                    
                default:
                    assert(false, "[Graph Error: Graph observed an object that is invalid.]")
                }
            }
        }
    }
}
