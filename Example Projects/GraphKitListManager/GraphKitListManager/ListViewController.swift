//
//  FocusGroupsViewController.swift
//  Focus
//
//  Created by Daniel Dahan on 2015-02-15.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import UIKit
import GKGraphKit

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GKGraphDelegate {
	
	let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
	var collectionView: UICollectionView?
	lazy var toolbar: ListToolbar = ListToolbar()
	
	// ViewController property value.
	// May also be setup as a local variable in any function
	// and maintain synchronization.
	lazy var graph: GKGraph = GKGraph()
	
	
	// #pragma mark View Handling
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// background color
		view.backgroundColor = .whiteColor()
		
		// toolbar
		toolbar.hideBottomHairline()
		toolbar.barTintColor = .whiteColor()
		toolbar.clipsToBounds = true
		toolbar.sizeToFit()
		toolbar.frame.origin.y = view.frame.size.height - 44.0
		toolbar.displayAddView()
		view.addSubview(toolbar)

		// set the graph as a delegate
		graph.delegate = self
		
		// watch the AddTask Action
		graph.watch(Action: "AddTask")
		
		// lets create a User Entity that will be used throughout the app.
		var user: GKEntity? = graph.search(Entity: "User").last
		if nil == user {
			user = GKEntity(type: "User")
			// this saves the user to the Graph
			graph.save() { (success: Bool, error: NSError?) in }
		}
		
	}
	
	override func viewWillAppear(animated: Bool) {
		
	}
	
	override func viewWillDisappear(animated: Bool) {
		
	}
	
	// Add the watch task delegate callback when this event
	// is saved to the Graph instance.
	func graph(graph: GKGraph!, didInsertAction action: GKAction!) {
		
	}
	
	// #pragma mark ScrollViewDelegate
	func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
	
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
	
	}
	
	// #pragma mark CollectionViewDelegate
	func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
	
		return true
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell;
		
		// clear before reuse
		for subView: AnyObject in cell.subviews {
			subView.removeFromSuperview()
		}
		
		var label: UILabel = UILabel(frame: CGRectMake(10.0, 0, collectionView.frame.size.width - 20.0, 30.0))
		label.font = UIFont(name: "Roboto", size: 20.0)
//		label.text = keys![indexPath.row]
		label.textColor = UIColor(red: 0/255.0, green: 145/255.0, blue: 254/255.0, alpha: 1.0)
		
		cell.addSubview(label)
		
		return cell
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		return keys!.count
		return 0;
	}
}