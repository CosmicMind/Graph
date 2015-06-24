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
* Entity
*
* Represents Entity Nodes, which are person, places, or things -- nouns.
*/

import Foundation

@objc(Entity)
public class Entity: NSObject {
	internal let node: ManagedEntity
	
	/**
	* init
	* Initializes Entity with a given ManagedEntity.
	* @param        entity: ManagedEntity!
	*/
	internal init(entity: ManagedEntity!) {
		node = entity
	}
	
	/**
	* init
	* An initializer for the wrapped Model Object with a given type.
	* @param        type: String!
	*/
	public convenience init(type: String) {
		self.init(entity: ManagedEntity(type: type))
	}
	
	/**
	* nodeClass
	* Retrieves the nodeClass for the Model Object that is wrapped internally.
	* @return       String
	*/
	public var nodeClass: String {
		return node.nodeClass
	}
	
	/**
	* type
	* Retrieves the type for the Model Object that is wrapped internally.
	* @return       String
	*/
	public var type: String {
		return node.type
	}
	
	/**
	* id
	* Retrieves the ID for the Model Object that is wrapped internally.
	* @return       String? of the ID
	*/
	public var id: String {
		let nodeURL: NSURL = node.objectID.URIRepresentation()
		let oID: String = nodeURL.lastPathComponent!
		return nodeClass + type + oID
	}
	
	/**
	* createdDate
	* Retrieves the date the Model Object was created.
	* @return       NSDate?
	*/
	public var createdDate: NSDate {
		return node.createdDate
	}
	
	/**
	* properties[ ]
	* Allows for Dictionary style coding, which maps to the wrapped Model Object property values.
	* @param        name: String!
	* get           Returns the property name value.
	* set           Value for the property name.
	*/
	public subscript(name: String) -> AnyObject? {
		get {
			return node[name]
		}
		set(value) {
			node[name] = value
		}
	}
	
	/**
	* addGroup
	* Adds a Group name to the list of Groups if it does not exist.
	* @param        name: String!
	* @return       Bool of the result, true if added, false otherwise.
	*/
	public func addGroup(name: String) -> Bool {
		return node.addGroup(name)
	}
	
	/**
	* hasGroup
	* Checks whether the Node is a part of the Group name passed or not.
	* @param        name: String!
	* @return       Bool of the result, true if is a part, false otherwise.
	*/
	public func hasGroup(name: String) -> Bool {
		return node.hasGroup(name)
	}
	
	/**
	* removeGroup
	* Removes a Group name from the list of Groups if it exists.
	* @param        name: String!
	* @return       Bool of the result, true if exists, false otherwise.
	*/
	public func removeGroup(name: String!) -> Bool {
		return node.removeGroup(name)
	}
	
	/**
	* groups
	* Retrieves the Groups the Node is a part of.
	* @return       Tree<String, String>
	*/
	public var groups: Tree<String, String> {
		var groups: Tree<String, String> = Tree<String, String>()
		for group in node.groupSet {
			let name: String = group.name!
			groups.insert(name, value: name)
		}
		return groups
	}
	
	/**
	* properties
	* Retrieves the Properties the Node is a part of.
	* @return       Tree<String, AnyObject?>
	*/
	public var properties: Tree<String, AnyObject?> {
		var properties: Tree<String, AnyObject?> = Tree<String, AnyObject?>()
		for property in node.propertySet {
			properties.insert(property.name, value: property.value!)
		}
		return properties
	}
	
	/**
    * actions
    * Retrieves a MultiTree of Action objects. Where the key
	* is the type of Action and the value is the Action instance.
    * @return       MultiTree<String, Action>
    */
    public var actions: MultiTree<String, Action> {
        return actionsWhenSubject + actionsWhenObject
    }

    /**
    * actionsWhenSubject
	* Retrieves a MultiTree of Action objects. Where the key
	* is the type of Action and the value is the Action instance.
	* The Actions included are those when the Entity is the subject of
	* the Action.
    * @return       MultiTree<String, Action>
    */
    public var actionsWhenSubject: MultiTree<String, Action> {
		let nodes: MultiTree<String, Action> = MultiTree<String, Action>()
		for entry in node.actionSubjectSet {
			let action: Action = Action(action: entry as! ManagedAction)
			nodes.insert(action.type, value: action)
		}
		return nodes
    }

    /**
    * actionsWhenObject
	* Retrieves a MultiTree of Action objects. Where the key
	* is the type of Action and the value is the Action instance.
	* The Actions included are those when the Entity is the object of
	* the Action.
	* @return       MultiTree<String, Action>
    */
    public var actionsWhenObject: MultiTree<String, Action> {
        let nodes: MultiTree<String, Action> = MultiTree<String, Action>()
		for entry in node.actionObjectSet {
			let action: Action = Action(action: entry as! ManagedAction)
			nodes.insert(action.type, value: action)
		}
		return nodes
    }

    /**
    * bonds
	* Retrieves a MultiTree of Bond objects. Where the key
	* is the type of Bond and the value is the Bond instance.
	* @return       MultiTree<String, Bond>
    */
    public var bonds: MultiTree<String, Bond> {
        return bondsWhenSubject + bondsWhenObject
    }

    /**
    * bondsWhenSubject
	* Retrieves a MultiTree of Bond objects. Where the key
	* is the type of Bond and the value is the Bond instance.
	* The Bonds included are those when the Entity is the subject of
	* the Bond.
	* @return       MultiTree<String, Bond>
    */
    public var bondsWhenSubject: MultiTree<String, Bond> {
		let nodes: MultiTree<String, Bond> = MultiTree<String, Bond>()
		for entry in node.bondSubjectSet {
			let bond: Bond = Bond(bond: entry as! ManagedBond)
			nodes.insert(bond.type, value: bond)
		}
		return nodes
    }

    /**
    * bondsWhenObject
	* Retrieves a MultiTree of Bond objects. Where the key
	* is the type of Bond and the value is the Bond instance.
	* The Bonds included are those when the Entity is the object of
	* the Bond.
	* @return       MultiTree<String, Bond>
    */
    public var bondsWhenObject: MultiTree<String, Bond> {
		let nodes: MultiTree<String, Bond> = MultiTree<String, Bond>()
		for entry in node.bondObjectSet {
			let bond: Bond = Bond(bond: entry as! ManagedBond)
			nodes.insert(bond.type, value: bond)
		}
		return nodes
    }

    /**
    * delete
    * Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
		node.delete()
    }
}

extension Entity: Equatable, Printable {
	override public var description: String {
		return "{id: \(id), type: \(type), groups: \(groups), properties: \(properties), createdDate: \(createdDate)}"
	}
}

public func ==(lhs: Entity, rhs: Entity) -> Bool {
	return lhs.id == rhs.id
}