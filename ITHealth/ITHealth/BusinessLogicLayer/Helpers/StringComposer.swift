//
//  StringComposer.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import Foundation

class StringComposer {
  
  // MARK: - Singleton
  public static let shared = StringComposer()
  
  // MARK: - Private variables
  private let localizator = Localizator.standard
  private var fractionPriceFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: "en_US")
    numberFormatter.minimumIntegerDigits = 1
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.roundingMode = .halfUp
    numberFormatter.groupingSize = 3
    numberFormatter.groupingSeparator = " "
    numberFormatter.usesGroupingSeparator = true
    numberFormatter.decimalSeparator = "."
    return numberFormatter
  }
  private var integerPriceFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: "en_US")
    numberFormatter.numberStyle = .none
    numberFormatter.minimumIntegerDigits = 1
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.minimumFractionDigits = 0
    numberFormatter.roundingMode = .halfUp
    numberFormatter.groupingSize = 3
    numberFormatter.groupingSeparator = " "
    numberFormatter.usesGroupingSeparator = true
    numberFormatter.decimalSeparator = ","
    return numberFormatter
  }
  
  // MARK: - Life cycle
  private init() { }
  
  func getStressString(from: Double) -> String {
    let priceFormatter = from.truncatingRemainder(dividingBy: 1) == .zero ? integerPriceFormatter : fractionPriceFormatter
      let price = priceFormatter.string(from: abs(Decimal(from)) as NSDecimalNumber) ?? ""
      return price
  }
}
