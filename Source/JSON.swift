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
		:name:	value
		:description:	The internal value for
		the JSON obejct.
		- returns:	AnyObject
	*/
	public private(set) var value: AnyObject
	
	/**
		:name:	stringValue
		:description:	A string representation of
		the JSON value.
		- returns:	String?
	*/
	public var stringValue: String? {
		return value as? String
	}
	
	/**
		:name:	integerValue
		:description:	An integer prepresentation
		of the JSON value.
		- returns:	Int?
	*/
	public var integerValue: Int? {
		return value as? Int
	}
	
	/**
		:name:	dataValue
		:description:	A serialized version of the
		JSON value.
		- returns:	NSData?
	*/
	public var dataValue: NSData? {
		do {
			return try JSON.serialize(value)
		} catch _ {
			return nil
		}
	}
	
	/**
		:name:	parse
		:description:	Parse a JSON block.
		- returns:	JSON?
	*/
	public class func parse(data: NSData) throws -> JSON {
		var error: NSError? = nil
		do {
			let json: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
			return JSON(value: json)
		} catch let e as NSError {
			error = e
		}
		throw error!
	}
	
	/**
		:name:	parse
		:description:	Parse a JSON block.
		- returns:	JSON?
	*/
	public class func parse(json: String) throws -> JSON {
		var error: NSError? = nil
		do {
			if let data: NSData = NSString(string: json).dataUsingEncoding(NSUTF8StringEncoding) {
				return try parse(data)
			}
		}
		catch let e as NSError {
			error = e
		}
		throw error!
	}
	
	/**
		:name:	serialize
		:description:	Serialize an object.
		- returns:	NSData?
	*/
	public class func serialize(object: AnyObject) throws -> NSData {
		return try NSJSONSerialization.dataWithJSONObject(object, options: [])
	}
	
	/**
		:name:	stringify
		:description:	Stringify an object.
		:Returns:	String?
	*/
	public class func stringify(object: AnyObject) throws -> String {
		var error: NSError?
		do {
			let data: NSData = try JSON.serialize(object)
			if let value = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
				return value
			}
		} catch let e as NSError {
			error = e
		}
		throw error!
	}
	
	/**
		:name:	init
		:description:	Constructor.
	*/
	public init(value: AnyObject) {
		self.value = value
	}
	
	/**
		:name:	description
		:description:	Conforms to the Printable Protocol. Outputs the
		data in the OrderedSet in a readable format.
		- returns:	String
	*/
	public var description: String {
		var error: NSError?
		var stringified: String?
		do {
			stringified = try JSON.stringify(value)
		} catch let e as NSError {
			error = e
			stringified = nil
		}
		return nil == error && nil != stringified ? stringified! : "{}"
	}
	
	/**
		:name:	operator [0...count - 1]
		:description:	Allows array like access of the index.
		- returns:	JSON?
	*/
	public subscript(index: Int) -> JSON? {
		if let item: Array<AnyObject> = value as? Array<AnyObject> {
			return JSON(value: item[index])
		}
		return nil
	}
	
	/**
		:name:	operator [key 1...key n]
		:description:	Property key mapping. If the key type is a
		String, this feature allows access like a
		Dictionary.
		- returns:	JSON?
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
	do {
		let l: String? = try JSON.stringify(lhs.value)
		let r: String? = try JSON.stringify(rhs.value)
		return l == r
	} catch {}
	return false
}
