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
* GKNodeProperty
*
* Stores Property values used to create subsets of the Nodes in the Graph.
*/

import CoreData

@objc(GKNodeProperty)
internal class GKNodeProperty: NSManagedObject {
    @NSManaged internal var name: String
    @NSManaged internal var value: AnyObject

    /**
    * init
    * Internal usage for inittializing the Model Object.
    * @param        entityDescription: NSEntityDescription!
    * @param        managedObjectContext: NSManagedObjectContext!
    */
    convenience internal init(entityDescription: NSEntityDescription!, managedObjectContext: NSManagedObjectContext!) {
        self.init(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
    }
}
