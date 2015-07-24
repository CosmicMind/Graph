/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

public class JSON: Printable {
	/**
		:name:	value
	*/
	public private(set) var value: AnyObject?
	
	/**
		:name:	value
	*/
	public var stringValue: String? {
		return value as? String
	}
	
	/**
		:name:	value
	*/
	public var integerValue: Int? {
		return value as? Int
	}
	
	/**
		:name:	parse
		:description:	Parse a JSON block.
	*/
	public class func parse(data: NSData!, inout error: NSError?) -> JSON? {
		if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) {
			return JSON(value: json)
		}
		return nil
	}
	
	/**
		:name:	parse
		:description:	Parse a JSON block.
	*/
	public class func parse(json: String!, inout error: NSError?) -> JSON? {
		if let data: NSData = NSString(string: json).dataUsingEncoding(NSUTF8StringEncoding) {
			return parse(data, error: &error)
		}
		return nil
	}
	
	/**
		:name:	serialize
		:description:	Serialize an object.
	*/
	public class func serialize(object: AnyObject!, inout error: NSError?) -> NSData? {
		return NSJSONSerialization.dataWithJSONObject(object, options: nil, error: &error)
	}
	
	/**
		:name:	stringify
		:description:	Stringify an object.
	*/
	public class func stringify(object: AnyObject!, inout error: NSError?) -> String? {
		if let data: NSData = NSJSONSerialization.dataWithJSONObject(object, options: nil, error: &error) {
			return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
		}
		return nil
	}
	
	public init(value: AnyObject!) {
		self.value = value
	}
	
	/**
	:name:	description
	:description:	Conforms to the Printable Protocol. Outputs the
	data in the OrderedSet in a readable format.
	*/
	public var description: String {
		var error: NSError?
		var stringified: String? = JSON.stringify(value, error: &error)
		return nil == error && nil != stringified ? stringified! : "{}"
	}
	
	public subscript(index: Int) -> JSON? {
		if let item: Array<AnyObject> = value as? Array<AnyObject> {
			return JSON(value: item[index])
		}
		return nil
	}
	
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
	var error: NSError?
	if let l: String? = JSON.stringify(lhs.value, error: &error) {
		if let r: String? = JSON.stringify(rhs.value, error: &error) {
			return l == r
		}
	}
	return false
}
