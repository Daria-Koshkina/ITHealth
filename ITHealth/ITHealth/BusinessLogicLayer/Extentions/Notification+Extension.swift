//
//  Notification+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 19.02.2023.
//

import Foundation

extension Notification.Name {
  static let networkBecomeAvailable = Notification.Name("networkBecomeAvailable")
  static let networkBecomeNotAvailable = Notification.Name("networkBecomeNotAvailable")
  static let userWasAuthorized = Notification.Name("userWasAuthorized")
  static let userWasUpdated = Notification.Name("userWasUpdated")
  static let logout = Notification.Name("logout")
  static let shouldResetPassword = Notification.Name("shouldResetPassword")
  static let applicationWillResignActive = Notification.Name("applicationWillResignActive")
}

extension Notification {
  struct Key {
    static let isUserWasUpdated = "isUserWasUpdated"
  }
}

