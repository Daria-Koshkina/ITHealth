//
//  AuthCoordinator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import Foundation

protocol AuthCoordinatorOutput: AnyObject {
  func wasAuthorized(from: AuthCoordinator)
}

class AuthCoordinator: Coordinator {
  
  // MARK: - Public variables
  weak var output: AuthCoordinatorOutput?
  
  // MARK: - Private variables
  private var authViewController: AuthViewController?
  private weak var registerViewController: RegisterViewController?
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    let authViewController = AuthViewController()
    authViewController.output = self
    self.authViewController = authViewController
    navigationController.pushViewController(authViewController, animated: true)
  }
}

extension AuthCoordinator: AuthViewControllerOutput {
  func wasAuthorized(from: AuthViewController) {
    navigationController.popViewController(animated: true) {
      self.output?.wasAuthorized(from: self)
    }
  }
  
  func register(from: AuthViewController) {
    let registerViewController = RegisterViewController()
    registerViewController.output = self
    self.registerViewController = registerViewController
    navigationController.pushViewController(registerViewController, animated: true)
  }
}

// MARK: - RegisterViewControllerOutput
extension AuthCoordinator: RegisterViewControllerOutput {
  func wasRegistered(from: RegisterViewController) {
    navigationController.popViewController(animated: true)
  }
}
