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
* GKManagedBond
*
* Represents an Bond Model Object in the persistent layer.
*/


import CoreData

@objc(GKManagedBond)
internal class GKManagedBond: GKManagedNode {
    @NSManaged internal var subject: GKManagedEntity?
    @NSManaged internal var object: GKManagedEntity?

    /**
    * entityDescription
    * Class method returning an NSEntityDescription Object for this Model Object.
    * @return        NSEntityDescription!
    */
    class func entityDescription() -> NSEntityDescription! {
        let graph: GKGraph = GKGraph()
        return NSEntityDescription.entityForName(GKGraphUtility.bondDescriptionName, inManagedObjectContext: graph.managedObjectContext)
    }

    /**
    * init
    * Initializes the Model Object with e a given type.
    * @param        type: String!
    */
    convenience internal init(type: String!) {
        let graph: GKGraph = GKGraph()
        let entitiDescription: NSEntityDescription! = NSEntityDescription.entityForName(GKGraphUtility.bondDescriptionName, inManagedObjectContext: graph.managedObjectContext)
        self.init(entity: entitiDescription, managedObjectContext: graph.managedObjectContext)
        nodeClass = "3"
        self.type = type
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
                let property: GKBondProperty = node as GKBondProperty
                if name == property.name {
                    return property.value
                }
            }
            return nil
        }
        set(value) {
            for node in propertySet {
                let property: GKBondProperty = node as GKBondProperty
                if name == property.name {
                    if nil == value {
                        managedObjectContext!.deleteObject(property)
                    } else {
                        property.value = value!
                    }
                    return
                }
            }
            if nil != value {
                var property: GKBondProperty = GKBondProperty(name: name, value: value, managedObjectContext: managedObjectContext)
                property.node = self
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
            var group: GKBondGroup = GKBondGroup(name: name, managedObjectContext: managedObjectContext)
            group.node = self
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
            let group: GKBondGroup = node as GKBondGroup
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
            let group: GKBondGroup = node as GKBondGroup
            if name == group.name {
                managedObjectContext!.deleteObject(group)
                return true
            }
        }
        return false
    }
}

extension GKManagedBond {
	/**
	* addGroupSetObject
	* Adds the Group to the groupSet for the Bond.
	* @param        value: GKBondGroup
	*/
	func addGroupSetObject(value: GKBondGroup) {
		let nodes: NSMutableSet = groupSet as NSMutableSet
		nodes.addObject(value)
	}
	
	/**
	* removeGroupSetObject
	* Removes the Group to the groupSet for the Bond.
	* @param        value: GKBondGroup
	*/
	func removeGroupSetObject(value: GKBondGroup) {
		let nodes: NSMutableSet = groupSet as NSMutableSet
		nodes.removeObject(value)
	}
}
