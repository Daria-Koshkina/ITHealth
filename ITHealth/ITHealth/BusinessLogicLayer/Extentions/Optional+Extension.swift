//
//  Optional+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import Foundation

extension Optional where Wrapped == String {
  
  var isNilOrEmpty: Bool {
    switch self {
    case .none:
      return true
    case .some(let value):
      return value.isEmpty
    }
  }
  
  func nonEmptyString() -> String? {
    return self.isNilOrEmpty ? nil : self
  }
  
  static func < (lhs: Optional, rhs: Optional) -> Bool {
    if let lhs = lhs {
      if let rhs = rhs {
        return lhs < rhs
      } else {
        return false
      }
    } else {
      return true
    }
  }
}

extension Optional where Wrapped == Int {
  static func < (lhs: Optional, rhs: Optional) -> Bool {
    if let lhs = lhs {
      if let rhs = rhs {
        return lhs < rhs
      } else {
        return false
      }
    } else {
      return true
    }
  }
}
