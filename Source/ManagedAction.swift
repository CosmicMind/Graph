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
*/

import CoreData

@objc(ManagedAction)
internal class ManagedAction : NSManagedObject {
	@NSManaged internal var nodeClass: String
	@NSManaged internal var type: String
	@NSManaged internal var createdDate: NSDate
	@NSManaged internal var propertySet: NSSet
	@NSManaged internal var groupSet: NSSet
	@NSManaged internal var subjectSet: NSSet
    @NSManaged internal var objectSet: NSSet

	private var context: NSManagedObjectContext?
	internal var worker: NSManagedObjectContext? {
		if nil == context {
			let graph: Graph = Graph()
			context = graph.worker
		}
		return context
	}

	/**
		init
		Initializes the Model Object with e a given type.
	*/
	convenience internal init(type: String!) {
		let g: Graph = Graph()
		var w: NSManagedObjectContext? = g.worker
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.actionDescriptionName, inManagedObjectContext: w!)!, insertIntoManagedObjectContext: w)
		nodeClass = "2"
        self.type = type
		createdDate = NSDate()
		propertySet = NSSet()
		groupSet = NSSet()
        subjectSet = NSSet()
        objectSet = NSSet()
		context = w
    }

	/**
		properties
		Allows for Dictionary style coding, which maps to the internal properties Dictionary.
    */
	internal subscript(name: String) -> AnyObject? {
		get {
			for n in propertySet {
				let property: ActionProperty = n as! ActionProperty
				if name == property.name {
					return property.value
				}
			}
			return nil
		}
		set(value) {
			if nil == value {
				for n in propertySet {
					let property: ActionProperty = n as! ActionProperty
					if name == property.name {
						property.delete()
						let set: NSMutableSet = propertySet as! NSMutableSet
						set.removeObject(property)
						break
					}
				}
			} else {
				var hasProperty: Bool = false
				for n in propertySet {
					let property: ActionProperty = n as! ActionProperty
					if name == property.name {
						hasProperty = true
						property.value = value!
						break
					}
				}
				if false == hasProperty {
					var property: ActionProperty = ActionProperty(name: name, value: value)
					property.node = self
				}
			}
		}
	}

    /**
		addGroup
		Adds a Group name to the list of Groups if it does not exist.
    */
    internal func addGroup(name: String!) -> Bool {
        if !hasGroup(name) {
			var group: ActionGroup = ActionGroup(name: name)
            group.node = self
            return true
        }
        return false
    }

    /**
		hasGroup
		Checks whether the Node is a part of the Group name passed or not.
    */
    internal func hasGroup(name: String!) -> Bool {
        for n in groupSet {
            let group: ActionGroup = n as! ActionGroup
            if name == group.name {
                return true
            }
        }
        return false
    }

    /**
		removeGroup
		Removes a Group name from the list of Groups if it exists.
    */
    internal func removeGroup(name: String!) -> Bool {
        for n in groupSet {
            let group: ActionGroup = n as! ActionGroup
            if name == group.name {
				group.delete()
				let set: NSMutableSet = groupSet as! NSMutableSet
				set.removeObject(group)
				return true
            }
        }
        return false
    }

    /**
		addSubject
		Adds a ManagedEntity Model Object to the Subject Set.
    */
    internal func addSubject(entity: ManagedEntity!) -> Bool {
        let count: Int = subjectSet.count
		mutableSetValueForKey("subjectSet").addObject(entity)
		return count != subjectSet.count
    }

    /**
		removeSubject
		Removes a ManagedEntity Model Object from the Subject Set.
    */
    internal func removeSubject(entity: ManagedEntity!) -> Bool {
        let count: Int = subjectSet.count
		mutableSetValueForKey("subjectSet").removeObject(entity)
		return count != subjectSet.count
    }

    /**
		addObject
		Adds a ManagedEntity Model Object to the Object Set.
    */
    internal func addObject(entity: ManagedEntity!) -> Bool {
        let count: Int = objectSet.count
		mutableSetValueForKey("objectSet").addObject(entity)
		return count != objectSet.count
    }

    /**
		removeObject
		Removes a ManagedEntity Model Object from the Object Set.
    */
    internal func removeObject(entity: ManagedEntity!) -> Bool {
        let count: Int = objectSet.count
		mutableSetValueForKey("objectSet").removeObject(entity)
		return count != objectSet.count
    }

	/**
		delete
		Marks the Model Object to be deleted from the Graph.
	*/
	internal func delete() {
		worker?.deleteObject(self)
	}
}

extension ManagedAction {

	/**
		addPropertySetObject
		Adds the Property to the propertySet for the Action.
	*/
	func addPropertySetObject(value: ActionProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		removePropertySetObject
		Removes the Property to the propertySet for the Action.
	*/
	func removePropertySetObject(value: ActionProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.removeObject(value)
	}

	/**
		addGroupSetObject
		Adds the Group to the groupSet for the Action.
	*/
	func addGroupSetObject(value: ActionGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		removeGroupSetObject
		Removes the Group to the groupSet for the Action.
	*/
	func removeGroupSetObject(value: ActionGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.removeObject(value)
	}
}
