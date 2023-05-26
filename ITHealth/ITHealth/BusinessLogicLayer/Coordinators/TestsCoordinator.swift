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
  weak var testListViewController: TestListViewController?
  weak var testViewController: TestViewController?
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    let vc = TestListViewController()
    vc.output = self
    testListViewController = vc
    navigationController.pushViewController(vc, animated: true)
  }
}

extension TestsCoordinator: TestListViewControllerOutput {
  func showTest(from: TestListViewController) {
    let vc = TestViewController()
    vc.output = self
    testViewController = vc
    navigationController.pushViewController(vc, animated: true)
  }
}

extension TestsCoordinator: TestViewControllerOutput {
  func back(from: TestViewController) {
    navigationController.popViewController(animated: true)
  }
}
