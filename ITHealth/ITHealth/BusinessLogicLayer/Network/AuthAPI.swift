//
//  AuthAPI.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 19.02.2023.
//

import Foundation
import HealthKit

typealias Token = String

class AuthAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = AuthAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let auth = "/account/login"
    static let register = "/account/signup"
    static let profile = "/account/profile"
    static let update = "/account/update"
    static let health = "/Health/Create"
    static let company = "/Company/AcceptUserToCompany"
  }
  
  func addToCompany(code: String,
                    completion: @escaping (_ response: Result<User, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    let url = Endpoint.company + "?inviteCode=" + code
    alamofireRequest(endpoint: url,
                     method: .post,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let user = User(json: data) {
          completion(.success(user))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
  
  func auth(email: String,
            password: String,
            completion: @escaping (_ response: Result<Token, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params: [String: Any] = [NetworkRequestKey.Auth.email: email,
                                 NetworkRequestKey.Auth.password: password]
    alamofireRequest(endpoint: Endpoint.auth,
                     method: .post,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let token = data[NetworkResponseKey.accessToken].string {
          completion(.success(token))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
  
  func register(email: String,
                password: String,
                fullName: String,
                gender: Gender,
                bloodType: HKBloodType,
                averagePressure: Double,
                workHoursCount: Int, completion: @escaping (_ response: Result<Any?, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params: [String: Any] = [NetworkRequestKey.Auth.email: email,
                                 NetworkRequestKey.Auth.role: "User",
                                 NetworkRequestKey.Auth.fullName: fullName,
                                 NetworkRequestKey.Auth.gender: gender.rawValue,
                                 NetworkRequestKey.Auth.bloodType: bloodType.rawValue,
                                 NetworkRequestKey.Auth.averagePressure: averagePressure,
                                 NetworkRequestKey.Auth.workHoursCount: workHoursCount,
                                 NetworkRequestKey.Auth.password: password]
    
    alamofireRequest(endpoint: Endpoint.register,
                     method: .post,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success:
        completion(.success(nil))
      }
    }
  }
  
  func update(email: String,
              fullName: String,
              averagePressure: Double,
              workHoursCount: Int,
              gender: Gender,
              bloodType: HKBloodType,
              completion: @escaping (_ response: Result<User, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params: [String: Any] = [NetworkRequestKey.Auth.email: email,
                                 NetworkRequestKey.Auth.fullName: fullName,
                                 NetworkRequestKey.Auth.gender: gender.rawValue,
                                 NetworkRequestKey.Auth.bloodType: bloodType.rawValue,
                                 NetworkRequestKey.Auth.averagePressure: averagePressure,
                                 NetworkRequestKey.Auth.workHoursCount: workHoursCount]
    
    alamofireRequest(endpoint: Endpoint.update,
                     method: .put,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        if let user = User(json: json[NetworkResponseKey.data]) {
          completion(.success(user))
        } else {
          completion(.failure(ServerError.unknown))
        }
      }
    }
  }
  
  func changePassword(email: String,
              fullName: String,
              averagePressure: Double,
              workHoursCount: Int,
              gender: Gender,
              bloodType: HKBloodType,
                      password: String,
              completion: @escaping (_ response: Result<User, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params: [String: Any] = [NetworkRequestKey.Auth.email: email,
                                 NetworkRequestKey.Auth.fullName: fullName,
                                 NetworkRequestKey.Auth.gender: gender.rawValue,
                                 NetworkRequestKey.Auth.bloodType: bloodType.rawValue,
                                 NetworkRequestKey.Auth.averagePressure: averagePressure,
                                 NetworkRequestKey.Auth.workHoursCount: workHoursCount,
                                 NetworkRequestKey.Auth.password: password]
    
    alamofireRequest(endpoint: Endpoint.update,
                     method: .put,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        if let user = User(json: json[NetworkResponseKey.data]) {
          completion(.success(user))
        } else {
          completion(.failure(ServerError.unknown))
        }
      }
    }
  }
  
  func getUser(completion: @escaping (_ response: Result<User, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.profile,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        if let user = User(json: json[NetworkResponseKey.data]) {
          completion(.success(user))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
  
  func sendHealthData(data: (Double, Double, Double, Double), completion: @escaping (_ response: Result<Any?, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    let params: [String: Any] = ["weight": data.0,
                                 "pulse": data.1,
                                 "pressure": data.2,
                                 "sleepTime": data.3]
    alamofireRequest(endpoint: Endpoint.health,
                     method: .post,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success:
        completion(.success(nil))
      }
    }
  }
}
