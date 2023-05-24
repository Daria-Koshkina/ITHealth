//
//  NetworkKeys.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import Foundation

// MARK: – NetworkResponseKey

enum NetworkResponseKey {
  static let data = "data"
  static let message = "message"
  enum Error {
    static let error = "error"
    static let title = "title"
    static let message = "message"
  }
  enum User {
    static let id = "id"
    static let userName = "userName"
    static let email = "email"
    static let role = "role"
    static let fullName = "fullName"
    static let birthday = "birthday"
    static let gender = "gender"
    static let bloodType = "bloodType"
    static let averagePressure = "averagePressure"
    static let workHoursCount = "workHoursCount"
    static let connectedToCompany = "connectedToCompany"
  }
  
  static let accessToken = "token"
}

// MARK: – NetworkRequestKey –

enum NetworkRequestKey {
  static let data = "data"
  static let acceptLanguage = "Accept-Language"
  static let authorization = "Authorization"
  enum Auth {
    static let email = "Email"
    static let password = "Password"
    static let userName = "UserName"
    static let role = "Role"
    static let fullName = "FullName"
    static let birthday = "Birthday"
    static let gender = "Gender"
    static let bloodType = "BloodType"
    static let averagePressure = "AveragePressure"
    static let workHoursCount = "WorkHoursCount"
  }
}

