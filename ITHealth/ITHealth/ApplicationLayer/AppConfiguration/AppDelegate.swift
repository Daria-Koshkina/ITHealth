//
//  AppDelegate.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Public variables
  var window: UIWindow?
  var appCoordinator: Coordinator?

  // MARK: - Life cycle
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
    AppConfigurator.shared.configure(appDelegate: self,
                                     application: application,
                                     didFinishLaunchingWithOptions: launchOptions)
    return true
  }
}
