//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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

@objc(ManagedActionProperty)
internal class ManagedActionProperty : NSManagedObject {
	@NSManaged internal var name: String
	@NSManaged internal var object: AnyObject
	@NSManaged internal var node: ManagedAction

	private var context: NSManagedObjectContext?
	internal var worker: NSManagedObjectContext? {
		if nil == context {
			let graph: Graph = Graph()
			context = graph.worker
		}
		return context
	}

	/**
		:name:	init
		:description:	Initializer for the Model Object.
	*/
	convenience init(name: String, object: AnyObject) {
		let g: Graph = Graph()
		let w: NSManagedObjectContext? = g.worker
		self.init(entity: NSEntityDescription.entityForName(GraphUtility.actionPropertyDescriptionName, inManagedObjectContext: w!)!, insertIntoManagedObjectContext: w)
		self.name = name
		self.object = object
		context = w
	}

	/**
		:name:	delete
		:description:	Deletes the Object Model.
	*/
	internal func delete() {
		worker?.deleteObject(self)
	}
}
