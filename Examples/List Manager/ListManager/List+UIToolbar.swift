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
			var imageView: UIImageView? = findHairlineImageViewUnder(subView as! UIView)
			if nil != imageView {
				return imageView
			}
		}
		return nil
	}
}