/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material
import Graph

public enum CellSize: Int {
    case small = 100
    case medium = 200
    case large = 300
}

class FeedTableViewCell: TableViewCell {
    public lazy var card: ImageCard = ImageCard()
    
    public var cellSize = CellSize.medium
    
    public var data: Entity? {
        didSet {
            reload()
        }
    }
    
    open override var height: CGFloat {
        get {
            card.layoutIfNeeded()
            
            var h = card.toolbar?.height ?? 0
            h += card.bottomBar?.height ?? 0
            
            h += CGFloat(cellSize.rawValue)
            
            return h
        }
        set(value) {
            super.height = value
        }
    }
    
    private func reload() {
        card.width = width
        card.toolbar?.title = data?["title"] as? String
        card.imageView?.image = data?["photo"] as? UIImage
        card.imageView?.contentMode = .scaleAspectFill
    }
    
    open override func prepare() {
        super.prepare()
        preparePresenterCard()
        layer.rasterizationScale = Device.scale
        layer.shouldRasterize = true
    }
    
    private func preparePresenterCard() {
        card.toolbar = Toolbar()
        card.toolbarAlignment = .top
        
        card.imageView = UIImageView()
        layout(card).edges()
    }
}
