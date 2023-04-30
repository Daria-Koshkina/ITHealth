//
//  TestsCoordinator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import Foundation

protocol TestsCoordinatorOutput: AnyObject {
  
}

class TestsCoordinator: Coordinator {
  
  // MARK: - Public variables
  weak var output: TestsCoordinatorOutput?
  
  // MARK: - Private variables
  
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    let vc = InitViewController()
    vc.view.backgroundColor = .systemBlue
    navigationController.pushViewController(vc, animated: true)
  }
}
