//
//  TestsService.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 24.05.2023.
//

import Foundation

class TestsService {
  
  static let shared = TestsService()
  
  private var test: TestInfo?
  private var answers = [UserAnswer]()
  private var currentIndex: Int = -1
  
  private init() {}
  
  func startTest(_ test: TestInfo) {
    resetTest()
    self.test = test
  }
  
  func nextQuestion() -> Question? {
    guard let test = test,
          test.questions.indices.contains(currentIndex + 1) else { return nil }
    currentIndex = currentIndex + 1
    return test.questions[currentIndex]
  }
  
  func addAnswer(questionId: Int,
                 answerId: Int,
                 openAnswers: [OpenAnswer]) {
    answers.append(UserAnswer(questionId: questionId, answerId: answerId, openAnswers: openAnswers))
  }
  
  func finishCurrentTest(completion: @escaping (_ response: Result<TestResult, Error>) -> Void) {
    guard let test = test else {
      completion(.failure(ServerError.unknown))
      return
    }
    TestsAPI.shared.sendResults(testId: test.id, answers: answers, completion: completion)
  }
  
  func getTestList(currentPage: Int, itemsCount: Int = 5, completion: @escaping (_ response: Result<TestList, Error>) -> Void) {
    TestsAPI.shared.getTestsList(currentPage: currentPage, itemsCount: itemsCount, completion: completion)
  }
  
  func getTest(id: Int, completion: @escaping (_ response: Result<TestInfo, Error>) -> Void) {
    TestsAPI.shared.getTest(testId: id, completion: completion)
  }
  
  func resetTest() {
    test = nil
    answers = []
    currentIndex = -1
  }
}
