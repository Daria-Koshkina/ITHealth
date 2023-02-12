//
//  Coordinator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

class Coordinator: NSObject {
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start(completion: (() -> Void)? = nil) {
    completion?()
  }
}

