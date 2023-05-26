//
//  AppConfigurator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit
import Lokalise
import SVProgressHUD

class AppConfigurator {
  
  // MARK: - Public variables
  static let shared = AppConfigurator()
  
  // MARK: - Private variables
  private weak var appCoordinator: Coordinator?
  
  // MARK: - Life cycle
  private init() { }
  
  // MARK: - Actions
  func configure(
    appDelegate: AppDelegate,
    application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    configureLokalise()
    configureHUD()
    configureAppCoordinator(appDelegate: appDelegate)
    configureAppWindow(appDelegate: appDelegate)
      ProfileService.shared.sendHealthData()
  }
  
  private func configureLokalise() {
    Lokalise.shared.swizzleMainBundle()
    Lokalise.shared.checkForUpdates()
  }
  
  private func configureHUD() {
    SVProgressHUD.setDefaultMaskType(.custom)
    SVProgressHUD.setBackgroundColor(.clear)
    SVProgressHUD.setForegroundColor(UIColor.darkGray)
    let backgroundColor = UIColor.white.withAlphaComponent(0.5)
    SVProgressHUD.setBackgroundLayerColor(backgroundColor)
    SVProgressHUD.setRingThickness(6)
  }
  
  private func configureAppCoordinator(appDelegate: AppDelegate) {
    let navigationController = MainNavigationController(nibName: nil, bundle: nil)
    let appCoordinator = AppCoordinator(navigationController: navigationController)
    self.appCoordinator = appCoordinator
    appDelegate.appCoordinator = appCoordinator
  }
  
  private func configureAppWindow(appDelegate: AppDelegate) {
    let window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window = window
    window.rootViewController = appDelegate.appCoordinator?.navigationController
    window.makeKeyAndVisible()
    appDelegate.appCoordinator?.start()
  }
}

