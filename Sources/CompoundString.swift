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
  
  /**
   Initialize a CompoundString with given array of CompoundString by compounding
   them into a single predicate using provided logical type.
   - Parameter _ compounds: An array of CompoundString.
   - Parameter type: An NSCompoundPredicate.LogicalType.
   */
  fileprivate init(_ compounds: [CompoundString], type: NSCompoundPredicate.LogicalType) {
    self.predicate = NSCompoundPredicate(type: type, subpredicates: compounds.map { $0.predicate })
  }
  
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
