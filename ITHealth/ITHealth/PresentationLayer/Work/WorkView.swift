//
//  WorkView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.05.2023.
//

import UIKit

class WorkView: InitView {
  
  let titleLabel = UILabel()
  let chartView = StressChartView()
  
  override func initConfigure() {
    super.initConfigure()
    configureTitleLabel()
    configureChartView()
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.font = Fonts.semibold16
    titleLabel.textColor = UIColor.darkGray
    titleLabel.textAlignment = .center
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
        .offset(30)
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
      make.bottom.lessThanOrEqualToSuperview()
    }
  }
}
