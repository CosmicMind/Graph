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

internal struct GraphRegistry {
    static var dispatchToken: dispatch_once_t = 0
    static var parentContexts: [String: NSManagedObjectContext]!
    static var mainContexts: [String: NSManagedObjectContext]!
}

public class Graph {
    /// Storage name.
    private(set) var name: String
	
	/// Storage type.
	private(set) var type: String
	
    /// Storage location.
    private(set) var location: NSURL
    
    /// Worker context.
    public private(set) var context: NSManagedObjectContext!
    
	public init(name: String = Storage.name, type: String = Storage.type, location: NSURL = Storage.location) {
        self.name = name
		self.type = type
		self.location = location
        prepareGraphRegistry()
        prepareContext()
    }
    
    /// Prepares the registry.
    private func prepareGraphRegistry() {
        dispatch_once(&GraphRegistry.dispatchToken) {
            GraphRegistry.parentContexts = [String: NSManagedObjectContext]()
            GraphRegistry.mainContexts = [String: NSManagedObjectContext]()
        }
    }
    
    /// Prapres the context.
    private func prepareContext() {
        guard let moc = GraphRegistry.mainContexts[name] else {
            let parentContext = Context.createManagedContext(.PrivateQueueConcurrencyType)
            parentContext.persistentStoreCoordinator = Coordinator.createPersistentStoreCoordinator(name, type: type, location: location)
            
            let mainContext = Context.createManagedContext(.MainQueueConcurrencyType, parentContext: parentContext)
            
            GraphRegistry.parentContexts[name] = parentContext
            GraphRegistry.mainContexts[name] = mainContext
            context = Context.createManagedContext(.PrivateQueueConcurrencyType, parentContext: mainContext)
            return
        }
        context = Context.createManagedContext(.PrivateQueueConcurrencyType, parentContext: moc)
    }
}