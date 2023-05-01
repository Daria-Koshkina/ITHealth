//
//  ChangePasswordView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 01.05.2023.
//

import Foundation

class ChangePasswordView: InitView {
  
  let passwordTextField = InputView()
  let button = PrimaryButton()
  
  override func initConfigure() {
    super.initConfigure()
    configurePasswordTextField()
    configureButton()
  }
  
  private func configurePasswordTextField() {
    addSubview(passwordTextField)
    passwordTextField.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
        .offset(30)
      make.left.right.equalToSuperview()
        .inset(16)
      make.height.equalTo(56)
    }
  }
  
  private func configureButton() {
    addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(passwordTextField.snp.bottom)
        .offset(30)
      make.left.right.equalToSuperview()
        .inset(16)
      make.height.equalTo(56)
      make.bottom.lessThanOrEqualToSuperview()
    }
  }
}
