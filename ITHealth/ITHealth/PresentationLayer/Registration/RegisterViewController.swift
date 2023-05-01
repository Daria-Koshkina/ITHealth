//
//  RegisterViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 25.02.2023.
//

import Foundation
import HealthKit
import UIKit
import SVProgressHUD

protocol RegisterViewControllerOutput: AnyObject {
  func wasRegistered(from: RegisterViewController)
}

class RegisterViewController: LocalizableViewController, ErrorAlertDisplayable, NavigationButtoned {
  
  // MARK: - Public variables
  weak var output: RegisterViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = RegisterView()
  private var sex: HKBiologicalSex?
  private var age: Int?
  private var bloodType: HKBloodType?
  private var selectedRole: Role?
  private let bloodTypes = HKBloodType.allCases
  private let roles = Role.allCases
  private let genders = Gender.allCases
  private var dateFormat: DateFormatter = {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format
  }()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    addObservers()
    localize()
    setup()
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    healthAuthIfNeeded()
  }
  
  override func localize() {
    super.localize()
    selfView.emailTextField.title = localizator.localizedString("registration.email")
    selfView.emailTextField.inputPlaceholder = localizator.localizedString("registration.email")
    selfView.passwordTextField.title = localizator.localizedString("registration.password")
    selfView.passwordTextField.inputPlaceholder = localizator.localizedString("registration.password")
    selfView.nickTextField.title = localizator.localizedString("registration.nick")
    selfView.nickTextField.inputPlaceholder = localizator.localizedString("registration.nick")
    selfView.nameTextField.title = localizator.localizedString("registration.name")
    selfView.nameTextField.inputPlaceholder = localizator.localizedString("registration.name")
    selfView.surnameTextField.title = localizator.localizedString("registration.surname")
    selfView.surnameTextField.inputPlaceholder = localizator.localizedString("registration.surname")
    selfView.birthdayTextField.title = localizator.localizedString("registration.birthday")
    selfView.birthdayTextField.inputPlaceholder = localizator.localizedString("registration.birthday")
    selfView.pressureTextField.title = localizator.localizedString("registration.pressure")
    selfView.pressureTextField.inputPlaceholder = localizator.localizedString("registration.pressure")
    selfView.workHoursTextField.title = localizator.localizedString("registration.hours")
    selfView.workHoursTextField.inputPlaceholder = localizator.localizedString("registration.hours")
    selfView.registerButton.setTitle(localizator.localizedString("registration.button"), for: .normal)
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(notification:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
  
  private func setup() {
    selfView.genderCollection.delegate = self
    selfView.genderCollection.dataSource = self
    selfView.bloodTypeCollection.delegate = self
    selfView.bloodTypeCollection.dataSource = self
    selfView.roleCollectionView.delegate = self
    selfView.roleCollectionView.dataSource = self
    selfView.roleLabel.isHidden = true
    selfView.bloodTypeCollection.register(LabelCollectionViewCell.self)
    selfView.genderCollection.register(LabelCollectionViewCell.self)
    selfView.roleCollectionView.register(LabelCollectionViewCell.self)
    [selfView.emailTextField, selfView.passwordTextField, selfView.nickTextField, selfView.nameTextField, selfView.surnameTextField, selfView.birthdayTextField, selfView.pressureTextField, selfView.workHoursTextField].forEach { $0.delegate = self }
    selfView.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    selfView.registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    selfView.bloodTypeCollection.reloadData()
    selfView.genderCollection.reloadData()
    selfView.roleCollectionView.reloadData()
    updateSexLabel()
    updateBloodTypeLabel()
  }
  
  private func loadHealthData() {
    do {
      let userAgeSexAndBloodType = try HealthService.shared.getAgeSexAndBloodType()
      age = userAgeSexAndBloodType.age
      sex = userAgeSexAndBloodType.biologicalSex
      bloodType = userAgeSexAndBloodType.bloodType
    } catch let error {
      print(error)
    }
  }
  
  private func healthAuthIfNeeded() {
    HealthService.shared.authorizeHealthKit { (authorized, error) in
      guard authorized else {
        let baseMessage = "HealthKit Authorization Failed"
        if let error = error {
          print("\(baseMessage). Reason: \(error.localizedDescription)")
        } else {
          print(baseMessage)
        }
        return
      }
      print("HealthKit Successfully Authorized.")
      self.loadHealthData()
    }
  }
  
  private func updateSexLabel() {
    HealthService.shared.authorizeHealthKit { (authorized, error) in
      DispatchQueue.main.async {
        guard authorized,
              let sex = self.sex else {
          self.selfView.genderLabel.isHidden = true
          self.selfView.genderCollection.isHidden = false
          return
        }
        self.selfView.genderLabel.isHidden = false
        self.selfView.genderCollection.isHidden = true
        switch sex {
        case .notSet,
            .other:
          self.selfView.genderLabel.isHidden = true
          self.selfView.genderCollection.isHidden = false
        case .female:
          self.selfView.genderLabel.text = Gender.female.title()
        case .male:
          self.selfView.genderLabel.text = Gender.male.title()
        @unknown default:
          self.selfView.genderLabel.isHidden = true
          self.selfView.genderCollection.isHidden = false
        }
      }
    }
  }
  
  private func updateBloodTypeLabel() {
    HealthService.shared.authorizeHealthKit { (authorized, error) in
      DispatchQueue.main.async {
        guard authorized,
              let bloodType = self.bloodType else {
          self.selfView.bloodTypeLabel.isHidden = true
          self.selfView.bloodTypeCollection.isHidden = false
          return
        }
        self.selfView.bloodTypeLabel.isHidden = false
        self.selfView.bloodTypeCollection.isHidden = true
        switch bloodType {
        case .notSet:
          self.selfView.bloodTypeLabel.isHidden = true
          self.selfView.bloodTypeCollection.isHidden = false
        case .aPositive,
            .aNegative,
            .bPositive,
            .bNegative,
            .abPositive,
            .abNegative,
            .oPositive,
            .oNegative:
          self.selfView.bloodTypeLabel.text = bloodType.title()
        @unknown default:
          self.selfView.bloodTypeLabel.isHidden = true
          self.selfView.bloodTypeCollection.isHidden = false
        }
      }
    }
  }
  
  private func isAllDataValid() -> Bool {
    let emailIsValid = Validator.isValidString(selfView.emailTextField.text, ofType: .email)
    if !emailIsValid {
      selfView.emailTextField.hasError = true
    }
    let passwordIsValid = Validator.isValidString(selfView.passwordTextField.text, ofType: .password)
    if !passwordIsValid {
      selfView.passwordTextField.hasError = true
    }
    let nameIsValid = Validator.isValidString(selfView.nameTextField.text, ofType: .name)
    if !nameIsValid {
      selfView.nameTextField.hasError = true
    }
    let surnameIsValid = Validator.isValidString(selfView.surnameTextField.text, ofType: .name)
    if !surnameIsValid {
      selfView.surnameTextField.hasError = true
    }
    let nickIsValid = Validator.isValidString(selfView.nickTextField.text, ofType: .name)
    if !nickIsValid {
      selfView.nickTextField.hasError = true
    }
    let birthdayIsValid = !selfView.birthdayTextField.text.isNilOrEmpty
    if !birthdayIsValid {
      selfView.birthdayTextField.hasError = true
    }
    let pressureIsValid = Validator.isValidString(selfView.pressureTextField.text, ofType: .pressure)
    if !pressureIsValid {
      selfView.pressureTextField.hasError = true
    }
    let hoursIsValid = Validator.isValidString(selfView.workHoursTextField.text, ofType: .hours)
    if !hoursIsValid {
      selfView.workHoursTextField.hasError = true
    }
    return emailIsValid && passwordIsValid && nameIsValid && surnameIsValid && nickIsValid && birthdayIsValid && pressureIsValid && hoursIsValid
  }
  
  private func updateContinueButton() {
    guard !selfView.emailTextField.text.isNilOrEmpty,
          !selfView.passwordTextField.text.isNilOrEmpty,
          !selfView.nickTextField.text.isNilOrEmpty,
          !selfView.nameTextField.text.isNilOrEmpty,
          !selfView.surnameTextField.text.isNilOrEmpty,
          !selfView.birthdayTextField.text.isNilOrEmpty,
          !selfView.pressureTextField.text.isNilOrEmpty,
          !selfView.workHoursTextField.text.isNilOrEmpty,
          selectedRole != nil,
          Gender(sex: sex) != nil,
          bloodType != nil else {
      selfView.registerButton.isEnabled = false
      return
    }
    selfView.registerButton.isEnabled = true
  }
  
  @objc
  private func didTapRegister() {
    guard isAllDataValid(),
          let email = selfView.emailTextField.text,
          let password = selfView.passwordTextField.text,
          let nick = selfView.nickTextField.text,
          let name = selfView.nameTextField.text,
          let surname = selfView.surnameTextField.text,
          let birthday = selfView.birthdayTextField.text,
          let pressure = Double(selfView.pressureTextField.text ?? ""),
          let hours = Int(selfView.workHoursTextField.text ?? ""),
          let role = selectedRole,
          let gender = Gender(sex: sex),
          let bloodType = bloodType else {
      return
    }
    SVProgressHUD.show()
    ProfileService.shared.register(email: email, password: password, nick: nick, role: role, fullName: name + " " + surname, birthday: birthday, gender: gender, bloodType: bloodType, averagePressure: pressure, workHoursCount: hours) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .success:
          self.output?.wasRegistered(from: self)
        case .failure(let error):
          self.handleError(error)
        }
      }
    }
  }
  
  @objc
  private func datePickerValueChanged(_ sender: UIDatePicker) {
    let selectedDate = sender.date
    selfView.birthdayTextField.text = dateFormat.string(from: selectedDate)
    updateContinueButton()
  }
  
  // MARK: - Keyboard
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard let kbSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    guard let kbDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
    animateToBottomOffset(kbSizeValue.cgRectValue.height,
                          duration: kbDuration.doubleValue)
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    animateToBottomOffset(0, duration: 0)
  }
  
  private func animateToBottomOffset(_ offset: CGFloat, duration: Double) {
    selfView.updateBottomConstraint(offset: offset,
                                    duration: duration)
  }
}

