//
//  TasksViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.05.2023.
//

import UIKit
import SVProgressHUD

protocol TasksViewControllerOutput: AnyObject {
  func showWebView(url: URL, from: TasksViewController)
}

class TasksViewController: LocalizableViewController, ErrorAlertDisplayable {
  
  weak var output: TasksViewControllerOutput?
  
  private let selfView = UITableView()
  private let refresh = UIRefreshControl()
  private var dataSource = [[Task]]()
  private var token: String?
  
  override func initConfigure() {
    super.initConfigure()
    localize()
    setup()
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func localize() {
    super.localize()
    getAppKey()
  }
  
  func setToken(_ token: String) {
    self.token = token
    loadData(token: token)
  }
  
  private func setup() {
    selfView.addSubview(refresh)
    refresh.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
    selfView.register(TaskTableViewCell.self)
    selfView.delegate = self
    selfView.dataSource = self
  }

  private func getAppKey() {
    SVProgressHUD.show()
    WorkService.shared.getAppKey { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let key):
          if let url = URL(string: "https://trello.com/1/authorize?expiration=1day&name=MyPersonalToken&scope=read&response_type=token&key=\(key)&return_url=http://localhost:3000/&callback_method=fragment") {
            self.output?.showWebView(url: url, from: self)
          }
        }
      }
    }
  }
  
  private func loadData(token: String) {
    SVProgressHUD.show()
    WorkService.shared.getTasks(token: token) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        if self.refresh.isRefreshing {
          self.refresh.endRefreshing()
        }
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success((let jira, let trello)):
          self.dataSource = []
          self.dataSource.append(jira)
          self.dataSource.append(trello)
          self.selfView.reloadData()
        }
      }
    }
  }
  
  @objc
  private func refreshPage() {
    if let token = token {
      loadData(token: token)
    }
  }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TaskTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    cell.configure(name: dataSource[indexPath.section][indexPath.row].name, description: dataSource[indexPath.section][indexPath.row].description, date: dataSource[indexPath.section][indexPath.row].date)
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Jira tasks"
    case 1:
      return "Trello tasks"
    default:
      return nil
    }
  }
}
