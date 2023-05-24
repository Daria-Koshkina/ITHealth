//
//  Date+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 01.05.2023.
//

import Foundation

extension Date {
  func startOfWeek() -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self)
    return calendar.date(from: components) ?? self
  }
  
  func endOfWeek() -> Date {
    var components = DateComponents()
    components.weekOfMonth = 1
    components.second = -1
    return Calendar.current.date(byAdding: components, to: self.startOfWeek()) ?? self
  }
  
  func yesterday() -> Date {
    return Calendar.current.date(byAdding: DateComponents(day: -1), to: self) ?? self
  }
  
  func previousWeek() -> Date {
    return Calendar.current.date(byAdding: DateComponents(weekOfMonth: -1), to: self) ?? self
  }
  
  func nextWeek() -> Date {
    return Calendar.current.date(byAdding: DateComponents(weekOfMonth: 1), to: self) ?? self
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
  
  func addYears(_ years: Int) -> Date {
    return Calendar.current.date(byAdding: DateComponents(year: years), to: self) ?? self
  }
}
