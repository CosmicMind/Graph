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
* ManagedEntity
*
* Represents an Entity Model Object in the persistent layer.
*/

import CoreData

@objc(ManagedEntity)
internal class ManagedEntity: NSManagedObject {
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
		get {
			if nil == context {
				let graph: Graph = Graph()
				context = graph.worker
			}
			return context
		}
	}
	
	/**
	* init
	* Initializes the Model Object with e a given type.
	* @param        type: String!
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
	* properties[ ]
	* Allows for Dictionary style coding, which maps to the internal properties Dictionary.
	* @param        name: String!
	* get           Returns the property name value.
	* set           Value for the property name.
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
	* addGroup
	* Adds a Group name to the list of Groups if it does not exist.
	* @param        name: String!
	* @return       Bool of the result, true if added, false otherwise.
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
	* hasGroup
	* Checks whether the Node is a part of the Group name passed or not.
	* @param        name: String!
	* @return       Bool of the result, true if is a part, false otherwise.
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
	* removeGroup
	* Removes a Group name from the list of Groups if it exists.
	* @param        name: String!
	* @return       Bool of the result, true if exists, false otherwise.
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
	* delete
	* Marks the Model Object to be deleted from the Graph.
	*/
	internal func delete() {
		worker?.deleteObject(self)
	}
}

extension ManagedEntity {
	
	/**
	* addActionSubjectSetObject
	* Adds the Action to the actionSubjectSet for the Entity.
	* @param        value: ManagedAction
	*/
	func addActionSubjectSetObject(value: ManagedAction) {
		let nodes: NSMutableSet = actionSubjectSet as! NSMutableSet
		nodes.addObject(value)
	}
	
	/**
	* removeActionSubjectSetObject
	* Removes the Action to the actionSubjectSet for the Entity.
	* @param        value: ManagedAction
	*/
	func removeActionSubjectSetObject(value: ManagedAction) {
		let nodes: NSMutableSet = actionSubjectSet as! NSMutableSet
		nodes.removeObject(value)
	}
	
	/**
	* addActionObjectSetObject
	* Adds the Action to the actionObjectSet for the Entity.
	* @param        value: ManagedAction
	*/
	func addActionObjectSetObject(value: ManagedAction) {
		let nodes: NSMutableSet = actionObjectSet as! NSMutableSet
		nodes.addObject(value)
	}
	
	/**
	* removeActionObjectSetObject
	* Removes the Action to the actionObjectSet for the Entity.
	* @param        value: ManagedAction
	*/
	func removeActionObjectSetObject(value: ManagedAction) {
		let nodes: NSMutableSet = actionObjectSet as! NSMutableSet
		nodes.removeObject(value)
	}
	
	/**
	* addBondSubjectSetObject
	* Adds the Bond to the bondSubjectSet for the Entity.
	* @param        value: ManagedBond
	*/
	func addBondSubjectSetObject(value: ManagedBond) {
		let nodes: NSMutableSet = bondSubjectSet as! NSMutableSet
		nodes.addObject(value)
	}
	
	/**
	* removeBondSubjectSetObject
	* Removes the Bond to the bondSubjectSet for the Entity.
	* @param        value: ManagedBond
	*/
	func removeBondSubjectSetObject(value: ManagedBond) {
		let nodes: NSMutableSet = bondSubjectSet as! NSMutableSet
		nodes.removeObject(value)
	}
	
	/**
	* addBondObjectSetObject
	* Adds the Bond to the bondObjectSet for the Entity.
	* @param        value: ManagedBond
	*/
	func addBondObjectSetObject(value: ManagedBond) {
		let nodes: NSMutableSet = bondObjectSet as! NSMutableSet
		nodes.addObject(value)
	}
	
	/**
	* removeBondObjectSetObject
	* Removes the Bond to the bondObjectSet for the Entity.
	* @param        value: ManagedBond
	*/
	func removeBondObjectSetObject(value: ManagedBond) {
		let nodes: NSMutableSet = bondObjectSet as! NSMutableSet
		nodes.removeObject(value)
	}
	
	/**
	* addPropertySetObject
	* Adds the Property to the propertySet for the Entity.
	* @param        value: EntityProperty
	*/
	func addPropertySetObject(value: EntityProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.addObject(value)
	}
	
	/**
	* removePropertySetObject
	* Removes the Property to the propertySet for the Entity.
	* @param        value: EntityProperty
	*/
	func removePropertySetObject(value: EntityProperty) {
		let nodes: NSMutableSet = propertySet as! NSMutableSet
		nodes.removeObject(value)
	}
	
	/**
	* addGroupSetObject
	* Adds the Group to the groupSet for the Entity.
	* @param        value: EntityGroup
	*/
	func addGroupSetObject(value: EntityGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.addObject(value)
	}
	
	/**
	* removeGroupSetObject
	* Removes the Group to the groupSet for the Entity.
	* @param        value: EntityGroup
	*/
	func removeGroupSetObject(value: EntityGroup) {
		let nodes: NSMutableSet = groupSet as! NSMutableSet
		nodes.removeObject(value)
	}
}