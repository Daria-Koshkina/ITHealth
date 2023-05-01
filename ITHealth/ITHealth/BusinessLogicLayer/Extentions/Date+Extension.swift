//
//  Date+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 01.05.2023.
//

import Foundation

extension Date {
  func startOfMonth() -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: self)
    return calendar.date(from: components) ?? self
  }
  
  func endOfMonth() -> Date {
    var components = DateComponents()
    components.month = 1
    components.second = -1
    return Calendar.current.date(byAdding: components, to: self.startOfMonth()) ?? self
  }
  
  func yesterday() -> Date {
    return Calendar.current.date(byAdding: DateComponents(day: -1), to: self) ?? self
  }
  
  func addYears(_ years: Int) -> Date {
    return Calendar.current.date(byAdding: DateComponents(year: years), to: self) ?? self
  }
  
  func previousMonth() -> Date {
    return Calendar.current.date(byAdding: DateComponents(month: -1), to: self) ?? self
  }
  
  func nextMonth() -> Date {
    return Calendar.current.date(byAdding: DateComponents(month: 1), to: self) ?? self
  }
  
  func get(_ component: Calendar.Component,
           calendar: Calendar = Calendar.current) -> Int {
    return calendar.component(component, from: self)
  }
  
  func add(_ components: DateComponents,
           calendar: Calendar = Calendar.current) -> Date {
    return Calendar.current.date(byAdding: components, to: self) ?? self
  }
  
  func startOfDay() -> Date {
    return Calendar.current.startOfDay(for: self)
  }
  
  func startOfYear() -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: self)
    return calendar.date(from: components) ?? self
  }
  
  static func getStartOfYearsBetweenDates(from fromDate: Date, to toDate: Date) -> [Date] {
    var dates: [Date] = []
    var date = fromDate
    
    while date <= toDate {
      dates.append(date)
      guard let newDate = Calendar.current.date(byAdding: .year, value: 1, to: date) else { break }
      date = newDate.startOfYear()
    }
    return dates
  }
  
  func getDaysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
    var dateComponents = DateComponents()
    dateComponents.year = year ?? Calendar.current.component(.year,  from: self)
    dateComponents.month = monthNumber ?? Calendar.current.component(.month,  from: self)
    if let d = Calendar.current.date(from: dateComponents),
       let interval = Calendar.current.dateInterval(of: .month, for: d),
       let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day {
      return days
    } else {
      return -1
    }
  }
}

