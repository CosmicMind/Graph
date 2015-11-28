//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

public protocol SessionDelegate {
	/**
		:name:	sessionDidReceiveGetResponse
		:description:	An optional Delegate that is called when GET requests are completed.
	*/
	func sessionDidReceiveGetResponse(session: Session, json: JSON?, error: NSError?)
	
	/**
		:name:	sessionDidReceivePOSTResponse
		:description:	An optional Delegate that is called when POST requests are completed.
	*/
	func sessionDidReceivePOSTResponse(session: Session, json: JSON?, error: NSError?)
}

public extension SessionDelegate {
	func sessionDidReceiveGetResponse(session: Session, json: JSON?, error: NSError?) {}
	func sessionDidReceivePOSTResponse(session: Session, json: JSON?, error: NSError?) {}
}

public class Session : NSObject {
	/**
		:name:	delegate
		:description:	An Optional delegate to set
		for Session GET/POST requests.
		- returns:	SessionDelegate?
	*/
	public var delegate: SessionDelegate?
	
	/**
		:name:	init
		:description:	Constructor.
	*/
	public override init() {
		super.init()
	}
	
	/**
		:name:	get
		:description:	Sends a GET request.
		- parameter	url:	NSURL	URL destination.
		- parameter	completion:	(json: JSON?, error: NSError?) -> ()	An Optional callback.
	*/
	public func get(url: NSURL, completion: (json: JSON?, error: NSError?) -> ()) {
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "GET"
		
		NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
			var json: JSON?
			var err: NSError?
			if nil == error {
				json = JSON.parse(data!)
			} else {
				err = error
			}
            dispatch_async(dispatch_get_main_queue()) {
                completion(json: json, error: err)
            }
			self.delegate?.sessionDidReceiveGetResponse(self, json: json, error: err)
		}).resume()
	}
	
	/**
		:name:	post
		:description:	Sends a POST request.
		- parameter	url:	NSURL	URL destination.
		- parameter	json:	JSON?	An Optional JSON block to send.
		- parameter	completion:	(json: JSON?, error: NSError?) -> ()	An Optional callback.
	*/
	public func post(url: NSURL, json: JSON?, completion: (json: JSON?, error: NSError?) -> ()) {
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "POST"
		request.HTTPBody = json?.asNSData
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
			var json: JSON?
			var err: NSError?
			if nil == error {
				json = JSON.parse(data!)
			} else {
				err = error
			}
            dispatch_async(dispatch_get_main_queue()) {
                completion(json: json, error: err)
            }
            self.delegate?.sessionDidReceivePOSTResponse(self, json: json, error: err)
		}).resume()
	}
}