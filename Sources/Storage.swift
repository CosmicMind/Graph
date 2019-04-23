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

/**
 A helper method to ensure that the completion callback
 is always called on the main thread.
 - Parameter success: A boolean of whether the process
 was successful or not.
 - Parameter error: An optional error object to pass.
 - Parameter completion: An Optional completion block.
 */
internal func GraphCompletionCallback(success: Bool, error: Error?, completion: ((Bool, Error?) -> Void)? = nil) {
  if Thread.isMainThread {
    completion?(success, error)
  } else {
    DispatchQueue.main.async {
      completion?(success, error)
    }
  }
}

/**
 A helper method to construct error messages.
 - Parameter message: The message to pass.
 - Returns: An Error object.
 */
internal func GraphError(message: String, domain: String = "com.cosmicmind.graph") -> Error? {
  var info = [String: Any]()
  info[NSLocalizedDescriptionKey] = message
  info[NSLocalizedFailureReasonErrorKey] = message
  
  let error = NSError(domain: domain, code: 0001, userInfo: info)
  info[NSUnderlyingErrorKey] = error
  
  return error
}

extension Graph {
  /**
   Performs a save.
   - Parameter completion: An Optional completion block that is
   executed when the save operation is completed.
   */
  public func async(_ completion: ((Bool, Error?) -> Void)? = nil) {
    guard let moc = managedObjectContext else {
      GraphCompletionCallback(
        success: false,
        error: GraphError(message: "[Graph Error: ManagedObjectContext does not exist."),
        completion: completion)
      return
    }
    
    moc.perform { [weak moc] in
      do {
        try moc?.save()
        GraphCompletionCallback(success: true, error: nil, completion: completion)
      } catch let e as NSError {
        GraphCompletionCallback(success: false, error: e, completion: completion)
      }
    }
  }
  
  /**
   Performs a synchronous save.
   - Parameter completion: An Optional completion block that is
   executed when the save operation is completed.
   */
  public func sync(_ completion: ((Bool, Error?) -> Void)? = nil) {
    guard let moc = managedObjectContext else {
      GraphCompletionCallback(
        success: false,
        error: GraphError(message: "[Graph Error: Worker ManagedObjectContext does not exist."),
        completion: completion)
      return
    }
    
    moc.performAndWait { [unowned moc] in
      do {
        try moc.save()
        GraphCompletionCallback(success: true, error: nil, completion: completion)
      } catch let e as NSError {
        GraphCompletionCallback(success: false, error: e, completion: completion)
      }
    }
  }
  
  /**
   Clears all persisted data.
   - Parameter completion: An Optional completion block that is
   executed when the save operation is completed.
   */
  public func clear(_ completion: ((Bool, Error?) -> Void)? = nil) {
    Search<Entity>(graph: self).where(.type("*")).sync().forEach {
      $0.delete()
    }
    
    Search<Relationship>(graph: self).where(.type("*")).sync().forEach {
      $0.delete()
    }
    
    Search<Action>(graph: self).where(.type("*")).sync().forEach {
      $0.delete()
    }
    
    sync(completion)
  }
  
  /// Reset the storage.
  public func reset() {
    guard let moc = managedObjectContext else {
      return
    }
    
    moc.performAndWait { [unowned moc] in
      moc.reset()
    }
  }
}
