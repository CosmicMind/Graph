//
//  AppDelegate.swift
//  GraphKitListManager
//
//  Created by Daniel Dahan on 2015-03-06.
//  Copyright (c) 2015 GraphKit, Inc. All rights reserved.
//

import UIKit
import GKGraphKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	private lazy var graph: GKGraph = GKGraph()
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		
		// lets create a User Entity that will be used throughout the app.
		var user: GKEntity? = graph.search(Entity: "User").last
		if nil == user {
			user = GKEntity(type: "User")
			// this saves the user to the Graph
			graph.save() { (success: Bool, error: NSError?) in }
		}
		
		// create an instance of a List to pass to the ListViewController
		var list: GKEntity? = graph.search(Entity: "List").last
		if nil == list {
			list = GKEntity(type: "List")
		}
		
		var navigationController = UINavigationController(rootViewController: ListViewController(list: list))
		navigationController.navigationBar.barTintColor = UIColor(red: 96/255.0, green: 125/255.0, blue: 139/255.0, alpha: 1)
		window!.rootViewController = navigationController
		window!.backgroundColor = UIColor(red: 213/255.0, green: 222/255.0, blue: 226/255.0, alpha: 1)
		window!.makeKeyAndVisible()
		return true
	}
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		graph.save() {(success: Bool, error: NSError?) in }
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		graph.save() {(success: Bool, error: NSError?) in }
	}
}

