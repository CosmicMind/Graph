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

@objc(ManagedEntity)
internal class ManagedEntity : NSManagedObject {
	@NSManaged internal var nodeClass: String
	@NSManaged internal var type: String
	@NSManaged internal var createdDate: NSDate
	@NSManaged internal var propertySet: NSSet
	@NSManaged internal var groupSet: NSSet
	@NSManaged internal var actionSubjectSet: NSSet
	@NSManaged internal var actionObjectSet: NSSet
	@NSManaged internal var bondSubjectSet: NSSet
	@NSManaged internal var bondObjectSet: NSSet

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
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.entityDescriptionName, inManagedObjectContext: w!)!, insertIntoManagedObjectContext: w)
		nodeClass = "1"
		self.type = type
		createdDate = NSDate()
		propertySet = NSSet()
		groupSet = NSSet()
		actionSubjectSet = NSSet()
		actionObjectSet = NSSet()
		bondSubjectSet = NSSet()
		bondObjectSet = NSSet()
		context = w
	}

	/**
		:name:	properties
		:description:	Allows for Dictionary style coding, which maps to the internal properties Dictionary.
	*/
	internal subscript(name: String) -> AnyObject? {
		get {
			for n in propertySet {
				let property: EntityProperty = n as! EntityProperty
				if name == property.name {
					return property.value
				}
			}
			return nil
		}
		set(value) {
			if nil == value {
				for n in propertySet {
					let property: EntityProperty = n as! EntityProperty
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
					let property: EntityProperty = n as! EntityProperty
					if name == property.name {
						hasProperty = true
						property.value = value!
						break
					}
				}
				if false == hasProperty {
					var property: EntityProperty = EntityProperty(name: name, value: value)
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
			var group: EntityGroup = EntityGroup(name: name)
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
			var group: EntityGroup = n as! EntityGroup
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
			let group: EntityGroup = n as! EntityGroup
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

extension ManagedEntity {

	/**
		:name:	addActionSubjectSetObject
		:description:	Adds the Action to the actionSubjectSet for the Entity.
	*/
	func addActionSubjectSetObject(value: ManagedAction) {
		let nodes: NSMutableSet = actionSubjectSet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removeActionSubjectSetObject
		:description:	Removes the Action to the actionSubjectSet for the Entity.
	*/
	func removeActionSubjectSetObject(value: ManagedAction) {
		let nodes: NSMutableSet = actionSubjectSet as! NSMutableSet
		nodes.removeObject(value)
	}

	/**
		:name:	addActionObjectSetObject
		:description:	Adds the Action to the actionObjectSet for the Entity.
	*/
	func addActionObjectSetObject(value: ManagedAction) {
		let nodes: NSMutableSet = actionObjectSet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removeActionObjectSetObject
		:description:	Removes the Action to the actionObjectSet for the Entity.
	*/
	func removeActionObjectSetObject(value: ManagedAction) {
		let nodes: NSMutableSet = actionObjectSet as! NSMutableSet
		nodes.removeObject(value)
	}

	/**
		:name:	addBondSubjectSetObject
		:description:	Adds the Bond to the bondSubjectSet for the Entity.
	*/
	func addBondSubjectSetObject(value: ManagedBond) {
		let nodes: NSMutableSet = bondSubjectSet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removeBondSubjectSetObject
		:description:	Removes the Bond to the bondSubjectSet for the Entity.
	*/
	func removeBondSubjectSetObject(value: ManagedBond) {
		let nodes: NSMutableSet = bondSubjectSet as! NSMutableSet
		nodes.removeObject(value)
	}

	/**
		:name:	addBondObjectSetObject
		:description:	Adds the Bond to the bondObjectSet for the Entity.
	*/
	func addBondObjectSetObject(value: ManagedBond) {
		let nodes: NSMutableSet = bondObjectSet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removeBondObjectSetObject
		:description:	Removes the Bond to the bondObjectSet for the Entity.
	*/
	func removeBondObjectSetObject(value: ManagedBond) {
		let nodes: NSMutableSet = bondObjectSet as! NSMutableSet
		nodes.removeObject(value)
	}

	/**
		:name:	addPropertySetObject
		:description:	Adds the Property to the propertySet for the Entity.
	*/
	func addPropertySetObject(value: EntityProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removePropertySetObject
		:description:	Removes the Property to the propertySet for the Entity.
	*/
	func removePropertySetObject(value: EntityProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.removeObject(value)
	}

	/**
		:name:	addGroupSetObject
		:description:	Adds the Group to the groupSet for the Entity.
	*/
	func addGroupSetObject(value: EntityGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.addObject(value)
	}

	/**
		:name:	removeGroupSetObject
		:description:	Removes the Group to the groupSet for the Entity.
	*/
	func removeGroupSetObject(value: EntityGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.removeObject(value)
	}
}
