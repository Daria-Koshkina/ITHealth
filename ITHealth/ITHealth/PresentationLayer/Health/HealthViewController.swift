//
//  HealthViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import Foundation
import SVProgressHUD

protocol HealthViewControllerOutput: AnyObject {
  func back(from: HealthViewController)
}

class HealthViewController: LocalizableViewController, ErrorAlertDisplayable, NavigationButtoned {
  
  weak var output: HealthViewControllerOutput?
  
  private let selfView = HealthView()
  private var currentDate = Date()
  
  override func initConfigure() {
    super.initConfigure()
    localize()
    setup()
    configureNavBar()
    loadData(date: currentDate)
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func localize() {
    super.localize()
    navigationItem.title = localizator.localizedString("health.navbar")
    selfView.effeciencyItem.configure(title: localizator.localizedString("health.effeciency"), image: Images.efficiency)
    selfView.stressItem.configure(title: localizator.localizedString("health.stress"), image: Images.stress)
    selfView.testItem.configure(title: localizator.localizedString("health.test"), image: Images.testHealth)
    selfView.workItem.configure(title: localizator.localizedString("health.work"), image: Images.workHealth)
    selfView.sleepItem.configure(title: localizator.localizedString("health.sleep"), image: Images.workHealth)
    selfView.titleLabel.text = localizator.localizedString("health.stress.title")
    selfView.prevButton.setTitle(localizator.localizedString("health.stress.prev"), for: .normal)
    selfView.nextButton.setTitle(localizator.localizedString("health.stress.next"), for: .normal)
    loadBurnoutInfo()
  }
  
  private func configureNavBar() {
    setNavigationButton(#selector(didTapBack), button: ButtonsFactory.getNavigationBarBackButton(), side: .left)
  }
  
  private func setup() {
    selfView.prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
    selfView.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
  }
  
  private func loadBurnoutInfo() {
    SVProgressHUD.show()
    HealthService.shared.getBurnoutResult { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let data):
          self.configureBurnoutInfo(data)
        }
      }
    }
  }
  
  private func configureBurnoutInfo(_ data: BurnoutInfo) {
    selfView.workItem.isError = data.hasOvertime
    selfView.testItem.isError = data.hasBadTestResults
    selfView.sleepItem.isError = data.hasBadSleep
    selfView.effeciencyItem.isError = data.hasLowEfficiency
    selfView.stressItem.isError = data.hasStress
    selfView.burnoutLabel.text = localizator.localizedString("health.burnout") + data.generalState
  }
  
  private func loadData(date: Date) {
    currentDate = date
    let startDate = date.startOfWeek()
    let endDate = date.endOfWeek()
    let dateFormat = DateFormatsFactory.getDefaultDateFormat()
    let startDateString = dateFormat.string(from: startDate)
    let endDateString = dateFormat.string(from: endDate)
    SVProgressHUD.show()
    HealthService.shared.getStressResult(startDate: startDateString, endDate: endDateString) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let stressList):
          self.selfView.chartView.configure(startDate: startDate, endDate: endDate, stressBound: Constants.stressBound, title: self.localizator.localizedString("stress.chart.stress_bound"), maxTitle: self.localizator.localizedString("stress.chart.top"), points: stressList)
        }
      }
    }
  }
  
  @objc
  private func didTapBack() {
    output?.back(from: self)
  }
  
  @objc
  private func didTapPrev() {
    loadData(date: currentDate.previousWeek())
  }
  
  @objc
  private func didTapNext() {
    loadData(date: currentDate.nextWeek())
  }
}
