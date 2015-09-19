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

import CoreData

public extension Graph {
	/**
		:name:	search(entity: group: property)
	*/
	public func search(entity types: String..., group names: Array<String>? = nil, property pairs: Array<(key: String, value: AnyObject?)>? = nil) -> OrderedSet<Entity> {
		return search(entity: types, group: names, property: pairs, false)
	}
	
	/**
		:name:	search(entity: group: property)
	*/
	public func search(entity types: Array<String>, group names: Array<String>? = nil, property pairs: Array<(key: String, value: AnyObject?)>? = nil, _: Bool = false) -> OrderedSet<Entity> {
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		
		// types
		for i in types {
			nodes += search(Entity: i)
		}
		
		// groups
		if let n: Array<String> = names {
			for i in n {
				nodes.intersectInPlace(search(EntityGroup: i))
			}
		}
		
		// properties
		if let n: Array<(key: String, value: AnyObject?)> = pairs {
			for i in n {
				if let v: AnyObject = i.value {
					if let a: String = v as? String {
						nodes.intersectInPlace(search(EntityProperty: i.key, value: a as String))
					} else if let a: Int = v as? Int {
						nodes.intersectInPlace(search(EntityProperty: i.key, value: a as Int))
					}
				} else {
					nodes.intersectInPlace(search(EntityProperty: i.key))
				}
			}
		}
		return nodes
	}
	
	/**
		:name:	search(action: group: property)
	*/
	public func search(action types: String..., group names: Array<String>? = nil, property pairs: Array<(key: String, value: AnyObject?)>? = nil) -> OrderedSet<Action> {
		return search(action: types, group: names, property: pairs, false)
	}
	
	/**
		:name:	search(action: group: property)
	*/
	public func search(action types: Array<String>, group names: Array<String>? = nil, property pairs: Array<(key: String, value: AnyObject?)>? = nil, _: Bool = false) -> OrderedSet<Action> {
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		
		// types
		for i in types {
			nodes += search(Action: i)
		}
		
		// groups
		if let n: Array<String> = names {
			for i in n {
				nodes.intersectInPlace(search(ActionGroup: i))
			}
		}
		
		// properties
		if let n: Array<(key: String, value: AnyObject?)> = pairs {
			for i in n {
				if let v: AnyObject = i.value {
					if let a: String = v as? String {
						nodes.intersectInPlace(search(ActionProperty: i.key, value: a as String))
					} else if let a: Int = v as? Int {
						nodes.intersectInPlace(search(ActionProperty: i.key, value: a as Int))
					}
				} else {
					nodes.intersectInPlace(search(ActionProperty: i.key))
				}
			}
		}
		return nodes
	}
	
	/**
		:name:	search(bond: group: property)
	*/
	public func search(bond types: String..., group names: Array<String>? = nil, property pairs: Array<(key: String, value: AnyObject?)>? = nil) -> OrderedSet<Bond> {
		return search(bond: types, group: names, property: pairs, false)
	}
	
	/**
		:name:	search(bond: group: property)
	*/
	public func search(bond types: Array<String>, group names: Array<String>? = nil, property pairs: Array<(key: String, value: AnyObject?)>? = nil, _: Bool = false) -> OrderedSet<Bond> {
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		
		// types
		for i in types {
			nodes += search(Bond: i)
		}
		
		// groups
		if let n: Array<String> = names {
			for i in n {
				nodes.intersectInPlace(search(BondGroup: i))
			}
		}
		
		// properties
		if let n: Array<(key: String, value: AnyObject?)> = pairs {
			for i in n {
				if let v: AnyObject = i.value {
					if let a: String = v as? String {
						nodes.intersectInPlace(search(BondProperty: i.key, value: a as String))
					} else if let a: Int = v as? Int {
						nodes.intersectInPlace(search(BondProperty: i.key, value: a as Int))
					}
				} else {
					nodes.intersectInPlace(search(BondProperty: i.key))
				}
			}
		}
		return nodes
	}
	
	//
	//	:name:	search
	//
	internal func search(entityDescriptorName: NSString, predicate: NSPredicate, sort: Array<NSSortDescriptor>? = nil) -> Array<AnyObject> {
		let request: NSFetchRequest = NSFetchRequest()
		let entity: NSEntityDescription = managedObjectModel!.entitiesByName[entityDescriptorName as String]!
		request.entity = entity
		request.predicate = predicate
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		request.sortDescriptors = sort
		
		var nodes: Array<AnyObject> = Array<AnyObject>()
		
		let moc: NSManagedObjectContext? = worker
		do {
			let result: Array<AnyObject> = try moc!.executeFetchRequest(request)
			for item: AnyObject in result {
				nodes.append(item)
			}
		} catch _ {
			fatalError("[GraphKit Error: Cannot search NSManagedContext.]")
		}
		return nodes
	}
	
