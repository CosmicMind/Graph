//
//  CompoundString.swift
//  Graph
//
//  Created by Orkhan Alikhanov on 8/16/18.
//  Copyright © 2018 Daniel Dahan. All rights reserved.
//

import Foundation

public struct CompoundString: ExpressibleByStringLiteral {
  private let predicate: NSPredicate

  init() {
    self.predicate = NSPredicate(value: false)
  }
  
  public init(stringLiteral value: StringLiteralType) {
    self.predicate = NSPredicate(format: "__REPLACE__ == %@", value)
  }
  
  internal func predicate(with format: String) -> Predicate {
    let format = predicate.predicateFormat.replacingOccurrences(of: "__REPLACE__ ==", with: format)
    let predicates = [NSPredicate(format: format)]
    return Predicate(predicates)
  }
  
  fileprivate init(_ predicates: [CompoundString], type: NSCompoundPredicate.LogicalType) {
    self.predicate = NSCompoundPredicate(type: type, subpredicates: predicates.map { $0.predicate })
  }
}

public func &&(left: CompoundString, right: CompoundString) -> CompoundString {
  return CompoundString([left, right], type: .and)
}

public func ||(left: CompoundString, right: CompoundString) -> CompoundString {
  return CompoundString([left, right], type: .or)
}

public prefix func !(compound: CompoundString) -> CompoundString {
  return CompoundString([compound], type: .not)
}

