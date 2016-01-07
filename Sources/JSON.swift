/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of GraphKit nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation

public class JSON : Equatable, CustomStringConvertible {
	/**
	:name:	description
	*/
	public var description: String {
		let s: String? = JSON.stringify(object)
		return nil == s ? "{}" : s!
	}
	
	/**
	:name:	object
	*/
	public private(set) var object: AnyObject
	
	/**
	:name:	asArray
	*/
	public var asArray: Array<AnyObject>? {
		get {
			return object as? Array<AnyObject>
		}
		set(value) {
			object = value!
		}
	}
	
	/**
	:name:	asDictionary
	*/
	public var asDictionary: Dictionary<String, AnyObject>? {
		get {
			return object as? Dictionary<String, AnyObject>
		}
		set(value) {
			object = value!
		}
	}
	
	/**
	:name:	asString
	*/
	public var asString: String? {
		return object as? String
	}
	
	/**
	:name:	asInt
	*/
	public var asInt: Int? {
		return object as? Int
	}
	
	/**
	:name:	asDouble
	*/
	public var asDouble: Double? {
		return object as? Double
	}
	
	/**
	:name:	asFloat
	*/
	public var asFloat: Float? {
		return object as? Float
	}
	
	/**
	:name:	asBool
	*/
	public var asBool: Bool? {
		return object as? Bool
	}
	
	/**
	:name:	asNSData
	*/
	public var asNSData: NSData? {
		return JSON.serialize(object)
	}
	
	/**
	:name:	parse
	*/
	public class func parse(data: NSData, options: NSJSONReadingOptions = .AllowFragments) -> JSON? {
		if let object: AnyObject = try? NSJSONSerialization.JSONObjectWithData(data, options: options) {
			return JSON(object)
		}
		return nil
	}
	
	/**
	:name:	parse
	*/
	public class func parse(json: String) -> JSON? {
		if let data: NSData = NSString(string: json).dataUsingEncoding(NSUTF8StringEncoding) {
			return parse(data)
		}
		return nil
	}
	
	/**
	:name:	serialize
	*/
	public class func serialize(object: AnyObject) -> NSData? {
		return try? NSJSONSerialization.dataWithJSONObject(object, options: [])
	}
	
	/**
	:name:	stringify
	*/
	public class func stringify(object: AnyObject) -> String? {
		if let o: JSON = object as? JSON {
			return stringify(o.object)
		} else if let data: NSData = JSON.serialize(object) {
			if let o: String = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
				return o
			}
		}
		return nil
	}
	
	/**
	:name:	init
	*/
	public required init(_ object: AnyObject) {
		if let o: JSON = object as? JSON {
			self.object = o.object
		} else {
			self.object = object
		}
	}
	
	/**
	:name:	operator [0...count - 1]
	*/
	public subscript(index: Int) -> AnyObject? {
		get { return nil }
		set(value) {
			if var item: Array<AnyObject> = asArray {
				if let o: JSON = value as? JSON {
					item[index] = o.object
				} else if nil == value {
					item.removeAtIndex(index)
				} else {
					item[index] = value!
				}
				object = item as AnyObject
			}
		}
	}
	
	/**
	:name:	operator [0...count - 1]
	*/
	public subscript(index: Int) -> JSON? {
		get {
			if let item: Array<AnyObject> = asArray {
				return JSON(item[index])
			}
			return nil
		}
	}
	
	/**
	:name:	operator [key 1...key n]
	*/
	public subscript(key: String) -> AnyObject? {
		get { return nil }
		set(value) {
			if var item: Dictionary<String, AnyObject> = asDictionary {
				if let o: JSON = value as? JSON {
					item[key] = o.object
				} else {
					item[key] = value
				}
				object = item as AnyObject
			}
		}
	}
	
	/**
	:name:	operator [key 1...key n]
	*/
	public subscript(key: String) -> JSON? {
		get {
			if let item: Dictionary<String, AnyObject> = asDictionary {
				if nil != item[key] {
					return JSON(item[key]!)
				}
			}
			return nil
		}
	}
}

public func ==(lhs: JSON, rhs: JSON) -> Bool {
	return JSON.stringify(lhs.object)! == JSON.stringify(rhs.object)!
}
