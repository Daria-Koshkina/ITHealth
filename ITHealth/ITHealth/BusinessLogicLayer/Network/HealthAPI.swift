//
//  HealthAPI.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 26.05.2023.
//

import Foundation

class HealthAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = HealthAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let stress = "/Health/GetUserStressLevels"
    static let burnout = "/Health/GetBurnoutInformation"
  }
  
  func getStressResult(startDate: String, endDate: String, completion: @escaping (_ response: Result<[Double], Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params: [String: Any] = ["StartDate": startDate,
                                 "EndDate": endDate]
    alamofireRequest(endpoint: Endpoint.stress,
                     method: .get,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let list = data["stressLevels"].array?.compactMap({ $0["stressLevel"].double }) {
          completion(.success(list))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
  
  func getBurnoutResult(email: String, completion: @escaping (_ response: Result<BurnoutInfo, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params: [String: Any] = ["email": email]
    alamofireRequest(endpoint: Endpoint.burnout,
                     method: .get,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let burnout = BurnoutInfo(json: data) {
          completion(.success(burnout))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
}
