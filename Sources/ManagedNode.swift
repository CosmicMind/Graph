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

internal class ManagedNode: GraphNode {
    @NSManaged internal var nodeClass: NSNumber
    @NSManaged internal var type: String
    @NSManaged internal var createdDate: NSDate
    @NSManaged internal var propertySet: NSSet
    @NSManaged internal var groupSet: NSSet
    
    /// A reference to the Nodes unique ID.
    internal var id: String {
        do {
            try context?.obtainPermanentIDsForObjects([self])
        } catch {}
        return String(stringInterpolationSegment: nodeClass) + type + objectID.URIRepresentation().lastPathComponent!
    }
    
    internal override func delete() {
        var set = groupSet as! NSMutableSet
        set.forEach { (object: AnyObject) in
            if let group = object as? ManagedNodeGroup {
                group.delete()
                set.removeObject(group)
            }
        }
        set = propertySet as! NSMutableSet
        set.forEach { (object: AnyObject) in
            if let property = object as? ManagedNodeProperty {
                property.delete()
                set.removeObject(property)
            }
        }
        super.delete()
    }
}
