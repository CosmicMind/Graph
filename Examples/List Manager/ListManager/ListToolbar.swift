/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import UIKit
import GKGraphKit

class ListToolbar: UIToolbar {
	
	// localized graph instance to connect
	lazy var graph: GKGraph = GKGraph()
	
	lazy var flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	lazy var focusButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem")
	
	func displayAddView() {
		setItems([flexibleSpace, focusButton, flexibleSpace], animated: true)
	}
	
	// #pragma mark Selectors
	func addItem() {
		// create the Action instance
		var action: GKAction = GKAction(type: "Clicked")
		
		// get our User Entity created in the ListViewController file
		let user: GKEntity? = graph.search(Entity: "User").last;
		
		// add the user as a Subject for the Action
		action.addSubject(user)
		
		// lets create a User Entity that will be used throughout the app.
		var button: GKEntity? = graph.search(Entity: "AddItemButton").last
		if nil == button {
			button = GKEntity(type: "AddItemButton")
			button!.addGroup("UIButton")
		}
		
		// add the button as an Object for the Action
		action.addObject(button)
		
		// save everything to the Graph
		graph.save() { (success: Bool, error: NSError? ) in }
	}
}