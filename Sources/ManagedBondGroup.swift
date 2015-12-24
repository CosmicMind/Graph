//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

// #internal

import CoreData

@objc(ManagedBondGroup)
internal class ManagedBondGroup : ManagedNodeGroup {
	@NSManaged internal var node: ManagedBond

	/**
		:name:	init
		:description:	Initializer for the Model Object.
	*/
	internal convenience init(name: String) {
		let g: Graph = Graph()
		let w: NSManagedObjectContext? = g.worker
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.bondGroupDescriptionName, inManagedObjectContext: w!)!, insertIntoManagedObjectContext: w)
		self.name = name
		context = w
	}
}
