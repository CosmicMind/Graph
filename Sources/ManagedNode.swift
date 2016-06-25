/*
 * Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import CoreData

internal class ManagedNode: ManagedModel {
    @NSManaged internal var nodeClass: NSNumber
    @NSManaged internal var type: String
    @NSManaged internal var createdDate: NSDate
    @NSManaged internal var propertySet: NSSet
    @NSManaged internal var groupSet: NSSet
    
    /// A reference to the Nodes unique ID.
    internal var id: String {
        do {
            try context.obtainPermanentIDsForObjects([self])
        } catch {}
        return String(stringInterpolationSegment: nodeClass) + type + objectID.URIRepresentation().lastPathComponent!
    }
    
    /**
     Initializer that accepts an identifier, a type, and a NSManagedObjectContext.
     - Parameter identifier: A model identifier.
     - Parameter type: A reference to the Entity type.
     - Parameter context: A reference to the NSManagedObejctContext.
     */
    internal convenience init(identifier: String, type: String, context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entityForName(identifier, inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
        self.context = context
        self.type = type
        createdDate = NSDate()
        propertySet = NSSet()
        groupSet = NSSet()
    }
    
    /// Deletes the relationships and actions before marking for deletion.
    internal override func delete() {
        var set = groupSet as! NSMutableSet
        groupSet.forEach { (object: AnyObject) in
            if let group = object as? ManagedGroup {
                group.context = context
                group.delete()
                set.removeObject(group)
            }
        }
        set = propertySet as! NSMutableSet
        propertySet.forEach { (object: AnyObject) in
            if let property = object as? ManagedProperty {
                property.context = context
                property.delete()
                set.removeObject(property)
            }
        }
        super.delete()
    }
    
    /**
     Access properties using the subscript operator.
     - Parameter name: A property name value.
     - Returns: The optional AnyObject value.
     */
    internal subscript(name: String) -> AnyObject? {
        for property in propertySet as! Set<ManagedProperty> {
            if name == property.name {
                return property.object
            }
        }
        return nil
    }
    
    /**
     Adds the ManagedNode to the group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if added, false
     otherwise.
     */
    internal func addToGroup(name: String) -> Bool {
        return false
    }
    
    /**
     Checks if the ManagedNode to a part group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if a member, false
     otherwise.
     */
    internal func memberOfGroup(name: String) -> Bool {
        for group in groupSet as! Set<ManagedGroup> {
            if name == group.name {
                return true
            }
        }
        return false
    }
    
    /**
     Removes the ManagedNode from the group.
     - Parameter name: The group name.
     - Returns: A boolean of the result, true if removed, false
     otherwise.
     */
    internal func removeFromGroup(name: String) -> Bool {
        for group in groupSet as! Set<ManagedGroup> {
            if name == group.name {
                group.delete()
                (groupSet as! NSMutableSet).removeObject(group)
                return true
            }
        }
        return false
    }
}
