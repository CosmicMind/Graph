//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import GraphKit

public class ViewController: UIViewController {
    
    private lazy var graph: Graph = Graph()
    
    public let tableView: UITableView = UITableView()
    public var notes: Array<Entity> = Array<Entity>()

    public override func viewDidLoad() {
        super.viewDidLoad()
        prepareGraph()
        prepareNotes()
        prepareTableView()
        prepareNavigationBarItems()
    }
    
    public func prepareGraph() {
        graph.delegate = self
        graph.watchForEntity(types: ["Note"])
    }
    
    public func prepareNotes() {
        notes = graph.searchForEntity(types: ["Note"])
    }
    
    public func prepareTableView() {
        tableView.frame = view.bounds
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    public func prepareNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "handleAddButton:")
    }
    
    public func handleAddButton(sender: UIBarButtonItem) {
		let note: Entity = Entity(type: "Note")
		
		note["text"] = "New Note entry."
		
		graph.save { (success: Bool, error: NSError?) in
			if let e: NSError = error {
				print(e)
			}
        }
    }
}

extension ViewController: UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count;
    }
	
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell!.backgroundColor = .whiteColor()
        
        let item = notes[indexPath.row]
        cell?.textLabel!.text = item["text"] as? String
        
        return cell!
    }
}

extension ViewController: GraphDelegate {
    public func graphDidInsertEntity(graph: Graph, entity: Entity) {
        notes.append(entity)
        tableView.reloadData()
    }
}

