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
* NSManagedNode
*
* Is the base class for Model Objects. This class should only be subclasses and never used directly.
*/

import CoreData

@objc(GKManagedNode)
internal class GKManagedNode : NSManagedObject, Printable {
    @NSManaged internal var nodeClass: String
    @NSManaged internal var type: String
    @NSManaged internal var createdDate: NSDate
    @NSManaged internal var properties: Dictionary<String, AnyObject>

    /**
    * Should be ignored, this class is merely to
    */
    convenience internal init(type: String!) {
        self.init()
    }

    /**
    * properties[ ]
    * Allows for Dictionary style coding, which maps to the internal properties Dictionary.
    * @param        property: String! Property name.
    * get           Returns the property name value.
    * set           Value for the property name.
    */
    internal subscript(property: String) -> AnyObject? {
        get {
            return properties[property]
        }
        set(value) {
            properties[property] = value
        }
    }

    /**
    * archive
    * Marks the Model Object to be deleted from its persistent layer.
    * @param        graph: GKGraph! An instance of the GKGraph.
    */
    internal func archive(graph: GKGraph!) {
        graph.managedObjectContext.deleteObject(self)
    }
}