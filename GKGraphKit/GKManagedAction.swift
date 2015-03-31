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
* GKManagedAction
*
* Represents an Action Model Object in the persistent layer.
*/


import CoreData

@objc(GKManagedAction)
internal class GKManagedAction: GKManagedNode {
    @NSManaged internal var subjectSet: NSSet
    @NSManaged internal var objectSet: NSSet

    /**
    * entityDescription
    * Class method returning an NSEntityDescription Object for this Model Object.
    * @return        NSEntityDescription!
    */
    class func entityDescription() -> NSEntityDescription! {
        let graph: GKGraph = GKGraph()
        return NSEntityDescription.entityForName(GKGraphUtility.actionDescriptionName, inManagedObjectContext: graph.managedObjectContext)
    }

    /**
    * init
    * Initializes the Model Object with e a given type.
    * @param        type: String!
    */
    convenience internal init(type: String!) {
        let graph: GKGraph = GKGraph()
        let entitiDescription: NSEntityDescription! = NSEntityDescription.entityForName(GKGraphUtility.actionDescriptionName, inManagedObjectContext: graph.managedObjectContext)
        self.init(entity: entitiDescription, managedObjectContext: graph.managedObjectContext)
        nodeClass = "2"
        self.type = type
        subjectSet = NSSet()
        objectSet = NSSet()
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
                let property: GKActionProperty = node as GKActionProperty
                if name == property.name {
                    return property.value
                }
            }
            return nil
        }
        set(value) {
            for node in propertySet {
                let property: GKActionProperty = node as GKActionProperty
                if name == property.name {
                    if nil == value {
                        graph.managedObjectContext.deleteObject(property)
						mutableSetValueForKey("propertySet").removeObject(property)
                    } else {
                        property.value = value!
                    }
                    return
                }
            }
            if nil != value {
                var property: GKActionProperty = GKActionProperty(name: name, value: value, managedObjectContext: graph.managedObjectContext)
                property.node = self
				mutableSetValueForKey("propertySet").addObject(property)
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
            var group: GKActionGroup = GKActionGroup(name: name, managedObjectContext: graph.managedObjectContext)
            group.node = self
			mutableSetValueForKey("groupSet").addObject(group)
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
            let group: GKActionGroup = node as GKActionGroup
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
            let group: GKActionGroup = node as GKActionGroup
            if name == group.name {
				graph.managedObjectContext.deleteObject(group)
				mutableSetValueForKey("groupSet").removeObject(group)
				return true
            }
        }
        return false
    }

    /**
    * addSubject
    * Adds a GKManagedEntity Model Object to the Subject Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if added, false otherwise.
    */
    internal func addSubject(entity: GKManagedEntity!) -> Bool {
        let nodes = mutableSetValueForKey("subjectSet")
        let count: Int = nodes.count
        nodes.addObject(entity)
        return count != nodes.count
    }

    /**
    * removeSubject
    * Removes a GKManagedEntity Model Object from the Subject Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if removed, false otherwise.
    */
    internal func removeSubject(entity: GKManagedEntity!) -> Bool {
        let nodes = mutableSetValueForKey("subjectSet")
        let count: Int = nodes.count
        nodes.removeObject(entity)
        return count != nodes.count
    }

    /**
    * addObject
    * Adds a GKManagedEntity Model Object to the Object Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if added, false otherwise.
    */
    internal func addObject(entity: GKManagedEntity!) -> Bool {
        let nodes = mutableSetValueForKey("objectSet")
        let count: Int = nodes.count
        nodes.addObject(entity)
        return count != nodes.count
    }

    /**
    * removeObject
    * Removes a GKManagedEntity Model Object from the Object Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if removed, false otherwise.
    */
    internal func removeObject(entity: GKManagedEntity!) -> Bool {
        let nodes = mutableSetValueForKey("objectSet")
        let count: Int = nodes.count
        nodes.removeObject(entity)
        return count != nodes.count
    }
}

extension GKManagedAction {
	/**
	* addPropertySetObject
	* Adds the Property to the propertySet for the Action.
	* @param        value: GKActionProperty
	*/
	func addPropertySetObject(value: GKActionProperty) {
		let nodes: NSMutableSet = propertySet as NSMutableSet
		nodes.addObject(value)
	}
	
	/**
	* removePropertySetObject
	* Removes the Property to the propertySet for the Action.
	* @param        value: GKActionProperty
	*/
	func removePropertySetObject(value: GKActionProperty) {
		let nodes: NSMutableSet = propertySet as NSMutableSet
		nodes.removeObject(value)
	}
	
	/**
	* addGroupSetObject
	* Adds the Group to the groupSet for the Action.
	* @param        value: GKActionGroup
	*/
	func addGroupSetObject(value: GKActionGroup) {
		let nodes: NSMutableSet = groupSet as NSMutableSet
		nodes.addObject(value)
	}
	
	/**
	* removeGroupSetObject
	* Removes the Group to the groupSet for the Action.
	* @param        value: GKActionGroup
	*/
	func removeGroupSetObject(value: GKActionGroup) {
		let nodes: NSMutableSet = groupSet as NSMutableSet
		nodes.removeObject(value)
	}
}
