/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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

import Foundation

public enum NodeClass: NSNumber {
    case Entity = 1
    case Relationship = 2
    case Action = 3
}

public protocol NodeType: Comparable {}

internal class Node <T: ManagedNode> {
    /// A reference to the managed node type.
    internal let managedNode: T
    
    /// A reference to the nodeClass.
    internal var nodeClass: NSNumber {
        var result: NSNumber?
        managedNode.managedObjectContext?.performBlockAndWait { [unowned self] in
            result = self.managedNode.nodeClass
        }
        return result!
    }
    
    /// A reference to the type.
    internal var type: String {
        var result: String?
        managedNode.managedObjectContext?.performBlockAndWait { [unowned self] in
            result = self.managedNode.type
        }
        return result!
    }
    
    /// A reference to the ID.
    internal var id: String {
        return managedNode.id
    }
    
    /// A reference to the createDate.
    internal var createdDate: NSDate {
        var result: NSDate?
        managedNode.managedObjectContext?.performBlockAndWait { [unowned self] in
            result = self.managedNode.createdDate
        }
        return result!
    }
    
    /// A reference to the groups.
    internal var groups: Set<String> {
        return managedNode.groups
    }
    
    /// A reference to the properties.
    internal var properties: [String: AnyObject] {
        return managedNode.properties
    }
    
    /**
     Initializer that accepts a managedNode.
     - Parameter managedNode: A reference to a managedNode.
     */
    internal init(managedNode: T) {
        self.managedNode = managedNode
    }
    
    /**
     Access properties using the subscript operator.
     - Parameter name: A property name value.
     - Returns: The optional AnyObject value.
     */
    internal subscript(name: String) -> AnyObject? {
        get {
            return managedNode[name]
        }
        set(object) {
            managedNode[name] = object
        }
    }
}