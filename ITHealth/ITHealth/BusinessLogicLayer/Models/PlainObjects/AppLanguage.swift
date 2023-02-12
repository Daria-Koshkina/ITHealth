//
//  AppLanguage.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import Foundation

class AppLanguage {
  // MARK: - Public variables
  var code: String // ISO 639-1
  var nativeName: String
  var languageCode: String {
    return Locale(identifier: code).languageCode ?? code
  }
  var regionCode: String {
    return Locale(identifier: code).regionCode ?? code
  }
  
  // MARK: - Life cycle
  private init() {
    self.code = ""
    self.nativeName = ""
  }
  
  private init(code: String, nativeName: String) {
    self.code = code
    self.nativeName = nativeName
  }
  
  // MARK: - Languages
  static var list: [AppLanguage] {
    var list: [AppLanguage] = []
    for code in AppLanguage.codes {
      list.append(AppLanguage.language(withCode: code))
    }
    return list
  }
  
  static var codes: [String] {
    return [AppLanguage.ISO639Alpha2.english]
  }
  
  // MARK: - ISO 639-1 Language codes
  enum ISO639Alpha2 {
    static let english = "en_US"
  }
  
  // MARK: - Factory method
  static func language(withCode code: String) -> AppLanguage {
    var language: AppLanguage
    switch code {
    case AppLanguage.ISO639Alpha2.english:
      language = AppLanguage(code: code, nativeName: "English")
    default:
      fatalError("Language with code \(code) is not supported")
    }
    return language
  }
}

// MARK: - Equatable
extension AppLanguage: Equatable {
  public static func == (lhs: AppLanguage, rhs: AppLanguage) -> Bool {
    return lhs.code == rhs.code
  }
}

// MARK: – CustomStringConvertible
extension AppLanguage: CustomStringConvertible {
  var description: String {
    return nativeName
  }
}
