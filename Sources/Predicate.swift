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
 A wrapper around NSPredicate to simplify generation of
 predicates for Search and Watch API of Graph by providing
 a set of operators and functions.
 
 ### Example
 ```swift
 let predicate: Predicate = .has(tags: "T1", "T2", using: ||)
   && .member(of: "T1", "T2", using: &&)
   && .exists(("T1" && "T2") || !"T3")
   && !.type("User")
   || "key" != "value"
   || "number" >= 20 && "bool" == true
 ```
 */
public struct Predicate {
  /// A reference to NSPredicate.
  let predicate: NSPredicate
  
  /**
   Initialize a Predicate with given array of Predicate by compounding
   them into a single predicate using provided logical type.
   - Parameter _ predicates: An array of Predicate.
   - Parameter type: An NSCompoundPredicate.LogicalType.
   */
  init(_ predicates: [Predicate], type: NSCompoundPredicate.LogicalType = .and) {
    self.init(predicates.map { $0.predicate }, type: type)
  }

  /**
   Initialize a Predicate with given array of NSPredicate by compounding
   them into a single predicate using provided logical type.
   - Parameter _ predicates: An array of NSPredicate.
   - Parameter type: An NSCompoundPredicate.LogicalType.
   */
  init(_ predicates: [NSPredicate], type: NSCompoundPredicate.LogicalType = .and) {
    predicate = NSCompoundPredicate(type: type, subpredicates: predicates)
  }
}

/**
 An operator to compound given two Predicate into a single
 Predicate using AND logic.
 - Parameter left: A Predicate.
 - Parameter right: A Predicate.
 - Returns: A single Predicate.
 */
public func &&(left: Predicate, right: Predicate) -> Predicate {
  return Predicate([left, right])
}

/**
 An operator to compound given two Predicate into a single
 Predicate using OR logic.
 - Parameter left: A Predicate.
 - Parameter right: A Predicate.
 - Returns: A single Predicate.
 */
public func ||(left: Predicate, right: Predicate) -> Predicate {
  return Predicate([left, right], type: .or)
}

/**
 A prefix operator to negate given Predicate.
 - Parameter predicate: A Predicate.
 - Returns: A negated Predicate.
 */
public prefix func !(predicate: Predicate) -> Predicate {
  return Predicate([predicate], type: .not)
}

/**
 Build a property query Predicate by comparing given key and value
 using provided NSComparisonPredicate.Operator type.
 - Parameter _ key: A String representing key of property.
 - Parameter _ value: An NSNumber or String representing value of property.
 - Parameter type: A comparison operator between key and value.
 - Returns: A property Predicate.
 */
private func build(_ key: String, _ value: CVarArg, type: NSComparisonPredicate.Operator) -> Predicate {

  let isString = value is String
  let requiresNot = isString && type == .notEqualTo
  
  let o = NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: "$property.object"),
                                rightExpression: NSExpression(forConstantValue: value),
                                modifier: .direct,
                                type: isString ? .like : type,
                                options: isString ? [.caseInsensitive, .diacriticInsensitive] : []).predicateFormat

  let p = NSPredicate(format: "\(requiresNot ? "NOT" : "")(SUBQUERY(propertySet, $property, $property.name LIKE[cd] %@ AND \(o)).@count > 0)", key)
  return Predicate([p])
}

/**
 An operator to create a property Predicate where key equals to value.
 - Parameter key: A String.
 - Parameter value: An NSNumber or String.
 - Returns: A property Predicate.
 */
public func ==(key: String, value: CVarArg) -> Predicate {
  return build(key, value, type: .equalTo)
}

/**
 An operator to create a property Predicate where key does not
 equal to value.
 - Parameter key: A String.
 - Parameter value: An NSNumber or String.
 - Returns: A property Predicate.
 */
public func !=(key: String, value: CVarArg) -> Predicate {
  return build(key, value, type: .notEqualTo)
}

/**
 An operator to create a property Predicate where key is
 greater than value.
 - Parameter key: A String.
 - Parameter value: An NSNumber.
 - Returns: A property Predicate.
 */
