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
* GKManagedAction
*
* Represents an Action Model Object in the persistent layer.
*/


import CoreData

@objc(GKManagedAction)
internal class GKManagedAction : GKManagedNode {
    @NSManaged internal var subjectSet: NSSet
    @NSManaged internal var objectSet: NSSet

    /**
    * entityDescription
    * Class method returning an NSEntityDescription Object for this Model Object.
    * @return        NSEntityDescription!
    */
    class func entityDescription() -> NSEntityDescription! {
        let graph: GKGraph = GKGraph()
        return NSEntityDescription.entityForName(GKGraphUtility.actionDescriptionName, inManagedObjectContext: graph.managedObjectContext)
    }

    /**
    * init
    * Initializes the Model Object with e a given type.
    * @param        type: String!
    */
    convenience internal init(type: String!) {
        let graph: GKGraph = GKGraph()
        let entitiDescription: NSEntityDescription! = NSEntityDescription.entityForName(GKGraphUtility.actionDescriptionName, inManagedObjectContext: graph.managedObjectContext)
        self.init(entity: entitiDescription, managedObjectContext: graph.managedObjectContext)
        nodeClass = "GKAction"
        self.type = type
        subjectSet = NSSet()
        objectSet = NSSet()
    }

    /**
    * addGroup
    * Adds a Group name to the list of Groups if it does not exist.
    * @param        name: String!
    * @return       Bool of the result, true if added, false otherwise.
    */
    override internal func addGroup(name: String!) -> Bool {
        if !hasGroup(name) {
            groups.append(name)
            var group: GKActionGroup = GKActionGroup(name: name, managedObjectContext: managedObjectContext)
            group.node = self
            groupSet.addObject(group)
			return true
        }
		return false
    }

    /**
    * hasGroup
    * Checks whether the Node is a part of the Group name passed or not.
    * @param        name: String!
    * @return       Bool of the result, true if is a part, false otherwise.
    */
    override internal func hasGroup(name: String!) -> Bool {
        return contains(groups, name)
    }

    /**
    * removeGroup
    * Removes a Group name from the list of Groups if it exists.
    * @param        name: String!
    * @return       Bool of the result, true if exists, false otherwise.
    */
    override internal func removeGroup(name: String!) -> Bool {
        for i in 0..<groups.count {
            if name == groups[i] {
                groups.removeAtIndex(i)
                for item: AnyObject in groupSet {
                    var group: GKActionGroup = item as GKActionGroup
                    if name == group.name {
                        groupSet.removeObject(item)
                        managedObjectContext!.deleteObject(group)
                        return true
                    }
                }
            }
        }
        return false
    }

    /**
    * addSubject
    * Adds a GKManagedEntity Model Object to the Subject Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if added, false otherwise.
    */
    internal func addSubject(entity: GKManagedEntity!) -> Bool {
        let nodes = mutableSetValueForKey("subjectSet");
        let count: Int = nodes.count
        nodes.addObject(entity)
        return count != nodes.count
    }

    /**
    * removeSubject
    * Removes a GKManagedEntity Model Object from the Subject Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if removed, false otherwise.
    */
    internal func removeSubject(entity: GKManagedEntity!) -> Bool {
        let nodes = mutableSetValueForKey("subjectSet");
        let count: Int = nodes.count
        nodes.removeObject(entity)
        return count != nodes.count
    }

    /**
    * addObject
    * Adds a GKManagedEntity Model Object to the Object Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if added, false otherwise.
    */
    internal func addObject(entity: GKManagedEntity!) -> Bool {
        let nodes = mutableSetValueForKey("objectSet");
        let count: Int = nodes.count
        nodes.addObject(entity)
        return count != nodes.count
    }

    /**
    * removeObject
    * Removes a GKManagedEntity Model Object from the Object Set.
    * @param        entity: GKManagedEntity!
    * @return       Bool of the result, true if removed, false otherwise.
    */
    internal func removeObject(entity: GKManagedEntity!) -> Bool {
        let nodes = mutableSetValueForKey("objectSet");
        let count: Int = nodes.count
        nodes.removeObject(entity)
        return count != nodes.count
    }

    /**
    * delete
    * Marks the Model Object to be deleted from the Graph.
    * @param        graph: GKGraph! An instance of the GKGraph.
    */
    internal func delete(graph: GKGraph!) {
        var nodes: NSMutableSet = subjectSet as NSMutableSet
        for node in nodes {
            nodes.removeObject(node)
        }
        nodes = objectSet as NSMutableSet
        for node in nodes {
            nodes.removeObject(node)
        }
        graph.managedObjectContext.deleteObject(self)
    }
}
