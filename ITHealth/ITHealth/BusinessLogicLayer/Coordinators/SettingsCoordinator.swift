//
//  SettingsCoordinator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import Foundation

protocol SettingsCoordinatorOutput: AnyObject {
  
}

class SettingsCoordinator: Coordinator {
  
  // MARK: - Public variables
  weak var output: SettingsCoordinatorOutput?
  
  // MARK: - Private variables
  
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    let vc = InitViewController()
    vc.view.backgroundColor = .magenta
    navigationController.pushViewController(vc, animated: true)
  }
}
