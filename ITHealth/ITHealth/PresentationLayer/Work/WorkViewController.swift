//
//  WorkViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.05.2023.
//

import Foundation
import SVProgressHUD

protocol WorkViewControllerOutput: AnyObject {
  func back(from: WorkViewController)
}

class WorkViewController: LocalizableViewController, ErrorAlertDisplayable, NavigationButtoned {
  
  weak var output: WorkViewControllerOutput?
  
  private let selfView = WorkView()
  private var currentDate = Date()
  
  override func initConfigure() {
    super.initConfigure()
    localize()
    configureNavBar()
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func localize() {
    super.localize()
    navigationItem.title = localizator.localizedString("work.navbar")
    selfView.titleLabel.text = localizator.localizedString("work.hours.title")
    loadHoursInfo()
  }
  
  private func configureNavBar() {
    setNavigationButton(#selector(didTapBack), button: ButtonsFactory.getNavigationBarBackButton(), side: .left)
  }
  
  private func loadHoursInfo() {
    SVProgressHUD.show()
    WorkService.shared.getHours { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let list):
          self.selfView.chartView.configure(startDate: Date().startOfWeek(), endDate: Date().endOfWeek(), stressBound: Double(ProfileService.shared.user?.workHoursCount ?? 8), title: self.localizator.localizedString("work.hours.norma"), maxTitle: self.localizator.localizedString("work.hours.max"), points: list)
        }
      }
    }
  }
  
  @objc
  private func didTapBack() {
    output?.back(from: self)
  }
}

