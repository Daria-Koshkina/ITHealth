//
//  SettingsViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.04.2023.
//

import UIKit
import SVProgressHUD

protocol SettingsViewControllerOutput: AnyObject {
  func showProfile(from viewController: SettingsViewController)
  func showHealth(from viewController: SettingsViewController)
  func showWork(from viewController: SettingsViewController)
  func showLanguage(from viewController: SettingsViewController)
  func showPassword(from viewController: SettingsViewController)
}

enum ProfileItemType {
  case profile
  case health
  case work
  case logout
  case language
  case password
}

class SettingsViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  var output: SettingsViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = SettingsView()
  private var itemsInfo = [ProfileItemInfoViewModel]()

  // MARK: - Life cycle
  override func loadView() {
    view = selfView
  }
  
  override func initConfigure() {
    super.initConfigure()
    setupNavigationController()
    setupView()
    localize()
  }
  
  private func setupNavigationController() {
    (navigationController as? MainNavigationController)?.setupSelfConfiguration(with: .white(withLine: false))
  }
  
  private func setupView() {
    edgesForExtendedLayout = [.top]
    selfView.delegate = self
  }
  
  private func setupViewContent() {
    setupItemsInfo()
  }
  
  private func setupItemsInfo() {
    itemsInfo = [
      ProfileItemInfoViewModel(
        type: .profile,
        image: Images.profile,
        title: localizator.localizedString("profile.item.profile"),
        subtitle: localizator.localizedString("profile.item.profile.subtitle"),
        showRightArrow: true,
        needBottomSpace: true),
      ProfileItemInfoViewModel(
        type: .health,
        image: Images.health,
        title: localizator.localizedString("profile.item.health"),
        subtitle: localizator.localizedString("profile.item.health.subtitle"),
        showRightArrow: true,
        needBottomSpace: false),
      ProfileItemInfoViewModel(
        type: .work,
        image: Images.work,
        title: localizator.localizedString("profile.item.work"),
        subtitle: localizator.localizedString("profile.item.work.subtitle"),
        showRightArrow: true,
        needBottomSpace: true),
      ProfileItemInfoViewModel(
        type: .language,
        image: Images.language,
        title: localizator.localizedString("profile.item.language"),
        subtitle: nil,
        showRightArrow: true,
        needBottomSpace: false),
      ProfileItemInfoViewModel(
        type: .password,
        image: Images.lock,
        title: localizator.localizedString("profile.item.password"),
        subtitle: nil,
        showRightArrow: true,
        needBottomSpace: false),
      ProfileItemInfoViewModel(
        type: .logout,
        image: Images.logout,
        title: localizator.localizedString("profile.item.logout"),
        subtitle: nil,
        showRightArrow: true,
        needBottomSpace: false)]
    
    selfView.configure(items: itemsInfo)
  }
  
  override func localize() {
    setupViewContent()
  }

  // MARK: - Actions
  
  private func didTapOnExitButton() {
    ProfileService.shared.logout()
  }
  
  private func showLogoutWarningAlert() {
    showAlert(title: Localizator.standard.localizedString("profile_editTitle_title.text"),
                      message: nil,
                      okButtonTitle: Localizator.standard.localizedString("profile_editTitle_exit.text"),
                      cancelButtonTitle: Localizator.standard.localizedString("profile_editTitle_cancel.text"),
              shouldAutomaticallyHide: true,
              okHandler: didTapOnExitButton,
              cancelHandler: nil,
              cancelButtonPosition: .bottom)
  }
}

// MARK: - ProfileItemDelegate
extension SettingsViewController: ProfileItemDelegate {
  func didTapOnProfileItem(_ viewModel: ProfileItemInfoViewModel) {
    switch viewModel.type {
    case .profile:
      output?.showProfile(from: self)
    case .health:
      output?.showHealth(from: self)
    case .work:
      output?.showWork(from: self)
    case .logout:
      showLogoutWarningAlert()
    case .language:
      output?.showLanguage(from: self)
    case .password:
      output?.showPassword(from: self)
    }
  }
}
