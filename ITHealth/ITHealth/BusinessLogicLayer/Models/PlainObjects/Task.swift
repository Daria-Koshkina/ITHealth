//
//  Task.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.05.2023.
//

import Foundation
import SwiftyJSON

struct Task {
  let date: Date
  let description: String
  let name: String
  
  init(date: Date, description: String, name: String) {
    self.date = date
    self.description = description
    self.name = name
  }
  
  init?(jiraJson: JSON) {
    guard let dateString = jiraJson["created"].string,
          let description = jiraJson["description"].string,
          let name = jiraJson["board"]["name"].string else { return nil }
    self.description = description
    self.name = name
    self.date = ISO8601DateFormatter().date(from: dateString) ?? Date()
  }
  
  init?(trelloJson: JSON) {
    guard let dateString = trelloJson["start"].string,
          let description = trelloJson["desc"].string,
          let name = trelloJson["name"].string else { return nil }
    self.description = description
    self.name = name
    self.date = ISO8601DateFormatter().date(from: dateString) ?? Date()
  }
}
