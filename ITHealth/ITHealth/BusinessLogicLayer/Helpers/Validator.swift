//
//  Validator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 15.02.2023.
//

import Foundation

class Validator {
  
  enum ValidatorType {
    case name
    case email
    case password
    case pressure
    case hours
  }
  
  static var latinAlphabetSet: CharacterSet {
    let latinSmallAlphabet = UInt32("a")...UInt32("z")
    let latinBigAlphabet = UInt32("A")...UInt32("Z")
    var string = String(String.UnicodeScalarView(latinSmallAlphabet.compactMap(UnicodeScalar.init)))
    string += String(String.UnicodeScalarView(latinBigAlphabet.compactMap(UnicodeScalar.init)))
    return CharacterSet(charactersIn: string)
  }
  
  static var spaceAlphanumericsSet: CharacterSet {
    var set = CharacterSet.alphanumerics
    set.insert(charactersIn: " ")
    return set
  }
  
  static func shouldChangeText(_ string: String?, for type: ValidatorType) -> Bool {
    return isValidString(string, ofType: type) || string.isNilOrEmpty
  }
  
  static func isValidString(_ string: String?, ofType type: ValidatorType, isEmptyStringValid: Bool = true) -> Bool {
    switch type {
    case .name:
      guard let string = string else { return isEmptyStringValid }
      let cutString = string.trimmingCharacters(in: .whitespacesAndNewlines)
      return cutString.count <= maxSymbolsCount(for: .name) && cutString.count >= minSymbolsCount(for: .name)
    case .email:
      guard let string = string else { return isEmptyStringValid }
      let cutString = string.trimmingCharacters(in: .whitespacesAndNewlines)
      return RegexValidator.shared.isValidEmail(cutString)
    case .password:
      guard let string = string else { return isEmptyStringValid }
      let cutString = string.trimmingCharacters(in: .whitespacesAndNewlines)
      return cutString.count <= maxSymbolsCount(for: .password) && cutString.count >= minSymbolsCount(for: .password)
    case .pressure:
      guard let string = string else { return isEmptyStringValid }
      let cutString = string.trimmingCharacters(in: .whitespacesAndNewlines)
      return cutString.count <= maxSymbolsCount(for: .pressure) && cutString.count >= minSymbolsCount(for: .pressure)
    case .hours:
      guard let string = string else { return isEmptyStringValid }
      let cutString = string.trimmingCharacters(in: .whitespacesAndNewlines)
      return cutString.count <= maxSymbolsCount(for: .hours) && cutString.count >= minSymbolsCount(for: .hours)
    }
  }
  
  static func allowedCharacterSet(for type: ValidatorType) -> CharacterSet {
    switch type {
    case .name:
      var set = latinAlphabetSet
      set.insert(charactersIn: "‘'. ")
      return set
    case .email:
      var set = latinAlphabetSet
      set.formUnion(CharacterSet.decimalDigits)
      set.insert(charactersIn: "!#$%&'*+-/=?^_`{|}~;@.")
      return set
    case .password:
      var set = latinAlphabetSet
      set.formUnion(CharacterSet.decimalDigits)
      return set
    case .pressure,
        .hours:
      return CharacterSet.decimalDigits
    }
  }
  
  static func maxSymbolsCount(for type: ValidatorType) -> Int {
    switch type {
    case .name:
      return 40
    case .email:
      return 63
    case .password:
      return Int.max
    case .pressure:
      return 3
    case .hours:
      return 2
    }
  }
  
  static func minSymbolsCount(for type: ValidatorType) -> Int {
    switch type {
    case .name:
      return 1
    case .email:
      return 5
    case .password:
      return 8
    case .pressure:
      return 1
    case .hours:
      return 1
    }
  }
}
