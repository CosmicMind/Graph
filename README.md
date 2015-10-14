# GraphKit

### CocoaPods Support

GraphKit is on CocoaPods under the name [GK](https://cocoapods.org/?q=GK).

### A Simple Entity

Let's begin with creating a simple model object using an Entity. An Entity represents a person, place, or thing. Below is an example of creating a User type Entity.

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
user["name"] = "Eve"
user["age"] = 27

graph.save()
```

### Relationship Bond

A Relationship between two Entity objects is done using a Bond. A Bond is structured like a sentence, in that it has a Subject and Object. Below is an example of constructing a relationship, between a User and Book. It may be thought of as User is Author of Book.

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

Engagement drives experience. When a user engages your application, an Action object may be used to capture all the relevant data in a single snapshot. An Action does this, very much like a Bond, by relating Subjects to Objects. Below is an example of a user purchasing many books. It may be thought of as User Purchased these Book(s).

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

As data moves through your application, the state of information may be observed to create a reactive experience. Below is an example of watching when a User Clicked a Button.

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

### License

[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)

### Contributors

* [Daniel Dahan](https://github.com/danieldahan)
* [Adam Dahan](https://github.com/adamdahan)
* [Michael Reyder](https://github.com/michaelReyder)
