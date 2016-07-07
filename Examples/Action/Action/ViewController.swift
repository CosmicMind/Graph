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

/*
The following ViewController exemplifies the usage of Actions.
In this example, there are Company Entity types that are
related through an Acquired Action.

For example:	CompanyA Acquired CompanyB.

CompanyA is a sbject of the Action.
Acquired is the Action type.
CompanyB is an object of the Action.
*/

import UIKit
import Graph

class ViewController: UIViewController {
	/// Access the Graph persistence layer.
	private lazy var graph = Graph()
	
	/// A tableView used to display Action entries.
	private let tableView = UITableView()
	
	/// A list of all the acquisition Actions.
	private var acquisitions = [Action]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareGraph()
		prepareAcquisitions()
		prepareTableView()
	}
	
	/// Prepares the Graph instance.
	private func prepareGraph() {
		/*
		Rather than searching the Acquired Actions on each
		insert, the Graph Watch API is used to update the
		acquisitions Array. This allows a single search query to be
		made when loading the ViewController.
		*/
		graph.delegate = self
		graph.watchForAction(types: ["Acquired"])
	}
	
	/// Prepares the acquisitions Array.
	private func prepareAcquisitions() {
		acquisitions = graph.searchForAction(types: ["Acquired"])
		
		// Add Acquired Actions if none exist.
		if 0 == acquisitions.count {
			// Create Company Entities.
			let apple = Entity(type: "Company")
			apple["name"] = "Apple"
			apple["photo"] = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Apple", ofType: "png")!)
			
			let beats = Entity(type: "Company")
			beats["name"] = "Beats Electronics"
			beats["photo"] = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Beats", ofType: "png")!)
			
			let facebook = Entity(type: "Company")
			facebook["name"] = "Facebook"
			facebook["photo"] = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Facebook", ofType: "png")!)
			
			let whatsapp = Entity(type: "Company")
			whatsapp["name"] = "WhatsApp"
			whatsapp["photo"] = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("WhatsApp", ofType: "png")!)
			
			// Create Acquired Actions.
			let acquisition1 = Action(type: "Acquired")
			acquisition1["acquisitionDate"] = "May 28, 2014"
			
			let acquisition2 = Action(type: "Acquired")
			acquisition2["acquisitionDate"] = "February 19, 2014"
			
			// Form relationships.
			acquisition1.addSubject(apple)
			acquisition1.addObject(beats)
			
			acquisition2.addSubject(facebook)
			acquisition2.addObject(whatsapp)
			
            /*
             The graph.async call triggers an asynchronous callback
             that may be used for various benefits. As well, since
             the graph is watching Person Entities, the
             graphDidInsertEntity delegate method is executed once
             the save has completed.
             */
            graph.async { (success: Bool, error: NSError?) in
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
}

/// GraphDelegate delegation methods.
extension ViewController: GraphDelegate {
	/// GraphDelegate delegation method that is executed on Action inserts.
    func graphDidInsertAction(graph: Graph, action: Action, fromCloud: Bool) {
		acquisitions.append(action)
		tableView.reloadData()
	}
}


/// TableViewDataSource methods.
extension ViewController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return acquisitions.count
	}
	
	/// Returns the number of sections.
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
		
		if 0 == indexPath.section {
			// Get the Action.
			let acquisition = acquisitions[indexPath.row]
			
			// Set the Company details.
			if let company = acquisition.subjects.first {
				cell.textLabel?.text = company["name"] as? String
				cell.imageView?.image = company["photo"] as? UIImage
			}
			
			// Set the Company details.
			if let company = acquisition.objects.first {
				cell.detailTextLabel?.text = "Bought: " + (company["name"] as! String)
			}
		} else {
			// Get the Action.
			let acquisition = acquisitions[indexPath.row]
			
			// Set the Company details.
			if let company = acquisition.objects.first {
				cell.textLabel?.text = company["name"] as? String
				cell.imageView?.image = company["photo"] as? UIImage
			}
			
			// Set the Company details.
			if let company = acquisition.subjects.first {
				cell.detailTextLabel?.text = "Sold To: " + (company["name"] as! String)
			}
		}
		
		return cell
	}
	
	/// Prepares the header within the tableView.
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UIView(frame: CGRectMake(0, 0, view.bounds.width, 48))
		header.backgroundColor = .whiteColor()
		
		let label = UILabel(frame: CGRectMake(16, 0, view.bounds.width - 32, 48))
		label.textColor = .grayColor()
		label.text = 0 == section ? "Buyer" : "Seller"
		
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
