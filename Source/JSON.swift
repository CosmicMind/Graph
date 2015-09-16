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

public class JSON : Equatable, CustomStringConvertible {
	/**
		:name:	array
	*/
	public var array: Array<AnyObject>? {
		return object as? Array<AnyObject>
	}
	
	/**
		:name:	dictionary
	*/
	public var dictionary: Dictionary<String, AnyObject>? {
		return object as? Dictionary<String, AnyObject>
	}
	
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
		:name:	string
	*/
	public var string: String? {
		return object as? String
	}
	
	/**
		:name:	int
	*/
	public var int: Int? {
		return object as? Int
	}
	
	/**
		:name:	double
	*/
	public var double: Double? {
		return object as? Double
	}
	
	/**
		:name:	double
	*/
	public var float: Float? {
		return object as? Float
	}
	
	/**
		:name:	bool
	*/
	public var bool: Bool? {
		return object as? Bool
	}
	
	/**
		:name:	dataValue
	*/
	public var data: NSData? {
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
		if let data: NSData = JSON.serialize(object) {
			if let o: String = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
				return o
			}
		}
		return nil
	}
	
	/**
		:name:	stringify
	*/
	public class func stringify(object: JSON) -> String? {
		return stringify(object.object)
	}
	
	/**
		:name:	init
	*/
	public required init(_ object: AnyObject) {
		self.object = object
	}
	
	/**
		:name:	init
	*/
	public init(_ object: JSON) {
		self.object = object.object
	}
	
	/**
		:name:	init
	*/
	public init(_ object: Array<AnyObject>) {
		self.object = object
	}
	
	/**
		:name:	init
	*/
	public init(_ object: Dictionary<String, AnyObject>) {
		self.object = object
	}
	
	/**
		:name:	operator [0...count - 1]
	*/
	public subscript(index: Int) -> AnyObject? {
		get { return nil }
		set(value) {
			if var item: Array<AnyObject> = array {
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
			if let item: Array<AnyObject> = array {
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
			if var item: Dictionary<String, AnyObject> = dictionary {
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
			if let item: Dictionary<String, AnyObject> = dictionary {
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
