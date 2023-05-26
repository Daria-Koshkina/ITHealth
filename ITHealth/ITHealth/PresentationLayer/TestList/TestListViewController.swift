//
//  TestListViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 24.05.2023.
//

import UIKit
import SVProgressHUD

protocol TestListViewControllerOutput: AnyObject {
  func showTest(from: TestListViewController)
}

class TestListViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  weak var output: TestListViewControllerOutput?
  
  private let selfView = UITableView()
  private let activityIndicator = UIActivityIndicatorView()
  private let refreshControl = UIRefreshControl()
  
  private var currentPage = 1
  private var lastPage = 0
  private var isLoading = false
  private var dataSource = [Test]()
  
  // MARK: - Life cycle
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
    loadData(page: currentPage)
  }
  
  private func setup() {
    selfView.delegate = self
    selfView.dataSource = self
    selfView.register(TestTableViewCell.self)
    selfView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
  }
  
  private func loadData(page: Int, isPaginationSearch: Bool = false, isSilently: Bool = false) {
    isLoading = true
    setLoadingAnimation(shouldAnimate: true, isPaginationSearch: isPaginationSearch, isSilently: isSilently)
    TestsService.shared.getTestList(currentPage: page) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        self.setLoadingAnimation(shouldAnimate: false, isPaginationSearch: isPaginationSearch, isSilently: isSilently)
        self.isLoading = false
        switch result {
        case .success(let data):
          self.currentPage = data.currentPage
          self.lastPage = data.lastPage
          self.setupDataSource(data.items)
        case .failure(let error):
          self.handleError(error)
        }
      }
    }
  }

  private func setLoadingAnimation(shouldAnimate: Bool, isPaginationSearch: Bool, isSilently: Bool) {
    if isPaginationSearch {
      setPaginationActivityIndicatorAnimate(shouldAnimate)
    } else {
      if !isSilently {
        shouldAnimate ? SVProgressHUD.show() : SVProgressHUD.dismiss()
      } else {
        refreshControl.endRefreshing()
      }
    }
  }
  
  private func setupDataSource(_ tests: [Test]) {
    if currentPage == 1 {
      dataSource = tests
      selfView.reloadData()
    } else {
      var insertedIndexes = [IndexPath]()
      if !tests.isEmpty {
        insertedIndexes = (0..<tests.count).map { IndexPath(row: self.dataSource.count + $0, section: 0) }
      }
      dataSource.append(contentsOf: tests)
      
      selfView.performBatchUpdates {
        selfView.insertRows(at: insertedIndexes, with: .automatic)
      }
    }
  }
  
  private func setPaginationActivityIndicatorAnimate(_ shouldAnimate: Bool) {
    if shouldAnimate {
      selfView.tableFooterView = activityIndicator
      activityIndicator.startAnimating()
    } else {
      selfView.tableFooterView = nil
      activityIndicator.stopAnimating()
    }
  }
  
  private func loadTest(testId: Int) {
    SVProgressHUD.show()
    TestsService.shared.getTest(id: testId) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let test):
          TestsService.shared.startTest(test)
          self.output?.showTest(from: self)
        }
      }
    }
  }
  
  @objc
  private func refresh() {
    currentPage = 1
    loadData(page: currentPage, isSilently: true)
  }
}

extension TestListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TestTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    cell.configure(title: dataSource[indexPath.row].title, description: dataSource[indexPath.row].description, date: dataSource[indexPath.row].deadline)
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard indexPath.row == dataSource.count - 1,
          currentPage < lastPage,
          !isLoading else { return }
    loadData(page: currentPage + 1, isPaginationSearch: true)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    loadTest(testId: dataSource[indexPath.row].id)
  }
}
