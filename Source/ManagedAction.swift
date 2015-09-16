//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

// #internal

import CoreData

@objc(ManagedAction)
internal class ManagedAction : ManagedNode {
	@NSManaged internal var subjectSet: NSSet
    @NSManaged internal var objectSet: NSSet

	/**
		:name:	init
		:description:	Initializes the Model Object with e a given type.
	*/
	internal convenience init(type: String!) {
		let g: Graph = Graph()
		let w: NSManagedObjectContext? = g.worker
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.actionDescriptionName, inManagedObjectContext: w!)!, insertIntoManagedObjectContext: w)
		nodeClass = 2
        self.type = type
		createdDate = NSDate()
		propertySet = NSSet()
		groupSet = NSSet()
        subjectSet = NSSet()
        objectSet = NSSet()
		context = w
    }

	/**
		:name:	properties
		:description:	Allows for Dictionary style coding, which maps to the internal properties Dictionary.
    */
	internal subscript(name: String) -> AnyObject? {
		get {
			for n in propertySet {
				let property: ManagedActionProperty = n as! ManagedActionProperty
				if name == property.name {
					return property.object
				}
			}
			return nil
		}
		set(object) {
			if nil == object {
				for n in propertySet {
					let property: ManagedActionProperty = n as! ManagedActionProperty
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
					let property: ManagedActionProperty = n as! ManagedActionProperty
					if name == property.name {
						hasProperty = true
						property.object = object!
						break
					}
				}
				if false == hasProperty {
					let property: ManagedActionProperty = ManagedActionProperty(name: name, object: object!)
					property.node = self
				}
			}
		}
	}

    /**
		:name:	addGroup
		:description:	Adds a Group name to the list of Groups if it does not exist.
    */
    internal func addGroup(name: String) -> Bool {
        if !hasGroup(name) {
			let group: ManagedActionGroup = ManagedActionGroup(name: name)
            group.node = self
            return true
        }
        return false
    }

    /**
		:name:	hasGroup
		:description:	Checks whether the Node is a part of the Group name passed or not.
    */
    internal func hasGroup(name: String) -> Bool {
        for n in groupSet {
            let group: ManagedActionGroup = n as! ManagedActionGroup
            if name == group.name {
                return true
            }
        }
        return false
    }

    /**
		:name:	removeGroup
		:description:	Removes a Group name from the list of Groups if it exists.
    */
    internal func removeGroup(name: String) -> Bool {
        for n in groupSet {
            let group: ManagedActionGroup = n as! ManagedActionGroup
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
		:name:	addSubject
		:description:	Adds a ManagedEntity Model Object to the Subject Set.
    */
    internal func addSubject(entity: ManagedEntity) -> Bool {
        let count: Int = subjectSet.count
		mutableSetValueForKey("subjectSet").addObject(entity)
		return count != subjectSet.count
    }

    /**
		:name:	removeSubject
		:description:	Removes a ManagedEntity Model Object from the Subject Set.
    */
    internal func removeSubject(entity: ManagedEntity) -> Bool {
        let count: Int = subjectSet.count
		mutableSetValueForKey("subjectSet").removeObject(entity)
		return count != subjectSet.count
    }

    /**
		:name:	addObject
		:description:	Adds a ManagedEntity Model Object to the Object Set.
    */
    internal func addObject(entity: ManagedEntity) -> Bool {
        let count: Int = objectSet.count
		mutableSetValueForKey("objectSet").addObject(entity)
		return count != objectSet.count
    }

    /**
		:name:	removeObject
		:description:	Removes a ManagedEntity Model Object from the Object Set.
    */
    internal func removeObject(entity: ManagedEntity) -> Bool {
        let count: Int = objectSet.count
		mutableSetValueForKey("objectSet").removeObject(entity)
		return count != objectSet.count
    }
}

extension ManagedAction {

	/**
		:name:	addPropertySetObject
		:description:	Adds the Property to the propertySet for the Action.
	*/
	func addPropertySetObject(value: ManagedActionProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removePropertySetObject
		:description:	Removes the Property to the propertySet for the Action.
	*/
	func removePropertySetObject(value: ManagedActionProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.removeObject(value)
	}

	/**
		:name:	addGroupSetObject
		:description:	Adds the Group to the groupSet for the Action.
	*/
	func addGroupSetObject(value: ManagedActionGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removeGroupSetObject
		:description:	Removes the Group to the groupSet for the Action.
	*/
	func removeGroupSetObject(value: ManagedActionGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.removeObject(value)
	}
}
