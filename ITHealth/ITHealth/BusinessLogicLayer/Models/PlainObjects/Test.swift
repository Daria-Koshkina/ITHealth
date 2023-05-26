//
//  Test.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 24.05.2023.
//

import Foundation
import SwiftyJSON

struct Test {
  let id: Int
  let title: String
  let description: String
  let deadline: Date
  
  init(id: Int, title: String, description: String, deadline: Date) {
    self.id = id
    self.title = title
    self.description = description
    self.deadline = deadline
  }
  
  init?(json: JSON) {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    guard let id = json["id"].int,
          let name = json["name"].string,
          let description = json["description"].string,
          let deadlineStr = json["deadline"].string else { return nil }
    self.id = id
    self.title = name
    self.description = description
    self.deadline = dateFormat.date(from: deadlineStr) ?? Date()
  }
}

struct TestList {
  let currentPage: Int
  let lastPage: Int
  let items: [Test]
  
  init(currentPage: Int, lastPage: Int, items: [Test]) {
    self.currentPage = currentPage
    self.lastPage = lastPage
    self.items = items
  }
  
  init?(json: JSON) {
    guard let currentPageNumber = json["currentPageNumber"].int,
          let lastPageNumber = json["lastPageNumber"].int else { return nil }
    self.currentPage = currentPageNumber
    self.lastPage = lastPageNumber
    self.items = (json["tests"].arrayValue).compactMap { Test(json: $0) }
  }
}
