/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*
* GKManagedEntity
*
* Represents an Entity Model Object in the persistent layer.
*/

import CoreData

@objc(GKManagedEntity)
internal class GKManagedEntity: GKManagedNode {
    @NSManaged internal var actionSubjectSet: NSSet
    @NSManaged internal var actionObjectSet: NSSet
    @NSManaged internal var bondSubjectSet: NSSet
    @NSManaged internal var bondObjectSet: NSSet

    /**
    * entityDescription
    * Class method returning an NSEntityDescription Object for this Model Object.
    * @return        NSEntityDescription!
    */
    class func entityDescription() -> NSEntityDescription! {
        let graph: GKGraph = GKGraph()
        return NSEntityDescription.entityForName(GKGraphUtility.entityDescriptionName, inManagedObjectContext: graph.managedObjectContext)
    }

    /**
    * init
    * Initializes the Model Object with e a given type.
    * @param        type: String!
    */
    convenience internal init(type: String!) {
        let graph: GKGraph = GKGraph()
        let entitiDescription: NSEntityDescription! = NSEntityDescription.entityForName(GKGraphUtility.entityDescriptionName, inManagedObjectContext: graph.managedObjectContext)
        self.init(entity: entitiDescription, managedObjectContext: graph.managedObjectContext)
        nodeClass = "1"
        self.type = type
        actionSubjectSet = NSSet()
        actionObjectSet = NSSet()
        bondSubjectSet = NSSet()
        bondObjectSet = NSSet()
    }

    /**
    * properties[ ]
    * Allows for Dictionary style coding, which maps to the internal properties Dictionary.
    * @param        name: String!
    * get           Returns the property name value.
    * set           Value for the property name.
    */
    override internal subscript(name: String) -> AnyObject? {
        get {
            for node in propertySet {
				let property: GKEntityProperty = node as GKEntityProperty
				if name == property.name {
                    return property.value
                }
            }
            return nil
        }
        set(value) {
			for node in propertySet {
				let property: GKEntityProperty = node as GKEntityProperty
                if name == property.name {
                    if nil == value {
                        propertySet.removeObject(property)
                        managedObjectContext!.deleteObject(property)
                    } else {
                        property.value = value!
                    }
                    return
                }
            }
            if nil != value {
                var property: GKEntityProperty = GKEntityProperty(name: name, value: value, managedObjectContext: managedObjectContext)
                property.node = self
                propertySet.addObject(property)
            }
        }
    }

    /**
    * addGroup
    * Adds a Group name to the list of Groups if it does not exist.
    * @param        name: String!
    * @return       Bool of the result, true if added, false otherwise.
    */
    override internal func addGroup(name: String!) -> Bool {
        if !hasGroup(name) {
            var group: GKEntityGroup = GKEntityGroup(name: name, managedObjectContext: managedObjectContext!)
            group.node = self
            groupSet.addObject(group)
            return true
        }
        return false
    }

    /**
    * hasGroup
    * Checks whether the Node is a part of the Group name passed or not.
    * @param        name: String!
    * @return       Bool of the result, true if is a part, false otherwise.
    */
    override internal func hasGroup(name: String!) -> Bool {
        for node in groupSet {
			let group: GKEntityGroup = node as GKEntityGroup
			if name == group.name {
                return true
            }
        }
        return false
    }

    /**
    * removeGroup
    * Removes a Group name from the list of Groups if it exists.
    * @param        name: String!
    * @return       Bool of the result, true if exists, false otherwise.
    */
    override internal func removeGroup(name: String!) -> Bool {
        for node in groupSet {
            let group: GKEntityGroup = node as GKEntityGroup
            if name == group.name {
                groupSet.removeObject(group)
                managedObjectContext!.deleteObject(group)
                return true
            }
        }
        return false
    }

    /**
    * delete
    * Marks the Model Object to be deleted from the Graph.
    */
    internal func delete() {
        var nodes: NSMutableSet = actionSubjectSet as NSMutableSet
        for node in nodes {
            nodes.removeObject(node)
        }
        nodes = actionObjectSet as NSMutableSet
        for node in nodes {
            nodes.removeObject(node)
        }
        nodes = propertySet as NSMutableSet
        for node in nodes {
            nodes.removeObject(node)
            managedObjectContext!.deleteObject(node as GKEntityProperty)
        }
        nodes = groupSet as NSMutableSet
        for node in nodes {
            nodes.removeObject(node)
            managedObjectContext!.deleteObject(node as GKEntityGroup)
        }
        managedObjectContext!.deleteObject(self)
    }
}

/**
* An extension used to handle the many-to-many relationship with Actions.
*/
extension GKManagedEntity {

    /**
    * addActionSubjectSetObject
    * Adds the Action to the actionSubjectSet for the Entity.
    * @param        value: GKManagedAction
    */
    func addActionSubjectSetObject(value: GKManagedAction) {
        let nodes: NSMutableSet = actionSubjectSet as NSMutableSet
        nodes.addObject(value)
    }

    /**
    * removeActionSubjectSetObject
    * Removes the Action to the actionSubjectSet for the Entity.
    * @param        value: GKManagedAction
    */
    func removeActionSubjectSetObject(value: GKManagedAction) {
        let nodes: NSMutableSet = actionSubjectSet as NSMutableSet
        nodes.removeObject(value)
    }

    /**
    * addActionObjectSetObject
    * Adds the Action to the actionObjectSet for the Entity.
    * @param        value: GKManagedAction
    */
    func addActionObjectSetObject(value: GKManagedAction) {
        let nodes: NSMutableSet = actionObjectSet as NSMutableSet
        nodes.addObject(value)
    }

    /**
    * removeActionObjectSetObject
    * Removes the Action to the actionObjectSet for the Entity.
    * @param        value: GKManagedAction
    */
    func removeActionObjectSetObject(value: GKManagedAction) {
        let nodes: NSMutableSet = actionObjectSet as NSMutableSet
        nodes.removeObject(value)
    }
}

/**
* An extension used to handle the many-to-many relationship with Bonds.
*/
extension GKManagedEntity {

    /**
    * addBondSubjectSetObject
    * Adds the Bond to the bondSubjectSet for the Entity.
    * @param        value: GKManagedBond
    */
    func addBondSubjectSetObject(value: GKManagedBond) {
        let nodes: NSMutableSet = bondSubjectSet as NSMutableSet
        nodes.addObject(value)
    }

    /**
    * removeBondSubjectSetObject
    * Removes the Bond to the bondSubjectSet for the Entity.
    * @param        value: GKManagedBond
    */
    func removeBondSubjectSetObject(value: GKManagedBond) {
        let nodes: NSMutableSet = bondSubjectSet as NSMutableSet
        nodes.removeObject(value)
    }

    /**
    * addBondObjectSetObject
    * Adds the Bond to the bondObjectSet for the Entity.
    * @param        value: GKManagedBond
    */
    func addBondObjectSetObject(value: GKManagedBond) {
        let nodes: NSMutableSet = bondObjectSet as NSMutableSet
        nodes.addObject(value)
    }

    /**
    * removeBondObjectSetObject
    * Removes the Bond to the bondObjectSet for the Entity.
    * @param        value: GKManagedBond
    */
    func removeBondObjectSetObject(value: GKManagedBond) {
        let nodes: NSMutableSet = bondObjectSet as NSMutableSet
        nodes.removeObject(value)
    }
}