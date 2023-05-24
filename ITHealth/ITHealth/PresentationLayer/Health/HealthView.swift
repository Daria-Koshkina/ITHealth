//
//  HealthView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import UIKit

class HealthView: InitView {
  
  private let stackView = UIStackView()
  private let stackView2 = UIStackView()
  private let stackView3 = UIStackView()
  let effeciencyItem = HealthItemView()
  let stressItem = HealthItemView()
  let testItem = HealthItemView()
  let workItem = HealthItemView()
  let titleLabel = UILabel()
  let chartView = StressChartView()
  let prevButton = PrimaryButton()
  let nextButton = PrimaryButton()
  
  override func initConfigure() {
    super.initConfigure()
    configureStackView()
    configureStackView2()
    configureTitleLabel()
    configureChartView()
    configureStackView3()
  }
  
  private func configureStackView() {
    addSubview(stackView)
    stackView.spacing = 8
    stackView.distribution = .fillEqually
    stackView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
        .inset(16)
      make.top.equalTo(safeAreaLayoutGuide)
        .offset(20)
      make.height.equalTo(44)
    }
    stackView.addArrangedSubview(effeciencyItem)
    stackView.addArrangedSubview(stressItem)
  }
  
  private func configureStackView2() {
    addSubview(stackView2)
    stackView2.spacing = 8
    stackView2.distribution = .fillEqually
    stackView2.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
        .inset(16)
      make.top.equalTo(stackView.snp.bottom)
        .offset(10)
      make.height.equalTo(44)
    }
    stackView2.addArrangedSubview(testItem)
    stackView2.addArrangedSubview(workItem)
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.font = Fonts.semibold16
    titleLabel.textColor = UIColor.darkGray
    titleLabel.textAlignment = .center
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(stackView2.snp.bottom)
        .offset(20)
      make.left.right.equalToSuperview()
        .inset(16)
    }
  }
  
  private func configureChartView() {
    addSubview(chartView)
    chartView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(15)
      make.left.right.equalToSuperview()
        .inset(16)
      make.height.equalTo(200)
    }
  }
  
  private func configureStackView3() {
    addSubview(stackView3)
    stackView3.spacing = 8
    stackView3.distribution = .fillEqually
    stackView3.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
        .inset(16)
      make.top.equalTo(chartView.snp.bottom)
        .offset(10)
      make.height.equalTo(44)
    }
    stackView3.addArrangedSubview(prevButton)
    stackView3.addArrangedSubview(nextButton)
  }
}
