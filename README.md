![GK](http://www.graphkit.io/GK/GraphKit.png)

# Welcome to GraphKit

GraphKit is a data and algorithm framework built on top of CoreData. It is available for iOS and OS X. A major goal in the design of GraphKit is to allow data to be modeled as one would think. GraphKit is thread safe and will never require a migration between data model changes. The following README is written to get you started, and is by no means a complete tutorial on all that is possible.

### CocoaPods Support

GraphKit is on CocoaPods under the name [GK](https://cocoapods.org/?q=GK).

### Carthage Support

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate GraphKit into your Xcode project using Carthage, specify it in your Cartfile:

```bash
github "CosmicMind/GraphKit"
```

Run carthage to build the framework and drag the built GraphKit.framework into your Xcode project.

### Table of Contents  

* [Entity](#entity)
* [Bond](#bond)
* [Action](#action)
* [Groups](#groups)
* [Probability](#probability)
* [Data Driven](#datadriven)
* [Faceted Search](#facetedsearch)
* [JSON](#json)
* [Data Structures](#datastructures)
* [DoublyLinkedList](#doublylinkedlist)
* [Stack](#stack)
* [Queue](#queue)
* [Deque](#deque)
* [RedBlackTree](#redblacktree)
* [SortedSet](#sortedset)
* [SortedMultiSet](#sortedmultiset)
* [SortedDictionary](#sorteddictionary)
* [SortedMultiDictionary](#sortedmultidictionary)

### Upcoming

* Example Projects
* Additional Data Structures

<a name="entity"/>
### Entity

Let's begin with creating a simple model object and saving it to the Graph. Model objects are known as Entity Objects, which represent a person, place, or thing. Each Entity has a type property that specifies the collection to which it belongs to. Below is an example of creating a "User" type Entity and saving it to the Graph.

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
user["name"] = "Eve"
user["age"] = 27

graph.save()
```

<a name="bond"/>
### Bond

A Bond is used to form a relationship between two Entity Objects. Like an Entity, a Bond also has a type property that specifies the collection to which it belongs to. A Bond's relationship structure is like a sentence, in that it has a Subject and Object. Let's look at an example to clarify this concept. Below is an example of two Entity Objects, a User and a Book, which have a relationship that is defined by the User being the Author of the Book. The relationship should read as, "User is Author of Book."

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

<a name="action"/>
### Action

An Action is used to form a relationship between many Entity Objects. Like an Entity, an Action also has a type property that specifies the collection to which it belongs to. An Action's relationship structure is like a sentence, in that it relates a collection of Subjects to a collection of Objects. Below is an example of a User purchasing many Books. It may be thought of as "User Purchased these Book(s)."

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
let books: Array<Entity> = graph.searchForEntity(types: ["Book"])

let purchased: Action = Action(type: "Purchased")
purchased.addSubject(user)

for book in books {
	purchased.addObject(book)
}

graph.save()
```

<a name="groups"/>
### Groups

Groups are used to organize Entities, Bonds, and Actions into different collections from their types. This allows multiple types to exist in a single collection. For example, a Photo and Video Entity type may exist in a group called Media. Another example may be including a Photo and Book Entity type in a Favorites group for your users' account. Below are examples of using groups.

```swift
let photo: Entity = Entity(type: "Photo")
photo.addGroup("Media")
photo.addGroup("Favorites")
photo.addGroup("Holiday Album")

let video: Entity = Entity(type: "Video")
video.addGroup("Media")

let book: Entity = Entity(type: "Book")
book.addGroup("Favorites")
book.addGroup("To Read")

// Searching groups.
let favorites: Array<Entity> = graph.searchForEntity(groups: ["Favorites"])
```

<a name="probability"/>
### Probability

Probability is a core feature within GraphKit. Your application may be completely catered to your users' habits and usage. To demonstrate this wonderful feature, let's look at some examples:

Determining the probability of rolling a 3 using a die of 6 numbers.

```swift
let die: Array<Int> = Array<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
print(die.probabilityOf(3)) // output: 0.166666666666667
```

The expected value of rolling a 3 or 6 with 100 trials using a die of 6 numbers.

```swift
let die: Array<Int> = Array<Int>(arrayLiteral: 1, 2, 3, 4, 5, 6)
print(die.expectedValueOf(100, elements: 3, 6)) // output: 33.3333333333333
```

Recommending a Physics book if the user is likely to buy a Physics book.

```swift
let purchased: Array<Action> = graph.searchForAction(types: ["Purchased"])

let pOfX: Double = purchased.probabilityOf { (action: Action) in
	if let entity: Entity = action.objects.first {
		if "Book" == entity.type {
			return entity.hasGroup("Physics")
		}
	}
	return false
}

if 33.33 < pOfX {
	// Recommend a Physics book.
}
```

<a name="datadriven"/>
### Data Driven

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

<a name="facetedsearch"/>
### Faceted Search

To explore the intricate relationships within the Graph, the search API adopts a faceted design. This allows the exploration of your data through any view point. The below examples show how to use the Graph search API:

Searching multiple Entity types.

```swift
let collection: Array<Entity> = graph.searchForEntity(types: ["Photo", "Video"])
```

Searching multiple Entity groups.

```swift
let collection: Array<Entity> = graph.searchForEntity(groups: ["Media", "Favorites"])
```

Searching multiple Entity properties.

```swift
let collection: Array<Entity> = graph.searchForEntity(properties: [(key: "name", value: "Eve"), ("age", 27)])
```

Searching multiple facets simultaneously will aggregate all results into a single collection.

```swift
let collection: Array<Entity> = graph.searchForEntity(types: ["Photo", "Friends"], groups: ["Media", "Favorites"])
```

Filters may be used to narrow in on a search result. For example, searching a book title and group within purchases.

```swift
let collection: Array<Action> = graph.searchForAction(types: ["Purchased"]).filter { (action: Action) -> Bool in
	if let entity: Entity = action.objects.first {
		if "Book" == entity.type && "The Holographic Universe" == entity["title"] as? String  {
			return entity.hasGroup("Physics")
		}
	}
	return false
}
```

<a name="json"/>
### JSON

JSON is a widely used format for serializing data. GraphKit comes with a JSON toolset. Below are some examples of its usage.

```swift
// Serialize.
let data: NSData? = JSON.serialize(["user": ["username": "daniel", "password": "abc123", "token": 123456789]])

// Parse.
let j1: JSON? = JSON.parse(data!)

// Acces.s
print(j1?["user"]?["username"]?.asString) // output: "daniel"

// Stringify.
let stringified: String? = JSON.stringify(j1!)
print(stringified) // output: "{\"user\":{\"password\":\"abc123\",\"token\":123456789,\"username\":\"daniel\"}}"

// Parse.
let j2: JSON? = JSON.parse(stringified!)
print(j2?["user"]?["token"]?.asInt) // output: 123456789
```

<a name="datastructures"/>
### Data Structures

GraphKit comes packed with some powerful data structures to help write algorithms. The following structures are included: DoublyLinkedList, Stack, Queue, Deque, RedBlackTree, SortedSet, SortedMultiSet, SortedDictionary, and SortedMultiDictionary.

<a name="doublylinkedlist"/>
### DoublyLinkedList

The DoublyLinkedList data structure is excellent for large growing collections of data. Below is an example of its usage.

```swift
let listA: DoublyLinkedList<Int> = DoublyLinkedList<Int>()
listA.insertAtFront(1)
listA.insertAtFront(2)
listA.insertAtFront(3)

let listB: DoublyLinkedList<Int> = DoublyLinkedList<Int>()
listB.insertAtBack(4)
listB.insertAtBack(5)
listB.insertAtBack(6)

let listC: DoublyLinkedList<Int> = listA + listB

listC.cursorToFront()
while !listC.isCursorAtBack {
	print(listC.cursor)
	listC.next
}
// Output:
// 1
// 2
// 3
// 4
// 5
// 6
```

<a name="stack"/>
### Stack

The Stack data structure is a container of objects that are inserted and removed according to the last-in-first-out (LIFO) principle. Below is an example of its usage.

```swift
let stack: Stack<Int> = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)

while !stack.isEmpty {
	print(stack.pop())
}
// Output:
// 3
// 2
// 1
```

<a name="queue"/>
### Queue

The Queue data structure is a container of objects that are inserted and removed according to the first-in-first-out (FIFO) principle. Below is an example of its usage.

```swift
let queue: Queue<Int> = Queue<Int>()
queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)

while !queue.isEmpty {
	print(queue.dequeue())
}
// Output:
// 1
// 2
// 3
```

<a name="deque"/>
### Deque

The Deque data structure is a container of objects that are inserted and removed according to the first-in-first-out (FIFO) and last-in-first-out (LIFO) principle. Essentially, a Deque is a Stack and Queue combined. Below are examples of its usage.

```swift
let dequeA: Deque<Int> = Deque<Int>()
dequeA.insertAtBack(1)
dequeA.insertAtBack(2)
dequeA.insertAtBack(3)

while !dequeA.isEmpty {
	print(dequeA.front)
	dequeA.removeAtFront()
}
// Output:
// 1
// 2
// 3

let dequeB: Deque<Int> = Deque<Int>()
dequeB.insertAtBack(4)
dequeB.insertAtBack(5)
dequeB.insertAtBack(6)

while !dequeB.isEmpty {
	print(dequeB.back)
	dequeB.removeAtBack()
}
// Output:
// 6
// 5
// 4
```

<a name="redblacktree"/>
### RedBlackTree

A RedBlackTree is a Balanced Binary Search Tree that maintains insert, remove, update, and search operations in a complexity of O(logn). The GraphKit implementation of a RedBlackTree also includes an order-statistic, which allows the data structure to be accessed using subscripts like an array or dictionary. RedBlackTrees may store unique keys or non-unique key values. Below is an example of its usage.

```swift
let rbA: RedBlackTree<Int, Int> = RedBlackTree<Int, Int>(uniqueKeys: true)

for var i: Int = 1000; 0 < i; --i {
	rbA.insert(1, value: 1)
	rbA.insert(2, value: 2)
	rbA.insert(3, value: 3)
}
print(rbA.count) // Output: 3
```

<a name="sortedset"/>
### SortedSet

SortedSets are a powerful data structure for algorithm and analysis design. Elements within a SortedSet are unique and insert, remove, and search operations have a complexity of O(logn). The GraphKit implementation of a SortedSet also includes an order-statistic, which allows the data structure to be accessed using an index subscript like an array. Below are examples of its usage.

```swift
let graph: Graph = Graph()

let setA: SortedSet<Bond> = SortedSet<Bond>(elements: graph.searchForBond(types: ["Author"]))
let setB: SortedSet<Bond> = SortedSet<Bond>(elements: graph.searchForBond(types: ["Director"]))

let setC: SortedSet<Entity> = SortedSet<Entity>(elements: graph.searchForEntity(groups: ["Physics"]))
let setD: SortedSet<Entity> = SortedSet<Entity>(elements: graph.searchForEntity(groups: ["Math"]))

let setE: SortedSet<Entity> = SortedSet<Entity>(elements: graph.searchForEntity(types: ["User"]))

// Union.
print((setA + setB).count) // output: 3
print(setA.union(setB).count) // output: 3

// Intersect.
print(setC.intersect(setD).count) // output: 1

// Subset.
print(setD < setC) // true
print(setD.isSubsetOf(setC)) // true

// Superset.
print(setD > setC) // false
print(setD.isSupersetOf(setC)) // false

// Contains.
print(setE.contains(setA.first!.subject!)) // true

// Probability.
print(setE.probabilityOf(setA.first!.subject!, setA.last!.subject!)) // 0.666666666666667
```

<a name="sortedmultiset"/>
### SortedMultiSet

A SortedMultiSet is identical to a SortedSet, except that a SortedMultiSet allows non-unique elements. Look at [SortedSet](#sortedset) for examples of its usage.

<a name="sorteddictionary"/>
### SortedDictionary

A SortedDictionary is a powerful data structure that maintains a sorted set of keys with value pairs. Keys within a SortedDictionary are unique and insert, remove, update, and search operations have a complexity of O(logn). Below is an example of its usage.

```swift
let graph: Graph = Graph()

let dict: SortedDictionary<String, Entity> = SortedDictionary<String, Entity>()

let students: Array<Entity> = graph.searchForEntity(types: ["Student"])

// Do something with an alphabetically SortedDictionary of student Entity Objects.
for student in students {
	dict.insert(student["name"] as! String, value: student)
}
```

<a name="sortedmultidictionary"/>
### SortedMultiDictionary

A SortedMultiDictionary is identical to a SortedDictionary, except that a SortedMultiDictionary allows non-unique keys. Look at [SortedDictionary](#sorteddictionary) for examples of its usage.

### License

[AGPL-3.0](http://choosealicense.com/licenses/agpl-3.0/)
