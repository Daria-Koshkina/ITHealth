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
  private var taskViewController: TasksViewController?
  
  // MARK: - Private variables
  
  
  // MARK: - Start
  override func start(completion: (() -> Void)? = nil) {
    let vc = TasksViewController()
    vc.output = self
    taskViewController = vc
    navigationController.pushViewController(vc, animated: true)
  }
}

extension TasksCoordinator: TasksViewControllerOutput {
  func showWebView(url: URL, from: TasksViewController) {
    let vc = WebViewController(source: .urlRequest(URLRequest(url: url)))
    vc.output = self
    navigationController.pushViewController(vc, animated: true)
  }
}

extension TasksCoordinator: WebViewControllerOutput {
  func didRedirect(from: WebViewController, token: String) {
    taskViewController?.setToken(token)
    navigationController.popViewController(animated: true)
  }
}
