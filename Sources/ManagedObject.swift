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

@objc(ManagedObject)
internal class ManagedObject: NSManagedObject {
  
  /// A model identifier.
  internal class var identifier: String {
    return ""
  }
  
  internal convenience init(managedObjectContext: NSManagedObjectContext) {
    let description = NSEntityDescription.entity(forEntityName: type(of: self).identifier, in: managedObjectContext)!
    self.init(entity: description, insertInto: managedObjectContext)
  }
  
  /// Marks for deletion.
  func delete() {
    guard let moc = managedObjectContext else {
      return
    }
    
    moc.performAndWait { [unowned self, unowned moc] in
      moc.delete(self)
    }
  }
}

internal protocol PerformAndWaitable: class {
  var managedObjectContext: NSManagedObjectContext? { get }
}

extension ManagedObject: PerformAndWaitable { }

internal extension PerformAndWaitable {
  func performAndWait<T>(_ block: (Self) -> T) -> T {
    return performAndWait(block)!
  }
  
  func performAndWait<T>(_ block: (Self) -> T?) -> T? {
    var result: T?
    
    managedObjectContext?.performAndWait { [unowned self] in
      result = block(self)
    }
    
    return result
  }
  
  func performAndWait(_ block: (Self) -> Void) {
    managedObjectContext?.performAndWait { [unowned self] in
      block(self)
    }
  }
}

