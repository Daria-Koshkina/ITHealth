//
//  DateFormatsFactory.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import Foundation

class DateFormatsFactory {
  class func getDefaultDateFormat() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }
  
  class func getStressChartDateFormat() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM"
    return dateFormatter
  }
}
