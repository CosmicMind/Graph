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
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(list: GKEntity!) {
		super.init(nibName: nil, bundle: nil)
		self.list = list
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
		layout.headerReferenceSize = CGSizeMake(0, 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 10
		layout.scrollDirection = .Vertical
		layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
		
		// collection view
		collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
		collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
		collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = .clearColor()
		collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
		view.addSubview(collectionView)
		
		// toolbar
		toolbar.setTranslatesAutoresizingMaskIntoConstraints(false)
		toolbar.hideBottomHairline()
		toolbar.barTintColor = .whiteColor()
		toolbar.clipsToBounds = true
		toolbar.sizeToFit()
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
		
		// autolayout commands
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[toolbar]|", options: nil, metrics: nil, views: ["toolbar": toolbar]))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: nil, metrics: nil, views: ["collectionView": collectionView]))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView][toolbar]|", options: nil, metrics: nil, views: ["collectionView": collectionView, "toolbar": toolbar]))
		
		// orientation change
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
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
	
	// orientation changes
	func orientationDidChange(sender: UIRotationGestureRecognizer) {
		// calling reload on orientation change
		// updates the cell sizes
		collectionView.reloadData()
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
		
		let item: GKEntity = items![indexPath.row]
		
		let font: UIFont = UIFont(name: "Helvetica Neue", size: 20)!
		var label: UILabel = UILabel(frame: cell.bounds)
		label.textAlignment = .Left
		label.font = font
		label.backgroundColor = .grayColor()
		label.lineBreakMode = .ByWordWrapping
		label.numberOfLines = 0
		label.text = item["note"] as? String
		
		var imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
		let photo: AnyObject = item["photo"]!
		imageView.image = photo as? UIImage
		println("\(photo.size)")
		cell.addSubview(imageView)
		cell.addSubview(label)
		
		
		cell.backgroundColor = .whiteColor()
		
		return cell
	}
	
	// dynamically sizes the cell based on the content
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		
		// generate the size that the text affects
		let font: UIFont = UIFont(name: "Helvetica Neue", size: 20)!
		let width: Double? = Double(collectionView.bounds.width - 20)
		let text: String = items![indexPath.row]["note"]! as String
		let r: CGSize = font.sizeOfString(text, constrainedToWidth: width)
		
		return CGSizeMake(collectionView.bounds.width - 20, r.height)
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items!.count
	}
}