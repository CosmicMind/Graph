# GraphKit

### CocoaPods Support

GraphKit is on CocoaPods under the name [GK](https://cocoapods.org/?q=GK).

### A Simple Entity

Let's begin with creating a simple model object using an Entity. An Entity represents a person, place, or thing. Below is an example of creating a "User" type Entity.

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
user["name"] = "Eve"
user["age"] = 27

graph.save()
```

### Relationship Bond

A Relationship between two Entity objects is done using a Bond. A Bond is structured like a sentence, in that it has a Subject and Object. Below is an example of constructing a relationship, between a "User" and "Book" Entity type. It may be thought of as "User is Author of Book".

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
user["name"] = "Michael Talbot"

let book: Entity = Entity(type: "Book")
book["title"] = "The Holographic Universe"
book.addGroup("Physics")

let author: Bond = Bond(type: "Author")
author["written"] = "May 6th 1992"
author.subject = user
author.object = book

graph.save()
```

### Real-Time Action

Engagement drives experience. When a user engages your application, an Action object may be used to capture all the relevant data in a single snapshot. An Action does this, very much like a Bond, by relating Subjects to Objects. Below is an example of a user purchasing many books. It may be thought of as "User Purchased these Book(s)".

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
let books: SortedSet<Entity> = graph.search(entity: ["Book"], group: ["Physics"])

let purchased: Action = Action(type: "Purchased")
purchased.addSubject(user)

for book in books {
	purchased.addObject(book)
}

graph.save()
```

### A Probable World

A great experience is never static. Data structures in GraphKit have an internal probability mechanism that enables your application to create a dynamic experience. Below is an example of determining the probability of rolling a 3 with a single die.

```swift
let die: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6)
print(die.probabilityOf(3)) // output: 0.166666666666667
```

It is possible to use the probability mechanism with stored objects in the Graph. Below is the same example that sets each die value as an Entity.

```swift
let n1: Entity = Entity(type: "Number")
n1["value"] = 1

let n2: Entity = Entity(type: "Number")
n2["value"] = 2

let n3: Entity = Entity(type: "Number")
n3["value"] = 3

let n4: Entity = Entity(type: "Number")
n4["value"] = 4

let n5: Entity = Entity(type: "Number")
n5["value"] = 5

let n6: Entity = Entity(type: "Number")
n6["value"] = 6

let die: SortedSet<Entity> = SortedSet<Entity>(elements: n1, n2, n3, n4, n5, n6)
print(die.probabilityOf(n3)) // output: 0.166666666666667
```

### Data-Driven Design

As data moves through your application, the state of information may be observed to create a reactive experience. Below is an example of watching when a "User Clicked a Button".

```swift
let graph: Graph = Graph() // set UIViewController delegate as GraphDelegate
graph.delegate = self

graph.watch(action: ["Clicked"])

let user: Entity = Entity(type: "User")
let clicked: Action = Action(type: "Clicked")
let button: Entity = Entity(type: "Button")

clicked.addSubject(user)
clicked.addObject(button)

graph.save()

// delegate method
func graphDidInsertAction(graph: Graph, action: Action) {
    switch(action.type) {
    case "Clicked":
      println(action.subjects.first?.type) // User
      println(action.objects.first?.type) // Button
    case "Swiped":
      // handle swipe
    default:
     break
    }
 }
```

### Faceted Search

To explore the intricate relationships within Graph, the search API is as faceted as it is dimensional. This allows the exploration of your data through any view point.

The below example shows how to access a couple Entity types simultaneously.

```swift
let graph: Graph = Graph()

// users
let u1: Entity = Entity(type: "User")
u1["name"] = "Michael Talbot"

let u2: Entity = Entity(type: "User")
u2["name"] = "Dr. Walter Russell"

let u3: Entity = Entity(type: "User")
u3["name"] = "Steven Speilberg"

// media
let b1: Entity = Entity(type: "Book")
b1["title"] = "The Holographic Universe"
b1.addGroup("Physics")

let b2: Entity = Entity(type: "Book")
b2["title"] = "Universal One"
b2.addGroup("Physics")
b2.addGroup("Math")

let v1: Entity = Entity(type: "Video")
v1["title"] = "Jurassic Park"
v1.addGroup("Thriller")
v1.addGroup("Action")

// relationships
let r1: Bond = Bond(type: "Author")
r1["year"] = "1992"
r1.subject = u1
r1.object = b1

let r2: Bond = Bond(type: "Author")
r2["year"] = "1926"
r2.subject = u2
r2.object = b2

let r3: Bond = Bond(type: "Director")
r3["year"] = "1993"
r3.subject = u3
r3.object = v1

graph.save()

