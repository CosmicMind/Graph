//
//  ItemCollectionViewCell.swift
//  GraphKitListManager
//
//  Created by Daniel Dahan on 2015-03-08.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import Foundation
import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
	override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes! {
		var attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as UICollectionViewLayoutAttributes
		
		var newFrame = attr.frame
		self.frame = newFrame
		
		self.setNeedsLayout()
		self.layoutIfNeeded()
		
		let desiredHeight: CGFloat = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
		newFrame.size.height = desiredHeight
		attr.frame = newFrame
		return attr
	}
}