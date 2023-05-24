//
//  DateFormatsFactory.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import Foundation

class DateFormatsFactory {
  class func getMonthYearDateFormat() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL yyyy"
    return dateFormatter
  }
  
  class func getTransactionDateFormat() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }
  
  class func getTransactionItemDateFormat() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM dd"
    return dateFormatter
  }
  
  class func getMonthDateFormat() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM"
    return dateFormatter
  }
  
  class func getEditTransactionDateFormat() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL dd, yyyy"
    return dateFormatter
  }
  
  class func getNetWealthCurrentDateFormat() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL, dd"
    return dateFormatter
  }
  
  class func getNetWealthChartDateFormat() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM"
    return dateFormatter
  }
}
