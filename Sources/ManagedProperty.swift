/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import CoreData

@objc(ManagedProperty)
internal class ManagedProperty: NamedManagedObject {
  @NSManaged internal var object: Any
  
  /**
   Initializer that accepts a name, value and
   a NSManagedObjectContext.
   - Parameter name: A property name.
   - Parameter object: A reference to the object value.
   - Parameter node: A ManagedNode subclass.
   - Parameter managedObjectContext: A reference to a NSManagedObjectContext.
   */
  convenience init(name: String, object: Any, node: ManagedNode, managedObjectContext: NSManagedObjectContext) {    
    self.init(name: name, node: node, managedObjectContext: managedObjectContext)
    self.object = object
  }
  
  /// Marks node for deletion.
  internal override func delete() {
    node.propertySet.remove(self)
    super.delete()
  }
}
