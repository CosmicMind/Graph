/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
 *	*	Neither the name of CosmicMind nor the names of its
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

open class GraphJSON: Equatable, CustomStringConvertible {
  /// A desiption of the object, used when printing.
  open var description: String {
    return GraphJSON.stringify(object: object) ?? "{}"
  }
  
  /// A reference to the core object.
  open private(set) var object: Any
  
  /// An Array representation of the object.
  open var asArray: [Any]? {
    return object as? [Any]
  }
  
  /// A Dictionary representation of the object.
  open var asDictionary: [String: Any]? {
    return object as? [String: Any]
  }
  
  /// A String representation of the object.
  open var asString: String? {
    return object as? String
  }
  
  /// An Int representation of the object.
  open var asInt: Int? {
    return object as? Int
  }
  
  /// A Double representation of the object.
  open var asDouble: Double? {
    return object as? Double
  }
  
  /// A Float representation of the object.
  open var asFloat: Float? {
    return object as? Float
  }
  
  /// A Bool representation of the object.
  open var asBool: Bool? {
    return object as? Bool
  }
  
  /// A Data representation of the object.
  open var asNSData: Data? {
    return GraphJSON.serialize(object: object)
  }
  
  /**
   Parses a given Data object.
   - Parameter _ data: A Data object.
   - Parameter options: JSONSerialization.ReadingOptions.
   - Returns: A GraphJSON object on success, nil otherwise.
   */
  open class func parse(_ data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) -> GraphJSON? {
    guard let object = try? JSONSerialization.jsonObject(with: data, options: options) else {
      return nil
    }
    
    return GraphJSON(object)
  }
  
  /**
   Parses a given String object.
   - Parameter _ string: A Data object.
   - Parameter options: JSONSerialization.ReadingOptions.
   - Returns: A GraphJSON object on success, nil otherwise.
   */
  open class func parse(_ string: String, options: JSONSerialization.ReadingOptions = .allowFragments) -> GraphJSON? {
    guard let data = string.data(using: String.Encoding.utf8) else {
      return nil
    }
    
    return parse(data, options: options)
  }
  
  /**
   Serializes an Any object into a Data object.
   - Parameter object: An Any object.
   - Returns: A Data object if successful, nil otherwise.
   */
  open class func serialize(object: Any) -> Data? {
    return try? JSONSerialization.data(withJSONObject: object, options: [])
  }
  
  /**
   Stringifies an instance of Any object into a String.
   - Parameter object: An Any object.
   - Returns: A String object if successful, nil otherwise.
   */
  open class func stringify(object: Any) -> String? {
    if let o = object as? GraphJSON {
      return stringify(object: o.object)
    
    } else if let data = GraphJSON.serialize(object: object) {
      if let o = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
        return o
      }
    }
    
    return nil
  }
  
  /// An initializer that accepts a given Any object.
  public required init(_ object: Any) {
    if let o = object as? GraphJSON {
      self.object = o.object
    
    } else {
      self.object = object
    }
  }
  
  /**
   A subscript operator for Array style access.
   - Parameter index: An Int.
   - Returns: A GraphJSON object if successful, nil otherwise.
   */
  open subscript(index: Int) -> GraphJSON? {
    guard let item = asArray else {
      return nil
    }
    
    return GraphJSON(item[index])
  }
  
  /**
   A subscript operator for Dictionary style access.
   - Parameter key: A String.
   - Returns: A GraphJSON object if successful, nil otherwise.
   */
  open subscript(key: String) -> GraphJSON? {
    guard let item = asDictionary else {
      return nil
    }
    
    guard nil != item[key] else {
      return nil
    }
    
    return GraphJSON(item[key]!)
  }
}

public func ==(lhs: GraphJSON, rhs: GraphJSON) -> Bool {
  return GraphJSON.stringify(object: lhs.object) == GraphJSON.stringify(object: rhs.object)
}
