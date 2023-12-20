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
  private weak var settingsViewController: SettingsViewController?
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    let settingsViewController = SettingsViewController()
    settingsViewController.output = self
    self.settingsViewController = settingsViewController
    navigationController.pushViewController(settingsViewController, animated: true)
  }
}

extension SettingsCoordinator: SettingsViewControllerOutput {
  func showPassword(from viewController: SettingsViewController) {
    let vc = ChangePasswordViewController()
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showProfile(from viewController: SettingsViewController) {
    let vc = ProfileViewController()
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showHealth(from viewController: SettingsViewController) {
    let vc = HealthViewController()
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showWork(from viewController: SettingsViewController) {
    let vc = WorkViewController()
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showLanguage(from viewController: SettingsViewController) {
    let vc = LanguageViewController()
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
  }
}

extension SettingsCoordinator: LanguageViewControllerOutput {
  func back(from: LanguageViewController) {
    navigationController.popViewController(animated: true)
  }
}

extension SettingsCoordinator: ProfileViewControllerOutput {
  func back(from: ProfileViewController) {
    navigationController.popViewController(animated: true)
  }
}

extension SettingsCoordinator: ChangePasswordViewControllerOutput {
  func back(from: ChangePasswordViewController) {
    navigationController.popViewController(animated: true)
  }
}

extension SettingsCoordinator: HealthViewControllerOutput {
  func back(from: HealthViewController) {
    navigationController.popViewController(animated: true)
  }
}

extension SettingsCoordinator: WorkViewControllerOutput {
  func back(from: WorkViewController) {
    navigationController.popViewController(animated: true)
  }
}
