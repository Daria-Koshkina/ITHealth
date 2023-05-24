//
//  HealthItemView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import UIKit

class HealthItemView: InitView {
  
  private let containerView = InitView()
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  
  var isError = false {
    didSet {
      containerView.backgroundColor = isError ?
        .systemRed.withAlphaComponent(0.3) :
        .systemGreen.withAlphaComponent(0.3)
    }
  }
  
  override func initConfigure() {
    super.initConfigure()
    backgroundColor = .clear
    configureContainerView()
    configureImageView()
    configureTitleLabel()
  }
  
  func configure(title: String, image: UIImage) {
    titleLabel.text = title
    imageView.image = image
  }
  
  private func configureContainerView() {
    addSubview(containerView)
    containerView.layer.cornerRadius = 10
    containerView.backgroundColor = .systemGreen.withAlphaComponent(0.3)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func configureImageView() {
    containerView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
        .inset(10)
      make.left.equalToSuperview()
        .inset(15)
      make.width.height.equalTo(24)
    }
  }
  
  private func configureTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.font = Fonts.semibold16
    titleLabel.textColor = .darkGray
    titleLabel.minimumScaleFactor = 0.7
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalTo(imageView.snp.right)
        .offset(8)
      make.right.equalToSuperview()
        .inset(16)
    }
  }
}
