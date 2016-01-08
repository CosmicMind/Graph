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
The following ViewController exemplifies the usage of Bond objects forming
relationships between Entity objects. In this example, there are User and 
Book Entity types that are related through an Author relationship. 

For example:	User is Author of Book.

The User is the sbject of the relationship.
The Author is the relationship.
The Book is the object of the relationship.
*/

import UIKit
import GraphKit

public class ViewController: UIViewController {
	/// Access the Graph persistence layer.
	private lazy var graph: Graph = Graph()
	
	/// A tableView used to display Bond entries.
	public let tableView: UITableView = UITableView()
	
	/// A list of all the Author Bond types.
	public var authors: Array<Bond> = Array<Bond>()
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		prepareGraph()
		prepareAuthors()
		prepareTableView()
		prepareNavigationBarItems()
	}
	
	/// Prepares the Graph instance.
	public func prepareGraph() {
		graph.delegate = self
		
		/*
		Rather than searching the Note Entity types on each
		insert, the Graph Watch API is used to update the
		notes Array. This allows a single search query to be
		made when loading the ViewController.
		*/
		graph.watchForBond(types: ["Author"])
	}
	
	/// Prepares the authors Array.
	public func prepareAuthors() {
		authors = graph.searchForBond(types: ["Author"])
		
		// Add Author relationships if none exist.
		if 0 == authors.count {
			// Create some User Entity types.
			let user1: Entity = Entity(type: "User")
			user1["name"] = "Eve"
			
			let user2: Entity = Entity(type: "User")
			user2["name"] = "Daniel"
			
			let user3: Entity = Entity(type: "User")
			user3["name"] = "Dima"
			
			// Create some Book Entity types.
			let book1: Entity = Entity(type: "Book")
			book1["title"] = "Yoga For Everyone"
			
			let book2: Entity = Entity(type: "Book")
			book2["title"] = "Learning GraphKit"
			
			let book3: Entity = Entity(type: "Book")
			book3["title"] = "Beautiful Design"
			
			// Create some Author Bond types.
			let author1: Bond = Bond(type: "Author")
			let author2: Bond = Bond(type: "Author")
			let author3: Bond = Bond(type: "Author")
			
			// Make relationships.
			author1.subject = user1
			author1.object = book1
			
			author2.subject = user2
			author2.object = book2
			
			author3.subject = user3
			author3.object = book3
			
			/*
			The graph.save call triggers an asynchronous callback
			that may be used for various benefits. As well, since
			the graph is watching Author Bond types, the
			graphDidInsertBond delegate method is executed once
			the save is complete.
			*/
			graph.save { (success: Bool, error: NSError?) in
				if let e: NSError = error {
					print(e)
				}
			}
		}
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
		// Create a User Entity types.
		let user: Entity = Entity(type: "User")
		user["name"] = "Anonymous"
		
		// Create a Book Entity types.
		let book: Entity = Entity(type: "Book")
		book["title"] = "A New Book Title"
		
		// Create a Author Bond types.
		let author: Bond = Bond(type: "Author")
		
		// Make relationships.
		author.subject = user
		author.object = book
		
		/*
		The graph.save call triggers an asynchronous callback
		that may be used for various benefits. As well, since
		the graph is watching Author Bond types, the
		graphDidInsertBond delegate method is executed once
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
		return authors.count;
	}
	
	/// Prepares the cells within the tableView.
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")

		// Get the Bond relationship.
		let author: Bond = authors[indexPath.row]
		
		// Set the Bookk title if it exists.
		if let title: String = author.object?["title"] as? String {
			cell.textLabel?.text = title
		}
		
		// Set the User name if it exists.
		if let name: String = author.subject?["name"] as? String {
			cell.detailTextLabel?.text = "Written By: \(name)"
		}
		
		return cell
	}
}

/// GraphDelegate delegation methods.
extension ViewController: GraphDelegate {
	/**
	GraphDelegate delegation method that is executed
	on Author Bond inserts.
	*/
	public func graphDidInsertBond(graph: Graph, bond: Bond) {
		authors.append(bond)
		tableView.reloadData()
	}
}
