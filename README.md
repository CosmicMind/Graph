GraphKit 
GraphKit is an elegant data driven framework for managing persistence on iOS. Built on top of CoreData and completely written in Swift (http://www.apple.com/ca/swift/?cid=wwa-ca-kwg-features-com), it extends iOS’ powerful persistent layer while abstracting its complexities. GraphKit has a “save whatever and however I want” attitude with powerful and rich APIs that are fun to work with. 

Probably the most exciting features that GraphKit offers, are: 

- That it is not a Singleton — storage objects may be instantiated anywhere and they all maintain synchronization.
- Data and analytics are considered the same. Your data is your analytics and through the following tutorial, you will see how easily these worlds meet. 

How to Get Started

1. Download the latest release (https://github.com/GraphKit/GKGraphKit/releases).
2. Follow the examples below. 
3. Have fun!

Installation with CocoaPods

CocoaPods (http://cocoapods.org) is a dependency manager for Objective-C and now in beta testing for Swift. We recommend using this tool in general. To learn more, visit their website http://cocoapods.org (http://cocoapods.org/). Setting up GraphKit is simple after learning how to use CocoaPods. 

Podfile

platform :ios, ‘8.0’
pod ‘GKGraphKit’

Exmaple Project

Let’s make a simple ‘Hello World’ example, well, let’s do a little more than that ;) How about we make a list manager. You can find the project in the Example Projects folder. A few cool things to note before we get started. GKGraphKit is not just about data. We believe that data and analytics are the same and for that reason, in this example, we will show you how to capture analytics and data without any extra effort.

Once you have downloaded the GraphKitListManager project and latest release, which includes all that you need, follow the steps bellow to gain an understanding of how to do this on your own. 

Add GraphKit Into the Example Project

1. Create a new workspace and name it LearningGraphKit, or something else of your choosing. 
2. Ensure the deployment targets are set to 8.0.
3. Click on the GraphKitListManager build target. Then click on the “+” button for embedding a framework. You should see GKGraphKit pop up in the list.  
4. That’s it, GKGraphKit.framework is now setup in the example project. 

Importing GKGraphKit Into the Example Project

In the AppDelete.swift file, there is a line added at the top that imports the GKGraphKit framework and another line added to “applicationWillTerminate” handler to save data incase termination occurs. 

swift
import GKGraphKit
…
func applicationWillTerminate(application: UIApplication) {
let graph: GKGraph = GKGraph();
graph.save() ￼ { (success: Bool, error: NSError? ) in }
}



License 
AGPLv3 (http://choosealicense.com/licenses/agpl-3.0/) 

Contributors 
Daniel Dahan (https://github.com/danieldahan)  
