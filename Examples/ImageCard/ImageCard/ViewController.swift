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

extension UIImage {
    public class func load(contentsOfFile name: String, ofType type: String) -> UIImage? {
        return UIImage(contentsOfFile: Bundle.main.path(forResource: name, ofType: type)!)
    }
}

class ViewController: UIViewController {
    /// View.
    internal var imageCard: ImageCard!
    
    /// Model.
    internal var graph: Graph!
    internal var search: Search<Entity>!
    internal var entity: Entity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        // Prepare model.
        prepareGraph()
        prepareSearch()
        prepareModel()
        
        // Prepare view.
        prepareImageCard()
    }
}

/// Model.
extension ViewController {
    internal func createSampleData() {
        entity = Entity(type: "ImageCard")
        
        entity["title"] = "Graph"
        entity["detail"] = "Build Data-Driven Software"
        entity["image"] = UIImage.load(contentsOfFile: "frontier", ofType: "jpg")?.resize(toWidth: view.width)
        entity["content"] = "Graph is a semantic database that is used to create data-driven applications."
        entity["author"] = "CosmicMind"
        
        /// To save the model data synchronously, use the sync method.
        graph.sync()
    }
    
    internal func prepareGraph() {
        graph = Graph()
        
        // Uncomment to clear the Graph data.
//        graph.clear()
    }
    
    internal func prepareSearch() {
        /// Add the Graph instance you would like to search from.
        search = Search<Entity>(graph: graph).for(types: ["ImageCard"])
    }
    
    internal func prepareModel() {
        /// To search for the model data synchronously, use the sync method.
        let imageCards = search.sync()
        
        guard let e = imageCards.first else {
            createSampleData()
            return
        }
        
        entity = e
    }
}

/// ImageCard.
extension ViewController {
    internal func prepareImageCard() {
        imageCard = ImageCard()
        view.layout(imageCard).horizontally(left: 20, right: 20).center()
        
        prepareToolbar()
        prepareImageView()
        prepareContentView()
        prepareBottomBar()
    }
    
    private func prepareToolbar() {
        imageCard.toolbar = Toolbar()
        imageCard.toolbar?.backgroundColor = .clear
        imageCard.toolbarEdgeInsetsPreset = .square3
        
        // Use the property subscript to access the model data.
        imageCard.toolbar?.title = entity["title"] as? String
        imageCard.toolbar?.titleLabel.textColor = .white
        
        imageCard.toolbar?.detail = entity["detail"] as? String
        imageCard.toolbar?.detailLabel.textColor = .white
    }
    
    private func prepareImageView() {
        imageCard.imageView = UIImageView()
        imageCard.imageView?.image = entity["image"] as? UIImage
    }
    
    private func prepareContentView() {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.text = entity["content"] as? String
        contentLabel.font = RobotoFont.regular(with: 14)
        
        imageCard.contentView = contentLabel
        imageCard.contentViewEdgeInsetsPreset = .square3
    }
    
    private func prepareBottomBar() {
        let shareButton = IconButton(image: Icon.cm.share, tintColor: Color.blueGrey.base)
        let favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
        
        let authorLabel = UILabel()
        authorLabel.text = entity["author"] as? String
        authorLabel.textAlignment = .center
        authorLabel.textColor = Color.blueGrey.base
        authorLabel.font = RobotoFont.regular(with: 12)
        
        imageCard.bottomBar = Bar()
        imageCard.bottomBarEdgeInsetsPreset = .wideRectangle2
        imageCard.bottomBarEdgeInsets.top = 0
        
        imageCard.bottomBar?.leftViews = [favoriteButton]
        imageCard.bottomBar?.centerViews = [authorLabel]
        imageCard.bottomBar?.rightViews = [shareButton]
    }
}

