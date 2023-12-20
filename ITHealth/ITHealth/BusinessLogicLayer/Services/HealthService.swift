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
    
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, HealthkitSetupError.notAvailableOnDevice)
      return
    }
    
    guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
            let pressure = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
      
      completion(false, HealthkitSetupError.dataTypeNotAvailable)
      return
    }
        
    let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                   bloodType,
                                                   biologicalSex,
                                                   bodyMassIndex,
                                                   height,
                                                   bodyMass,
                                                   activeEnergy,
                                                   pressure,
                                                   HKObjectType.workoutType(),
                                                   heartRate]
    
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
      let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
      let biologicalSex =       try healthKitStore.biologicalSex()
      let bloodType =           try healthKitStore.bloodType()
        
      let today = Date()
      let calendar = Calendar.current
      let todayDateComponents = calendar.dateComponents([.year],
                                                          from: today)
      let thisYear = todayDateComponents.year!
      let age = thisYear - birthdayComponents.year!
       
      let unwrappedBiologicalSex = biologicalSex.biologicalSex
      let unwrappedBloodType = bloodType.bloodType
        
      return (age, unwrappedBiologicalSex, unwrappedBloodType)
    }
  }
  
  func getUserData(completion: @escaping ((Double, Double, Double, Double)?, Error?)  -> Void) {
    var weight: Double = 0
    var pulse: Double = 0
    var pressure: Double = 0
    var sleepTime: Double = 0
    
    guard let weightId = HKSampleType.quantityType(forIdentifier: .bodyMass),
          let heartRateId = HKObjectType.quantityType(forIdentifier: .heartRate),
          let pressureId = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic) else {
      completion(nil, ServerError.unknown)
      return
    }
    
    getData(for: weightId) { (sample, _) in
      guard let sample = sample else {
        completion(nil, ServerError.unknown)
        return
      }
      weight = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
      
      self.getData(for: heartRateId) { (sample, _) in
        guard let sample = sample else {
          completion(nil, ServerError.unknown)
          return
        }
        pulse = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
        
        self.getData(for: pressureId) { (sample, _) in
          guard let sample = sample else {
            completion(nil, ServerError.unknown)
            return
          }
          pressure = sample.quantity.doubleValue(for: .millimeterOfMercury())
          
          self.getSleepTime(completion: { (sleep, _) in
            guard let sleep = sleep else {
              completion(nil, ServerError.unknown)
              return
            }
            sleepTime = sleep
            
            completion((weight, pulse, pressure, sleepTime), nil)
          })
        }
      }
    }
  }
  
  private func getSleepTime(completion: @escaping (Double?, Error?) -> Void) {
    if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
      let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
      let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 100000, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
        
        if let result = tmpResult {
          var timeSec: TimeInterval = 0
          for item in result {
            if let sample = item as? HKCategorySample {
              print()
              let sleepTimeForOneDay = sample.endDate.timeIntervalSince(sample.startDate)
              timeSec += sleepTimeForOneDay
            }
          }
          completion(Double(timeSec / 3600), nil)
        }
      }
      HKHealthStore().execute(query)
    }
  }
  
  private func getData(for sampleType: HKSampleType,
                   completion: @escaping (HKQuantitySample?, Error?) -> Void) {
    let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                          end: Date(),
                                                          options: .strictEndDate)
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                          ascending: false)
    let limit = 1
    let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                    predicate: mostRecentPredicate,
                                    limit: limit,
                                    sortDescriptors: [sortDescriptor]) { (query, samples, error) in
      DispatchQueue.main.async {
        guard let samples = samples,
              let mostRecentSample = samples.first as? HKQuantitySample else {
          
          completion(nil, error)
          return
        }
        
        completion(mostRecentSample, nil)
      }
    }
    HKHealthStore().execute(sampleQuery)
  }
  
  func getStressResult(startDate: String, endDate: String, completion: @escaping (_ response: Result<[Double], Error>) -> Void) {
    HealthAPI.shared.getStressResult(startDate: startDate, endDate: endDate, completion: completion)
  }
  
  func getBurnoutResult(completion: @escaping (_ response: Result<BurnoutInfo, Error>) -> Void) {
    guard let email = ProfileService.shared.user?.email else {
      completion(.failure(ServerError.unknown))
      return
    }
    HealthAPI.shared.getBurnoutResult(email: email, completion: completion)
  }
}
