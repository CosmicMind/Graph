//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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

@objc(ManagedEntity)
internal class ManagedEntity : ManagedNode {
	@NSManaged internal var actionSubjectSet: NSSet
	@NSManaged internal var actionObjectSet: NSSet
	@NSManaged internal var bondSubjectSet: NSSet
	@NSManaged internal var bondObjectSet: NSSet

	/**
		:name:	init
		:description:	Initializes the Model Object with e a given type.
	*/
	internal convenience init(type: String!) {
		let g: Graph = Graph()
		let w: NSManagedObjectContext? = g.worker
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.entityDescriptionName, inManagedObjectContext: w!)!, insertIntoManagedObjectContext: w)
		nodeClass = 1
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
				let property: ManagedEntityProperty = n as! ManagedEntityProperty
				if name == property.name {
					return property.object
				}
			}
			return nil
		}
		set(object) {
			if nil == object {
				for n in propertySet {
					let property: ManagedEntityProperty = n as! ManagedEntityProperty
					if name == property.name {
						property.delete()
						(propertySet as! NSMutableSet).removeObject(property)
						break
					}
				}
			} else {
				var hasProperty: Bool = false
				for n in propertySet {
					let property: ManagedEntityProperty = n as! ManagedEntityProperty
					if name == property.name {
						hasProperty = true
						property.object = object!
						break
					}
				}
				if false == hasProperty {
					let property: ManagedEntityProperty = ManagedEntityProperty(name: name, object: object!)
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
			let group: ManagedEntityGroup = ManagedEntityGroup(name: name)
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
			let group: ManagedEntityGroup = n as! ManagedEntityGroup
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
			let group: ManagedEntityGroup = n as! ManagedEntityGroup
			if name == group.name {
				group.delete()
				(groupSet as! NSMutableSet).removeObject(group)
				return true
			}
		}
		return false
	}
}

extension ManagedEntity {

	/**
		:name:	addActionSubjectSetObject
		:description:	Adds the Action to the actionSubjectSet for the Entity.
	*/
	func addActionSubjectSetObject(value: ManagedAction) {
		(actionSubjectSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeActionSubjectSetObject
		:description:	Removes the Action to the actionSubjectSet for the Entity.
	*/
	func removeActionSubjectSetObject(value: ManagedAction) {
		(actionSubjectSet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addActionObjectSetObject
		:description:	Adds the Action to the actionObjectSet for the Entity.
	*/
	func addActionObjectSetObject(value: ManagedAction) {
		(actionObjectSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeActionObjectSetObject
		:description:	Removes the Action to the actionObjectSet for the Entity.
	*/
	func removeActionObjectSetObject(value: ManagedAction) {
		(actionObjectSet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addBondSubjectSetObject
		:description:	Adds the Bond to the bondSubjectSet for the Entity.
	*/
	func addBondSubjectSetObject(value: ManagedBond) {
		(bondSubjectSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeBondSubjectSetObject
		:description:	Removes the Bond to the bondSubjectSet for the Entity.
	*/
	func removeBondSubjectSetObject(value: ManagedBond) {
		(bondSubjectSet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addBondObjectSetObject
		:description:	Adds the Bond to the bondObjectSet for the Entity.
	*/
	func addBondObjectSetObject(value: ManagedBond) {
		(bondObjectSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeBondObjectSetObject
		:description:	Removes the Bond to the bondObjectSet for the Entity.
	*/
	func removeBondObjectSetObject(value: ManagedBond) {
		(bondObjectSet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addPropertySetObject
		:description:	Adds the Property to the propertySet for the Entity.
	*/
	func addPropertySetObject(value: ManagedEntityProperty) {
		(propertySet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removePropertySetObject
		:description:	Removes the Property to the propertySet for the Entity.
	*/
	func removePropertySetObject(value: ManagedEntityProperty) {
		(propertySet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addGroupSetObject
		:description:	Adds the Group to the groupSet for the Entity.
	*/
	func addGroupSetObject(value: ManagedEntityGroup) {
		(groupSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeGroupSetObject
		:description:	Removes the Group to the groupSet for the Entity.
	*/
	func removeGroupSetObject(value: ManagedEntityGroup) {
		(groupSet as! NSMutableSet).removeObject(value)
	}
}
