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
* GKBond
*
* Represents Bond Nodes, which are unique relationships between Entity Nodes.
*/

import Foundation

@objc(GKBond)
public class GKBond : GKNode {

    /**
    * init
    * Initializes GKBond with a given type.
    * @param        type: String
    */
    override public init(type: String) {
        super.init(type: type)
    }

    /**
    * subject
    * Retrieves an GKEntity Object.
    * @return       GKEntity
    */
    public var subject: GKEntity? {
        get {
            var entity: GKEntity?
            graph.managedObjectContext.performBlockAndWait {
                if let node: GKManagedBond = self.node as? GKManagedBond {
                    entity = GKEntity(entity: node.subject as GKManagedEntity)
                }
            }
            return entity
        }
        set(entity) {
            graph.managedObjectContext.performBlockAndWait {
                if let node: GKManagedBond = self.node as? GKManagedBond {
                    node.subject = entity?.node as GKManagedEntity
                }
            }
        }
    }

    /**
    * object
    * Retrieves an GKEntity Object.
    * @return       GKEntity
    */
    public var object: GKEntity? {

        get {
            var entity: GKEntity?
            graph.managedObjectContext.performBlockAndWait {
                if let node: GKManagedBond = self.node as? GKManagedBond {
                    entity = GKEntity(entity: node.object as GKManagedEntity)
                }
            }
            return entity
        }
        set(entity) {
            graph.managedObjectContext.performBlockAndWait {
				if let node: GKManagedBond = self.node as? GKManagedBond {
					node.object = entity?.node as GKManagedEntity

                }
            }
        }
    }

    /**
    * delete
    * Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
        graph.managedObjectContext.performBlockAndWait {
            var node: GKManagedBond = self.node as GKManagedBond
            node.delete()
        }
    }

    /**
    * init
    * Initializes GKBond with a given GKManagedBond.
    * @param        bond: GKManagedBond!
    */
    internal init(bond: GKManagedBond!) {
        super.init(node: bond)
    }

    /**
    * createImplementorWithType
    * Initializes GKManagedBond with a given type.
    * @param        type: String
    * @return       GKManagedBond
    */
    override internal func createImplementorWithType(type: String) -> GKManagedNode {
        return GKManagedBond(type: type);
    }
}
