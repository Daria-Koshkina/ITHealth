//
//  WorkService.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.05.2023.
//

import Foundation

class WorkService {
  
  static let shared = WorkService()
  
  private init() {}
  
  func getTasks(token: String, completion: @escaping (_ response: Result<(jira: [Task], trello: [Task]), Error>) -> Void) {
    WorkAPI.shared.getJiraTasks { result in
      switch result {
      case .success(let jira):
        WorkAPI.shared.getTrelloTasks(token: token) { result in
          switch result {
          case .success(let trello):
            completion(.success((jira: jira, trello: trello)))
          case .failure(let error):
            completion(.failure(error))
          }
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func getHours(completion: @escaping (_ response: Result<[Double], Error>) -> Void) {
    WorkAPI.shared.getHours(completion: completion)
  }
  
  func getAppKey(completion: @escaping (_ response: Result<String, Error>) -> Void) {
    WorkAPI.shared.getAppKey(completion: completion)
  }
}
