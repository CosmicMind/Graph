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
* GKBondProperty
*
* Stores a reference to the GKManagedBond Model Object.
*/

import CoreData

@objc(GKBondProperty)
internal class GKBondProperty: NSManagedObject {
	@NSManaged internal var name: String
	@NSManaged internal var value: AnyObject
	@NSManaged internal var node: GKManagedBond

    /**
    * init
    * Initializer for the Model Object.
    * @param        name: String!
    * @param        value: AnyObject!
	* @param		managedObjectContext: NSManagedObjectContxt!
    */
    convenience init(name: String!, value: AnyObject!, managedObjectContext: NSManagedObjectContext!) {
        var entityDescription: NSEntityDescription = NSEntityDescription.entityForName(GKGraphUtility.bondPropertyDescriptionName, inManagedObjectContext: managedObjectContext)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        self.name = name
        self.value = value
    }
}
