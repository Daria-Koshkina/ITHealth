//
//  ServerError.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit
import SwiftyJSON

enum ServerErrorType: Int {
  case unauthorized = 401
  case accessDenied = 403
  case notFound = 404
  case unknown = -10000
  case noInternetConnection = -10001
  case webViewNoInternet = -1009
}

struct ServerError: Error {
  var title: String
  var description: String
  var type: ServerErrorType
  
  init(type: Int, json: JSON) {
    self.type = ServerErrorType(rawValue: type) ?? .unknown
    if let description = json[NetworkResponseKey.Error.message].string {
      self.type = ServerErrorType(rawValue: type) ?? .unknown
      self.title = ServerError.unknown.title
      self.description = description
    } else {
      title = ServerError.unknown.title
      description = ServerError.unknown.description
    }
  }
  
  init(type: ServerErrorType = .unknown, title: String = ServerError.unknown.title, description: String) {
    self.title = title
    self.description = description
    self.type = type
  }
  
  static var unknown: ServerError {
    return ServerError(type: .unknown,
                       title: Localizator.standard.localizedString("server_error.title"),
                       description: Localizator.standard.localizedString("server_error.unknown.message"))
  }
  
  static var noInternetConnection: ServerError {
    return ServerError(type: .noInternetConnection,
                       title: Localizator.standard.localizedString("server_error.title"),
                       description: Localizator.standard.localizedString("server_error.no_internet.message"))
  }
  
  static var webViewNoInternet: ServerError {
    return ServerError(type: .webViewNoInternet,
                       title: Localizator.standard.localizedString("server_error.title"),
                       description: Localizator.standard.localizedString("server_error.no_internet.message"))
  }
  
  static var unauthorized: ServerError {
    return ServerError(type: .unauthorized,
                       title: Localizator.standard.localizedString("server_error.title"),
                       description: Localizator.standard.localizedString("server_error.unauthorized.message"))
  }
}

