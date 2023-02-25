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
                nick: String,
                role: Role,
                fullName: String,
                birthday: String,
                gender: Gender,
                bloodType: HKBloodType,
                averagePressure: Double,
                workHoursCount: Int, completion: @escaping (_ response: Result<Token, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params: [String: Any] = [NetworkRequestKey.Auth.email: email,
                                 NetworkRequestKey.Auth.userName: nick,
                                 NetworkRequestKey.Auth.role: role.rawValue,
                                 NetworkRequestKey.Auth.fullName: fullName,
                                 NetworkRequestKey.Auth.birthday: birthday,
                                 NetworkRequestKey.Auth.gender: gender.rawValue,
                                 NetworkRequestKey.Auth.bloodType: bloodType.rawValue,
                                 NetworkRequestKey.Auth.averagePressure: averagePressure,
                                 NetworkRequestKey.Auth.workHoursCount: workHoursCount]
    
    alamofireRequest(endpoint: Endpoint.register,
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
}
