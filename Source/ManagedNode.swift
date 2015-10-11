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

internal class ManagedNode : GraphObject {
	@NSManaged internal var nodeClass: Int
	@NSManaged internal var type: String
	@NSManaged internal var createdDate: NSDate
	@NSManaged internal var propertySet: NSSet
	@NSManaged internal var groupSet: NSSet
	
	//
	//	:name:	delete
	//	:note: This method when called, deletes all the relationships first
	//	so delegation can be called with an entact Node, then the Node is
	//	deleted.
	//
	internal override func delete() {
		var s: NSMutableSet = groupSet as! NSMutableSet
		for x in s {
			if let v: ManagedNodeGroup = x as? ManagedNodeGroup {
				v.delete()
				s.removeObject(v)
			}
		}
		s = propertySet as! NSMutableSet
		for x in s {
			if let v: ManagedNodeProperty = x as? ManagedNodeProperty {
				v.delete()
				s.removeObject(v)
			}
		}
		super.delete()
	}
}
