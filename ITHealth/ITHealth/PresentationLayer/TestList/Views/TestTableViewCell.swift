//
//  TestTableViewCell.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 24.05.2023.
//

import UIKit

class TestTableViewCell: BaseTableViewCell {
  
  private let containerView = InitView()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let dateLabel = UILabel()
  
  override func initConfigure() {
    super.initConfigure()
    configureContainerView()
    configureTitleLabel()
    configureDescriptionLabel()
    configureDateLabel()
  }
  
  func configure(title: String, description: String, date: Date) {
    titleLabel.text = title
    descriptionLabel.text = description
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
    titleLabel.textAlignment = .center
    titleLabel.font = Fonts.semibold16
    titleLabel.textColor = Colors.blueDark
    titleLabel.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
        .inset(12)
    }
  }
  
  private func configureDescriptionLabel() {
    containerView.addSubview(descriptionLabel)
    descriptionLabel.font = Fonts.regular12
    descriptionLabel.textColor = .black
    descriptionLabel.numberOfLines = .zero
    descriptionLabel.snp.makeConstraints { make in
      make.left.right.equalTo(titleLabel)
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(8)
    }
  }
  
  private func configureDateLabel() {
    containerView.addSubview(dateLabel)
    dateLabel.font = Fonts.regular16
    dateLabel.textColor = .black
    dateLabel.snp.makeConstraints { make in
      make.left.right.equalTo(titleLabel)
      make.top.equalTo(descriptionLabel.snp.bottom)
        .offset(8)
      make.bottom.equalToSuperview()
        .inset(12)
    }
  }
}
