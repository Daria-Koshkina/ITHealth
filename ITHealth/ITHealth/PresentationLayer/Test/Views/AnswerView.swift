//
//  AnswerView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 25.05.2023.
//

import UIKit

class AnswerView: InitView {
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  
  private(set) var isSelected = false
  
  var answer: Answer?
  
  override func initConfigure() {
    super.initConfigure()
    configureImageView()
    configureTitleLabel()
  }
  
  func setTitle(_ title: String) {
    titleLabel.text = title
  }
  
  func setIsSelected(_ isSelected: Bool) {
    self.isSelected = isSelected
    imageView.image = isSelected ? Images.radioFilled : Images.radioEmpty
  }
  
  private func configureImageView() {
    addSubview(imageView)
    imageView.image = Images.radioEmpty
    imageView.snp.makeConstraints { make in
      make.left.centerY.equalToSuperview()
      make.width.height.equalTo(22)
    }
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.font = Fonts.regular16
    titleLabel.textColor = .black
    titleLabel.numberOfLines = .zero
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(imageView.snp.right)
        .offset(8)
      make.top.bottom.right.equalToSuperview()
    }
  }
}
