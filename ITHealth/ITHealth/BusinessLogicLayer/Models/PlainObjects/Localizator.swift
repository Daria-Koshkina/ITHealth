//
//  Localizator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import Foundation
import Lokalise

class Localizator {
  
  // MARK: - Public variables
  static let standard = Localizator(stringsFileName: "Localizable",
                                    stringsDictFileName: "LocalizableDict")
  
  // MARK: - Private variables
  private let stringsFileName: String?
  private let stringsDictFileName: String?
  private let appLanguageStorage: LocalizationStorage
  
  // MARK: - Life cycle
  init(stringsFileName: String? = nil,
       stringsDictFileName: String? = nil,
       appLanguageStorage: LocalizationStorage = LocalizationService.shared) {
    self.appLanguageStorage = appLanguageStorage
    self.stringsFileName = stringsFileName
    self.stringsDictFileName = stringsDictFileName
  }
  
  // MARK: - Public
  func localizedString(_ string: String, _ args: CVarArg...) -> String {
    let defaultString = "*\(string)"
    
    let stringsLocalizedString = searchInStrings(translateString: string,
                                                 defaultString: defaultString)
    
    let stringsFound = stringsLocalizedString != defaultString
    if stringsFound {
      return String(format: stringsLocalizedString, arguments: args)
    }
    
    let stringsDictLocalizedString = searchInStringsDict(translateString: string,
                                                         defaultString: defaultString)
    return String(format: stringsDictLocalizedString, arguments: args)
  }
  
  // MARK: - Searching in localization files
  private func searchInStrings(translateString: String, defaultString: String) -> String {
    return Lokalise.shared.localizedString(forKey: translateString,
                                           value: defaultString,
                                           table: stringsFileName)
  }
  
  private func searchInStringsDict(translateString: String, defaultString: String) -> String {
    return Lokalise.shared.localizedString(forKey: translateString,
                                           value: defaultString,
                                           table: stringsDictFileName ?? stringsFileName)
  }
}