// MARK: - UICollectionViewDelegate
extension RegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if selfView.roleCollectionView == collectionView {
      return Role.allCases.count
    } else if selfView.genderCollection == collectionView {
      return Gender.allCases.count
    } else if selfView.bloodTypeCollection == collectionView {
      return HKBloodType.allCases.count
    } else {
      return .zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: LabelCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
    if selfView.roleCollectionView == collectionView {
      cell.configure(text: roles[indexPath.item].rawValue, isSelected: roles[indexPath.item] == selectedRole)
    } else if selfView.genderCollection == collectionView {
      cell.configure(text: genders[indexPath.item].title(), isSelected: genders[indexPath.item].isEqual(to: sex))
    } else if selfView.bloodTypeCollection == collectionView {
      cell.configure(text: bloodTypes[indexPath.item].title() ?? "", isSelected: bloodTypes[indexPath.item] == bloodType)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if selfView.roleCollectionView == collectionView {
      selectedRole = roles[indexPath.item]
    } else if selfView.genderCollection == collectionView {
      switch genders[indexPath.item] {
      case .male:
        sex = .male
      case .female:
        sex = .female
      }
    } else if selfView.bloodTypeCollection == collectionView {
      bloodType = bloodTypes[indexPath.item]
    }
    collectionView.reloadData()
    updateContinueButton()
  }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let newString = ((textField.text ?? "") as NSString?)?
      .replacingCharacters(in: range,
                           with: string) else { return false }
    let isNewStringValid: Bool
    if textField == selfView.emailTextField {
      let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        .removingCharacters(from: Validator.allowedCharacterSet(for: .email).inverted)
      isNewStringValid = Validator.maxSymbolsCount(for: .email) >= trimmedString.count
      if isNewStringValid {
        textField.setTextWithSavingCursorPosition(trimmedString)
        selfView.emailTextField.hasError = false
      }
    } else if textField == selfView.nameTextField {
      let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        .removingCharacters(from: Validator.allowedCharacterSet(for: .name).inverted)
      isNewStringValid = Validator.maxSymbolsCount(for: .name) >= trimmedString.count
      if isNewStringValid {
        textField.setTextWithSavingCursorPosition(trimmedString)
        selfView.nameTextField.hasError = false
      }
    } else if textField == selfView.surnameTextField {
      let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        .removingCharacters(from: Validator.allowedCharacterSet(for: .name).inverted)
      isNewStringValid = Validator.maxSymbolsCount(for: .name) >= trimmedString.count
      if isNewStringValid {
        textField.setTextWithSavingCursorPosition(trimmedString)
        selfView.surnameTextField.hasError = false
      }
    } else if textField == selfView.passwordTextField {
      let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        .removingCharacters(from: Validator.allowedCharacterSet(for: .password).inverted)
      isNewStringValid = Validator.maxSymbolsCount(for: .password) >= trimmedString.count
      if isNewStringValid {
        textField.setTextWithSavingCursorPosition(trimmedString)
        selfView.passwordTextField.hasError = false
      }
    } else if textField == selfView.nickTextField {
      let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        .removingCharacters(from: Validator.allowedCharacterSet(for: .name).inverted)
      isNewStringValid = Validator.maxSymbolsCount(for: .name) >= trimmedString.count
      if isNewStringValid {
        textField.setTextWithSavingCursorPosition(trimmedString)
        selfView.nickTextField.hasError = false
      }
    } else if textField == selfView.pressureTextField {
      let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        .removingCharacters(from: Validator.allowedCharacterSet(for: .pressure).inverted)
      isNewStringValid = Validator.maxSymbolsCount(for: .pressure) >= trimmedString.count
      if isNewStringValid {
        textField.setTextWithSavingCursorPosition(trimmedString)
        selfView.pressureTextField.hasError = false
      }
    } else if textField == selfView.workHoursTextField {
      let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        .removingCharacters(from: Validator.allowedCharacterSet(for: .hours).inverted)
      isNewStringValid = Validator.maxSymbolsCount(for: .hours) >= trimmedString.count
      if isNewStringValid {
        textField.setTextWithSavingCursorPosition(trimmedString)
        selfView.workHoursTextField.hasError = false
      }
    }
    updateContinueButton()
    return false
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    defer {
      textField.resignFirstResponder()
    }
    return true
  }
}

extension HKBloodType: CaseIterable {
  public static let allCases: [HKBloodType] = [.aNegative, .aPositive, .bPositive, .bNegative, .abPositive, .abNegative, .oPositive, .oNegative]
  
  func title() -> String? {
    switch self {
    case .notSet:
      return nil
    case .aPositive:
      return "II Positive"
    case .aNegative:
      return "II Negative"
    case .bPositive:
      return "III Positive"
    case .bNegative:
      return "III Negative"
    case .abPositive:
      return "IV Positive"
    case .abNegative:
      return "IV Negative"
    case .oPositive:
      return "I Positive"
    case .oNegative:
      return "I Negative"
    @unknown default:
      return nil
    }
  }
}