	//
	//	:name:	search(Entity)
	//
	internal func search(Entity type: String) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type), sort: [NSSortDescriptor(key: "createdDate", ascending: false)])
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for entity: ManagedEntity in entries as! Array<ManagedEntity> {
			nodes.insert(Entity(entity: entity))
		}
		return nodes
	}
	
	//
	//	:name:	search(EntityGroup)
	//
	internal func search(EntityGroup name: String) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name))
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for group: ManagedEntityGroup in entries as! Array<ManagedEntityGroup> {
			nodes.insert(Entity(entity: group.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(EntityProperty)
	//
	internal func search(EntityProperty name: String) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name))
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for property: ManagedEntityProperty in entries as! Array<ManagedEntityProperty> {
			nodes.insert(Entity(entity: property.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(EntityProperty)
	//
	internal func search(EntityProperty name: String, value: String) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name, value))
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for property: ManagedEntityProperty in entries as! Array<ManagedEntityProperty> {
			nodes.insert(Entity(entity: property.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(EntityProperty)
	//
	internal func search(EntityProperty name: String, value: Int) -> OrderedSet<Entity> {
		let entries: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name, value as NSNumber))
		let nodes: OrderedSet<Entity> = OrderedSet<Entity>()
		for property: ManagedEntityProperty in entries as! Array<ManagedEntityProperty> {
			nodes.insert(Entity(entity: property.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(Action)
	//
	internal func search(Action type: String) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type), sort: [NSSortDescriptor(key: "createdDate", ascending: false)])
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for action: ManagedAction in entries as! Array<ManagedAction> {
			nodes.insert(Action(action: action))
		}
		return nodes
	}
	
	//
	//	:name:	search(ActionGroup)
	//
	internal func search(ActionGroup name: String) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name))
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for group: ManagedActionGroup in entries as! Array<ManagedActionGroup> {
			nodes.insert(Action(action: group.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(ActionProperty)
	//
	internal func search(ActionProperty name: String) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name))
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for property: ManagedActionProperty in entries as! Array<ManagedActionProperty> {
			nodes.insert(Action(action: property.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(ActionProperty)
	//
	internal func search(ActionProperty name: String, value: String) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name, value))
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for property: ManagedActionProperty in entries as! Array<ManagedActionProperty> {
			nodes.insert(Action(action: property.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(ActionProperty)
	//
	internal func search(ActionProperty name: String, value: Int) -> OrderedSet<Action> {
		let entries: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name, value as NSNumber))
		let nodes: OrderedSet<Action> = OrderedSet<Action>()
		for property: ManagedActionProperty in entries as! Array<ManagedActionProperty> {
			nodes.insert(Action(action: property.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(Bond)
	//
	internal func search(Bond type: String) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondDescriptionName, predicate: NSPredicate(format: "type LIKE %@", type), sort: [NSSortDescriptor(key: "createdDate", ascending: false)])
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for bond: ManagedBond in entries as! Array<ManagedBond> {
			nodes.insert(Bond(bond: bond))
		}
		return nodes
	}
	
	//
	//	:name:	search(BondGroup)
	//
	internal func search(BondGroup name: String) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondGroupDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name))
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for group: ManagedBondGroup in entries as! Array<ManagedBondGroup> {
			nodes.insert(Bond(bond: group.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(BondProperty)
	//
	internal func search(BondProperty name: String) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "name LIKE %@", name))
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for property: ManagedBondProperty in entries as! Array<ManagedBondProperty> {
			nodes.insert(Bond(bond: property.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(BondProperty)
	//
	internal func search(BondProperty name: String, value: String) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name, value))
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for property: ManagedBondProperty in entries as! Array<ManagedBondProperty> {
			nodes.insert(Bond(bond: property.node))
		}
		return nodes
	}
	
	//
	//	:name:	search(BondProperty)
	//
	internal func search(BondProperty name: String, value: Int) -> OrderedSet<Bond> {
		let entries: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, predicate: NSPredicate(format: "(name == %@) AND (object == %@)", name, value as NSNumber))
		let nodes: OrderedSet<Bond> = OrderedSet<Bond>()
		for property: ManagedBondProperty in entries as! Array<ManagedBondProperty> {
			nodes.insert(Bond(bond: property.node))
		}
		return nodes
	}
}
