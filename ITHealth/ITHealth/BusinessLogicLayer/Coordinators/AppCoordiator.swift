//
//  AppCoordiator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit
import SnapKit

class AppCoordinator: Coordinator {
  
  // MARK: - Private variables
  private var authCoordinator: AuthCoordinator?
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    showAuth()
  }
  
  // MARK: - Private methods
  private func showAuth() {
    let authCoordinator = AuthCoordinator(navigationController: navigationController)
    authCoordinator.output = self
    self.authCoordinator = authCoordinator
    authCoordinator.start()
  }
}

extension AppCoordinator: AuthCoordinatorOutput {
  func wasAuthorized(from: AuthCoordinator) {
    
  }
}
