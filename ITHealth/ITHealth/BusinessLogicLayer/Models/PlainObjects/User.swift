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

enum Role: String, CaseIterable {
  case user = "User"
  case administrator = "Administrator"
  case globalAdministrator = "GlobalAdministrator"
}

struct User {
  let id: Int
  let nick: String
  let email: String
  let role: Role
  let fullName: String
  let birthday: Date
  let gender: Gender
  let bloodType: HKBloodType
  let averagePressure: Double
  let workHoursCount: Int
  
  init?(json: JSON) {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    guard let dictionary = json.dictionary,
          let id = dictionary[NetworkResponseKey.User.id]?.intValue,
          let nick = dictionary[NetworkResponseKey.User.userName]?.stringValue,
          let email = dictionary[NetworkResponseKey.User.email]?.stringValue,
          let role = Role(rawValue: dictionary[NetworkResponseKey.User.role]?.stringValue ?? ""),
          let fullName = dictionary[NetworkResponseKey.User.fullName]?.stringValue,
          let birthday = dateFormat.date(from: dictionary[NetworkResponseKey.User.birthday]?.stringValue ?? ""),
          let gender = Gender(rawValue: dictionary[NetworkResponseKey.User.gender]?.intValue ?? .zero),
          let bloodType = HKBloodType(rawValue: dictionary[NetworkResponseKey.User.bloodType]?.intValue ?? .zero),
          let averagePressure = dictionary[NetworkResponseKey.User.averagePressure]?.doubleValue,
          let workHoursCount = dictionary[NetworkResponseKey.User.workHoursCount]?.intValue else {
      return nil
    }
    self.id = id
    self.nick = nick
    self.email = email
    self.role = role
    self.fullName = fullName
    self.birthday = birthday
    self.gender = gender
    self.bloodType = bloodType
    self.averagePressure = averagePressure
    self.workHoursCount = workHoursCount
  }
  
  init?(userMO: UserMO) {
    guard let nick = userMO.nick,
          let email = userMO.email,
          let fullName = userMO.fullName,
          let birthday = userMO.birthday,
          let gender = Gender(rawValue: Int(userMO.gender)),
          let role = Role(rawValue: userMO.role ?? ""),
          let bloodType = HKBloodType(rawValue: Int(userMO.bloodType)) else {
      return nil
    }
    self.id = Int(userMO.id)
    self.nick = nick
    self.email = email
    self.role = role
    self.fullName = fullName
    self.birthday = birthday
    self.gender = gender
    self.bloodType = bloodType
    self.averagePressure = userMO.averagePressure
    self.workHoursCount = Int(userMO.workHoursCount)
  }
}
