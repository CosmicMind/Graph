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
* GKEntity
*
* Represents Entity Nodes, which are person, places, or things -- nouns.
*/

import Foundation

@objc(GKEntity)
public class GKEntity: GKNode {
	
	/**
    * init
    * Initializes GKEntity with a given type.
    * @param        type: String
    */
    override public init(type: String) {
        super.init(type: type)
    }
	
	/**
    * actions
    * Retrieves an Array of GKAction Objects.
    * @return       Array<GKAction>
    */
    public var actions: Array<GKAction> {
        get {
            return actionsWhenSubject + actionsWhenObject
        }
        set(value) {
            assert(false, "[GraphKit Error: Actions may not be set.]")
        }
    }

    /**
    * actionsWhenSubject
    * Retrieves an Array of GKAction Objects when the Entity is a Subject of the Action.
    * @return       Array<GKAction>
    */
    public var actionsWhenSubject: Array<GKAction> {
        get {
            var nodes: Array<GKAction> = Array<GKAction>()
            graph.managedObjectContext.performBlockAndWait {
                var node: GKManagedEntity = self.node as GKManagedEntity
                for item: AnyObject in node.actionSubjectSet {
                    nodes.append(GKAction(action: item as GKManagedAction))
                }
            }
            return nodes
        }
        set(value) {
            assert(false, "[GraphKit Error: ActionWhenSubject may not be set.]")
        }
    }

    /**
    * actionsWhenObject
    * Retrieves an Array of GKAction Objects when the Entity is an Object of the Action.
    * @return       Array<GKAction>
    */
    public var actionsWhenObject: Array<GKAction> {
        get {
            var nodes: Array<GKAction> = Array<GKAction>()
            graph.managedObjectContext.performBlockAndWait {
                var node: GKManagedEntity = self.node as GKManagedEntity
                for item: AnyObject in node.actionObjectSet {
                    nodes.append(GKAction(action: item as GKManagedAction))
                }
            }
            return nodes
        }
        set(value) {
            assert(false, "[GraphKit Error: ActionWhenObject may not be set.]")
        }
    }

    /**
    * bonds
    * Retrieves an Array of GKBond Objects.
    * @return       Array<GKBond>
    */
    public var bonds: Array<GKBond> {
        get {
            return bondsWhenSubject + bondsWhenObject
        }
        set(value) {
            assert(false, "[GraphKit Error: Bonds may not be set.]")
        }
    }

    /**
    * bondsWhenSubject
    * Retrieves an Array of GKBond Objects when the Entity is a Subject of the Bond.
    * @return       Array<GKBond>
    */
    public var bondsWhenSubject: Array<GKBond> {
        get {
            var nodes: Array<GKBond> = Array<GKBond>()
            graph.managedObjectContext.performBlockAndWait {
                var node: GKManagedEntity = self.node as GKManagedEntity
                for item: AnyObject in node.bondSubjectSet {
                    nodes.append(GKBond(bond: item as GKManagedBond))
                }
            }
            return nodes
        }
        set(value) {
            assert(false, "[GraphKit Error: BondWhenSubject may not be set.]")
        }
    }

    /**
    * bondsWhenObject
    * Retrieves an Array of GKBond Objects when the Entity is an Object of the Bond.
    * @return       Array<GKBond>
    */
    public var bondsWhenObject: Array<GKBond> {
        get {
            var nodes: Array<GKBond> = Array<GKBond>()
            graph.managedObjectContext.performBlockAndWait {
                var node: GKManagedEntity = self.node as GKManagedEntity
                for item: AnyObject in node.bondObjectSet {
                    nodes.append(GKBond(bond: item as GKManagedBond))
                }
            }
            return nodes
        }
        set(value) {
            assert(false, "[GraphKit Error: BondWhenObject may not be set.]")
        }
    }

    /**
    * delete
    * Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
        graph.managedObjectContext.performBlockAndWait {
            var node: GKManagedEntity = self.node as GKManagedEntity
            node.delete()
        }
    }

    /**
    * init
    * Initializes GKEntity with a given GKManagedEntity.
    * @param        entity: GKManagedEntity!
    */
    internal init(entity: GKManagedEntity!) {
        super.init(node: entity)
    }

    /**
    * createImplementorWithType
    * Initializes GKManagedEntity with a given type.
    * @param        type: String
    * @return       GKManagedEntity
    */
    override internal func createImplementorWithType(type: String) -> GKManagedNode {
        return GKManagedEntity(type: type)
    }
}
