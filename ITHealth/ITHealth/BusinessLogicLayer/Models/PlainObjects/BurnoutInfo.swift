//
//  BurnoutInfo.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 28.05.2023.
//

import Foundation
import SwiftyJSON

struct BurnoutInfo {
  let hasStress: Bool
  let hasBadSleep: Bool
  let hasLowEfficiency: Bool
  let hasBadTestResults: Bool
  let hasOvertime: Bool
  let generalState: String
  
  init(hasStress: Bool, hasBadSleep: Bool, hasLowEfficiency: Bool, hasBadTestResults: Bool, hasOvertime: Bool, generalState: String) {
    self.hasStress = hasStress
    self.hasBadSleep = hasBadSleep
    self.hasLowEfficiency = hasLowEfficiency
    self.hasBadTestResults = hasBadTestResults
    self.hasOvertime = hasOvertime
    self.generalState = generalState
  }
  
  init?(json: JSON) {
    guard let hasStress = json["hasStress"].bool,
          let hasBadSleep = json["hasBadSleep"].bool,
          let hasLowEfficiency = json["hasLowEfficiency"].bool,
          let hasBadTestResults = json["hasBadTestResults"].bool,
          let hasOvertime = json["hasOvertime"].bool,
          let generalState = json["generalState"].string else { return nil }
    self.hasStress = hasStress
    self.hasOvertime = hasOvertime
    self.hasBadSleep = hasBadSleep
    self.hasLowEfficiency = hasLowEfficiency
    self.hasBadTestResults = hasBadTestResults
    self.generalState = generalState
  }
}
