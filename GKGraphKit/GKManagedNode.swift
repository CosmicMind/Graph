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
internal class GKManagedNode: NSManagedObject {
    @NSManaged internal var nodeClass: String
    @NSManaged internal var type: String
    @NSManaged internal var createdDate: NSDate
    @NSManaged internal var propertySet: NSMutableSet
    @NSManaged internal var groupSet: NSMutableSet

	internal var context: NSManagedObjectContext {
		get {
			return nil == managedObjectContext ? GKGraphManagedObjectContext.managedObjectContext : managedObjectContext
		}
	}
	
	/**
    * properties[ ]
    * Allows for Dictionary style coding, which maps to the internal properties Dictionary.
    * @param        name: String!
    * get           Returns the property name value.
    * set           Value for the property name.
    */
    internal subscript(name: String) -> AnyObject? {
        get {return nil}
        set(value) {}
    }

    /**
    * groups[ ]
    * Allows for Array style coding, which maps to the internal groups Array.
    * @param        index: Int
    * @return       A group
    */
    internal subscript(index: Int) -> String {
        get {
            assert(-1 < index && index < groupSet.count, "[GraphKit Error: Group index out of range.]")
            return groupSet.allObjects[index].name
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
    internal func addGroup(name: String!) -> Bool {
        return false
    }

    /**
    * hasGroup
    * Checks whether the Node is a part of the Group name passed or not.
    * @param        name: String!
    * @return       Bool of the result, true if is a part, false otherwise.
    */
    internal func hasGroup(name: String!) -> Bool {
        return false
    }

    /**
    * removeGroup
    * Removes a Group name from the list of Groups if it exists.
    * @param        name: String!
    * @return       Bool of the result, true if exists, false otherwise.
    */
    internal func removeGroup(name: String!) -> Bool {
        return false
    }
	
	/**
	* delete
	* Marks the Model Object to be deleted from the Graph.
	*/
	internal func delete() {
		context.deleteObject(self)
	}
}