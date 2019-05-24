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

> **Embedded frameworks require a minimum deployment target of iOS 8.**
> - [Download Graph](https://github.com/CosmicMind/Graph/archive/master.zip)

## CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Graph's core features into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Graph', '~> 3.1.0'
```

Then, run the following command:

```bash
$ pod install
```

## Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate Graph into your Xcode project using Carthage, specify it in your Cartfile:

```bash
github "CosmicMind/Graph"
```

Run `carthage update` to build the framework and drag the built `Graph.framework` into your Xcode project.

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

The MIT License (MIT)

Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
