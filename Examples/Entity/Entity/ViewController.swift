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
The following ViewController exemplifies the usage of Entities. 
In this example, there are Person Entity types that are displayed 
in a list.
*/

import UIKit
import GraphKit

class ViewController: UIViewController {
	/// Access the Graph persistence layer.
	private lazy var graph: Graph = Graph()
	
	/// A tableView used to display Entity entries.
	private let tableView: UITableView = UITableView()
	
	/// A list of all the Person Entities.
	private var people: Array<Entity> = Array<Entity>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareGraph()
		preparePeople()
		prepareTableView()
		prepareNavigationBarItems()
	}
	
	/// Handles the add button event.
	internal func handleAddButton(sender: UIBarButtonItem) {
		// Create a Person Entity.
		let person: Entity = Entity(type: "Person")
		person["firstName"] = "First"
		person["lastName"] = "Last"
		person["photo"] = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Avatar", ofType: "png")!)
		
		/*
		The graph.save call triggers an asynchronous callback
		that may be used for various benefits. As well, since
		the graph is watching Person Entities, the
		graphDidInsertEntity delegate method is executed once
		the save has completed.
		*/
		graph.save { (success: Bool, error: NSError?) in
			if let e: NSError = error {
				print(e)
			}
		}
	}
	
	/// Prepares the Graph instance.
	private func prepareGraph() {
		/*
		Rather than searching the Person Entities on each
		insert, the Graph Watch API is used to update the
		people Array. This allows a single search query to be
		made when loading the ViewController.
		*/
		graph.delegate = self
		graph.watchForEntity(types: ["Person"])
	}
	
	/// Prepares the people Array.
	private func preparePeople() {
		people = graph.searchForEntity(types: ["Person"])
		
		// Add People if none exist.
		if 0 == people.count {
			// Create Person Entities.
			let tim: Entity = Entity(type: "Person")
			tim["firstName"] = "Tim"
			tim["lastName"] = "Cook"
			tim["photo"] = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("TimCook", ofType: "png")!)
			
			let mark: Entity = Entity(type: "Person")
			mark["firstName"] = "Mark"
			mark["lastName"] = "Zuckerberg"
			mark["photo"] = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("MarkZuckerberg", ofType: "png")!)
			
			let elon: Entity = Entity(type: "Person")
			elon["firstName"] = "Elon"
			elon["lastName"] = "Musk"
			elon["photo"] = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("ElonMusk", ofType: "png")!)
			
			/*
			The graph.save call triggers an asynchronous callback
			that may be used for various benefits. As well, since
			the graph is watching Person Entities, the
			graphDidInsertEntity delegate method is executed once
			the save has completed.
			*/
			graph.save { (success: Bool, error: NSError?) in
				if let e: NSError = error {
					print(e)
				}
			}
		}
	}
	
	/// Prepares the tableView.
	private func prepareTableView() {
		tableView.frame = view.bounds
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.dataSource = self
		tableView.delegate = self
		view.addSubview(tableView)
	}
	
	/// Prepares the navigation bar items.
	private func prepareNavigationBarItems() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "handleAddButton:")
	}
}

/// GraphDelegate delegation methods.
extension ViewController: GraphDelegate {
	/// GraphDelegate delegation method that is executed on Entity inserts.
	func graphDidInsertEntity(graph: Graph, entity: Entity) {
		people.append(entity)
		tableView.reloadData()
	}
}


/// TableViewDataSource methods.
extension ViewController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return people.count
	}
	
	/// Returns the number of sections.
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
		
		// Get the Person Entity.
		let person: Entity = people[indexPath.row]
		
		// Set the Person details.
		cell.textLabel?.text = (person["firstName"] as! String) + " " + (person["lastName"] as! String)
		cell.imageView?.image = person["photo"] as? UIImage
		
		return cell
	}
	
	/// Prepares the header within the tableView.
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UIView(frame: CGRectMake(0, 0, view.bounds.width, 48))
		header.backgroundColor = .whiteColor()
		
		let label: UILabel = UILabel(frame: CGRectMake(16, 0, view.bounds.width - 32, 48))
		label.textColor = .grayColor()
		label.text = "People"
		
		header.addSubview(label)
		return header
	}
}

/// UITableViewDelegate methods.
extension ViewController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
	
	/// Sets the tableView header height.
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 48
	}
}
