//
//  LocalizationService.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import Lokalise

protocol LocalizationStorage {
  var language: AppLanguage { get }
}

class LocalizationService: LocalizationStorage {
  
  enum RegionCodes {
    static let english = "US"
  }
  
  // MARK: Public variables
  static let shared = LocalizationService()
  
  var language: AppLanguage {
    get {
      var languageCode = UserDefaults.standard.string(
        forKey: LocalizationService.languageUserDefaultsKey)
      if languageCode == nil,
        let firstLanguage = Locale.preferredLanguages.first {
        let index = firstLanguage.index(firstLanguage.startIndex, offsetBy: 2)
        let operatingSystemLanguage = String(firstLanguage[..<index])
        if let language = AppLanguage.list.first(where: {
          $0.languageCode == operatingSystemLanguage }) {
          languageCode = language.code
        } else {
          languageCode = LocalizationService.defaultLanguageCode
        }
        guard let languageCode = languageCode else { fatalError("Language was not determined") }
        save(language: languageCode)
      }
      guard let languageCodeUnwrapped = languageCode
      else { fatalError("Language was not loaded from UserDefaults") }
      return AppLanguage.language(withCode: languageCodeUnwrapped)
    }
    set {
      save(language: newValue.code)
      Lokalise.shared.setLocalizationLocale(Locale(identifier: newValue.languageCode),
                                            makeDefault: true)
    }
  }
  
  // MARK: - Life cycle
  private init() {
    setup()
  }
  
  // MARK: Setup
  private func setup() {
    Lokalise.shared.setLocalizationLocale(Locale(identifier: language.languageCode),
                                          makeDefault: true)
  }
}

// MARK: - Private
extension LocalizationService {
  private static let defaultLanguageCode = AppLanguage.ISO639Alpha2.english
  private static let languageUserDefaultsKey = "languageUserDefaultsKey"
  
  private func save(language: String) {
    UserDefaults.standard.set(language, forKey: LocalizationService.languageUserDefaultsKey)
  }
}

