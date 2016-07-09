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

import CoreData

/**
 A helper method to ensure that the completion callback
 is always called on the main thread.
 - Parameter success: A boolean of whether the process
 was successful or not.
 - Parameter error: An optional error object to pass.
 - Parameter completion: An Optional completion block.
 */
internal func GraphCompletionCallback(success success: Bool, error: NSError?, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
    if NSThread.isMainThread() {
        completion?(success: success, error: error)
    } else {
        dispatch_async(dispatch_get_main_queue()) {
            completion?(success: success, error: error)
        }
    }
}

/**
 A helper method to construct error messages.
 - Parameter message: The message to pass.
 - Returns: An NSError object.
 */
internal func GraphError(message message: String, domain: String = "io.cosmicmind.graph") -> NSError {
    var info = [String: AnyObject]()
    info[NSLocalizedDescriptionKey] = message
    info[NSLocalizedFailureReasonErrorKey] = message
    let error = NSError(domain: domain, code: 0001, userInfo: info)
    info[NSUnderlyingErrorKey] = error
    return error
}

public extension Graph {
    /**
     Performs a save.
     - Parameter completion: An Optional completion block that is
     executed when the save operation is completed.
     */
    public func async(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        guard let moc = managedObjectContext else {
            GraphCompletionCallback(
                success: false,
                error: GraphError(message: "[Graph Error: ManagedObjectContext does not exist."),
                completion: completion)
            return
        }
        
        moc.performBlock { [weak moc] in
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
    public func sync(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        guard let moc = managedObjectContext else {
            GraphCompletionCallback(
                success: false,
                error: GraphError(message: "[Graph Error: Worker ManagedObjectContext does not exist."),
                completion: completion)
            return
        }
        
        moc.performBlockAndWait { [unowned moc] in
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
    public func clear(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        for entity in searchForEntity(types: ["*"]) {
            entity.delete()
        }
        
        for action in searchForAction(types: ["*"]) {
            action.delete()
        }
        
        for relationship in searchForRelationship(types: ["*"]) {
            relationship.delete()
        }
        
        sync(completion)
    }
    
    /// Reset the storage.
    public func reset() {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performBlockAndWait { [unowned moc] in
            moc.reset()
        }
    }
}
