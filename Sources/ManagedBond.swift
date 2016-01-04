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

@objc(ManagedBond)
internal class ManagedBond : ManagedNode {
	@NSManaged internal var subject: ManagedEntity?
    @NSManaged internal var object: ManagedEntity?

	/**
		:name:	init
		:description:	Initializes the Model Object with e a given type.
	*/
	internal convenience init(type: String!) {
		let g: Graph = Graph()
		let w: NSManagedObjectContext? = g.worker
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.bondDescriptionName, inManagedObjectContext: w!)!, insertIntoManagedObjectContext: w)
		nodeClass = 3
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
				let property: ManagedBondProperty = n as! ManagedBondProperty
				if name == property.name {
					return property.object
				}
			}
			return nil
		}
		set(object) {
			if nil == object {
				for n in propertySet {
					let property: ManagedBondProperty = n as! ManagedBondProperty
					if name == property.name {
						property.delete()
						(propertySet as! NSMutableSet).removeObject(property)
						break
					}
				}
			} else {
				var hasProperty: Bool = false
				for n in propertySet {
					let property: ManagedBondProperty = n as! ManagedBondProperty
					if name == property.name {
						hasProperty = true
						property.object = object!
						break
					}
				}
				if false == hasProperty {
					let property: ManagedBondProperty = ManagedBondProperty(name: name, object: object!)
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
			let group: ManagedBondGroup = ManagedBondGroup(name: name)
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
            let group: ManagedBondGroup = n as! ManagedBondGroup
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
            let group: ManagedBondGroup = n as! ManagedBondGroup
            if name == group.name {
				group.delete()
				(groupSet as! NSMutableSet).removeObject(group)
				return true
            }
        }
        return false
    }
}

extension ManagedBond {

	/**
		:name:	addPropertySetObject
		:description:	Adds the Property to the propertySet for the Bond.
	*/
	func addPropertySetObject(value: ManagedBondProperty) {
		(propertySet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removePropertySetObject
		:description:	Removes the Property to the propertySet for the Bond.
	*/
	func removePropertySetObject(value: ManagedBondProperty) {
		(propertySet as! NSMutableSet).removeObject(value)
	}

	/**
		:name:	addGroupSetObject
		:description:	Adds the Group to the groupSet for the Bond.
	*/
	func addGroupSetObject(value: ManagedBondGroup) {
		(groupSet as! NSMutableSet).addObject(value)
	}

	/**
		:name:	removeGroupSetObject
		:description:	Removes the Group to the groupSet for the Bond.
	*/
	func removeGroupSetObject(value: ManagedBondGroup) {
		(groupSet as! NSMutableSet).removeObject(value)
	}
}
