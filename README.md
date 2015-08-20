# Build Intelligent Software
### A powerful iOS / OSX framework for data-driven design.

* [Get Started](http://graphkit.io)
* [Installation Guide](http://www.graphkit.io/tutorials/workspace)

### Unbelievable Persistence
Developers are limited by their efficiency to model simple and complex data. Without any configuration or schemas, GraphKit can model any scenario with a few lines of code. Take advantage of fast prototyping that is ready for production when you are.

### Flexible Data Structures

Juggle data around with ease and comfort. A library of flexible data structures are at your fingertips.

### Built in Probability Theory

An interwoven probability framework is built in. Bring your application to life based on user engagement and predictive analytics without making a single network request.

### A Simple Model

GraphKit model objects vary based on usage. An Entity is representative of a person place or thing. Below is an example of creating a User Entity and saving it to the Graph.

```swift
let graph = Graph()

let user = Entity(type: "User")
user["name"] = "Eve"
user["age"] = 27

graph.save()
```

### Relationships Between Models

Relationships between Model objects is done using sentence structures. A Bond object forms the connection between two Entity objects using its subject and object property. Below is an example of a relationship between a User Entity and a Book Entity where the User is the Author of the Book.

```swift
let graph = Graph()

let user = Entity(type: "User")
user["name"] = "Michael Talbot"

let book = Entity(type: "Book")
book["title"] = "The Holographic Universe"
book.addGroup("Physics")

let bond = Bond(type: "AuthorOf")
bond["written"] = "May 6th 1992"
bond.subject = user
bond.object = book

graph.save()
```

### Real-Time Analytics

Engagement drives the user experience. GraphKit captures engagement through Action objects that form a relationship between many subjects and many objects. Below is an example of a User Entity purchasing many books in a single transaction.

```swift
let graph = Graph()

let user = graph.search(Entity: "User").last!.value
let books = graph.search(EntityGroup: "Popular")

let purchased = Action(type: "Purchased")
purchased.addSubject(user)

for (_, book) in books {
    purchased.addObject(book)  
}

graph.save()
```

### Recommendations Based on Probability

As the user engages your application, GraphKit offers a probability interface to give a truely unique experience. Below is an example of recommending a book that is in the physics genre.

```swift
let graph = Graph()

let purchases = graph.search(Action: "Purchased")
let set = OrderedMultiSet&ltString>()

for (_, purchase) in purchases {
     for (_, book) in purchase!.objects.search("Book") {
        set.insert(book!["genre"] as! String)
    }
}

if set.probabilityOf("Physics") > 0.5 {
     // offer physics books
} else {
     // offer other books
}
```

### Data-Driven Design

As data moves through your application, the state of information may be observed to create a reactive experience. Below is an example of watching Clicked Actions on a button.

```swift
let graph = Graph()
graph.delegate = self
graph.watch(Action: "Clicked")

let user = Entity(type: "User")
let click = Action(type: "Clicked")
let button = Entity(type: "Button")

action.addSubject(user)
action.addObject(button)

graph.save()

// delegate method
func graphDidInsertAction(graph: Graph, action: Action) {
    switch(action.tyoe) {
    case "Clicked":
      println(action.subjects.first.type) // User
      println(action.objects.first.type) // Button
      break
    case "Swiped":
      // handle swipe
     break
    default:
     break
    }
 }
```


### License


[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)


### Contributors


[Daniel Dahan](https://github.com/danieldahan)
