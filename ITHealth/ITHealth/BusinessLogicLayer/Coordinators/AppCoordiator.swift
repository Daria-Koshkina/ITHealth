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
  private var mainTabBarCoordinator: MainTabBarCoordinator?
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    if ProfileService.shared.isUserAuthorized {
      showMain(completion: completion)
    } else {
      showAuth()
    }
  }
  
  // MARK: - Private methods
  private func showAuth() {
    let authCoordinator = AuthCoordinator(navigationController: navigationController)
    authCoordinator.output = self
    self.authCoordinator = authCoordinator
    authCoordinator.start()
  }
  
  private func showMain(completion: (() -> Void)? = nil) {
    guard let user = ProfileService.shared.user,
          user.connectedToCompany else {
      showAddToCompany()
      return
    }
    let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
    mainTabBarCoordinator.output = self
    self.mainTabBarCoordinator = mainTabBarCoordinator
    mainTabBarCoordinator.start(completion: completion)
  }
  
  private func showAddToCompany() {
    let vc = CodeViewController()
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
  }
}

extension AppCoordinator: AuthCoordinatorOutput {
  func wasAuthorized(from: AuthCoordinator) {
    navigationController.viewControllers.removeAll(where: { $0.isKind(of: AuthViewController.self) })
    showMain()
  }
}

extension AppCoordinator: MainTabBarCoordinatorOutput {
  func userDidLogout(from: MainTabBarCoordinator) {
    mainTabBarCoordinator?.clearControllers {
      self.showAuth()
    }
  }
}

extension AppCoordinator: CodeViewControllerOutput {
  func codeWasEntered(from: CodeViewController) {
    navigationController.viewControllers.removeAll(where: { $0.isKind(of: CodeViewController.self) })
    showMain()
  }
}
