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
* GKAction
*
* Represents Action Nodes, which are repetitive relationships between Entity Nodes.
*/

import Foundation

@objc(GKAction)
public class GKAction: GKNode {

    /**
    * init
    * Initializes GKAction with a given type.
    * @param        type: String
    */
    override public init(type: String) {
        super.init(type: type)
    }

    /**
    * subjects
    * Retrieves an Array of GKEntity Objects.
    * @return       Array<GKEntity>
    */
    public var subjects: Array<GKEntity> {
        get {
            var nodes: Array<GKEntity> = Array<GKEntity>()
            graph.managedObjectContext.performBlockAndWait {
                var node: GKManagedAction = self.node as GKManagedAction
				for item: AnyObject in node.subjectSet {
                    nodes.append(GKEntity(entity: item as GKManagedEntity))
                }
            }
            return nodes
        }
        set(value) {
            assert(false, "[GraphKit Error: Subjects may not be set.]")
        }
    }

    /**
    * objects
    * Retrieves an Array of GKEntity Objects.
    * @return       Array<GKEntity>
    */
    public var objects: Array<GKEntity> {
        get {
            var nodes: Array<GKEntity> = Array<GKEntity>()
            graph.managedObjectContext.performBlockAndWait {
                var node: GKManagedAction = self.node as GKManagedAction
                for item: AnyObject in node.objectSet {
                    nodes.append(GKEntity(entity: item as GKManagedEntity))
                }
            }
            return nodes
        }
        set(value) {
            assert(false, "[GraphKit Error: Objects may not be set.]")
        }
    }

    /**
    * addSubject
    * Adds a GKEntity Model Object to the Subject Set.
    * @param        entity: GKEntity!
    * @return       Bool of the result, true if added, false otherwise.
    */
    public func addSubject(entity: GKEntity!) -> Bool {
        var result: Bool = false
        graph.managedObjectContext.performBlockAndWait {
			var node: GKManagedAction = self.node as GKManagedAction
			result = node.addSubject(entity.node as GKManagedEntity)
        }
        return result
    }

    /**
    * removeSubject
    * Removes a GKEntity Model Object from the Subject Set.
    * @param        entity: GKEntity!
    * @return       Bool of the result, true if removed, false otherwise.
    */
    public func removeSubject(entity: GKEntity!) -> Bool {
        var result: Bool = false
        graph.managedObjectContext.performBlockAndWait {
            var node: GKManagedAction = self.node as GKManagedAction
            result = node.removeSubject(entity.node as GKManagedEntity)
        }
        return result
    }

    /**
    * addObject
    * Adds a GKEntity Object to the Object Set.
    * @param        entity: GKEntity!
    * @return       Bool of the result, true if added, false otherwise.
    */
    public func addObject(entity: GKEntity!) -> Bool {
        var result: Bool = false
        graph.managedObjectContext.performBlockAndWait {
            var node: GKManagedAction = self.node as GKManagedAction
            result = node.addObject(entity.node as GKManagedEntity)
        }
        return result
    }

    /**
    * removeObject
    * Removes a GKEntity Model Object from the Object Set.
    * @param        entity: GKEntity!
    * @return       Bool of the result, true if removed, false otherwise.
    */
    public func removeObject(entity: GKEntity!) -> Bool {
        var result: Bool = false
        graph.managedObjectContext.performBlockAndWait {
            var node: GKManagedAction = self.node as GKManagedAction
            result = node.removeObject(entity.node as GKManagedEntity)
        }
        return result
    }

    /**
    * delete
    * Marks the Model Object to be deleted from the Graph.
    */
    public func delete() {
        graph.managedObjectContext.performBlockAndWait {
            var node: GKManagedAction = self.node as GKManagedAction
            node.delete()
        }
    }

    /**
    * init
    * Initializes GKAction with a given GKManagedAction.
    * @param        action: GKManagedAction!
    */
    internal init(action: GKManagedAction!) {
        super.init(node: action)
    }

    /**
    * createImplementorWithType
    * Initializes GKManagedAction with a given type.
    * @param        type: String
    * @return       GKManagedAction
    */
    override internal func createImplementorWithType(type: String) -> GKManagedNode {
        return GKManagedAction(type: type)
    }
}
