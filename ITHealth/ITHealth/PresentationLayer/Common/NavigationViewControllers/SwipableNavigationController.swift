//
//  SwipableNavigationController.swift
//  RoomvoDev
//
//  Created by Dasha Koshkina on 31.05.2022.
//

import UIKit

class SwipableNavigationController: BaseNavigationViewController {
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  // MARK: - Configuration
  private func configure() {
    interactivePopGestureRecognizer?.delegate = self
  }
}

// MARK: - UIGestureRecognizerDelegate
extension SwipableNavigationController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
