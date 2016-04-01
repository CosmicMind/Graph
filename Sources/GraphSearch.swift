/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Graph nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
			var i: Int = nodes.count - 1
			while 0 <= i {
				if let v: ManagedEntity = nodes[i] as? ManagedEntity {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Entity(object: v)
						i -= 1
						continue
					}
				} else if let v: ManagedEntity = Graph.context!.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedEntity {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Entity(object: v)
						i -= 1
						continue
					}
				}
				nodes.removeAtIndex(i)
				i -= 1
			}
			return nodes as! Array<Entity>
		} else {
			return nodes.map {
				if let v: ManagedEntity = $0 as? ManagedEntity {
					return Entity(object: v)
				}
				return Entity(object: Graph.context!.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedEntity)
			} as Array<Entity>
		}
	}
	
	/**
	:name:	searchForRelationship(types: groups: properties)
	*/
	public func searchForRelationship(types types: Array<String>? = nil, groups: Array<String>? = nil, properties: Array<(key: String, value: AnyObject?)>? = nil) -> Array<Relationship> {
		var nodes: Array<AnyObject> = Array<AnyObject>()
		var toFilter: Bool = false
		
		if let v: Array<String> = types {
			if let n: Array<AnyObject> = search(GraphUtility.relationshipDescriptionName, types: v) {
				nodes.appendContentsOf(n)
			}
		}
		
		if let v: Array<String> = groups {
			if let n: Array<AnyObject> = search(GraphUtility.relationshipGroupDescriptionName, groups: v) {
				toFilter = 0 < nodes.count
				nodes.appendContentsOf(n)
			}
		}
		
		if let v: Array<(key: String, value: AnyObject?)> = properties {
			if let n: Array<AnyObject> = search(GraphUtility.relationshipPropertyDescriptionName, properties: v) {
				toFilter = 0 < nodes.count
				nodes.appendContentsOf(n)
			}
		}
		
		if toFilter {
			var seen: Dictionary<String, Bool> = Dictionary<String, Bool>()
			var i: Int = nodes.count - 1
			while 0 <= i {
				if let v: ManagedRelationship = nodes[i] as? ManagedRelationship {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Relationship(object: v)
						i -= 1
						continue
					}
				} else if let v: ManagedRelationship = Graph.context!.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedRelationship {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Relationship(object: v)
						i -= 1
						continue
					}
				}
				nodes.removeAtIndex(i)
				i -= 1
			}
			return nodes as! Array<Relationship>
		} else {
			return nodes.map {
				if let v: ManagedRelationship = $0 as? ManagedRelationship {
					return Relationship(object: v)
				}
				return Relationship(object: Graph.context!.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedRelationship)
			} as Array<Relationship>
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
			var i: Int = nodes.count - 1
			while 0 <= i {
				if let v: ManagedAction = nodes[i] as? ManagedAction {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Action(object: v)
						i -= 1
						continue
					}
				} else if let v: ManagedAction = Graph.context!.objectWithID(nodes[i]["node"]! as! NSManagedObjectID) as? ManagedAction {
					if nil == seen.updateValue(true, forKey: v.id) {
						nodes[i] = Action(object: v)
						i -= 1
						continue
					}
				}
				nodes.removeAtIndex(i)
				i -= 1
			}
			return nodes as! Array<Action>
		} else {
			return nodes.map {
				if let v: ManagedAction = $0 as? ManagedAction {
					return Action(object: v)
				}
				return Action(object: Graph.context!.objectWithID($0["node"]! as! NSManagedObjectID) as! ManagedAction)
			} as Array<Action>
		}
	}
	
	internal func search(typeDescriptionName: String, types: Array<String>) -> Array<AnyObject>? {
		var typesPredicate: Array<NSPredicate> = Array<NSPredicate>()
		
		for v in types {
			typesPredicate.append(NSPredicate(format: "type LIKE[cd] %@", v))
		}
		
		let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(typeDescriptionName, inManagedObjectContext: Graph.context!)!
		let request: NSFetchRequest = NSFetchRequest()
		request.entity = entityDescription
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: typesPredicate)
		request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
		
		return try? Graph.context!.executeFetchRequest(request)
	}
	
	internal func search(groupDescriptionName: String, groups: Array<String>) -> Array<AnyObject>? {
		var groupsPredicate: Array<NSPredicate> = Array<NSPredicate>()
		
		for v in groups {
			groupsPredicate.append(NSPredicate(format: "name LIKE[cd] %@", v))
		}
		
		let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(groupDescriptionName, inManagedObjectContext: Graph.context!)!
		let request: NSFetchRequest = NSFetchRequest()
		request.entity = entityDescription
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		request.resultType = .DictionaryResultType
		request.propertiesToFetch = ["node"]
		request.returnsDistinctResults = true
		request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: groupsPredicate)
		request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
		
		return try? Graph.context!.executeFetchRequest(request)
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
		
		let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(propertyDescriptionName, inManagedObjectContext: Graph.context!)!
		let request: NSFetchRequest = NSFetchRequest()
		request.entity = entityDescription
		request.fetchBatchSize = batchSize
		request.fetchOffset = batchOffset
		request.resultType = .DictionaryResultType
		request.propertiesToFetch = ["node"]
		request.returnsDistinctResults = true
		request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: propertiesPredicate)
		request.sortDescriptors = [NSSortDescriptor(key: "node.createdDate", ascending: true)]
		
		return try? Graph.context!.executeFetchRequest(request)
	}
}
