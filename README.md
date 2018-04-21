![Graph](http://www.cosmicmind.com/graph/github/graph-logo.png)

## Welcome to Graph

Graph is a semantic database that is used to create data-driven applications.

![Material Sample](http://cosmicmind.com/samples/github/page-tab-bar-controller-2.png)

* [Download the latest sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/CardTableView).

## Features

- [x] iCloud Support
- [x] Multi Local & Cloud Graphs
- [x] Thread Safe
- [x] Store Any Data Type, Including Binary Data
- [x] Relationship Modeling
- [x] Action Modeling For Analytics
- [x] Model With Graph Theory and Set Theory
- [x] Asynchronous / Synchronous Search
- [x] Asynchronous / Synchronous Saving
- [x] Data-Driven Architecture
- [x] Data Model Observation
- [x] Comprehensive Unit Test Coverage
- [x] Example Projects

## Requirements

* iOS 8.0+ / Mac OS X 10.10+
* Xcode 8.0+

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cosmicmind). (Tag 'cosmicmind')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cosmicmind).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Yosemite (10.10).**
> - [Download Graph](https://github.com/CosmicMind/Graph/archive/master.zip)

Visit the [Installation](https://github.com/CosmicMind/Graph/wiki/Installation) page to learn how to install Graph using [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).

## Changelog

Graph is a growing project and will encounter changes throughout its development. It is recommended that the [Changelog](https://github.com/CosmicMind/Graph/wiki/Changelog) be reviewed prior to updating versions.

# Samples

The following are samples to see how Graph may be used within your applications.

* Visit the [Samples](https://github.com/CosmicMind/Samples) repo to see example projects using Graph.

## Creating an Entity for an ImageCard

An **Entity** is a model (data) object that represents a **person**, **place**, or **thing**. It may store property values, be a member of groups, and can be tagged.

In the following example, we create an ImageCard view using Material and populate it's properties with an Entity that stores the data for that view.

![Material ImageCard](http://www.cosmicmind.com/gifs/white/image-card.gif)

#### Creating data

```swift
let graph = Graph()

let entity = Entity(type: "ImageCard")
entity["title"] = "Graph"
entity["detail"] = "Build Data-Driven Software"
entity["content"] = "Graph is a semantic database that is used to create data-driven applications."
entity["author"] = "CosmicMind"
entity["image"] = UIImage.load(contentsOfFile: "frontier", ofType: "jpg")

graph.sync()
```

#### Setting the view's properties

```swift
imageCard.toolbar?.title = entity["title"] as? String
imageCard.toolbar?.detail = entity["detail"] as? String
imageCard.imageView?.image = entity["image"] as? UIImage

let contentLabel = UILabel()
contentLabel.text = entity["content"] as? String
imageCard.contentView = contentLabel

let authorLabel = UILabel()
authorLabel.text = entity["author"] as? String
imageCard.bottomBar?.centerViews = [authorLabel]
```

* Download the complete [ImageCard example](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/ImageCard).
* Learn more about [Material's ImageCard](http://cosmicmind.com/material/imagecard).

## Searching a list of users in realtime

Using the **Search** API is incredibly flexible. In the following example, Search is used to create a live search on user names with a dynamic UI provided by [Material's SearchBar](http://cosmicmind.com/material/searchbar).

![Material SearchBar](http://www.cosmicmind.com/gifs/shared/search-bar-controller.gif)

#### Preparing the search criteria

```swift
let graph = Graph()

let search = Search<Entity>(graph: graph).for(types: "User").where(properties: "name")
```

#### Asynchronously searching graph

```swift        
search.async { [weak self, pattern = pattern] (users) in

	guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
	    return
    }

	var data = [Entity]()

	for user in users {
		if let name = user["name"] as? String {
			let matches = regex.matches(in: name, range: NSRange(location: 0, length: name.utf16.count))

			if 0 < matches.count {
				data.append(user)
			}
		}
	}

	self?.tableView.data = data
}
```

* Download the complete [Search example](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Search).
* Learn more about [Material's SearchBar](http://cosmicmind.com/material/searchbar).

## License

Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

*   Redistributions of source code must retain the above copyright notice, this     
    list of conditions and the following disclaimer.

*   Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

*   Neither the name of CosmicMind nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
