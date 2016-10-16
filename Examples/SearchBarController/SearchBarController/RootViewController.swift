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
    internal func prepareGraph() {
        graph = Graph()
        
        // Uncomment to clear the Graph data.
        graph.clear()
    }
    
    internal func prepareSearch() {
        search = Search<Entity>(graph: graph).for(types: ["User"]).where(properties: "name")
        
        search.async { [weak self] (data) in
            if 0 == data.count {
                SampleData.createSampleData()
            }
            self?.reloadData()
        }
    }
    
    internal func prepareTableView() {
        tableView = UserTableView()
        view.layout(tableView).edges()
    }
    
    internal func reloadData() {
        tableView.data = search.sync().sorted(by: { (a, b) -> Bool in
            guard let n = a["name"] as? String, let m = b["name"] as? String else {
                return false
            }
            return n < m
        })
    }
}

// View.
extension RootViewController: SearchBarDelegate {
    internal func prepareSearchBar() {
        // Access the searchBar.
        guard let searchBar = searchBarController?.searchBar else {
            return
        }
     
        searchBar.delegate = self
    }
    
    func searchBar(searchBar: SearchBar, didClear textField: UITextField, with text: String?) {
        reloadData()
    }
    
    func searchBar(searchBar: SearchBar, didChange textField: UITextField, with text: String?) {
        guard let pattern = text, 0 < pattern.utf16.count else {
            reloadData()
            return
        }
        
        search.async { [weak self, pattern = pattern] (users) in
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                return
            }
        
            var data = [Entity]()
            
            for user in users {
                if let name = user["name"] as? String {
                    let matches = regex.matches(in: name, range: NSRange(location: 0, length: name.utf16.count))
                    if 0 < matches.count {
                        data.append(user)
                    }
                }
            }
            
            self?.tableView.data = data
        }
    }
}

