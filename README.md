![MacDown Screenshot](http://graphkit.io/graphkitbanner.png) 
GraphKit is an elegant data driven framework for managing persistence on iOS. Built on top of CoreData and completely written in Swift (http://www.apple.com/ca/swift/?cid=wwa-ca-kwg-features-com), it extends iOS’ powerful persistent layer while abstracting its complexities. GraphKit has a “save whatever and however I want” attitude with powerful and rich APIs that are fun to work with. 

Probably the most exciting features that GraphKit offers, are: 

- Everything is data driven, and now changes in your data layer can drive changes in your UI decoupling views. 
- Data and analytics are considered the same. Your data is your analytics and through the following example project, you will see how easily these worlds meet. 
- GraphKit is not a Singleton — storage objects may be instantiated anywhere and they all maintain synchronization.

#How to Get Started

1. Download the latest [release](https://github.com/GraphKit/GKGraphKit/releases).
2. Follow the examples below. 
3. Have fun!

#Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C and now in beta testing for Swift. We recommend using this tool in general. To learn more, visit their website [http://cocoapods.org](http://cocoapods.org/). Setting up GraphKit is simple after learning how to use CocoaPods. 

> **Podfile**
> 
> platform :ios, ‘8.0’  
> pod ‘GKGraphKit’
 

#Exmaple Project

Let’s make a simple ‘Hello World’ example, well, let’s do a little more than that ;) How about we make a list manager. You can find the project in the Example Projects folder. A few cool things to note before we get started. GKGraphKit is not just about data. We believe that data and analytics are the same and for that reason, in this example, we will show you how to capture analytics and data without any extra effort.

Once you have downloaded the GraphKitListManager project and latest release, which includes all that you need, follow the steps bellow to gain an understanding of how to do this on your own. 

###Add GraphKit to the Example Project

1. Create a new workspace and name it LearningGraphKit, or something else of your choosing. 
2. Ensure the deployment targets are set to 8.0.
3. Click on the GraphKitListManager build target. Then click on the “+” button for embedding a framework. You should see GKGraphKit pop up in the list.  
4. That’s it, GKGraphKit.framework is now setup in the example project. 

###AppDelegate.swift

In the AppDelete.swift file, there is a line added at the top that imports the GKGraphKit framework and another line added to “applicationWillTerminate” handler to save data incase termination occurs. 

```swift
import UIKit
import GKGraphKit /* import the GKGraphKit framework */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	...

	/* save all data before app terminates */
	func applicationWillTerminate(application: UIApplication) {
		let graph: GKGraph = GKGraph(); 
		graph.save() ￼ { (success: Bool, error: NSError? ) in }
	}
}
```

###ListViewController.swift

In this example, we will use a collection view and manage the layout and data source in the controller itself. In order to have the app be responsive to user engagement, the GKGraphDelegate Protocol is added at the top of the Class declaration. 

```swift

import UIKit
import GKGraphKit

class ListViewController: UIViewController, GKGraphDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

}

```

Now that we have the delegate setup, we can watch changes in our data layer. The following code sets a lazy loaded GKGraph instance, which is responsible for persisting the application data. GKGraph manages the entire data layer over CoreData, allowing us to take advantage of the framework's powerful features, but without the hastle. So it actually becomes fun :) ... well it was always a bit fun.


```swift
class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GKGraphDelegate {

	...
	
	// ViewController property value. 
	// May also be setup as a local variable in any function
	// and maintain synchronization.
	lazy var graph: GKGraph = GKGraph()
	
	
	// #pragma mark View Handling
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set the graph as a delegate
		graph.delegate = self
		
		// watch the AddTask Action
		graph.watch(Action: "AddTask")
	
		...
	
	}

	...	
	
	// Add the watch task delegate callback when this event
	// is saved to the Graph instance.
	func graph(graph: GKGraph!, didInsertAction action: GKAction!) {
		// do something
	}
}

```

That's it. Now we are watching an Action that is of type AddTask, and we have setup a delegate that will fire anytime a new AddType Action is added to the Graph. Next we will add a User. Our approach to maintaining users will be a simple one. We will check if any User Entity objects exist, and if one does we will use it. This should allow us to only ever have one User. The Graph will always find one User after our initial save of the User Entity. 

```swift
		...

		// watch the AddTask Action
		graph.watch(Action: "AddTask")

		// lets create a User Entity that will be used throughout the app. 
		var user: GKEntity? = graph.search(Entity: "User").last
		if nil == user {
			user = GKEntity(type: "User")
			// this saves the user to the Graph
			graph.save() { (success: Bool, error: NSError?) in }
		}
		
		...
```
Now that we have a User, we can track when the User Clicks on the AddTask Action and then react by opening a TaskViewController, which will be completely data driven. Go to the ListToolbar.swift file and view the following code. 

```swift
import UIKit
import GKGraphKit

class ListToolbar: UIToolbar {
	
	// localized graph instance to connect
	lazy var graph: GKGraph = GKGraph()
	
	lazy var flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	lazy var focusButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTask")
	
	...
	
	func addTask() {
		// create the Action instance
		var action: GKAction = GKAction(type: "AddTask")
		
		// get our User Entity created in the ListViewController.swift file
		let user: GKEntity? = graph.search(Entity: "User").last;
		
		// add the user as a Subject for the Action
		action.addSubject(user)
		
		// lets create a User Entity that will be used throughout the app.
		var button: GKEntity? = graph.search(Entity: "ToolbarButton").last
		if nil == button {
			button = GKEntity(type: "ToolbarButton")
		}
		
		// add the button as an Object for the Action
		action.addObject(button)
		
		// save everything to the Graph
		graph.save() { (success: Bool, error: NSError? ) in }
	}
}


```
Like before we setup a Graph instance that is localized to that Views scope, no Singletons. When the Add Button is clicked, we construct an Action instance. 


#License 
[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/) 

#Contributors 
[Daniel Dahan](https://github.com/danieldahan)  
