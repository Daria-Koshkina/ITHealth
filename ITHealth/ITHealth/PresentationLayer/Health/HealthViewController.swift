//
//  HealthViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import Foundation

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
    selfView.titleLabel.text = localizator.localizedString("health.stress.title")
    selfView.prevButton.setTitle(localizator.localizedString("health.stress.prev"), for: .normal)
    selfView.nextButton.setTitle(localizator.localizedString("health.stress.next"), for: .normal)
  }
  
  private func configureNavBar() {
    setNavigationButton(#selector(didTapBack), button: ButtonsFactory.getNavigationBarBackButton(), side: .left)
  }
  
  private func setup() {
    selfView.workItem.isError = true
    selfView.testItem.isError = true
    selfView.prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
    selfView.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
  }
  
  private func loadData(date: Date) {
    currentDate = date
    let startDate = date.startOfWeek()
    let endDate = date.endOfWeek()
    selfView.chartView.configure(startDate: startDate, endDate: endDate, stressBound: 1.12, points: [0.3, 0.5, 0.6, 0.9, 0.4])
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
