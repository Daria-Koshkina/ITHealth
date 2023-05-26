//
//  TestInfo.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 24.05.2023.
//

import Foundation
import SwiftyJSON

struct TestInfo {
  let id: Int
  let title: String
  let description: String
  let questions: [Question]
  
  init(id: Int, title: String, description: String, questions: [Question]) {
    self.id = id
    self.title = title
    self.description = description
    self.questions = questions
  }
  
  init?(json: JSON) {
    guard let id = json["id"].int,
          let name = json["name"].string,
          let description = json["description"].string else { return nil }
    self.id = id
    self.title = name
    self.description = description
    self.questions = (json["questions"].arrayValue).compactMap { Question(json: $0) }
  }
}
