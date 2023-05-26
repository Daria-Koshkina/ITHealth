//
//  OpenAnswerView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 26.05.2023.
//

import UIKit

class OpenAnswerView: InitView {
  
  let titleLabel = UILabel()
  let textView = CustomTextView()
  
  var answer: OpenQuestion?
  
  override func initConfigure() {
    super.initConfigure()
    configureTitleLabel()
    configureTextView()
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.font = Fonts.regular16
    titleLabel.textColor = .black
    titleLabel.numberOfLines = .zero
    titleLabel.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }
  }
  
  private func configureTextView() {
    addSubview(textView)
    textView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(8)
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(70)
    }
  }
}
