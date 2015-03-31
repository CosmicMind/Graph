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
* GKNode
*
* Base wrapper classed used for GKManagedNode Model Objects. This should never be used directly.
*/

import Foundation

@objc(GKNode)
public class GKNode: NSObject {
    internal lazy var graph: GKGraph = GKGraph()
    internal let node: GKManagedNode!

    /**
    * nodeClass
    * Retrieves the nodeClass for the Model Object that is wrapped internally.
    * @return       String!
    */
    public var nodeClass: String! {
        var nodeClass: String!
        graph.managedObjectContext.performBlockAndWait {
            nodeClass = self.node.nodeClass
        }
        return nodeClass
    }

    /**
    * type
    * Retrieves the type for the Model Object that is wrapped internally.
    * @return       String!
    */
    public var type: String! {
        var type: String!
        graph.managedObjectContext.performBlockAndWait {
            type = self.node.type
        }
        return type
    }

    /**
    * objectID
    * Retrieves the ID for the Model Object that is wrapped internally.
    * @return       String! of the ID
    */
    public var objectID: String! {
        var oID: String!
        graph.managedObjectContext.performBlockAndWait {
            let nodeURL: NSURL = self.node.objectID.URIRepresentation()
            oID = nodeURL.lastPathComponent! as String
        }
        return nodeClass + type + oID
    }

    /**
    * createdDate
    * Retrieves the date the Model Object was created.
    * @return       NSDate!
    */
    public var createdDate: NSDate! {
        var createdDate: NSDate!
        graph.managedObjectContext.performBlockAndWait {
            createdDate = self.node.createdDate
        }
        return createdDate
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
            var value: AnyObject?
            graph.managedObjectContext.performBlockAndWait {
                value = self.node[name]
            }
            return value
        }
        set(value) {
            graph.managedObjectContext.performBlockAndWait {
                self.node[name] = value
            }
        }
    }

    /**
    * groups[ ]
    * Allows for Array style coding, which maps to the internal groups Array.
    * @param        index: Int
    * @return       A group
    */
    public subscript(index: Int) -> String {
        get {
            var value: String!
            graph.managedObjectContext.performBlockAndWait {
                value = self.node[index]
            }
            return value
        }
        set(value) {
            assert(false, "[GraphKit Error: Not allowed to set Group index directly.]")
        }
    }

    /**
    * addGroup
    * Adds a Group name to the list of Groups if it does not exist.
    * @param        name: String!
    * @return       Bool of the result, true if added, false otherwise.
    */
    public func addGroup(name: String!) -> Bool {
		var result: Bool!
		graph.managedObjectContext.performBlockAndWait {
            result = self.node.addGroup(name)
        }
		return result
    }

    /**
    * hasGroup
    * Checks whether the Node is a part of the Group name passed or not.
    * @param        name: String!
    * @return       Bool of the result, true if is a part, false otherwise.
    */
    public func hasGroup(name: String!) -> Bool {
        var result: Bool = false
        graph.managedObjectContext.performBlockAndWait {
            result = self.node.hasGroup(name)
        }
        return result
    }

    /**
    * removeGroup
    * Removes a Group name from the list of Groups if it exists.
    * @param        name: String!
    * @return       Bool of the result, true if exists, false otherwise.
    */
    public func removeGroup(name: String!) -> Bool {
        var result: Bool = false
        graph.managedObjectContext.performBlockAndWait {
            result = self.node.removeGroup(name)
        }
        return result
    }

    /**
    * groups
    * Retrieves the Groups the Node is a part of.
    * @return       Array<String>
    */
    public var groups: Array<String> {
        get {
			var groups: Array<String> = Array<String>()
            graph.managedObjectContext.performBlockAndWait {
				for group in self.node.groupSet {
					groups.append(group.name)
				}
            }
            return groups
        }
        set(value) {
            assert(false, "[GraphKit Error: Groups is not allowed to be set.]")
        }
    }
	
	/**
	* properties
	* Retrieves the Properties the Node is a part of.
	* @return       Dictionary<String, AnyObject?>
	*/
	public var properties: Dictionary<String, AnyObject?> {
		get {
			var properties: Dictionary<String, AnyObject?> = Dictionary<String, AnyObject>()
			graph.managedObjectContext.performBlockAndWait {
				for property in self.node.propertySet {
					properties[property.name] = property.value
				}
			}
			return properties
		}
		set(value) {
			assert(false, "[GraphKit Error: Properties is not allowed to be set.]")
		}
	}

    /**
    * init
    * An internal initializer using a GKManagedNode instance.
    * @param        node: GKManagedNode!
    */
    internal init(node: GKManagedNode!) {
        super.init()
        self.node = node
    }

    /**
    * init
    * An internal initializer for the wrapped Model Object with a given type.
    * @param        type: String!
    */
    internal init(type: String) {
        super.init()
        graph.managedObjectContext.performBlockAndWait {
            self.node = self.createImplementorWithType(type)
        }
    }

    /**
    * createImplementorWithType
    * Initializes GKManagedNode with a given type.
    * @param        type: String!
    * @return       GKManagedNode
    */
    internal func createImplementorWithType(type: String) -> GKManagedNode {
        return GKManagedNode()
    }
}
