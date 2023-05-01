//
//  MainTabBarCoordinator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import UIKit

protocol MainTabBarCoordinatorOutput: AnyObject {
  func userDidLogout(from: MainTabBarCoordinator)
}

class MainTabBarCoordinator: Coordinator {
  
  // MARK: - Public varaibles
  weak var output: MainTabBarCoordinatorOutput?
  
  // MARK: - Private varaibles
  private var settingsCoordinator: Coordinator?
  private var testsCoordinator: Coordinator?
  private var tasksCoordinator: Coordinator?
  
  private let tabBarController: MainTabBarController = {
    let viewController = MainTabBarController()
    viewController.modalPresentationStyle = .fullScreen
    return viewController
  }()
  
  // MARK: - Life cycle
  override func start(completion: (() -> Void)? = nil) {
    addObservers()
    configureMainTabBarController()
    showMainTabBarController(completion: completion)
    showFirstTabBar()
    setupLocalization()
  }
  
  func clearControllers(completion: (() -> Void)?) {
    navigationController.popToRootViewController(animated: true) {
      self.navigationController.dismiss(animated: true) {
        completion?()
      }
    }
  }
  
  private func showMainTabBarController(completion: (() -> Void)?) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.navigationController.present(
        self.tabBarController, animated: true, completion: completion)
    }
  }
  
  private func showFirstTabBar() {
    tabBarController.selectedItem = Application.shared.allTabBars.sorted(by: { $0.index < $1.index }).first ?? Application.shared.defaultTabBar
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(userDidLogout),
      name: .logout,
      object: nil)
  }
  
  private func setupLocalization() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(localize),
      name: Notification.Name.LokaliseDidUpdateLocalization,
      object: nil)
  }
  
  @objc
  private func userDidLogout() {
    output?.userDidLogout(from: self)
  }
  
  // MARK: - Configuration
  private func configureMainTabBarController() {
    var items: [TabItem: UIViewController] = [:]
    Application.shared.allTabBars.forEach { (item) in
      items[item] = createTab(item: item)
    }

    let sortedDict = items.sorted { return $0.key.index < $1.key.index }
    let sortedVCs = sortedDict.map { $0.value }

    tabBarController.viewControllers = sortedVCs
    tabBarController.coordinator = self
  }
  
  // MARK: - Tab items create
  private func createTab(item: TabItem) -> UIViewController {
    switch item.type {
    case .settings:
      return createSettingsTab(item: item)
    case .tests:
      return createTestsTab(item: item)
    case .tasks:
      return createTasksTab(item: item)
    }
  }
  
  private func createSettingsTab(item: TabItem) -> UIViewController {
    let tabBarRootNavigationController = TabBarRootNavigationController()
    let settingsCoordinator = SettingsCoordinator(
      navigationController: tabBarRootNavigationController)
    settingsCoordinator.output = self
    self.settingsCoordinator = settingsCoordinator
    settingsCoordinator.start()
    tabBarRootNavigationController.configureTabBarItem(tabItem: item)
    return tabBarRootNavigationController
  }
  
  private func createTestsTab(item: TabItem) -> UIViewController {
    let tabBarRootNavigationController = TabBarRootNavigationController()
    let testsCoordinator = TestsCoordinator(
      navigationController: tabBarRootNavigationController)
    testsCoordinator.output = self
    self.testsCoordinator = testsCoordinator
    testsCoordinator.start()
    tabBarRootNavigationController.configureTabBarItem(tabItem: item)
    return tabBarRootNavigationController
  }
  
  private func createTasksTab(item: TabItem) -> UIViewController {
    let tabBarRootNavigationController = TabBarRootNavigationController()
    let tasksCoordinator = TasksCoordinator(
      navigationController: tabBarRootNavigationController)
    tasksCoordinator.output = self
    self.tasksCoordinator = tasksCoordinator
    tasksCoordinator.start()
    tabBarRootNavigationController.configureTabBarItem(tabItem: item)
    return tabBarRootNavigationController
  }
  
  @objc
  private func localize() {
    guard let viewControllers = tabBarController.viewControllers as? [TabItemConfigurable] else { return }
    for (index, vc) in viewControllers.enumerated() {
      guard let tabItem = Application.shared.allTabBars.first(where: { $0.index == index }) else { return }
      vc.configureTabBarItem(tabItem: tabItem)
    }
  }
}

// MARK: - MainTabBarControllerOutput
extension MainTabBarCoordinator: MainTabBarControllerOutput {
  
}

// MARK: - NetWealthCoordinatorOutput
extension MainTabBarCoordinator: SettingsCoordinatorOutput { }

// MARK: - TransactionsCoordinatorOutput
extension MainTabBarCoordinator: TestsCoordinatorOutput { }

// MARK: - BudgetingCoordinatorOutput
extension MainTabBarCoordinator: TasksCoordinatorOutput { }
