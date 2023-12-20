//
//  File.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 24.05.2023.
//

import Foundation
import SwiftyJSON

struct Question {
  let id: Int
  let number: Int
  let description: String
  let answers: [Answer]
  var openQuestions: [OpenQuestion]
  
  init(id: Int, number: Int, description: String, answers: [Answer], openQuestions: [OpenQuestion]) {
    self.id = id
    self.number = number
    self.description = description
    self.answers = answers
    self.openQuestions = openQuestions
  }
  
  init?(json: JSON) {
    guard let id = json["id"].int,
    let number = json["number"].int,
    let description = json["description"].string else { return nil }
    self.id = id
    self.number = number
    self.description = description
    self.answers = (json["answers"].arrayValue).compactMap { Answer(json: $0) }
    self.openQuestions = (json["subquestions"].arrayValue).compactMap { OpenQuestion(json: $0) }
    if !answers.isEmpty {
      openQuestions.removeAll()
    }
  }
}

struct OpenQuestion {
  let id: Int
  let description: String
  
  init(id: Int, description: String) {
    self.id = id
    self.description = description
  }
  
  init?(json: JSON) {
    guard let id = json["id"].int,
          let text = json["text"].string else { return nil }
    self.id = id
    self.description = text
  }
}
