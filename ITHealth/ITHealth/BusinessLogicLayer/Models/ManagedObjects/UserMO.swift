//
//  UserMO.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 15.02.2023.
//

import Foundation
import CoreData

extension UserMO {
  func fill(from user: User, in context: NSManagedObjectContext) {
    id = Int64(user.id)
    email = user.email
    fullName = user.fullName
    gender = Int64(user.gender.rawValue)
    bloodType = Int64(user.bloodType.rawValue)
    averagePressure = user.averagePressure
    workHoursCount = Int64(user.workHoursCount)
    connectedToCompany = user.connectedToCompany
  }
}
