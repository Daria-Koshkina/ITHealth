//
//  RegisterView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 25.02.2023.
//

import UIKit

class RegisterView: InitView {
  
  private let scrollView = UIScrollView()
  private let containerView = InitView()
  private let stackView = UIStackView()
  let emailTextField = InputView()
  let passwordTextField = InputView()
  let nickTextField = InputView()
  let nameTextField = InputView()
  let surnameTextField = InputView()
  let birthdayTextField = InputView()
  let pressureTextField = InputView()
  let workHoursTextField = InputView()
  let roleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
  let genderCollection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
  let bloodTypeCollection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
  let genderLabel = UILabel()
  let bloodTypeLabel = UILabel()
  let registerButton = PrimaryButton()
  let datePicker = UIDatePicker()
  
  override func initConfigure() {
    super.initConfigure()
    configureScrollView()
    configureContainerView()
    configureStackView()
    configureTextFields()
    configureRoleCollectionView()
    configureGenderLabel()
    configureBloodTypeLabel()
    configureRegisterButton()
  }
  
  func updateBottomConstraint(offset: CGFloat, duration: TimeInterval) {
    UIView.animate(withDuration: duration, delay: 0, animations: {
      self.scrollView.contentInset.bottom = offset
    })
  }
  
  private func configureScrollView() {
    addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(safeAreaLayoutGuide)
    }
    scrollView.showsVerticalScrollIndicator = false
  }
  
  private func configureContainerView() {
    scrollView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalTo(self)
    }
  }
  
  private func configureStackView() {
    containerView.addSubview(stackView)
    stackView.distribution = .fillProportionally
    stackView.axis = .vertical
    stackView.spacing = 30
    stackView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
        .inset(16)
      make.top.equalToSuperview()
        .offset(20)
      make.bottom.equalToSuperview()
    }
    stackView.addArrangedSubview(emailTextField)
    stackView.addArrangedSubview(passwordTextField)
    stackView.addArrangedSubview(nickTextField)
    stackView.addArrangedSubview(nameTextField)
    stackView.addArrangedSubview(surnameTextField)
    stackView.addArrangedSubview(birthdayTextField)
    stackView.addArrangedSubview(pressureTextField)
    stackView.addArrangedSubview(workHoursTextField)
    stackView.addArrangedSubview(roleCollectionView)
    stackView.addArrangedSubview(genderLabel)
    stackView.addArrangedSubview(genderCollection)
    stackView.addArrangedSubview(bloodTypeLabel)
    stackView.addArrangedSubview(bloodTypeCollection)
    stackView.addArrangedSubview(registerButton)
  }
  
  private func configureTextFields() {
    [emailTextField, passwordTextField, nickTextField, nameTextField, surnameTextField, birthdayTextField, pressureTextField, workHoursTextField].forEach { view in
      view.snp.makeConstraints { make in
        make.height.equalTo(56)
      }
    }
    birthdayTextField.inputView = datePicker
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .wheels
  }
  
  private func configureRoleCollectionView() {
    roleCollectionView.backgroundColor = .white
    roleCollectionView.snp.makeConstraints { make in
      make.height.equalTo(56)
    }
    bloodTypeCollection.backgroundColor = .white
    bloodTypeCollection.snp.makeConstraints { make in
      make.height.equalTo(56)
    }
    genderCollection.backgroundColor = .white
    genderCollection.snp.makeConstraints { make in
      make.height.equalTo(56)
    }
  }
  
  private func configureGenderLabel() {
    genderLabel.font = Fonts.semibold16
    genderLabel.textColor = Colors.blueDark
    genderLabel.snp.makeConstraints { make in
      make.height.equalTo(40)
    }
  }
  
  private func configureBloodTypeLabel() {
    bloodTypeLabel.font = Fonts.semibold16
    bloodTypeLabel.textColor = Colors.blueDark
    bloodTypeLabel.snp.makeConstraints { make in
      make.height.equalTo(40)
    }
  }
  
  private func configureRegisterButton() {
    registerButton.snp.makeConstraints { make in
      make.height.equalTo(56)
    }
  }
}

private func createLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 10
    layout.scrollDirection = .horizontal
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    return layout
}
