//
//  Predicate.swift
//  Graph
//
//  Created by Orkhan Alikhanov on 8/15/18.
//  Copyright © 2018 Daniel Dahan. All rights reserved.
//

import Foundation

public struct Predicate {
  let predicate: NSPredicate
  
  init(_ predicates: [Predicate], type: NSCompoundPredicate.LogicalType = .and) {
    self.init(predicates.map { $0.predicate }, type: type)
  }
  
  init(_ predicates: [NSPredicate], type: NSCompoundPredicate.LogicalType = .and) {
    predicate = NSCompoundPredicate(type: type, subpredicates: predicates)
  }
}

public func &&(left: Predicate, right: Predicate) -> Predicate {
  return Predicate([left, right])
}

public func ||(left: Predicate, right: Predicate) -> Predicate {
  return Predicate([left, right], type: .or)
}

public prefix func !(predicate: Predicate) -> Predicate {
  return Predicate([predicate], type: .not)
}

private func build(_ key: String, _ value: CVarArg) -> Predicate {
  let v = value as? NSNumber
  let predicates = [
    NSPredicate(format: "ANY propertySet.name LIKE[cd] %@", key),
    NSPredicate(format: "ANY propertySet.object = %@", v ?? value)
  ]
  
  return Predicate(predicates)
}

public func ==(left: String, right: CVarArg) -> Predicate {
  return build(left, right)
}

extension Predicate {
  static func exists(_ properties: String...) -> Predicate {
    return exists(properties)
  }
  
  static func exists(_ properties: [String]) -> Predicate {
    return exists(properties.compound(with: &&))
  }
  
  static func exists(_ properties: CompoundString) -> Predicate {
    return properties.predicate(with: "ANY propertySet.name LIKE[cd]")
  }
  
  static func types(_ types: String...) -> Predicate {
    return self.types(types)
  }
  
  static func types(_ types: [String]) -> Predicate {
    return types.compound(with: ||).predicate(with: "type LIKE[cd]")
  }

  static func has(tags: String...) -> Predicate {
    return has(tags: tags)
  }
  
  static func has(tags: [String]) -> Predicate {
    return has(tags: tags.compound(with: &&))
  }
  
  static func has(tags: CompoundString) -> Predicate {
    return tags.predicate(with: "ANY tagSet.name LIKE[cd]")
  }
  
  static func member(of groups: String...) -> Predicate {
    return member(of: groups)
  }
  
  static func member(of groups: [String]) -> Predicate {
    return member(of: groups.compound(with: &&))
  }
  
  static func member(of groups: CompoundString) -> Predicate {
    return groups.predicate(with: "ANY groupSet.name LIKE[cd]")
  }
}

private extension Array where Element == String {
  func compound(with block: (CompoundString, CompoundString) -> CompoundString) -> CompoundString {
    guard !isEmpty else {
      return CompoundString()
    }
    
    return dropFirst().reduce(CompoundString(stringLiteral: self[0])) {
      block($0, CompoundString(stringLiteral: $1))
    }
  }
}
