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

class ViewController: UIViewController {
    /// View.
    internal var dateFormatter: DateFormatter!
    internal var card: Card!
    
    /// Model.
    internal var graph: Graph!
    internal var search: Search<Entity>!
    internal var model: Entity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareGraph()
        prepareSearch()
        prepareModel()
        
        prepareDateFormatter()
        prepareCard()
    }
}

/// Model.
extension ViewController {
    internal func createModel() -> Entity {
        let entity = Entity(type: "Card")
        
        entity["title"] = "Graph"
        entity["detail"] = "Build Intelligent Software"
        entity["content"] = "Graph is a semantic database that requires zero configuration. It is incredible for machine learning, shopping systems, complex architectures, and general purpose use."
        
        /// To save the model data synchronously, use the sync method.
        graph.sync()
        
        return entity
    }
    
    internal func prepareGraph() {
        graph = Graph()
        
        // Uncomment to clear the Graph data.
        graph.clear()
    }
    
    internal func prepareSearch() {
        /// Add the Graph instance you would like to search from.
        search = Search<Entity>(graph: graph).for(types: ["Card"])
    }
    
    internal func prepareModel() {
        /// To search for the model data synchronously, use the sync method.
        let cards = search.sync()
        
        guard let entity = cards.first else {
            model = createModel()
            return
        }
        
        model = entity
    }
}

/// Card.
extension ViewController {
    internal func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    internal func prepareCard() {
        card = Card()
        
        card.toolbar = Toolbar()
        
        /// Use the property subscript to access the model data.
        card.toolbar?.title = model["title"] as? String
        card.toolbar?.detail = model["detail"] as? String
        
        card.toolbarEdgeInsetsPreset = .square3
        card.toolbarEdgeInsets.bottom = 0
        
        let contentLabel = UILabel()
        contentLabel.text = model["content"] as? String
        contentLabel.font = RobotoFont.regular(with: 14)
        contentLabel.numberOfLines = 0
        
        card.contentView = contentLabel
        card.contentViewEdgeInsetsPreset = .square3
        
        card.bottomBar = Bar()
        
        let favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
        card.bottomBar?.rightViews = [favoriteButton]
        card.bottomBarEdgeInsetsPreset = .wideRectangle3
        card.bottomBarEdgeInsets.top = 0
        
        let dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.text = dateFormatter.string(from: model.createdDate)
        
        card.bottomBar?.leftViews = [dateLabel]
        
        view.layout(card).horizontally(left: 20, right: 20).center()
    }
}

