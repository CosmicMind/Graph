//
//  FocusGroupsViewController.swift
//  Focus
//
//  Created by Daniel Dahan on 2015-02-15.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import UIKit
import GKGraphKit

class ListViewController: UIViewController, GKGraphDelegate {
	
	let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
	var collectionView: UICollectionView?
	var groups: Dictionary<String, Array<GKEntity>>?
	var keys: Array<String>?
	lazy var graph: GKGraph = GKGraph()
	
	// #pragma mark View Handling
	override func viewDidLoad() {
		super.viewDidLoad()
		
		graph.delegate = self
		graph.watch(Action: "AddTask")
		graph.watch(Action: "OpenGroup")
		
		// background color
		view.backgroundColor = .whiteColor()
		
		groupsReload()
	}
	
	override func viewWillAppear(animated: Bool) {
		if nil != groups {
			groupsReload()
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		// handle search bar
		for subView: AnyObject in navigationController!.navigationBar.subviews {
			if subView is UISearchBar {
				subView.removeFromSuperview()
				break
			}
		}
	}
	
	// #pragma mark Selectors
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
		label.text = keys![indexPath.row]
		label.textColor = UIColor(red: 0/255.0, green: 145/255.0, blue: 254/255.0, alpha: 1.0)
		
		cell.addSubview(label)
		
		return cell
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return keys!.count
	}
	
	func groupsReload() {
		groups = graph.searchForEntityGroups()
		keys = Array<String>()
		for key in groups!.keys {
			keys!.append(key)
		}
		NSLog("%@", keys!)
		collectionView!.reloadData()
	}
	
	// #pragma mark GKGraphDelegate
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
		groupsReload()
	}
	
	func graph(graph: GKGraph!, didUpdateEntity entity: GKEntity!, property: String!, value: AnyObject!) {
		groupsReload()
	}
}