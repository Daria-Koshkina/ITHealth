//
//  Answer.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 24.05.2023.
//

import Foundation
import SwiftyJSON

struct Answer {
  let id: Int
  let text: String
  
  init(id: Int, text: String) {
    self.id = id
    self.text = text
  }
  
  init?(json: JSON) {
    guard let id = json["id"].int,
          let text = json["text"].string else { return nil }
    self.id = id
    self.text = text
  }
}

struct OpenAnswer {
  let id: Int
  let answer: String
}

struct UserAnswer {
  let questionId: Int
  let answerId: Int
  let openAnswers: [OpenAnswer]
}
