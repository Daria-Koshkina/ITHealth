//
//  NavigationButtoned.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 25.02.2023.
//

import UIKit

enum NavigationButtonSide {
  case left
  case right
}

protocol NavigationButtoned {
  func setNavigationButton(_ action: Selector, button: UIButton, side: NavigationButtonSide)
  func addNavigationButton(_ action: Selector, button: UIButton, side: NavigationButtonSide)
}

extension NavigationButtoned where Self: UIViewController {
  
  func setNavigationButton(_ action: Selector, button: UIButton, side: NavigationButtonSide = .left) {
    button.addTarget(self, action: action, for: .touchUpInside)
    let barButtonItem = UIBarButtonItem(customView: button)
    setButtonItem(barButtonItem, to: side)
  }
  
  func addNavigationButton(_ action: Selector, button: UIButton, side: NavigationButtonSide = .left) {
    button.addTarget(self, action: action, for: .touchUpInside)
    let barButtonItem = UIBarButtonItem(customView: button)
    addButtonItem(barButtonItem, to: side)
  }
  
  private func addButtonItem(_ button: UIBarButtonItem, to side: NavigationButtonSide) {
    switch side {
    case .left:
      if navigationItem.leftBarButtonItems != nil {
        navigationItem.leftBarButtonItems?.append(button)
      } else {
        navigationItem.leftBarButtonItems = [button]
      }
    case .right:
      if navigationItem.rightBarButtonItems != nil {
        navigationItem.rightBarButtonItems?.append(button)
      } else {
        navigationItem.rightBarButtonItems = [button]
      }
    }
  }
  
  private func setButtonItem(_ button: UIBarButtonItem, to side: NavigationButtonSide) {
    switch side {
    case .left:
      navigationItem.leftBarButtonItems = [button]
    case .right:
      navigationItem.rightBarButtonItems = [button]
    }
  }
}
