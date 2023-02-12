//
//  AppCoordiator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit
import SnapKit

class AppCoordinator: Coordinator {
  
  // MARK: - Private variables
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    let vc = UIViewController()
    vc.view.backgroundColor = .systemRed
    navigationController.pushViewController(vc, animated: true)
  }
  
  // MARK: - Private methods
  
}
