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
*	*	Neither the name of GraphKit nor the names of its
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

/*
The following ViewController exemplifies the usage of Entity objects being
created and inserted within a tableView. There is a single Graph Search
query when loading the ViewController. On inserts, the Graph Watch API is
utilized to update the Array block that holds the Entity objects to better
the efficiency of the overall process of updating the UI for the ViewController.
*/

import UIKit
import GraphKit

public class ViewController: UIViewController {
	/// Access the Graph persistence layer.
	private lazy var graph: Graph = Graph()
	
	/// A tableView used to display new Entity entries.
	public let tableView: UITableView = UITableView()
	
	/// A list of all the Note Entity types.
	public var notes: Array<Entity> = Array<Entity>()
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		prepareGraph()
		prepareNotes()
		prepareTableView()
		prepareNavigationBarItems()
	}
	
	/// Prepares the Graph instance.
	public func prepareGraph() {
		/*
		Rather than searching the Note Entity types on each
		insert, the Graph Watch API is used to update the
		notes Array. This allows a single search query to be 
		made when loading the ViewController.
		*/
		graph.delegate = self
		graph.watchForEntity(types: ["Note"])
	}
	
	/// Prepares the notes Array.
	public func prepareNotes() {
		notes = graph.searchForEntity(types: ["Note"])
	}
	
	/// Prepares the tableView.
	public func prepareTableView() {
		tableView.frame = view.bounds
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.dataSource = self
		view.addSubview(tableView)
	}
	
	/// Prepares the navigation bar items.
	public func prepareNavigationBarItems() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "handleAddButton:")
	}
	
	/// Handles the add button event.
	public func handleAddButton(sender: UIBarButtonItem) {
		let note: Entity = Entity(type: "Note")
		
		note["text"] = "New Note entry."
		note["image"] = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("GraphKit", ofType: "png")!)
		
		/*
		The graph.save call triggers an asynchronous callback
		that may be used for various benefits. As well, since
		the graph is watching Note Entity types, the 
		graphDidInsertEntity delegate method is executed once
		the save is complete.
		*/
		graph.save { (success: Bool, error: NSError?) in
			if let e: NSError = error {
				print(e)
			}
		}
	}
}

/// TableViewDataSource methods.
extension ViewController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count;
	}
	
	/// Prepares the cells within the tableView.
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
		cell.backgroundColor = .whiteColor()
		
		let note: Entity = notes[indexPath.row]
		cell.textLabel!.text = note["text"] as? String
		cell.imageView!.image = note["image"] as? UIImage
		
		return cell
	}
}

/// GraphDelegate delegation methods.
extension ViewController: GraphDelegate {
	/// GraphDelegate delegation method that is executed on Entity inserts.
	public func graphDidInsertEntity(graph: Graph, entity: Entity) {
		notes.append(entity)
		tableView.reloadData()
	}
}
