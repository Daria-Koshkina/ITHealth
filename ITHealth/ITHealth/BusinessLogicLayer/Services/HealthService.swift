//
//  HealthService.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 28.04.2023.
//

import Foundation
import HealthKit

class HealthService {
  
  static let shared = HealthService()
  
  private init() {}
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    
    //1. Check to see if HealthKit Is Available on this device
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, HealthkitSetupError.notAvailableOnDevice)
      return
    }
    
    //2. Prepare the data types that will interact with HealthKit
    guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
      
      completion(false, HealthkitSetupError.dataTypeNotAvailable)
      return
    }
    
    //3. Prepare a list of types you want HealthKit to read and write
    
    let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                   bloodType,
                                                   biologicalSex,
                                                   bodyMassIndex,
                                                   height,
                                                   bodyMass,
                                                   activeEnergy,
                                                   HKObjectType.workoutType()]
    
    //4. Request Authorization
    HKHealthStore().requestAuthorization(toShare: [],
                                         read: healthKitTypesToRead) { (success, error) in
      completion(success, error)
    }
  }
  
  func getAgeSexAndBloodType() throws -> (age: Int,
                                                biologicalSex: HKBiologicalSex,
                                                bloodType: HKBloodType) {
      
    let healthKitStore = HKHealthStore()
      
    do {

      //1. This method throws an error if these data are not available.
      let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
      let biologicalSex =       try healthKitStore.biologicalSex()
      let bloodType =           try healthKitStore.bloodType()
        
      //2. Use Calendar to calculate age.
      let today = Date()
      let calendar = Calendar.current
      let todayDateComponents = calendar.dateComponents([.year],
                                                          from: today)
      let thisYear = todayDateComponents.year!
      let age = thisYear - birthdayComponents.year!
       
      //3. Unwrap the wrappers to get the underlying enum values.
      let unwrappedBiologicalSex = biologicalSex.biologicalSex
      let unwrappedBloodType = bloodType.bloodType
        
      return (age, unwrappedBiologicalSex, unwrappedBloodType)
    }
  }
}
