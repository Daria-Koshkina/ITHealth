//
//  User.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 15.02.2023.
//

import Foundation
import CoreData
import HealthKit
import SwiftyJSON

enum Gender: Int, CaseIterable {
  case male = 0
  case female = 1
  
  func title() -> String {
    switch self {
    case .male:
      return Localizator.standard.localizedString("gender.male")
    case .female:
      return Localizator.standard.localizedString("gender.female")
    }
  }
  
  func isEqual(to: HKBiologicalSex?) -> Bool {
    switch to {
    case .notSet:
      return false
    case .female:
      return self == .female
    case .male:
      return self == .male
    case .other:
      return false
    case .none:
      return false
    @unknown default:
      return false
    }
  }
  
  init?(sex: HKBiologicalSex?) {
    switch sex {
    case .notSet:
      return nil
    case .female:
      self = .female
    case .male:
      self = .male
    case .other:
      return nil
    case .none:
      return nil
    @unknown default:
      return nil
    }
  }
}

struct User {
  let id: Int
  let email: String
  let fullName: String
  let gender: Gender
  let bloodType: HKBloodType
  let averagePressure: Double
  let workHoursCount: Int
  let connectedToCompany: Bool
  
  init?(json: JSON) {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    guard let dictionary = json.dictionary,
          let id = dictionary[NetworkResponseKey.User.id]?.intValue,
          let email = dictionary[NetworkResponseKey.User.email]?.stringValue,
          let fullName = dictionary[NetworkResponseKey.User.fullName]?.stringValue,
          let gender = Gender(rawValue: dictionary[NetworkResponseKey.User.gender]?.intValue ?? .zero),
          let bloodType = HKBloodType(rawValue: dictionary[NetworkResponseKey.User.bloodType]?.intValue ?? .zero),
          let averagePressure = dictionary[NetworkResponseKey.User.averagePressure]?.doubleValue,
          let workHoursCount = dictionary[NetworkResponseKey.User.workHoursCount]?.intValue,
          let connectedToCompany = dictionary[NetworkResponseKey.User.connectedToCompany]?.bool else {
      return nil
    }
    self.id = id
    self.email = email
    self.fullName = fullName
    self.gender = gender
    self.bloodType = bloodType
    self.averagePressure = averagePressure
    self.workHoursCount = workHoursCount
    self.connectedToCompany = connectedToCompany
  }
  
  init?(userMO: UserMO) {
    guard let email = userMO.email,
          let fullName = userMO.fullName,
          let gender = Gender(rawValue: Int(userMO.gender)),
          let bloodType = HKBloodType(rawValue: Int(userMO.bloodType)) else {
      return nil
    }
    self.id = Int(userMO.id)
    self.email = email
    self.fullName = fullName
    self.gender = gender
    self.bloodType = bloodType
    self.averagePressure = userMO.averagePressure
    self.workHoursCount = Int(userMO.workHoursCount)
    self.connectedToCompany = userMO.connectedToCompany
  }
}
