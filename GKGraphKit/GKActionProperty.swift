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
* GKActionProperty
*
* Stores a reference to the GKManagedAction Model Object.
*/

import CoreData

@objc(GKActionProperty)
internal class GKActionProperty: GKNodeProperty {
    @NSManaged internal var node: GKManagedAction

    /**
    * init
    * Initializer for the Model Object.
    * @param        name: String!
    * @param        value: AnyObject!
    */
    convenience init(name: String!, value: AnyObject!) {
        var entityDescription: NSEntityDescription = NSEntityDescription.entityForName(GKGraphUtility.actionPropertyDescriptionName, inManagedObjectContext: GKGraphManagedObjectContext.managedObjectContext)!
        self.init(entityDescription: entityDescription, managedObjectContext: GKGraphManagedObjectContext.managedObjectContext)
        self.name = name
        self.value = value
    }
}
