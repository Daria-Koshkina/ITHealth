//
//  TestResult.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 24.05.2023.
//

import Foundation
import SwiftyJSON

struct TestResult {
  let result: Double
  let maxPoints: Double
  
  init(result: Double, maxPoints: Double) {
    self.result = result
    self.maxPoints = maxPoints
  }
  
  init?(json: JSON) {
    guard let result = json["result"].double,
          let maxPoints = json["maxPoints"].double else { return nil }
    self.result = result
    self.maxPoints = maxPoints
  }
}
