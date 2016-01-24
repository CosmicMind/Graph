![GraphKit](http://www.graphkit.io/GK/GraphKit.png)

## Welcome to GraphKit

GraphKit is a CoreData and Algorithm framework written in Swift. It's designed to simplify the complexities when working with CoreData while providing a seamless data-driven architecture for algorithm design.

## Features

- [x] Thread Safe
- [x] Store Any Data Type, Including Binary Data
- [x] Relationship Modeling
- [x] Action Modeling For Analytics
- [x] Model With Graph Theory and Set Theory
- [x] Faceted Search API
- [x] JSON Toolset
- [x] Probability Extension For Predictive Analytics
- [x] Library of Data Structures
- [x] Asynchronous / Synchronous Saving
- [x] Data-Driven Architecture
- [x] Data Model Observation
- [x] Comprehensive Unit Test Coverage
- [x] Example Projects

## Requirements

* iOS 8.0+ / Mac OS X 10.9+
* Xcode 7.2+

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphkit). (Tag 'graphkit')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphkit).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks (10.9).**
> - [Download GraphKit](https://github.com/CosmicMind/GraphKit/archive/master.zip)

Visit the [Installation](https://github.com/CosmicMind/GraphKit/wiki/Installation) page to learn how to install GraphKit using [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).

## Changelog

GraphKit is a growing project and will encounter changes throughout its development. It is recommended that the [Changelog](https://github.com/CosmicMind/GraphKit/wiki/Changelog) be reviewed prior to updating versions.

## Examples

* Visit the Examples directory to see example projects using GraphKit.

## A Tour  

* [Entity](#entity)
* [Relationship](#relationship)
* [Action](#action)
* [Groups](#groups)
* [Probability](#probability)
* [Data Driven](#datadriven)
* [Faceted Search](#facetedsearch)
* [JSON](#json)

<a name="entity"></a>
## Entity

An **Entity** is a model object that **represents a person, place, or thing**. For example, a Company, Photo, Video, User, Person, and Note. In code, the following is how this would look.

![GraphKitEntity](http://graphkit.io/GK/GraphKitEntity.png)

```swift
let graph: Graph = Graph()

// Create a Person Entity.
let elon: Entity = Entity(type: "Person")
elon["firstName"] = "Elon"
elon["lastName"] = "Musk"

let path: String = NSBundle.mainBundle().pathForResource("ElonMusk", ofType: "png")!
elon["photo"] = UIImage(contentsOfFile: path)

graph.save()
```

[Learn More About Entities](https://github.com/CosmicMind/GraphKit/wiki/Entity)

<a name="relationship"></a>
## Relationship

A **Relationship** is a model object that **forms a relationship between two Entities**. For example, "Mark is an Employee of Facebook". _Mark_ and _Facebook_ are two Entities that form a Relationship -- of type _Employee_. In code, the following is how this would look.

![GraphKitRelationship](http://graphkit.io/GK/GraphKitRelationship.png)

```swift
let graph: Graph = Graph()

// Create a Person Entity.
let mark: Entity = Entity(type: "Person")
mark["firstName"] = "Mark"
mark["lastName"] = "Zuckerberg"

let path: String = NSBundle.mainBundle().pathForResource("MarkZuckerberg", ofType: "png")!
mark["photo"] = UIImage(contentsOfFile: path)

// Create a Company Entity.
let facebook: Entity = Entity(type: "Company")
facebook["name"] = "Facebook"

// Create an Employee Relationship.
let employee: Relationship = Relationship(type: "Employee")
employee["startDate"] = "February 4, 2004"

// Form the relationship.
employee.subject = mark
employee.object = facebook

graph.save()
```

Notice that information about the relationship is stored within the _Employee_ Relationship leaving both _Mark_ and _Facebook_ to form other relationships freely. This is a key principal when using Relationships.

[Learn More About Relationships](https://github.com/CosmicMind/GraphKit/wiki/Relationship)

<a name="action"></a>
## Action

An **Action** is a model object that **forms a relationship between a collection of Entity subjects and a collection of Entity objects**. For example, "Apple Acquired Beats Electronics". The _Acquired_ Action captures the _Company_ Entities in a single relationship that may be used later to ask questions like, "which company acquired Beats Electronics?", or "what companies did Apple acquire?". In code, the following is how this would look.

![GraphKitAction](http://graphkit.io/GK/GraphKitAction.png)

```swift
let graph: Graph = Graph()

// Create a Company Entity.
let apple: Entity = Entity(type: "Company")
apple["name"] = "Apple"

// Create a Company Entity.
let beats: Entity = Entity(type: "Company")
beats["name"] = "Beats Electronics"

// Create an Acquired Action.
let acquired: Action = Action(type: "Acquired")
acquired["acquisitionDate"] = "May 28, 2014"

// Form the action.
acquired.addSubject(apple)
acquired.addObject(beats)

graph.save()
```

Notice that information about the action is stored within the _Acquired_ Action leaving both _Apple_ and _Beats Electronics_ to form other actions freely. This is a key principal when using Actions.

[Learn More About Actions](https://github.com/CosmicMind/GraphKit/wiki/Action)

<a name="groups"></a>
## Groups

Groups are used to organize Entities, Relationships, and Actions into different collections from their types. This allows multiple types to exist in a single collection. For example, a Photo and Video Entity type may exist in a group called Media. Another example may be including a Photo and Book Entity type in a Favorites group for your users' account. Below are examples of using groups.

```swift
let graph: Graph = Graph()

let photo: Entity = Entity(type: "Photo")
photo.addGroup("Media")
photo.addGroup("Favorites")
photo.addGroup("Holiday Album")

let video: Entity = Entity(type: "Video")
video.addGroup("Media")

let book: Entity = Entity(type: "Book")
book.addGroup("Favorites")
book.addGroup("To Read")

graph.save()

// Searching groups.
let favorites: Array<Entity> = graph.searchForEntity(groups: ["Favorites"])
```

<a name="datadriven"></a>
## Data Driven

As data moves through your application, the state of information may be observed to create a reactive experience. Below is an example of watching when a "User Clicked a Button".

```swift
// Set the UIViewController's Protocol to GraphDelegate.
let graph: Graph = Graph()
graph.delegate = self

graph.watchForAction(types: ["Clicked"])

let user: Entity = Entity(type: "User")
let clicked: Action = Action(type: "Clicked")
let button: Entity = Entity(type: "Button")

clicked.addSubject(user)
clicked.addObject(button)

graph.save()

// Delegate method.
func graphDidInsertAction(graph: Graph, action: Action) {
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

<a name="facetedsearch"></a>
## Faceted Search

To explore the intricate relationships within GraphKit, the search API adopts a faceted design. The below examples show how to use the _Graph_ search API:

Searching multiple Entity types.

```swift
let graph: Graph = Graph()
let collection: Array<Entity> = graph.searchForEntity(types: ["Photo", "Video"])
```

Searching multiple Entity groups.

```swift
let graph: Graph = Graph()
let collection: Array<Entity> = graph.searchForEntity(groups: ["Media", "Favorites"])
```

Searching multiple Entity properties.

```swift
let graph: Graph = Graph()
let collection: Array<Entity> = graph.searchForEntity(properties: [(key: "name", value: "Eve"), ("age", 27)])
```

Searching multiple facets simultaneously will aggregate all results into a single collection.

```swift
let graph: Graph = Graph()
let collection: Array<Entity> = graph.searchForEntity(types: ["Photo", "Friends"], groups: ["Media", "Favorites"])
```

Filters may be used to narrow in on a search result. For example, searching a book title and group within purchases.

```swift
let graph: Graph = Graph()

let collection: Array<Action> = graph.searchForAction(types: ["Purchased"]).filter { (action: Action) -> Bool in
	if let entity: Entity = action.objects.first {
		if "Book" == entity.type && "The Holographic Universe" == entity["title"] as? String  {
			return entity.hasGroup("Physics")
		}
	}
	return false
}
```

<a name="json"></a>
## JSON

JSON is a widely used format for serializing data. GraphKit comes with a JSON toolset. Below are some examples of its usage.

```swift
// Serialize Dictionary.
let data: NSData? = JSON.serialize(["user": ["username": "daniel", "password": "abc123", "token": 123456789]])

// Parse NSData.
let j1: JSON? = JSON.parse(data!)
print(j1?["user"]?["username"]?.asString) // Output: "daniel"

// Stringify.
let stringified: String? = JSON.stringify(j1!)
print(stringified) // Output: "{\"user\":{\"password\":\"abc123\",\"token\":123456789,\"username\":\"daniel\"}}"

// Parse String.
let j2: JSON? = JSON.parse(stringified!)
print(j2?["user"]?["token"]?.asInt) // Output: 123456789
```

## License

Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

*   Redistributions of source code must retain the above copyright notice, this     
    list of conditions and the following disclaimer.

*   Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

*   Neither the name of GraphKit nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
