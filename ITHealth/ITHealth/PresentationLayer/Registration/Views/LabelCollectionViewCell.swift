//
//  LabelCollectionViewCell.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import UIKit

class LabelCollectionViewCell: BaseCollectionViewCell {
  
  private let containerView = InitView()
  let titleLabel = UILabel()
  
  override func initConfigure() {
    super.initConfigure()
    backgroundColor = .clear
    configureContainerView()
    configureTitleLabel()
  }
  
  func configure(text: String, isSelected: Bool) {
    titleLabel.text = text
    containerView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.white
  }
  
  private func configureContainerView() {
    contentView.addSubview(containerView)
    containerView.layer.cornerRadius = 12
    containerView.layer.borderColor = UIColor.lightGray.cgColor
    containerView.layer.borderWidth = 1
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func configureTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.textColor = Colors.textColorDark
    titleLabel.font = Fonts.regular16
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.right.equalToSuperview()
        .inset(10)
    }
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
}
