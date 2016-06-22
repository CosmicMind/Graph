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

public extension Graph {
    /**
     Performs a save.
     - Parameter completion: An Optional completion block that is
     executed when the save operation is completed.
     */
    public func save(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        guard context.hasChanges else {
            return
        }
        
        context.performBlockAndWait { [weak self] in
            if let moc = self?.context {
                do {
                    try moc.save()
                    
                    guard let parentContext = moc.parentContext else {
                        return
                    }
                    
                    guard parentContext.hasChanges else {
                        return
                    }
                    
                    parentContext.performBlock {
                        do {
                            try parentContext.save()
                            dispatch_async(dispatch_get_main_queue()) {
                                completion?(success: true, error: nil)
                            }
                        } catch let e as NSError {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion?(success: false, error: e)
                            }
                        }
                    }
                } catch let e as NSError {
                    completion?(success: false, error: e)
                }
            }
        }
    }
}