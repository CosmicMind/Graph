//
//  FocusGroupsViewController.swift
//  Focus
//
//  Created by Daniel Dahan on 2015-02-15.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

//extension UICollectionViewCell {
// 
//	override var bounds : CGRect {
//		didSet {
//			// Fix autolayout constraints broken in Xcode 6 GM + iOS 7.1
//			self.contentView.frame = bounds
//		}
//	}
// 
//}

import UIKit
import GKGraphKit

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GKGraphDelegate {

	private let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
	private var collectionView: UICollectionView!
	private lazy var toolbar: ListToolbar = ListToolbar()
	private lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
	private let list: GKEntity!
	
	// ViewController property value.
	// May also be setup as a local variable in any function
	// and maintain synchronization.
	private lazy var graph: GKGraph = GKGraph()
	private var items: Array<GKEntity>?
	
	// rotation handling
	private var rotationRecognizer: UIRotationGestureRecognizer!
	private var rotationAngleInRadians = 0.0 as CGFloat
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(list: GKEntity!) {
		super.init(nibName: nil, bundle: nil)
		self.list = list
		rotationRecognizer = UIRotationGestureRecognizer(target: self, action: "handleRotations:")
	}
	
	func handleRotations(sender: UIRotationGestureRecognizer) {
		collectionView.reloadData()
		
		/* At the end of the rotation, keep the angle for later use */
		if sender.state == .Ended{
			rotationAngleInRadians += sender.rotation;
		}
		println("HELLO")
	}
	
	// #pragma mark View Handling
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set the graph as a delegate
		graph.delegate = self
		
		// watch the Clicked Action
		graph.watch(Action: "Clicked")
		
		// watch for changes in Items
		graph.watch(Entity: "Item")
		
		// flow layout for collection view
		layout.itemSize = CGSizeMake(view.bounds.width - 20, 100)
		layout.headerReferenceSize = CGSizeMake(0, 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 10
		layout.scrollDirection = .Vertical
		layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
		
		// collection view
		collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
		collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = .clearColor()
		collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
		collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
		view.addSubview(collectionView)
		
		// toolbar
		toolbar.setTranslatesAutoresizingMaskIntoConstraints(false)
		toolbar.hideBottomHairline()
		toolbar.barTintColor = .whiteColor()
		toolbar.clipsToBounds = true
		toolbar.sizeToFit()
		toolbar.frame.origin.y = view.bounds.height - 44
		toolbar.displayAddView()
		view.addSubview(toolbar)
		
		// tool bar constraints
		view.addConstraint(NSLayoutConstraint(
			item: toolbar,
			attribute: .Bottom,
			relatedBy: .Equal,
			toItem: view,
			attribute: .Bottom,
			multiplier: 1,
			constant: 0
		))
		
		view.addConstraint(NSLayoutConstraint(
			item: toolbar,
			attribute: .Width,
			relatedBy: .Equal,
			toItem: view,
			attribute: .Width,
			multiplier: 1,
			constant: 0
		))
		
		view.addConstraint(NSLayoutConstraint(
			item: collectionView,
			attribute: .Height,
			relatedBy: .Equal,
			toItem: view,
			attribute: .Height,
			multiplier: 1,
			constant: -toolbar.bounds.height
		))
		
		view.addConstraint(NSLayoutConstraint(
			item: collectionView,
			attribute: .Width,
			relatedBy: .Equal,
			toItem: view,
			attribute: .Width,
			multiplier: 1,
			constant: 0
		))

		view.addGestureRecognizer(rotationRecognizer)
	}
	
	override func viewWillAppear(animated: Bool) {
		// fetch all the items in the list
		items = graph.search(Entity: "Item")
		collectionView?.reloadData()
	}
	
	override func viewWillDisappear(animated: Bool) {
		
	}
	
	func graph(graph: GKGraph!, didInsertEntity entity: GKEntity!) {
		let bond: GKBond = GKBond(type: "ItemOf")
		bond.subject = list
		bond.object = entity
		println("\(bond)")
		println("\(entity.bonds.count)")
	}
	
	func graph(graph: GKGraph!, didDeleteEntity entity: GKEntity!) {
		println("\(entity.bonds.count)")
	}
	
	// Add the watch item delegate callback when this event
	// is saved to the Graph instance.
	func graph(graph: GKGraph!, didInsertAction action: GKAction!) {
		
		// prepare the Item that will be used to launch the new
		// ViewController
		var item: GKEntity?
		
		if "AddItemButton" == action.objects.last?.type {
			
			// passing a newly created Item
			item = GKEntity(type: "Item")
		
		} else if "Item" == action.objects.last?.type {
			
			// clicking a collection cell and passing the Item
			item = action.objects.last!
		}
		
		var itemViewController: ItemViewController = ItemViewController(item: item)
		navigationController!.pushViewController(itemViewController, animated: true)
	}
	
	// #pragma mark CollectionViewDelegate
	func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		let action: GKAction = GKAction(type: "Clicked")
		let user: GKEntity = graph.search(Entity: "User").last!
		action.addSubject(user)
		action.addObject(items![indexPath.row])
		graph.save() { (success: Bool, error: NSError?) in }
		return true
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell;
		
		// clear before reuse
		for subView: AnyObject in cell.subviews {
			subView.removeFromSuperview()
		}
		
		cell.backgroundColor = .whiteColor()
		
		var label: UILabel = UILabel(frame: cell.bounds)
		label.font = UIFont(name: "Roboto", size: 20.0)
		label.text = items![indexPath.row]["note"] as? String
		label.textColor = UIColor(red: 0/255.0, green: 145/255.0, blue: 254/255.0, alpha: 1.0)
		cell.addSubview(label)
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(collectionView.bounds.width - 20, 100)
	}
	
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		// tool bar constraints
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items!.count
	}
}