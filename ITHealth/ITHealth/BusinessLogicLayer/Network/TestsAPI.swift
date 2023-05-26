//
//  TestsAPI.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 26.05.2023.
//

import Foundation

class TestsAPI: NetworkAPI {
  
  // MARK: - Variables
  static let shared = TestsAPI()
  
  // MARK: - Endpoints
  private enum Endpoint {
    static let list = "/Test/GetUserTests"
    static let test = "/Test/Get"
    static let result = "/Test/SendForVerification"
  }
  
  func getTestsList(currentPage: Int, itemsCount: Int, completion: @escaping (_ response: Result<TestList, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let params: [String: Any] = ["CurrentPageNumber": currentPage,
                                 "TestCount": itemsCount]
    alamofireRequest(endpoint: Endpoint.list,
                     method: .get,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let list = TestList(json: data) {
          completion(.success(list))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
  
  func sendResults(testId: Int, answers: [UserAnswer], completion: @escaping (_ response: Result<TestResult, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let answers: [[String: Any]] = answers.map {
      var answer = [String: Any]()
      answer["questionId"] = $0.questionId
      answer["answerId"] = $0.answerId
      let subAnswers: [[String: Any]] = $0.openAnswers.map {
        var subAnswer = [String: Any]()
        subAnswer["subquestionId"] = $0.id
        subAnswer["answer"] = $0.answer
        return subAnswer
      }
      answer["subAnswers"] = subAnswers
      return answer
    }
    let params: [String: Any] = ["testId": testId,
                                 "userAnswers": answers]
    alamofireRequest(endpoint: Endpoint.result,
                     method: .post,
                     parameters: params) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let result = TestResult(json: data) {
          completion(.success(result))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
  
  func getTest(testId: Int, completion: @escaping (_ response: Result<TestInfo, Error>) -> Void) {
    if !ReachabilityService.shared.isInternetAvailable {
      completion(.failure(ServerError.noInternetConnection))
      return
    }
    let url = Endpoint.test + "/" + "\(testId)"
    alamofireRequest(endpoint: url,
                     method: .get,
                     parameters: [:]) { [weak self] dataResponse in
      guard let self = self else { return }
      let parsedResult = self.parseResponse(dataResponse)
      switch parsedResult {
      case .failure(let error):
        completion(.failure(error))
      case .success(let json):
        let data = json[NetworkResponseKey.data]
        if let test = TestInfo(json: data) {
          completion(.success(test))
        } else {
          completion(.failure(ServerError.unknown))
          return
        }
      }
    }
  }
}
