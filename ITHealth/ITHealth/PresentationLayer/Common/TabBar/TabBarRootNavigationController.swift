//
//  TabBarRootNavigationController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import UIKit

class TabBarRootNavigationController: MainNavigationController, TabItemConfigurable {
  override var childForStatusBarStyle: UIViewController? {
    return viewControllers.last
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
