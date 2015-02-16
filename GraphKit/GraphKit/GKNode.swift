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
public class GKNode : NSObject {
    internal lazy var graph: GKGraph = GKGraph()
    internal let node: GKManagedNode!

    /**
    * type
    * Retrieves the type ofModel Object that is wrapped internally.
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

    public var groups: Array<String> {
        var groups: Array<String>!
        graph.managedObjectContext.performBlockAndWait {
            groups = self.node.groups
        }
        return groups
    }

    /**
    * archive
    * Marks the Model Object to be deleted from its persistent layer.
    */
    public func archive() {
        graph.managedObjectContext.performBlockAndWait {
            self.node.archive(self.graph)
        }
    }

    /**
    * properties[ ]
    * Allows for Dictionary style coding, which maps to the wrapped Model Object property values.
    * @param        property: String! Property name.
    * get           Returns the property name value.
    * set           Value for the property name.
    */
    public subscript(property: String) -> AnyObject? {
        get {
            var value: AnyObject?
            graph.managedObjectContext.performBlockAndWait {
                value = self.node[property]
            }
            return value
        }
        set(value) {
            graph.managedObjectContext.performBlockAndWait {
                self.node[property] = value
            }
        }
    }

    public subscript(index: Int) -> String {
        get {
            var value: String!
            graph.managedObjectContext.performBlockAndWait {
                value = self.node[index]
            }
            return value
        }
        set(value) {
            graph.managedObjectContext.performBlockAndWait {
                self.node[index] = value
            }
        }
    }

    public func addGroup(name: String!) -> Bool {
		var result: Bool = false
		graph.managedObjectContext.performBlockAndWait {
            result = self.node.addGroup(name)
        }
		return result
    }

    public func hasGroup(name: String!) -> Bool {
        var result: Bool = false
        graph.managedObjectContext.performBlockAndWait {
            result = self.node.hasGroup(name)
        }
        return result
    }

    public func removeGroup(name: String!) -> Bool {
        var result: Bool = false
        graph.managedObjectContext.performBlockAndWait {
            result = self.node.removeGroup(name)
        }
        return result
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
