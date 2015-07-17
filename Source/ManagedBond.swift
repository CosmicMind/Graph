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

@objc(ManagedBond)
internal class ManagedBond : NSManagedObject {
	@NSManaged internal var nodeClass: String
	@NSManaged internal var type: String
	@NSManaged internal var createdDate: NSDate
	@NSManaged internal var propertySet: NSSet
	@NSManaged internal var groupSet: NSSet
	@NSManaged internal var subject: ManagedEntity?
    @NSManaged internal var object: ManagedEntity?

	private var context: NSManagedObjectContext?
	internal var worker: NSManagedObjectContext? {
		if nil == context {
			let graph: Graph = Graph()
			context = graph.worker
		}
		return context
	}

	/**
		:name:	init
		:description:	Initializes the Model Object with e a given type.
	*/
	convenience internal init(type: String!) {
		let g: Graph = Graph()
		var w: NSManagedObjectContext? = g.worker
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.bondDescriptionName, inManagedObjectContext: w!)!, insertIntoManagedObjectContext: w)
		nodeClass = "3"
        self.type = type
		createdDate = NSDate()
		propertySet = NSSet()
		groupSet = NSSet()
		subject = nil
		object = nil
		context = w
	}

	/**
		:name:	properties
		:description:	Allows for Dictionary style coding, which maps to the internal properties Dictionary.
    */
	internal subscript(name: String) -> AnyObject? {
		get {
			for n in propertySet {
				let property: BondProperty = n as! BondProperty
				if name == property.name {
					return property.value
				}
			}
			return nil
		}
		set(value) {
			if nil == value {
				for n in propertySet {
					let property: BondProperty = n as! BondProperty
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
					let property: BondProperty = n as! BondProperty
					if name == property.name {
						hasProperty = true
						property.value = value!
						break
					}
				}
				if false == hasProperty {
					var property: BondProperty = BondProperty(name: name, value: value)
					property.node = self
				}
			}
		}
	}

    /**
		:name:	addGroup
		:description:	Adds a Group name to the list of Groups if it does not exist.
    */
    internal func addGroup(name: String!) -> Bool {
        if !hasGroup(name) {
			var group: BondGroup = BondGroup(name: name)
            group.node = self
			return true
        }
        return false
    }

    /**
		:name:	hasGroup
		:description:	Checks whether the Node is a part of the Group name passed or not.
    */
    internal func hasGroup(name: String!) -> Bool {
        for n in groupSet {
            let group: BondGroup = n as! BondGroup
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
    internal func removeGroup(name: String!) -> Bool {
        for n in groupSet {
            let group: BondGroup = n as! BondGroup
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
		:name:	delete
		:description:	Marks the Model Object to be deleted from the Graph.
	*/
	internal func delete() {
		worker?.deleteObject(self)
	}
}

extension ManagedBond {

	/**
		:name:	addPropertySetObject
		:description:	Adds the Property to the propertySet for the Bond.
	*/
	func addPropertySetObject(value: BondProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removePropertySetObject
		:description:	Removes the Property to the propertySet for the Bond.
	*/
	func removePropertySetObject(value: BondProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.removeObject(value)
	}

	/**
		:name:	addGroupSetObject
		:description:	Adds the Group to the groupSet for the Bond.
	*/
	func addGroupSetObject(value: BondGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removeGroupSetObject
		:description:	Removes the Group to the groupSet for the Bond.
	*/
	func removeGroupSetObject(value: BondGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.removeObject(value)
	}
}
