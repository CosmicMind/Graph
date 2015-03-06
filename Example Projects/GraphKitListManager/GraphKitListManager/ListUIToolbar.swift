//
//  ListUIToolbar.swift
//  GraphKitListManager
//
//  Created by Daniel Dahan on 2015-03-06.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import UIKit

extension UIToolbar {
	
	func hideBottomHairline() {
		var imageView: UIImageView? = findHairlineImageViewUnder(self)
		if nil != imageView {
			imageView!.hidden = true
		}
	}
	
	func showBottomHairline() {
		var imageView: UIImageView? = findHairlineImageViewUnder(self)
		if nil != imageView {
			imageView!.hidden = false
		}
	}
	
	func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
		if (view is UIImageView) && (1.0 >= view.bounds.size.height) {
			return view as? UIImageView
		}
		for subView: AnyObject in view.subviews {
			var imageView: UIImageView? = findHairlineImageViewUnder(subView as UIView)
			if nil != imageView {
				return imageView
			}
		}
		return nil
	}
}