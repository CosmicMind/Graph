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

import UIKit
import Material
import Graph

class RootViewController: UIViewController {
    // Model.
    internal var graph: Graph!
    internal var search: Search<Entity>!
    
    // View.
    internal var tableView: UserTableView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        // Prepare view.
        prepareSearchBar()
        prepareTableView()
        
        // Prepare model.
        prepareGraph()
        prepareSearch()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView?.reloadData()
    }
}

/// Model.
extension RootViewController {
    internal func createSampleData() {
        let u1 = Entity(type: "User")
        u1["name"] = "Daniel Dahan"
        u1["status"] = "Working on CosmicMind frameworks!"
        u1["photo"] = UIImage.image(with: Color.grey.lighten5, size: CGSize(width: 100, height: 100))
        
        let u2 = Entity(type: "User")
        u2["name"] = "Deepali Parhar"
        u2["status"] = "Posting a tweet!"
        u2["photo"] = UIImage.image(with: Color.grey.lighten5, size: CGSize(width: 100, height: 100))
        
        let u3 = Entity(type: "User")
        u3["name"] = "Eve"
        u3["status"] = "Doing yoga <3"
        u3["photo"] = UIImage.image(with: Color.grey.lighten5, size: CGSize(width: 100, height: 100))
        
        let u4 = Entity(type: "User")
        u4["name"] = "Charles St. Louis"
        u4["status"] = "Kicking butt at Queens University."
        u4["photo"] = UIImage.image(with: Color.grey.lighten5, size: CGSize(width: 100, height: 100))
        
        /// To save the model data synchronously, use the sync method.
        graph.sync()
    }
    
    internal func prepareGraph() {
        graph = Graph()
        
        // Uncomment to clear the Graph data.
        graph.clear()
    }
    
    internal func prepareSearch() {
        search = Search<Entity>(graph: graph).for(types: ["User"]).where(properties: "name")
        var data = search.sync()
        
        if 0 == data.count {
            createSampleData()
            data = search.sync()
        }
        
        tableView.data = data
    }
    
    internal func prepareTableView() {
        tableView = UserTableView()
        view.layout(tableView).edges()
    }
}

// View.
extension RootViewController {
    internal func prepareSearchBar() {
        // Access the searchBar.
        guard let searchBar = searchBarController?.searchBar else {
            return
        }
     
        searchBar.textField.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
    }
    
    // Live updates the search results.
    internal func handleTextChange(textField: UITextField) {
        guard let pattern = textField.text, let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            tableView.data = search.sync()
            return
        }
        
        var data = [Entity]()
        
        search.sync().forEach { [regex = regex] (user) in
            guard let name = user["name"] as? String else {
                return
            }
            
            let matches = regex.matches(in: name, range: NSRange(location: 0, length: name.utf16.count))
            if 0 < matches.count {
                data.append(user)
            }
        }
        
        tableView.data = data
        
        
    }
}

