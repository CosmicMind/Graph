//
//  ListToolbar.swift
//  GraphKitListManager
//
//  Created by Daniel Dahan on 2015-03-06.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import UIKit
import GKGraphKit

class ListToolbar: UIToolbar {
	
	// localized graph instance to connect
	lazy var graph: GKGraph = GKGraph()
	
	lazy var flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	lazy var focusButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add")
	
	func displayAddView() {
		setItems([flexibleSpace, focusButton, flexibleSpace], animated: true)
	}
	
	// #pragma mark Selectors
	func add() {
		// create the Action instance
		var action: GKAction = GKAction(type: "AddTask")
		
		// get our User Entity created in the ListViewController.swift file
		let user: GKEntity? = graph.search(Entity: "User").last;
		
		// add the user as the Subject of the Action
		action.addSubject(user)
		
		// lets create a User Entity that will be used throughout the app.
		var button: GKEntity? = graph.search(Entity: "ToolbarButton").last
		if nil == button {
			button = GKEntity(type: "ToolbarButton")
			
			// this saves the user to the Graph
			graph.save() { (success: Bool, error: NSError?) in }
		}
		
		
		action.addObject(button)
		graph.save() { (success: Bool, error: NSError? ) in }
	}
}
