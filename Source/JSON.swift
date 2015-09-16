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
	public class func parse(data: NSData) -> JSON? {
		if let object: AnyObject = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
			return JSON(object: object)
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
			if let object: String = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
				return object
			}
		}
		return nil
	}
	
	/**
		:name:	stringify
	*/
	public class func stringify(json: JSON) -> String? {
		return stringify(json.object)
	}
	
	/**
		:name:	init
	*/
	public init(object: AnyObject) {
		self.object = object
	}
	
	/**
		:name:	init
	*/
	public init(object: JSON) {
		self.object = object.object
	}
	
	/**
		:name:	append
	*/
	public func append(value: AnyObject) {
		if var item: Array<AnyObject> = array {
			if let v: AnyObject = value {
				item.append(v)
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
				return JSON(object: item[index])
			}
			return nil
		}
		set(value) {
			if var item: Array<AnyObject> = array {
				if let v: JSON = value {
					item[index] = v.object
					object = item as AnyObject
				}
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
					return JSON(object: item[key]!)
				}
			}
			return nil
		}
		set(value) {
			if var item: Dictionary<String, AnyObject> = dictionary {
				item[key] = value?.object
				object = item as AnyObject
			}
		}
	}
}

public func ==(lhs: JSON, rhs: JSON) -> Bool {
	return JSON.stringify(lhs.object)! == JSON.stringify(rhs.object)!
}
