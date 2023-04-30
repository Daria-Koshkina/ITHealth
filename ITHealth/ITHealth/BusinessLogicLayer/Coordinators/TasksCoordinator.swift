//
//  TasksCoordinator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import Foundation

protocol TasksCoordinatorOutput: AnyObject {
  
}

class TasksCoordinator: Coordinator {
  
  // MARK: - Public variables
  weak var output: TasksCoordinatorOutput?
  
  // MARK: - Private variables
  
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    let vc = InitViewController()
    vc.view.backgroundColor = .green
    navigationController.pushViewController(vc, animated: true)
  }
}

