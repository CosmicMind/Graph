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
		:name:	description
	*/
	public var description: String {
		let s: String? = JSON.stringify(value)
		return nil == s ? "{}" : s!
	}
	
	/**
		:name:	value
	*/
	public private(set) var value: AnyObject
	
	/**
		:name:	stringValue
	*/
	public var stringValue: String? {
		return value as? String
	}
	
	/**
		:name:	integerValue
	*/
	public var integerValue: Int? {
		return value as? Int
	}
	
	/**
		:name:	dataValue
	*/
	public var dataValue: NSData? {
		return JSON.serialize(value)
	}
	
	/**
		:name:	parse
	*/
	public class func parse(data: NSData) -> JSON? {
		if let value: AnyObject = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
			return JSON(value: value)
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
			if let value: String = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
				return value
			}
		}
		return nil
	}
	
	/**
		:name:	init
	*/
	public init(value: AnyObject) {
		self.value = value
	}

	/**
		:name:	operator [0...count - 1]
	*/
	public subscript(index: Int) -> JSON? {
		if let item: Array<AnyObject> = value as? Array<AnyObject> {
			return JSON(value: item[index])
		}
		return nil
	}
	
	/**
		:name:	operator [key 1...key n]
	*/
	public subscript(key: String) -> JSON? {
		if let item: Dictionary<String, AnyObject> = value as? Dictionary<String, AnyObject> {
			if nil != item[key] {
				return JSON(value: item[key]!)
			}
		}
		return nil
	}
}

public func ==(lhs: JSON, rhs: JSON) -> Bool {
	return JSON.stringify(lhs.value)! == JSON.stringify(rhs.value)!
}
