/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  *  Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  *  Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  *  Neither the name of CosmicMind nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
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

public struct AnyCodable: Codable {
  public let value: Encodable
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
   - Parameter encoder: The encoder to write data to.
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
  
  
  func encode(to container: inout SingleValueEncodingContainer) throws {
    try container.encode(self)
  }
}