public func >(left: String, right: NSNumber) -> Predicate {
  return build(left, right, type: .greaterThan)
}

/**
 An operator to create a property Predicate where key is
 greater than or equal to value.
 - Parameter key: A String.
 - Parameter value: An NSNumber.
 - Returns: A property Predicate.
 */
public func >=(left: String, right: NSNumber) -> Predicate {
  return build(left, right, type: .greaterThanOrEqualTo)
}

/**
 An operator to create a property Predicate where key is
 less than value.
 - Parameter key: A String.
 - Parameter value: An NSNumber.
 - Returns: A property Predicate.
 */
public func <(left: String, right: NSNumber) -> Predicate {
  return build(left, right, type: .lessThan)
}

/**
 An operator to create a property Predicate where key is
 less than or equal to value.
 - Parameter key: A String.
 - Parameter value: An NSNumber.
 - Returns: A property Predicate.
 */
public func <=(left: String, right: NSNumber) -> Predicate {
  return build(left, right, type: .lessThanOrEqualTo)
}

extension Predicate {
  /**
   Create a Predicate to filter nodes that have any of
   the properties in the given list.
   - Parameter _ properties: A list of String.
   - Returns: A Predicate.
   */
  static func exists(_ properties: String...) -> Predicate {
    return exists(properties)
  }

  /**
   Create a Predicate to filter nodes that have any of
   the properties in the given array.
   - Parameter _ properties: An array of String.
   - Returns: A Predicate.
   */
  static func exists(_ properties: [String]) -> Predicate {
    return exists(properties, using: ||)
  }

  /**
   Create a Predicate to filter nodes that have the properties
   in the given list compounding using provided compounder.
   - Parameter _ properties: A list of String.
   - Parameter using compounder: A Compounder closure.
   - Returns: A Predicate.
   */
  static func exists(_ properties: String..., using compounder: Compounder) -> Predicate {
    return exists(properties, using: compounder)
  }

  /**
   Create a Predicate to filter nodes that have the properties
   in the given array compounding using provided compounder.
   - Parameter _ properties: An array of String.
   - Parameter using compounder: A Compounder closure.
   - Returns: A Predicate.
   */
  static func exists(_ properties: [String], using compounder: Compounder) -> Predicate {
    return exists(properties.compound(with: compounder))
  }
  
  /**
   Create a Predicate to filter nodes that have the properties
   in the given CompoundString.
   - Parameter _ properties: A CompoundString.
   - Returns: A Predicate.
   */
  static func exists(_ properties: CompoundString) -> Predicate {
    return properties.predicate(with: "ANY propertySet.name LIKE[cd]")
  }
  
  /**
   Create a Predicate to filter nodes that have any of
   the types in the given list.
   - Parameter _ types: A list of String.
   - Returns: A Predicate.
   */
  static func type(_ types: String...) -> Predicate {
    return self.type(types)
  }

  /**
   Create a Predicate to filter nodes that have any of
   the types in the given array.
   - Parameter _ types: An array of String.
   - Returns: A Predicate.
   */
  static func type(_ types: [String]) -> Predicate {
    return self.type(types, using: ||)
  }
  
  /**
   Create a Predicate to filter nodes that have the types
   in the given list compounding using provided compounder.
   - Parameter _ types: A list of String.
   - Parameter using compounder: A Compounder closure.
   - Returns: A Predicate.
   */
  static func type(_ types: String..., using compounder: Compounder) -> Predicate {
    return self.type(types, using: compounder)
  }
  
  /**
   Create a Predicate to filter nodes that have the types
   in the given list compounding using provided compounder.
   - Parameter _ types: An array of String.
   - Parameter using compounder: A Compounder closure.
   - Returns: A Predicate.
   */
  static func type(_ types: [String], using compounder: Compounder) -> Predicate {
    return self.type(types.compound(with: compounder))
  }
  
