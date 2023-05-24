//
//  LanguageViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 01.05.2023.
//

import UIKit
import FlagKit
import SVProgressHUD

protocol LanguageViewControllerOutput: AnyObject {
  func back(from: LanguageViewController)
}

private enum LanguageItem {
  case language(language: AppLanguage, isSelected: Bool, hasBorder: Bool)
}

class LanguageViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  weak var output: LanguageViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = UITableView()
  private var dataSource = [LanguageItem]()
  
  // MARK: - Life cycle
  override func loadView() {
    view = selfView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func initConfigure() {
    super.initConfigure()
    setupNavBar()
    configureTableView()
    localizeStrings()
    setDataSource()
  }
  
  override func localize() {
    localizeStrings()
    setDataSource()
  }
  
  private func localizeStrings() {
    navigationItem.title = localizator.localizedString("language_navTitle.text")
  }
  
  private func setupNavBar() {
    setNavigationButton(#selector(didTapBack), button: ButtonsFactory.getNavigationBarBackButton())
    (navigationController as? MainNavigationController)?.setupSelfConfiguration(with: .white(withLine: false))
  }
  
  private func setDataSource() {
    let lastLanguageCode = AppLanguage.list.last?.code
    dataSource = AppLanguage.list.map { .language(language: $0,
                                                  isSelected: LocalizationService.shared.language.code == $0.code,
                                                  hasBorder: $0.code != lastLanguageCode) }
    selfView.reloadData()
  }
  
  private func configureTableView() {
    selfView.separatorStyle = .none
    selfView.delegate = self
    selfView.dataSource = self
    selfView.register(LanguageTableViewCell.self)
    selfView.tableFooterView = UIView()
  }
  
  private func setLanguage(_ language: AppLanguage) {
    var indexesForReloading = [Int]()
    for index in dataSource.indices {
      switch dataSource[index] {
      case .language(let item, let isSelected, let hasBorder):
        if item.code == language.code {
          dataSource[index] = .language(language: item, isSelected: true, hasBorder: hasBorder)
          indexesForReloading.append(index)
        } else if isSelected {
          dataSource[index] = .language(language: item, isSelected: false, hasBorder: hasBorder)
          indexesForReloading.append(index)
        }
      }
    }
    selfView.reloadRows(at: indexesForReloading.map { IndexPath(row: $0, section: 0) },
                        with: .automatic)
    if LocalizationService.shared.language != language {
      LocalizationService.shared.language = language
    }
    output?.back(from: self)
  }
  
  @objc
  private func didTapBack() {
    output?.back(from: self)
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch dataSource[indexPath.row] {
    case .language(let language, let isSelected, let hasBorder):
      let cell: LanguageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(languageTitle: language.nativeName,
                     flagImage: Flag(countryCode: language.regionCode.uppercased())?.originalImage ?? UIImage(),
                     isSelected: isSelected)
      cell.showBorders(hasBorder ? [.bottom] : [])
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch dataSource[indexPath.row] {
    case .language(let language, _, _):
      setLanguage(language)
    }
  }
}

