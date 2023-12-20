//
//  TaskTableViewCell.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.05.2023.
//

import UIKit

class TaskTableViewCell: BaseTableViewCell {
  
  private let containerView = InitView()
  private let titleLabel = UILabel()
  private let descLabel = UILabel()
  private let dateLabel = UILabel()
  
  override func initConfigure() {
    super.initConfigure()
    configureContainerView()
    configureTitleLabel()
    configureDescLabel()
    configureDateLabel()
  }
  
  func configure(name: String, description: String, date: Date) {
    titleLabel.text = name
    descLabel.text = description
    dateLabel.text = DateFormatsFactory.getDefaultDateFormat().string(from: date)
  }
  
  private func configureContainerView() {
    contentView.addSubview(containerView)
    containerView.layer.cornerRadius = 12
    containerView.layer.borderColor = Colors.lightBlue.cgColor
    containerView.layer.borderWidth = 2
    containerView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
        .inset(16)
      make.top.bottom.equalToSuperview()
        .inset(8)
    }
  }
  
  private func configureTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.font = Fonts.semibold16
    titleLabel.textColor = Colors.blueDark
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = .zero
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(8)
      make.left.right.equalToSuperview()
        .inset(16)
    }
  }
  
  private func configureDescLabel() {
    containerView.addSubview(descLabel)
    descLabel.font = Fonts.regular16
    descLabel.textColor = UIColor.black
    descLabel.numberOfLines = .zero
    descLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(4)
      make.left.right.equalToSuperview()
        .inset(16)
    }
  }
  
  private func configureDateLabel() {
    containerView.addSubview(dateLabel)
    dateLabel.font = Fonts.regular12
    dateLabel.textColor = UIColor.darkGray
    dateLabel.numberOfLines = .zero
    dateLabel.snp.makeConstraints { make in
      make.top.equalTo(descLabel.snp.bottom)
        .offset(4)
      make.left.right.equalToSuperview()
        .inset(16)
      make.bottom.equalToSuperview()
        .inset(8)
    }
  }
}
