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

public class JSON {
	public var error: NSError?
	
	private var parsedObject: AnyObject
	
	public var stringValue: String {
		return parsedObject as! String
	}
	
	public var integerValue: Int {
		return parsedObject as! Int
	}
	
	/**
		:name:	parse
		:description:	Parsing a JSON block.
	*/
	public class func parse(data: NSData!, inout error: NSError?) -> JSON? {
		var parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
		if nil != parsedObject {
			return JSON(parsedObject: parsedObject)
		}
		return nil
	}
	
	public init(parsedObject: AnyObject!) {
		self.parsedObject = parsedObject
	}
	
	public subscript(index: Int) -> JSON? {
		if let item: Array<AnyObject> = parsedObject as? Array<AnyObject> {
			return JSON(parsedObject: item[index])
		}
		return nil
	}
	
	public subscript(key: String) -> JSON? {
		if let item: Dictionary<String, AnyObject> = parsedObject as? Dictionary<String, AnyObject> {
			if nil != item[key] {
				return JSON(parsedObject: item[key]!)
			}
		}
		return nil
	}
}