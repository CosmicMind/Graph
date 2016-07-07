![Graph](http://www.cosmicmind.io/GK/Graph.png)

## Welcome to Graph

Graph is a data-driven framework for CoreData. It comes complete with iCloud support and the ability to create as many local and cloud instances as you would like.

## Features

- [x] iCloud Support
- [x] Multi Storage Support
- [x] Thread Safe
- [x] Store Any Data Type, Including Binary Data
- [x] Relationship Modeling
- [x] Action Modeling For Analytics
- [x] Model With Graph Theory and Set Theory
- [x] Faceted Search API
- [x] Asynchronous / Synchronous Saving
- [x] Data-Driven Architecture
- [x] Data Model Observation
- [x] Comprehensive Unit Test Coverage
- [x] Example Projects

## Requirements

* iOS 8.0+ / Mac OS X 10.9+
* Xcode 7.3+

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cosmicmind). (Tag 'cosmicmind')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cosmicmind).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks (10.9).**
> - [Download Graph](https://github.com/CosmicMind/Graph/archive/master.zip)

Visit the [Installation](https://github.com/CosmicMind/Graph/wiki/Installation) page to learn how to install Graph using [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).

## Changelog

Graph is a growing project and will encounter changes throughout its development. It is recommended that the [Changelog](https://github.com/CosmicMind/Graph/wiki/Changelog) be reviewed prior to updating versions.

## Examples

* Visit the Examples directory to see example projects using Graph.

## A Tour  

* [Entity](#entity)
* [Relationship](#relationship)
* [Action](#action)
* [Data Driven](#data-driven)
* [Faceted Search](#faceted-search)

<a name="entity"></a>
## Entity

An Entity is a model object that represents a person, place, or thing. It may store property values and be a member of groups.

For example, creating a Person Entity:

```swift
let graph = Graph()

let person = Entity(type: "Person")
person["firstName"] = "Elon"
person["lastName"] = "Musk"
person["age"] = 41

person.addToGroup("Male")
person.addToGroup("Inspiring")

graph.async()
```

[Learn More About Entities](http://www.cosmicmind.io/graph/entity)

<a name="relationship"></a>
## Relationship

A Relationship is a model object that forms a connection between two Entities. It may store property values and be a member of groups.

```swift
let graph = Graph()

let person = Entity(type: "Person")
person["firstName"] = "Mark"
person["lastName"] = "Zuckerberg"

let company = Entity(type: "Company")
company["name"] = "Facebook"

let employee = Relationship(type: "Employee")
employee["startDate"] = "February 4, 2004"
employee.addToGroup("CEO")
employee.addToGroup("Founder")

employee.subject = person
employee.object = company

graph.async()
```

[Learn More About Relationships](http://www.cosmicmind.io/graph/relationship)

<a name="action"></a>
## Action

An Action is a model object that forms a connection between many Entities. It may store property values and be a member of groups.

```swift
let graph = Graph()

let user = Entity(type: "User")
user["name"] = "Daniel"

let book1 = Entity(type: "Book")
book1["title"] = "Learning Swift"
book1.addToGroup("Programming")

let book2 = Entity(type: "Book")
book2["title"] = "The Holographic Universe"
book2.addToGroup("Physics")

let purchased = Action(type: "Purchased")
purchased.addToGroup("Pending")

purchased.addSubject(user)
purchased.addObject(book1)
purchased.addObject(book2)

graph.async()
```

[Learn More About Actions](http://www.cosmicmind.io/graph/action)

<a name="data-driven"></a>
## Data Driven

As data moves through your application, the state of information may be observed to create a reactive experience. Below is an example of watching when a "User Clicked a Button".

```swift
// Set Protocol to GraphDelegate.

let graph = Graph()
graph.delegate = self

graph.watchForAction(types: ["Clicked"])

let user: Entity = Entity(type: "User")
let clicked = Action(type: "Clicked")
let button = Entity(type: "Button")

clicked.addSubject(user)
clicked.addObject(button)

graph.async()

// Delegate method.
func graphDidInsertAction(graph: Graph, action: Action, fromCloud: Bool) {
    switch(action.type) {
    case "Clicked":
      print(action.subjects.first?.type) // User
      print(action.objects.first?.type) // Button
    case "Swiped":
      // Handle swipe.
    default:break
    }
 }
```

<a name="faceted-search"></a>
## Faceted Search

To explore the intricate relationships within Graph, the search API adopts a faceted design. The below examples show how to use the _Graph_ search API:

Searching multiple Entity types.

```swift
let graph = Graph()
let collection = graph.searchForEntity(types: ["Photo", "Video"])
```

Searching multiple Entity groups.

```swift
let graph = Graph()
let collection = graph.searchForEntity(groups: ["Media", "Favorites"])
```

Searching multiple Entity properties.

```swift
let graph = Graph()
let collection = graph.searchForEntity(properties: [(key: "name", value: "Eve"), ("age", 27)])
```

Searching multiple facets simultaneously will aggregate all results into a single collection.

```swift
let graph = Graph()
let collection = graph.searchForEntity(types: ["Photo", "Friends"], groups: ["Media", "Favorites"])
```

Filters may be used to narrow in on a search result. For example, searching a book title and group within purchases.

```swift
let graph = Graph()

let collection = graph.searchForAction(types: ["Purchased"]).filter { (action: Action) -> Bool in
	if let entity = action.objects.first {
		if "Book" == entity.type && "The Holographic Universe" == entity["title"] as? String  {
			return entity.memberOfGroup("Physics")
		}
	}
	return false
}
```

## License

Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.

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
