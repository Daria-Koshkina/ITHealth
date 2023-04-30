//
//  MainTabBarController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import UIKit

protocol MainTabBarControllerOutput: AnyObject {
  
}

class MainTabBarController: ColoredTabBarController {
  
  // MARK: - Public variables
  weak var coordinator: MainTabBarControllerOutput?
  
  var selectedItem: TabItem {
    get { Application.shared.allTabBars.first(where: { $0.index == selectedIndex }) ?? Application.shared.defaultTabBar }
    set { selectedIndex = newValue.index }
  }
}

enum TabItemType: String {
  case settings
  case tests
  case tasks
}

struct TabItem: Hashable {
  let index: Int
  let type: TabItemType
  let title: String
  let image: UIImage
  let selectedImage: UIImage
  let notificationValue: Int
}

class Application {
  
  // MARK: - Public variables
  static let shared = Application()
  var allTabBars = [
    TabItem(
    index: 0,
    type: .settings,
    title: Localizator.standard.localizedString("settings.title"),
    image: Images.settings,
    selectedImage: Images.settings,
    notificationValue: 0),
    TabItem(
    index: 1,
    type: .tests,
    title: Localizator.standard.localizedString("tests.title"),
    image: Images.tests,
    selectedImage: Images.tests,
    notificationValue: 0),
    TabItem(
    index: 2,
    type: .tasks,
    title: Localizator.standard.localizedString("tasks.title"),
    image: Images.tasks,
    selectedImage: Images.tasks,
    notificationValue: 0),
  ]
  
  let defaultTabBar = TabItem(
    index: 0,
    type: .settings,
    title: Localizator.standard.localizedString("settings.title"),
    image: Images.settings,
    selectedImage: Images.settings,
    notificationValue: 0)
  
  // MARK: - Life cycle
  private init() {}
}
