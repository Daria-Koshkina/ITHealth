//
//  UINavigationViewController+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 25.02.2023.
//

import UIKit

extension UINavigationController {
  func pushViewController(_ viewController: UIViewController,
                          animated: Bool,
                          completion: @escaping () -> Void) {
    pushViewController(viewController, animated: animated)
    guard animated,
      let coordinator = transitionCoordinator else {
        DispatchQueue.main.async { completion() }
        return
    }
    coordinator.animate(alongsideTransition: nil) { _ in completion() }
  }
  
  func popToRootViewController(animated: Bool,
                               completion: @escaping () -> Void) {
    popToRootViewController(animated: animated)
    guard animated,
      let coordinator = transitionCoordinator else {
        DispatchQueue.main.async { completion() }
        return
    }
    coordinator.animate(alongsideTransition: nil) { _ in completion() }
  }
  
  func popViewController(animated: Bool,
                         completion: @escaping () -> Void) {
    popViewController(animated: animated)
    guard animated,
          let coordinator = transitionCoordinator else {
      DispatchQueue.main.async { completion() }
      return
    }
    coordinator.animate(alongsideTransition: nil) { _ in completion() }
  }
}
