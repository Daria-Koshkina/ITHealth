//
//  WorkAPI.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.05.2023.
//

import Foundation

class WorkAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = WorkAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let jira = "/Jira/GetCurrentUserTasksInProgress"
    static let trello = "/Trello/GetCurrentUserTasksInProgress"
    static let hours = "/Health/GetUserWorkTime"
    static let key = "/Trello/GetTeamTrelloSecret"
  }
  
  func getJiraTasks(completion: @escaping (_ response: Result<[Task], Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.jira,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let list = data["jiraIssues"].array?.compactMap({ Task(jiraJson: $0) }) {
          completion(.success(list))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
  
  func getTrelloTasks(token: String, completion: @escaping (_ response: Result<[Task], Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.trello,
                     method: .get,
                     parameters: ["token": token]) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let list = data["trelloCards"].array?.compactMap({ Task(trelloJson: $0) }) {
          completion(.success(list))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
  
  func getHours(completion: @escaping (_ response: Result<[Double], Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.hours,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let list = data["hours"].array?.compactMap({ $0["hours"].double }) {
          completion(.success(list))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
  
  func getAppKey(completion: @escaping (_ response: Result<String, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    
    alamofireRequest(endpoint: Endpoint.key,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let key = data["appKey"].string {
          completion(.success(key))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
}
