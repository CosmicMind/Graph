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
* Bond
*
* Represents Bond Nodes, which are unique relationships between Entity Nodes.
*/

import Foundation

@objc(Bond)
public class Bond: NSObject {
	internal let node: ManagedBond
	
	/**
	* init
	* Initializes Bond with a given ManagedBond.
	* @param        entity: ManagedBond!
	*/
	internal init(bond: ManagedBond!) {
		node = bond
	}
	
	/**
	* init
	* An initializer for the wrapped Model Object with a given type.
	* @param        type: String!
	*/
	public convenience init(type: String) {
		self.init(bond: ManagedBond(type: type))
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
	* @return       Array<String>
	*/
	public var groups: Array<String> {
		var groups: Array<String> = Array<String>()
		for group in node.groupSet {
			groups.append(group.name)
		}
		return groups
	}
	
	/**
	* properties
	* Retrieves the Properties the Node is a part of.
	* @return       Dictionary<String, AnyObject?>
	*/
	public var properties: Dictionary<String, AnyObject?> {
		var properties: Dictionary<String, AnyObject?> = Dictionary<String, AnyObject>()
		for property in node.propertySet {
			properties[property.name] = property.value
		}
		return properties
	}

    /**
    * subject
    * Retrieves an Entity Object.
    * @return       Entity
    */
    public var subject: Entity? {
        get {
			return nil == node.subject ? nil : Entity(entity: node.subject)
        }
        set(entity) {
            node.subject = entity?.node
        }
    }

    /**
    * object
    * Retrieves an Entity Object.
    * @return       Entity
    */
    public var object: Entity? {
		get {
			return nil == node.object ? nil : Entity(entity: node.object)
		}
		set(entity) {
			node.object = entity?.node
		}
    }

    /**
    * delete
    * Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
        node.delete()
    }
}

extension Bond: Equatable, Printable {
	override public var description: String {
		return "[id: \(id), type: \(type), groups: \(groups), properties: \(properties), subject: \(subject), object: \(object), createdDate: \(createdDate)]"
	}
}

public func ==(lhs: Bond, rhs: Bond) -> Bool {
	return lhs.id == rhs.id
}