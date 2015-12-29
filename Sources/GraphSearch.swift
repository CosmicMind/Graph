//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>.
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
	:name:	searchForEntity(types: groups: properties)
	*/
	public func searchForEntity(types types: Array<String>, groups: Array<String>? = nil, properties: Array<(key: String, value: AnyObject?)>? = nil) -> SortedSet<Entity> {
		let nodes: SortedSet<Entity> = SortedSet<Entity>()
		
		var groupNodes: Array<AnyObject>?
		var propertyNodes: Array<AnyObject>?
		
		if let v: Array<String> = groups {
			groupNodes = search(GraphUtility.entityDescriptionName, types: types, groupDescriptionName: GraphUtility.entityGroupDescriptionName, groups: v)
		}
		
		if let v: Array<(key: String, value: AnyObject?)> = properties {
			propertyNodes = search(GraphUtility.entityDescriptionName, types: types, propertyDescriptionName: GraphUtility.entityPropertyDescriptionName, properties: v)
		}
		
		if nil != groupNodes && nil != propertyNodes {
			if groupNodes!.count < propertyNodes!.count {
				for v in propertyNodes! {
					nodes.insert(Entity(entity: (v as! ManagedEntityProperty).node as ManagedEntity))
				}
				for v in groupNodes! {
					let n: Entity = Entity(entity: (v as! ManagedEntityGroup).node as ManagedEntity)
					if !nodes.contains(n) {
						nodes.remove(n)
					}
				}
			} else {
				for v in groupNodes! {
					nodes.insert(Entity(entity: (v as! ManagedEntityGroup).node as ManagedEntity))
				}
				for v in propertyNodes! {
					let n: Entity = Entity(entity: (v as! ManagedEntityProperty).node as ManagedEntity)
					if !nodes.contains(n) {
						nodes.remove(n)
					}
				}
			}
		} else if let v: Array<AnyObject> = groupNodes {
			for n in v {
				nodes.insert(Entity(entity: (n as! ManagedEntityGroup).node as ManagedEntity))
			}
		} else if let v: Array<AnyObject> = propertyNodes {
			for n in v {
				nodes.insert(Entity(entity: (n as! ManagedEntityProperty).node as ManagedEntity))
			}
		} else {
			for v in search(GraphUtility.entityDescriptionName, types: types)! {
				nodes.insert(Entity(entity: v as! ManagedEntity))
			}
		}
		
		return nodes
	}
	
	/**
	:name:	searchForAction(types: groups: properties)
	*/
	public func searchForAction(types types: Array<String>, groups: Array<String>? = nil, properties: Array<(key: String, value: AnyObject?)>? = nil) -> SortedSet<Action> {
		let nodes: SortedSet<Action> = SortedSet<Action>()
		
		var groupNodes: Array<AnyObject>?
		var propertyNodes: Array<AnyObject>?
		
		if let v: Array<String> = groups {
			groupNodes = search(GraphUtility.actionDescriptionName, types: types, groupDescriptionName: GraphUtility.actionGroupDescriptionName, groups: v)
		}
		
		if let v: Array<(key: String, value: AnyObject?)> = properties {
			propertyNodes = search(GraphUtility.actionDescriptionName, types: types, propertyDescriptionName: GraphUtility.actionPropertyDescriptionName, properties: v)
		}
		
		if nil != groupNodes && nil != propertyNodes {
			if groupNodes!.count < propertyNodes!.count {
				for v in propertyNodes! {
					nodes.insert(Action(action: (v as! ManagedActionProperty).node as ManagedAction))
				}
				for v in groupNodes! {
					let n: Action = Action(action: (v as! ManagedActionGroup).node as ManagedAction)
					if !nodes.contains(n) {
						nodes.remove(n)
					}
				}
			} else {
				for v in groupNodes! {
					nodes.insert(Action(action: (v as! ManagedActionGroup).node as ManagedAction))
				}
				for v in propertyNodes! {
					let n: Action = Action(action: (v as! ManagedActionProperty).node as ManagedAction)
					if !nodes.contains(n) {
						nodes.remove(n)
					}
				}
			}
		} else if let v: Array<AnyObject> = groupNodes {
			for n in v {
				nodes.insert(Action(action: (n as! ManagedActionGroup).node as ManagedAction))
			}
		} else if let v: Array<AnyObject> = propertyNodes {
			for n in v {
				nodes.insert(Action(action: (n as! ManagedActionProperty).node as ManagedAction))
			}
		} else {
			for v in search(GraphUtility.actionDescriptionName, types: types)! {
				nodes.insert(Action(action: v as! ManagedAction))
			}
		}
		
		return nodes
	}
	
	/**
	:name:	searchForBond(types: groups: properties)
	*/
	public func searchForBond(types types: Array<String>, groups: Array<String>? = nil, properties: Array<(key: String, value: AnyObject?)>? = nil) -> SortedSet<Bond> {
		let nodes: SortedSet<Bond> = SortedSet<Bond>()
		
		var groupNodes: Array<AnyObject>?
		var propertyNodes: Array<AnyObject>?
		
		if let v: Array<String> = groups {
			groupNodes = search(GraphUtility.bondDescriptionName, types: types, groupDescriptionName: GraphUtility.bondGroupDescriptionName, groups: v)
		}
		
		if let v: Array<(key: String, value: AnyObject?)> = properties {
			propertyNodes = search(GraphUtility.bondDescriptionName, types: types, propertyDescriptionName: GraphUtility.bondPropertyDescriptionName, properties: v)
		}
		
		if nil != groupNodes && nil != propertyNodes {
			if groupNodes!.count < propertyNodes!.count {
				for v in propertyNodes! {
					nodes.insert(Bond(bond: (v as! ManagedBondProperty).node as ManagedBond))
				}
				for v in groupNodes! {
					let n: Bond = Bond(bond: (v as! ManagedBondGroup).node as ManagedBond)
					if !nodes.contains(n) {
						nodes.remove(n)
					}
				}
			} else {
				for v in groupNodes! {
					nodes.insert(Bond(bond: (v as! ManagedBondGroup).node as ManagedBond))
				}
				for v in propertyNodes! {
					let n: Bond = Bond(bond: (v as! ManagedBondProperty).node as ManagedBond)
					if !nodes.contains(n) {
						nodes.remove(n)
					}
				}
			}
		} else if let v: Array<AnyObject> = groupNodes {
			for n in v {
				nodes.insert(Bond(bond: (n as! ManagedBondGroup).node as ManagedBond))
			}
		} else if let v: Array<AnyObject> = propertyNodes {
			for n in v {
				nodes.insert(Bond(bond: (n as! ManagedBondProperty).node as ManagedBond))
			}
		} else {
			for v in search(GraphUtility.bondDescriptionName, types: types)! {
				nodes.insert(Bond(bond: v as! ManagedBond))
			}
		}
		
		return nodes
	}
	
	internal func search(typeDescriptionName: String, types: Array<String>) -> Array<AnyObject>? {
		var typesPredicate: Array<NSPredicate> = Array<NSPredicate>()
		for v in types {
			typesPredicate.append(NSPredicate(format: "type LIKE[cd] %@", v))
		}
		
		let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(typeDescriptionName, inManagedObjectContext: worker!)!
		let request: NSFetchRequest = NSFetchRequest()
		request.entity = entityDescription
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: typesPredicate)
		
		return try? worker!.executeFetchRequest(request)
	}
	
	internal func search(typeDescriptionName: String, types: Array<String>, groupDescriptionName: String, groups: Array<String>) -> Array<AnyObject>? {
		let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(groupDescriptionName, inManagedObjectContext: worker!)!
		let request: NSFetchRequest = NSFetchRequest()
		request.entity = entityDescription
		request.relationshipKeyPathsForPrefetching = [typeDescriptionName]
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		
		var typesPredicate: Array<NSPredicate> = Array<NSPredicate>()
		for v in types {
			typesPredicate.append(NSPredicate(format: "node.type LIKE[cd] %@", v))
		}
		
		var groupsPredicate: Array<NSPredicate> = Array<NSPredicate>()
		for v in groups {
			groupsPredicate.append(NSPredicate(format: "%@ LIKE[%@] name AND ANY %@ CONTAINS[cd] node.groupSet.name", v, groups))
		}
		
		groupsPredicate.append(NSPredicate(format: "%@ <= node.groupSet.@count", groups.count as NSNumber))
		
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
			NSCompoundPredicate(orPredicateWithSubpredicates: typesPredicate),
			NSCompoundPredicate(andPredicateWithSubpredicates: groupsPredicate)
		])
		print(request.predicate)
			
		return try? worker!.executeFetchRequest(request)
	}
	
	internal func search(typeDescriptionName: String, types: Array<String>, propertyDescriptionName: String, properties: Array<(key: String, value: AnyObject?)>) -> Array<AnyObject>? {
		let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(propertyDescriptionName, inManagedObjectContext: worker!)!
		let request: NSFetchRequest = NSFetchRequest()
		request.entity = entityDescription
		request.relationshipKeyPathsForPrefetching = [typeDescriptionName]
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		
		var typesPredicate: Array<NSPredicate> = Array<NSPredicate>()
		for v in types {
			typesPredicate.append(NSPredicate(format: "node.type LIKE[cd] %@", v))
		}
		
		var nodes: Array<AnyObject> = Array<AnyObject>()
		
		if let p: Array<(key: String, value: AnyObject?)> = properties {
			var propertyPredicate: Array<NSPredicate> = Array<NSPredicate>()
			
			for (k, v) in p {
				if let x: AnyObject = v {
					if let a: String = x as? String {
						propertyPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name LIKE[cd] %@", k), NSPredicate(format: "object = %@", a)]))
					} else if let a: NSNumber = x as? NSNumber {
						propertyPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name LIKE[cd] %@", k), NSPredicate(format: "object = %@", a)]))
					}
				} else {
					propertyPredicate.append(NSPredicate(format: "name LIKE[cd] %@", k))
				}
				
				request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
					NSCompoundPredicate(orPredicateWithSubpredicates: typesPredicate),
					NSCompoundPredicate(andPredicateWithSubpredicates: propertyPredicate)
				])
				
				if let n: Array<AnyObject> = try? worker!.executeFetchRequest(request) {
					nodes.appendContentsOf(n)
				}
			}
		}
		
		return nodes
	}
}