let media: SortedSet<Entity> = graph.search(entity: ["Book", "Video"])
print(media.count) // output: 3
```

All search results are SortedSet structures that sort data by the id property of the model object. It is possible to narrow the search result by adding group and property filters. The example below demonstrates this.

```swift
let setA: SortedSet<Entity> = graph.search(entity: ["*"], group: ["Physics"])
print(setA.count) // output: 2
```

The * wildcard value tells Graph to look for Entity objects that have values LIKE the ones passed. In the above search, we are asking Graph to look for all Entity types that are in the group "Physics".

The following example searches Graph by property.

```swift
let setB: SortedSet<Entity> = graph.search(entity: ["Book", "Video"], property: [("title", "Jurassic Park")])
print(setB.count) // output: 1
```

We can optionally include a group filter to the above search.

```swift
let setC: SortedSet<Entity> = graph.search(entity: ["Book", "Video"], group: ["Math"], property: [("title", "Jurassic Park")])
print(setC.count) // output: 0
```

The above example returns 0 Entity objects, since "Jurassic Park" is not in the group "Math".

Since return types are SortedSet structures, it is possible to apply set theory to search results. SortedSet structures support operators as well.

Below are some examples of set operations.

```swift
let setA: SortedSet<Bond> = graph.search(bond: ["Author"])
let setB: SortedSet<Bond> = graph.search(bond: ["Director"])

let setC: SortedSet<Entity> = graph.search(entity: ["Book"], group: ["Physics"])
let setD: SortedSet<Entity> = graph.search(entity: ["Book"], group: ["Math"])

let setE: SortedSet<Entity> = graph.search(entity: ["User"])

// union
print((setA + setB).count) // output: 3
print(setA.union(setB).count) // output: 3

// intersect
print(setC.intersect(setD).count) // output: 1

// subset
print(setD < setC) // true
print(setD.isSubsetOf(setC)) // true

// superset
print(setD > setC) // false
print(setD.isSupersetOf(setC)) // false

// contains
print(setE.contains(setA.first!.subject!)) // true

// probability
print(setE.probabilityOf(setA.first!.subject!, setA.last!.subject!)) // 0.666666666666667
```

We can even apply filter, map, and sort operations to search results. Below are some examples using the data from above.

```swift
// filter
let arrayA: Array<Entity> = setC.filter { (entity: Entity) -> Bool in
	return entity["title"] as? String == "The Holographic Universe"
}
print(arrayA.count) // 1

// map
let arrayB: Array<Bond> = setA.map { (bond: Bond) -> Bond in
	bond["mapped"] = true
	return bond
}
print(arrayB.first!["mapped"] as? Bool) // output: true

// sort
let arrayC: Array<Entity> = setE.sort { (a: Entity, b: Entity) -> Bool in
	return (a["name"] as? String) < (b["name"] as? String)
}
print(arrayC.first!["name"] as? String) // output: "Dr. Walter Russell"
```

### Remote Data

It is great to have data flow throughout your application. Let's go beyond this by sending and receiving JSON objects from our application to a remote address.

Below is an example of a GET and POST request.

```swift
let session: Session = Session()
session.get(NSURL(string: "http://graph.graphkit.io/key/1/graph/test")!) { (json: JSON?, error: NSError?) in
	// do something
}

session.post(NSURL(string: "http://graph.graphkit.io/index")!, json: JSON([["type": "User", "nodeClass": 1]])) { (json: JSON?, error: NSError?) in
	// do something
}
```

You can even send Entity, Action, and Bond objects easily with the asJSON conversion facility. Below is an example of saving an Entity if the server receives it.

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
user["name"] = "Michael Talbot"

session.post(NSURL(string: "http://graph.graphkit.io/index")!, json: user.asJSON) { (json: JSON?, error: NSError?) in
	// Save the user if it is received correctly.
	if nil != error {
		user.delete()
	}
	graph.save()
}
```

### JSON Manipulation

JSON is a widely used format for sending data through networks and your application locally. GraphKit comes with a full JSON parser. Below are some examples of JSON manipulations.

```swift
// serialize
let data: NSData? = JSON.serialize(["user": ["username": "daniel", "password": "abc123", "token": 123456789]])

// parse
let j1: JSON? = JSON.parse(data!)

// access
print(j1?["user"]?["username"]?.string) // output: "daniel"

// stringify
let stringified: String? = JSON.stringify(j1!)
print(stringified) // output: "{\"user\":{\"password\":\"abc123\",\"token\":123456789,\"username\":\"daniel\"}}"

// parse
let j2: JSON? = JSON.parse(stringified!)
print(j2?["user"]?["token"]?.int) // output: 123456789

// Entity
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
user["name"] = "Michael Talbot"

graph.save()

print(user.asJSON) // output: {"properties":{"name":"Michael Talbot"},"createdDate":"Thursday, October 22, 2015 at 1:11:05 PM Eastern Daylight Time","nodeClass":1,"id":"1Userp7","groups":[],"type":"User"}
```

### Algorithms & Structures

GraphKit comes packed with some useful data structures to help write wonderful algorithms. The following structures are included: List, Stack, Queue, Deque, RedBlackTree, SortedSet, SortedMultiSet, SortedDictionary, and SortedMultiDictionary.

### License

[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)

### Contributors

* [Daniel Dahan](https://github.com/danieldahan)
* [Adam Dahan](https://github.com/adamdahan)
* [Michael Reyder](https://github.com/michaelReyder)
