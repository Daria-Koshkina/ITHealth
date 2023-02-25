//
//  AuthView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

class AuthView: InitView {
  
  // MARK: - Public variables
  let imageView = UIImageView()
  let titleLabel = UILabel()
  let emailTextField = InputView()
  let passwordTextField = InputView()
  let authButton = OutlinedButton()
  let registerButton = PrimaryButton()
  
  // MARK: - Private variables
  private let scrollView = UIScrollView()
  private let containerView = InitView()
  private let buttonsStackView = UIStackView()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureScrollView()
    configureContainerView()
    configureImageView()
    configureTitleLabel()
    configureEmailTextField()
    configurePasswordTextField()
    configureButtonsStackView()
  }
  
  func updateBottomOffset(_ keyboardOffset: CGFloat, duration: TimeInterval) {
    let offset = keyboardOffset.isZero ? 40 : keyboardOffset + 15
    scrollView.contentInset.bottom = offset
  }
  
  private func configureScrollView() {
    addSubview(scrollView)
    scrollView.alwaysBounceVertical = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    scrollView.contentInset.bottom = 40
  }
  
  private func configureContainerView() {
    scrollView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalTo(self)
    }
  }
  
  private func configureImageView() {
    containerView.addSubview(imageView)
    imageView.image = Images.logo
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(30)
      make.centerX.equalToSuperview()
      make.height.lessThanOrEqualTo(120)
    }
  }
  
  private func configureTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.font = Fonts.medium32
    titleLabel.textColor = Colors.textColorDark
    titleLabel.textAlignment = .center
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom)
        .offset(30)
      make.left.right.equalToSuperview()
        .inset(16)
    }
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureEmailTextField() {
    containerView.addSubview(emailTextField)
    emailTextField.keyboardType = .emailAddress
    emailTextField.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
        .offset(150 * Constants.Screen.heightCoefficient)
      make.left.right.equalToSuperview()
        .inset(16)
      make.height.equalTo(56)
    }
  }
  
  private func configurePasswordTextField() {
    containerView.addSubview(passwordTextField)
    passwordTextField.snp.makeConstraints { make in
      make.top.equalTo(emailTextField.snp.bottom)
        .offset(40)
      make.left.right.equalToSuperview()
        .inset(16)
      make.height.equalTo(56)
    }
  }
  
  private func configureButtonsStackView() {
    containerView.addSubview(buttonsStackView)
    buttonsStackView.distribution = .fillEqually
    buttonsStackView.spacing = 10
    buttonsStackView.snp.makeConstraints { make in
      make.top.equalTo(passwordTextField.snp.bottom)
        .offset(40)
      make.left.right.equalToSuperview()
        .inset(16)
      make.height.equalTo(56)
      make.bottom.equalToSuperview()
    }
    buttonsStackView.addArrangedSubview(authButton)
    buttonsStackView.addArrangedSubview(registerButton)
  }
}
