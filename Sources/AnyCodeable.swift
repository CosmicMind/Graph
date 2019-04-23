/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

public struct AnyCodable: Codable {
  /// Encoded value.
  public let value: Encodable
  
  /// Codable types.
  public static var codables: [Codable.Type] = [
    String.self,
    Double.self,
    Bool.self,
    Date.self,
    Data.self,
    Int.self,
    URL.self
  ]
  
  /**
   Recursively creates AnyCodable instance.
   - Parameter _ value: Any value.
   */
  public init?(_ value: Any) {
    if let array = value as? [Any] {
      self.value = array.map { AnyCodable($0) }
      return
    }
    
    if let dictionary = value as? [String: Any] {
      self.value = dictionary.reduce(into: [String: AnyCodable]()) {
        $0[$1.key] = AnyCodable($1.value)
      }
      return
    }
    
    /// value as? Encodable always fails.
    /// So we cast to the supported types and take the Encodable value.
    for c in AnyCodable.codables {
      if let v = c.casting(value) {
        self.value = v
        return
      }
    }
    
    return nil
  }
  
  /**
   Creates a new instance by decoding from the given decoder.
   - Parameter decoder: The decoder to read data from.
   */
  public init(from decoder: Decoder) throws {
    /// Trying to decode from supporting types.
    for c in AnyCodable.codables {
      if let v = try? c.init(from: decoder) {
        value = v
        return
      }
    }
    
    if let v = try? [AnyCodable].init(from: decoder) {
      value = v
      return
    }
    
    if let v = try? [String: AnyCodable].init(from: decoder) {
      value = v
      return
    }
    
    
    throw DecodingError.dataCorruptedError(in: try decoder.unkeyedContainer(), debugDescription: "[AnyCodable: Failed to decode]")
  }
  
  /**
   Encodes this value into the given encoder.
   - Parameter to encoder: The encoder to write data to.
   */
  public func encode(to encoder: Encoder) throws {
    /// https://stackoverflow.com/q/48658574/jsonencoders-dateencodingstrategy-not-working
    var container = encoder.singleValueContainer()
    try value.encode(to: &container)
  }
  
  /// Recursively unwraps any nested AnyCodable in the value.
  public func unwrap() -> Any {
    return AnyCodable.unwrap(self)
  }
}

private extension AnyCodable {
  /// Recursively unwraps any nested AnyCodable in the value.
  static func unwrap(_ value: Any) -> Any {
    if let v = value as? AnyCodable {
      return unwrap(v.value)
    }
    
    if let v = value as? [AnyCodable] {
      return v.map { unwrap($0.value) }
    }
    
    if let v = value as? [String: AnyCodable] {
      return v.reduce(into: [String: Any]()) {
        $0[$1.key] = unwrap($1.value)
      }
    }
    
    return value
  }
}

private extension Encodable {
  /**
   Casts a value to itself.
   - Parameter _ value: A value to be cast.
   - Returns: Casted value, nil if cast failed.
   */
  static func casting(_ value: Any) -> Self? {
    return value as? Self
  }
  
  
  /**
   Encodes this value into the given encoder.
   - Parameter to container: A SingleValueEncodingContainer to encode.
   */
  func encode(to container: inout SingleValueEncodingContainer) throws {
    try container.encode(self)
  }
}
