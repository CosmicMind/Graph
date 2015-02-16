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
* GKManagedEntity
*
* Represents an Entity Model Object in the persistent layer.
*/

import CoreData

@objc(GKManagedEntity)
internal class GKManagedEntity : GKManagedNode {

    /**
    * init
    * Initializes the Model Object with e a given type.
    * @param        type: String!
    */
    convenience internal init(type: String!) {
        let graph: GKGraph = GKGraph()
        let entitiDescription: NSEntityDescription! = NSEntityDescription.entityForName(GKGraphUtility.entityDescriptionName, inManagedObjectContext: graph.managedObjectContext)
        self.init(entity: entitiDescription, managedObjectContext: graph.managedObjectContext)
        nodeClass = "GKEntity"
        self.type = type
    }

    override internal func addGroup(name: String!) -> Bool {
        if !hasGroup(name) {
            groups.append(name)
            var group: GKEntityGroup = GKEntityGroup(name: name, managedObjectContext: managedObjectContext)
            group.node = self
            groupSet.addObject(group)
			return true
        }
		return false
    }

    override internal func hasGroup(name: String!) -> Bool {
        return contains(groups, name)
    }

    override internal func removeGroup(name: String!) -> Bool {
        for i in 0..<groups.count {
            if name == groups[i] {
                groups.removeAtIndex(i)
                for item: AnyObject in groupSet {
                    var group: GKEntityGroup = item as GKEntityGroup
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
    * entityDescription
    * Class method returning an NSEntityDescription Object for this Model Object.
    * @return        NSEntityDescription!
    */
    class func entityDescription() -> NSEntityDescription! {
        let graph: GKGraph = GKGraph()
        return NSEntityDescription.entityForName(GKGraphUtility.entityDescriptionName, inManagedObjectContext: graph.managedObjectContext)
    }
}