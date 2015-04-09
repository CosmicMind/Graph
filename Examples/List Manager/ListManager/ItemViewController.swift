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

class ItemViewController: UIViewController, UITextViewDelegate {
	
	private var item: GKEntity?
	private lazy var graph: GKGraph = GKGraph()
	private lazy var textView: UITextView = UITextView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(item: GKEntity!) {
		super.init(nibName: nil, bundle: nil)
		self.item = item
	}
	
	// #pragma mark View Handling
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// background color
		view.backgroundColor = .whiteColor()
		
		textView.delegate = self
		textView.text = item!["note"] as? String
		view.addSubview(textView)
	}
	
	override func viewWillAppear(animated: Bool) {
		
	}
	
	override func viewDidAppear(animated: Bool) {
		var rightButton: UIBarButtonItem
		if nil == item!["note"] {
			textView.becomeFirstResponder()
			rightButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: "saveTask")
		} else {
			rightButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "saveTask")
		}
		navigationController!.navigationBar.topItem!.rightBarButtonItem = rightButton
	}
	
	override func viewWillDisappear(animated: Bool) {
		navigationController!.navigationBar.topItem!.rightBarButtonItem = nil
		
		if 0 == count(textView.text) {
			item?.delete()
		}
	}
	
	// MARK: - Selectors
	
	func saveTask() {
		if 0 < count(textView.text) {
			item!["note"] = textView.text
			let photo: String = NSBundle.mainBundle().pathForResource("GraphKitLogo", ofType: "png")!
			item!["photo"] = UIImage(contentsOfFile: photo)
			graph.save() { (success: Bool, error: NSError?) in }
		}
		navigationController!.popViewControllerAnimated(true)
	}
}
