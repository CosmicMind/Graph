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
internal class GKManagedAction: NSManagedObject {
	@NSManaged internal var nodeClass: String
	@NSManaged internal var type: String
	@NSManaged internal var createdDate: NSDate
	@NSManaged internal var propertySet: NSMutableSet
	@NSManaged internal var groupSet: NSMutableSet
	@NSManaged internal var subjectSet: NSMutableSet
    @NSManaged internal var objectSet: NSMutableSet

	private var worker: NSManagedObjectContext?
	
	/**
	* init
	* Initializes the Model Object with e a given type.
	* @param        type: String!
	*/
	convenience internal init(type: String!) {
		let g: GKGraph = GKGraph()
		let w: NSManagedObjectContext = g.worker()
		self.init(entity: NSEntityDescription.entityForName(GKGraphUtility.actionDescriptionName, inManagedObjectContext: w)!, insertIntoManagedObjectContext: w)
		nodeClass = "2"
        self.type = type
		createdDate = NSDate()
		propertySet = NSMutableSet()
		groupSet = NSMutableSet()
        subjectSet = NSMutableSet()
        objectSet = NSMutableSet()
		worker = w
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
                let property: GKActionProperty = n as GKActionProperty
                if name == property.name {
                    return property.value
                }
            }
            return nil
        }
        set(value) {
            for n in propertySet {
                let property: GKActionProperty = n as GKActionProperty
                if name == property.name {
                    if nil == value {
						propertySet.removeObject(property)
                    } else {
                        property.value = value!
                    }
                    return
                }
            }
            if nil != value {
                var property: GKActionProperty = GKActionProperty(name: name, value: value, managedObjectContext: worker!)
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
			var group: GKActionGroup = GKActionGroup(name: name, managedObjectContext: worker!)
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
            let group: GKActionGroup = n as GKActionGroup
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
            let group: GKActionGroup = n as GKActionGroup
            if name == group.name {
				groupSet.removeObject(group)
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
        let count: Int = subjectSet.count
        subjectSet.addObject(entity)
		entity.actionSubjectSet.addObject(self)
		return count != subjectSet.count
    }

    /**
    * removeSubject
    * Removes a GKManagedEntity Model Object from the Subject Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if removed, false otherwise.
    */
    internal func removeSubject(entity: GKManagedEntity!) -> Bool {
        let count: Int = subjectSet.count
		subjectSet.removeObject(entity)
		entity.actionSubjectSet.removeObject(self)
		return count != subjectSet.count
    }

    /**
    * addObject
    * Adds a GKManagedEntity Model Object to the Object Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if added, false otherwise.
    */
    internal func addObject(entity: GKManagedEntity!) -> Bool {
        let count: Int = objectSet.count
		objectSet.addObject(entity)
		entity.actionObjectSet.addObject(self)
		return count != objectSet.count
    }

    /**
    * removeObject
    * Removes a GKManagedEntity Model Object from the Object Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if removed, false otherwise.
    */
    internal func removeObject(entity: GKManagedEntity!) -> Bool {
        let count: Int = objectSet.count
		objectSet.removeObject(entity)
		entity.actionObjectSet.removeObject(self)
		return count != objectSet.count
    }
	
	/**
	* delete
	* Marks the Model Object to be deleted from the Graph.
	*/
	internal func delete() {
		worker!.deleteObject(self)
	}
}
