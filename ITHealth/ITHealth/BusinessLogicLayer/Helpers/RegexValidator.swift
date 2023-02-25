//
//  RegexValidator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 15.02.2023.
//

import Foundation

class RegexValidator {
  
  // MARK: Singleton
  static let shared = RegexValidator()
  
  private init() {}
  
  // MARK: - Public functions
  func isValidEmail(_ email: String) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: Regex.email) else {
      return false
    }
    let range = NSRange(location: 0, length: email.count)
    let result = regex.matches(in: email, range: range)
    return !result.isEmpty
  }
}

// MARK: - Regex
private enum Regex {
  static let email = "^[A-Z0-9a-z._%+-]{2,}@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
}