  /**
   Create a Predicate to filter nodes that have the types
   in the given CompoundString.
   - Parameter _ types: A CompoundString.
   - Returns: A Predicate.
   */
  static func type(_ types: CompoundString) -> Predicate {
    return types.predicate(with: "type LIKE[cd]")
  }
  
  /**
   Create a Predicate to filter nodes that have any of
   the tags in the given list.
   - Parameter tags: A list of String.
   - Returns: A Predicate.
   */
  static func has(tags: String...) -> Predicate {
    return has(tags: tags)
  }

  /**
   Create a Predicate to filter nodes that have any of
   the tags in the given array.
   - Parameter tags: An array of String.
   - Returns: A Predicate.
   */
  static func has(tags: [String]) -> Predicate {
    return has(tags: tags, using: ||)
  }

  /**
   Create a Predicate to filter nodes that have the tags
   in the given list compounding using provided compounder.
   - Parameter tags: A list of String.
   - Parameter using compounder: A Compounder closure.
   - Returns: A Predicate.
   */
  static func has(tags: String..., using compounder: Compounder) -> Predicate {
    return has(tags: tags, using: compounder)
  }
  
  /**
   Create a Predicate to filter nodes that have the tags
   in the given array compounding using provided compounder.
   - Parameter tags: An array of String.
   - Parameter using compounder: A Compounder closure.
   - Returns: A Predicate.
   */
  static func has(tags: [String], using compounder: Compounder) -> Predicate {
    return has(tags: tags.compound(with: compounder))
  }
  
  /**
   Create a Predicate to filter nodes that have the tags
   in the given CompoundString.
   - Parameter tags: A CompoundString.
   - Returns: A Predicate.
   */
  static func has(tags: CompoundString) -> Predicate {
    return tags.predicate(with: "ANY tagSet.name LIKE[cd]")
  }
  
  /**
   Create a Predicate to filter nodes that have any of
   the groups in the given list.
   - Parameter of groups: A list of String.
   - Returns: A Predicate.
   */
  static func member(of groups: String...) -> Predicate {
    return member(of: groups)
  }
  
  /**
   Create a Predicate to filter nodes that have any of
   the groups in the given array.
   - Parameter of groups: An array of String.
   - Returns: A Predicate.
   */
  static func member(of groups: [String]) -> Predicate {
    return member(of: groups, using: ||)
  }
  
  /**
   Create a Predicate to filter nodes that have the groups
   in the given list compounding using provided compounder.
   - Parameter of groups: A list of String.
   - Parameter using compounder: A Compounder closure.
   - Returns: A Predicate.
   */
  static func member(of groups: String..., using compounder: Compounder) -> Predicate {
    return member(of: groups, using: compounder)
  }

  /**
   Create a Predicate to filter nodes that have the groups
   in the given array compounding using provided compounder.
   - Parameter of groups: An array of String.
   - Parameter using compounder: A Compounder closure.
   - Returns: A Predicate.
   */
  static func member(of groups: [String], using compounder: Compounder) -> Predicate {
    return member(of: groups.compound(with: compounder))
  }
  
  /**
   Create a Predicate to filter nodes that have the groups
   in the given CompoundString.
   - Parameter of groups: A CompoundString.
   - Returns: A Predicate.
   */
  static func member(of groups: CompoundString) -> Predicate {
    return groups.predicate(with: "ANY groupSet.name LIKE[cd]")
  }
}

/**
 A compounder clousure that takes two CompoundString
 and merges them into a single CompoundString.
 */
public typealias Compounder = (CompoundString, CompoundString) -> CompoundString

private extension Array where Element == String {
  
  /**
   Compound the string array into a single CompoundString
   using provided compounder clousure.
   - Parameter with block: A Compounder closure.
   - Returns: A single CompoundString.
   */
  func compound(with block: Compounder) -> CompoundString {
    guard !isEmpty else {
      return CompoundString()
    }
    
    return dropFirst().reduce(CompoundString(stringLiteral: self[0])) {
      block($0, CompoundString(stringLiteral: $1))
    }
  }
}
