/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  * Neither the name of CosmicMind nor the names of its
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

/**
 Compound strings into a single Predicate.
 ### Example
 ```swift
 let compoundString: CompoundString = ("T1" && "T2") || !"T3"
 let predicate = compoundString.predicate(with "X ==")
 print(predicate)
 // prints: (X == "T1" AND X == "T2") OR NOT (X == "T3")
 ```
 */
public struct CompoundString: ExpressibleByStringLiteral {
  /// A reference to NSPredicate.
  private let predicate: NSPredicate

  /// Initialze CompoundString with FALSEPREDICATE.
  init() {
    self.predicate = NSPredicate(value: false)
  }
  
  /**
   Initialize CompoundString with string literal value.
   - Parameter stringLiteral value: An StringLiteralType.
   */
  public init(stringLiteral value: StringLiteralType) {
    self.predicate = NSPredicate(format: "__REPLACE__ == %@", value)
  }

  /**
   Create a Predicate by replacing placeholder with the given format.
   - Parameter with format: A String.
   - Returns: A Predicate having the provided format.
   */
  internal func predicate(with format: String) -> Predicate {
    let format = predicate.predicateFormat.replacingOccurrences(of: "__REPLACE__ ==", with: format)
    let predicates = [NSPredicate(format: format)]
    return Predicate(predicates)
  }
  
  /**
   Initialize a CompoundString with given array of CompoundString by compounding
   them into a single predicate using provided logical type.
   - Parameter _ compounds: An array of CompoundString.
   - Parameter type: An NSCompoundPredicate.LogicalType.
   */
  fileprivate init(_ compounds: [CompoundString], type: NSCompoundPredicate.LogicalType) {
    self.predicate = NSCompoundPredicate(type: type, subpredicates: compounds.map { $0.predicate })
  }
}

/**
 An operator to compound given two CompoundString into
 a single CompoundString using AND logic.
 - Parameter left: A CompoundString.
 - Parameter right: A CompoundString.
 - Returns: A single CompoundString.
 */
public func &&(left: CompoundString, right: CompoundString) -> CompoundString {
  return CompoundString([left, right], type: .and)
}

/**
 An operator to compound given two CompoundString into
 a single CompoundString using OR logic.
 - Parameter left: A CompoundString.
 - Parameter right: A CompoundString.
 - Returns: A single CompoundString.
 */
public func ||(left: CompoundString, right: CompoundString) -> CompoundString {
  return CompoundString([left, right], type: .or)
}

/**
 A prefix operator to negate given CompoundString.
 - Parameter compound: A CompoundString.
 - Returns: A negated CompoundString.
 */
public prefix func !(compound: CompoundString) -> CompoundString {
  return CompoundString([compound], type: .not)
}
