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
* GKEntity
*
* Represents Entity Nodes, which are person, places, or things -- nouns.
*/

import Foundation

@objc(GKEntity)
public class GKEntity : GKNode {

    /**
    * init
    * Initializes GKEntity with a given GKManagedEntity.
    * @param        entity: GKManagedEntity!
    */
    init(entity: GKManagedEntity!) {
        super.init(node: entity)
    }

    /**
    * init
    * Initializes GKEntity with a given type.
    * @param        type: String!
    */
    override public init(type: String) {
        super.init(type: type)
    }

    /**
    * createImplementorWithType
    * Initializes GKManagedEntity with a given type.
    * @param        type: String!
    * @return       GKManagedEntity
    */
    override internal func createImplementorWithType(type: String) -> GKManagedNode {
        return GKManagedEntity(type: type);
    }
}
