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
	public func searchForEntity(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<(key: String, value: AnyObject?)>? = nil) -> Array<Entity> {
		var nodes: Array<AnyObject> = Array<AnyObject>()
		var toFilter: Bool = false
		
		if let v: Array<String> = types {
			if let n: Array<AnyObject> = search(GraphUtility.entityDescriptionName, types: v) {
				nodes.appendContentsOf(n)
			}
		}
		
		if let v: Array<String> = groups {
			if let n: Array<AnyObject> = search(GraphUtility.entityGroupDescriptionName, groups: v) {
				toFilter = 0 < nodes.count
				nodes.appendContentsOf(n)
			}
		}
		
		if let v: Array<(key: String, value: AnyObject?)> = properties {
			if let n: Array<AnyObject> = search(GraphUtility.entityPropertyDescriptionName, properties: v) {
				toFilter = 0 < nodes.count
				nodes.appendContentsOf(n)
			}
		}
		
		if toFilter {
			var seen: Dictionary<String, Bool> = Dictionary<String, Bool>()
			for var i: Int = nodes.count - 1; 0 <= i; --i {
				if let v: ManagedEntity = nodes[i] as? ManagedEntity {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Entity(object: v)
						continue
					}
				} else if let v: ManagedEntity = worker!.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedEntity {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Entity(object: v)
						continue
					}
				}
				nodes.removeAtIndex(i)
			}
			return nodes as! Array<Entity>
		} else {
			return nodes.map {
				if let v: ManagedEntity = $0 as? ManagedEntity {
					return Entity(object: v)
				}
				return Entity(object: worker!.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedEntity)
			} as Array<Entity>
		}
	}
	
	/**
	:name:	searchForBond(types: groups: properties)
	*/
	public func searchForBond(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<(key: String, value: AnyObject?)>? = nil) -> Array<Bond> {
		var nodes: Array<AnyObject> = Array<AnyObject>()
		var toFilter: Bool = false
		
		if let v: Array<String> = types {
			if let n: Array<AnyObject> = search(GraphUtility.bondDescriptionName, types: v) {
				nodes.appendContentsOf(n)
			}
		}
		
		if let v: Array<String> = groups {
			if let n: Array<AnyObject> = search(GraphUtility.bondGroupDescriptionName, groups: v) {
				toFilter = 0 < nodes.count
				nodes.appendContentsOf(n)
			}
		}
		
		if let v: Array<(key: String, value: AnyObject?)> = properties {
			if let n: Array<AnyObject> = search(GraphUtility.bondPropertyDescriptionName, properties: v) {
				toFilter = 0 < nodes.count
				nodes.appendContentsOf(n)
			}
		}
		
		if toFilter {
			var seen: Dictionary<String, Bool> = Dictionary<String, Bool>()
			for var i: Int = nodes.count - 1; 0 <= i; --i {
				if let v: ManagedBond = nodes[i] as? ManagedBond {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Bond(object: v)
						continue
					}
				} else if let v: ManagedBond = worker!.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedBond {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Bond(object: v)
						continue
					}
				}
				nodes.removeAtIndex(i)
			}
			return nodes as! Array<Bond>
		} else {
			return nodes.map {
				if let v: ManagedBond = $0 as? ManagedBond {
					return Bond(object: v)
				}
				return Bond(object: worker!.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedBond)
			} as Array<Bond>
		}
	}
	
	/**
	:name:	searchForAction(types: groups: properties)
	*/
	public func searchForAction(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<(key: String, value: AnyObject?)>? = nil) -> Array<Action> {
		var nodes: Array<AnyObject> = Array<AnyObject>()
		var toFilter: Bool = false
		
		if let v: Array<String> = types {
			if let n: Array<AnyObject> = search(GraphUtility.actionDescriptionName, types: v) {
				nodes.appendContentsOf(n)
			}
		}
		
		if let v: Array<String> = groups {
			if let n: Array<AnyObject> = search(GraphUtility.actionGroupDescriptionName, groups: v) {
				toFilter = 0 < nodes.count
				nodes.appendContentsOf(n)
			}
		}
		
		if let v: Array<(key: String, value: AnyObject?)> = properties {
			if let n: Array<AnyObject> = search(GraphUtility.actionPropertyDescriptionName, properties: v) {
				toFilter = 0 < nodes.count
				nodes.appendContentsOf(n)
			}
		}
		
		if toFilter {
			var seen: Dictionary<String, Bool> = Dictionary<String, Bool>()
			for var i: Int = nodes.count - 1; 0 <= i; --i {
				if let v: ManagedAction = nodes[i] as? ManagedAction {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Action(object: v)
						continue
					}
				} else if let v: ManagedAction = worker!.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedAction {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Action(object: v)
						continue
					}
				}
				nodes.removeAtIndex(i)
			}
			return nodes as! Array<Action>
		} else {
			return nodes.map {
				if let v: ManagedAction = $0 as? ManagedAction {
					return Action(object: v)
				}
				return Action(object: worker!.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedAction)
			} as Array<Action>
		}
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
		request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
		
		return try? worker!.executeFetchRequest(request)
	}
	
	internal func search(groupDescriptionName: String, groups: Array<String>) -> Array<AnyObject>? {
		var groupsPredicate: Array<NSPredicate> = Array<NSPredicate>()
		
		for v in groups {
			groupsPredicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
		}
		
		let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(groupDescriptionName, inManagedObjectContext: worker!)!
		let request: NSFetchRequest = NSFetchRequest()
		request.entity = entityDescription
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		request.resultType = .DictionaryResultType
		request.propertiesToFetch = ["node"]
		request.returnsDistinctResults = true
		request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: groupsPredicate)
		request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
		
		return try? worker!.executeFetchRequest(request)
	}
	
	internal func search(propertyDescriptionName: String, properties: Array<(key: String, value: AnyObject?)>) -> Array<AnyObject>? {
		var propertiesPredicate: Array<NSPredicate> = Array<NSPredicate>()
		
		for (k, v) in properties {
			if let x: AnyObject = v {
				if let a: String = x as? String {
					propertiesPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name LIKE[cd] %@", k), NSPredicate(format: "object = %@", a)]))
				} else if let a: NSNumber = x as? NSNumber {
					propertiesPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name LIKE[cd] %@", k), NSPredicate(format: "object = %@", a)]))
				}
			} else {
				propertiesPredicate.append(NSPredicate(format: "name LIKE[cd] %@", k))
			}
		}
		
		let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(propertyDescriptionName, inManagedObjectContext: worker!)!
		let request: NSFetchRequest = NSFetchRequest()
		request.entity = entityDescription
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		request.resultType = .DictionaryResultType
		request.propertiesToFetch = ["node"]
		request.returnsDistinctResults = true
		request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: propertiesPredicate)
		request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
		
		return try? worker!.executeFetchRequest(request)
	}
}
