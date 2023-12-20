//
//  Constants.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 15.02.2023.
//

import UIKit

enum Constants {
  
  enum Screen {
    static let heightCoefficient = UIScreen.main.bounds.height / defaultScreenSize.height
    static let widthCoefficient = UIScreen.main.bounds.width / defaultScreenSize.width
    static let isSmall: Bool = heightCoefficient <= 1
    
    private static let defaultScreenSize = CGSize(width: 375, height: 667)
  }
  
  enum Keychain {
    static let name = "ITHealth"
    static let token = "Token"
  }
  
  static var baseURL: String {
    return baseURLWithoutAPI + "/api"
  }
  
  static var baseURLWithoutAPI: String { return "https://ithealthwebapi.azurewebsites.net" }
  
  static let stressBound = 1.12
}
