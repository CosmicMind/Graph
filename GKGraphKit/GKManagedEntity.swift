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
internal class GKManagedEntity: NSManagedObject {
	@NSManaged internal var nodeClass: String
	@NSManaged internal var type: String
	@NSManaged internal var createdDate: NSDate
	@NSManaged internal var propertySet: NSMutableSet
	@NSManaged internal var groupSet: NSMutableSet
	@NSManaged internal var actionSubjectSet: NSMutableSet
    @NSManaged internal var actionObjectSet: NSMutableSet
    @NSManaged internal var bondSubjectSet: NSMutableSet
    @NSManaged internal var bondObjectSet: NSMutableSet
	
	private var graph: GKGraph?
	
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
		let g: GKGraph = GKGraph()
		self.init(entity: GKManagedEntity.entityDescription(), insertIntoManagedObjectContext: g.managedObjectContext)
		nodeClass = "1"
        self.type = type
		createdDate = NSDate()
		propertySet = NSMutableSet()
		groupSet = NSMutableSet()
        actionSubjectSet = NSMutableSet()
        actionObjectSet = NSMutableSet()
        bondSubjectSet = NSMutableSet()
        bondObjectSet = NSMutableSet()
		graph = g
    }

	/**
	* context
	* Retrieves the best context for Model Object.
	* @return       NSManagedObjectContext
	*/
	internal var context: NSManagedObjectContext {
		get {
			if nil == graph {
				graph = GKGraph()
			}
			return graph!.managedObjectContext
		}
	}
	
    /**
    * properties[ ]
    * Allows for Dictionary style coding, which maps to the internal properties Dictionary.
    * @param        name: String!
    * get           Returns the property name value.
    * set           Value for the property name.
    */
    internal subscript(name: String) -> AnyObject? {
        get {
            for n in propertySet {
				let property: GKEntityProperty = n as GKEntityProperty
				if name == property.name {
                    return property.value
                }
            }
            return nil
        }
        set(value) {
			for n in propertySet {
				let property: GKEntityProperty = n as GKEntityProperty
                if name == property.name {
                    if nil == value {
						propertySet.removeObject(property)
						context.deleteObject(property)
					} else {
                        property.value = value!
                    }
                    return
                }
            }
            if nil != value {
                var property: GKEntityProperty = GKEntityProperty(name: name, value: value, managedObjectContext: context)
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
    internal func addGroup(name: String!) -> Bool {
        if !hasGroup(name) {
            var group: GKEntityGroup = GKEntityGroup(name: name, managedObjectContext: context)
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
    internal func hasGroup(name: String!) -> Bool {
        for n in groupSet {
			var group: GKEntityGroup = n as GKEntityGroup
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
    internal func removeGroup(name: String!) -> Bool {
        for n in groupSet {
            let group: GKEntityGroup = n as GKEntityGroup
			if name == group.name {
				groupSet.removeObject(group)
				context.deleteObject(group)
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
		for n in groupSet {
			let group: GKEntityGroup = n as GKEntityGroup
			groupSet.removeObject(group)
			context.deleteObject(group)
		}
		for n in propertySet {
			let property: GKEntityProperty = n as GKEntityProperty
			propertySet.removeObject(property)
			context.deleteObject(property)
		}
		for n in actionSubjectSet {
			var action: GKManagedAction = n as GKManagedAction
			actionSubjectSet.removeObject(action)
			action.removeSubject(self)
		}
		for n in actionObjectSet {
			var action: GKManagedAction = n as GKManagedAction
			actionObjectSet.removeObject(action)
			action.removeObject(self)
		}
		for n in bondSubjectSet {
			var bond: GKManagedBond = n as GKManagedBond
			bondSubjectSet.removeObject(bond)
			bond.delete()
		}
		for n in bondObjectSet {
			var bond: GKManagedBond = n as GKManagedBond
			bondObjectSet.removeObject(bond)
			bond.delete()
		}
		context.deleteObject(self)
	}
}

extension GKManagedEntity {

	/**
    * addBondSubjectSetObject
    * Adds the Bond to the bondSubjectSet for the Entity.
    * @param        value: GKManagedBond
    */
    func addBondSubjectSetObject(value: GKManagedBond) {
        bondSubjectSet.addObject(value)
    }

    /**
    * removeBondSubjectSetObject
    * Removes the Bond to the bondSubjectSet for the Entity.
    * @param        value: GKManagedBond
    */
    func removeBondSubjectSetObject(value: GKManagedBond) {
		bondSubjectSet.removeObject(value)
    }

    /**
    * addBondObjectSetObject
    * Adds the Bond to the bondObjectSet for the Entity.
    * @param        value: GKManagedBond
    */
    func addBondObjectSetObject(value: GKManagedBond) {
        bondObjectSet.addObject(value)
    }

    /**
    * removeBondObjectSetObject
    * Removes the Bond to the bondObjectSet for the Entity.
    * @param        value: GKManagedBond
    */
    func removeBondObjectSetObject(value: GKManagedBond) {
        bondObjectSet.removeObject(value)
    }
	
	/**
	* addPropertySetObject
	* Adds the Property to the propertySet for the Entity.
	* @param        value: GKEntityProperty
	*/
	func addPropertySetObject(value: GKEntityProperty) {
		propertySet.addObject(value)
	}
	
	/**
	* removePropertySetObject
	* Removes the Property to the propertySet for the Entity.
	* @param        value: GKEntityProperty
	*/
	func removePropertySetObject(value: GKEntityProperty) {
		propertySet.removeObject(value)
	}
	
	/**
	* addGroupSetObject
	* Adds the Group to the groupSet for the Entity.
	* @param        value: GKEntityGroup
	*/
	func addGroupSetObject(value: GKEntityGroup) {
		groupSet.addObject(value)
	}
	
	/**
	* removeGroupSetObject
	* Removes the Group to the groupSet for the Entity.
	* @param        value: GKEntityGroup
	*/
	func removeGroupSetObject(value: GKEntityGroup) {
		groupSet.removeObject(value)
	}
}