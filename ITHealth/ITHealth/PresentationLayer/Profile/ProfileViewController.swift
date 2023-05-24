//
//  ProfileViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 01.05.2023.
//

import Foundation
import HealthKit
import UIKit
import SVProgressHUD

protocol ProfileViewControllerOutput: AnyObject {
  func back(from: ProfileViewController)
}

class ProfileViewController: LocalizableViewController, ErrorAlertDisplayable, NavigationButtoned {
  
  // MARK: - Public variables
  weak var output: ProfileViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = RegisterView()
  private var sex: HKBiologicalSex?
  private var age: Int?
  private var bloodType: HKBloodType?
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureNavBar()
    addObservers()
    localize()
    setup()
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func localize() {
    super.localize()
    navigationItem.title = localizator.localizedString("registration.navbar")
    selfView.emailTextField.title = localizator.localizedString("registration.email")
    selfView.emailTextField.inputPlaceholder = localizator.localizedString("registration.email")
    selfView.passwordTextField.title = localizator.localizedString("registration.password")
    selfView.passwordTextField.inputPlaceholder = localizator.localizedString("registration.password")
    selfView.nameTextField.title = localizator.localizedString("registration.name")
    selfView.nameTextField.inputPlaceholder = localizator.localizedString("registration.name")
    selfView.surnameTextField.title = localizator.localizedString("registration.surname")
    selfView.surnameTextField.inputPlaceholder = localizator.localizedString("registration.surname")
    selfView.pressureTextField.title = localizator.localizedString("registration.pressure")
    selfView.pressureTextField.inputPlaceholder = localizator.localizedString("registration.pressure")
    selfView.workHoursTextField.title = localizator.localizedString("registration.hours")
    selfView.workHoursTextField.inputPlaceholder = localizator.localizedString("registration.hours")
    selfView.registerButton.setTitle(localizator.localizedString("profile.button.save"), for: .normal)
  }
  
  private func configureNavBar() {
    setNavigationButton(#selector(didTapBack), button: ButtonsFactory.getNavigationBarBackButton(), side: .left)
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
    selfView.hideKeyboardWhenTappedAround(cancelsTouchesInView: true)
    selfView.passwordTextField.isHidden = true
    [selfView.emailTextField, selfView.nameTextField, selfView.surnameTextField, selfView.pressureTextField, selfView.workHoursTextField].forEach { $0.delegate = self }
    selfView.registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    if let user = ProfileService.shared.user {
      sex = HKBiologicalSex(gender: user.gender)
      bloodType = user.bloodType
      selfView.emailTextField.text = user.email
      let credantials = user.fullName.split(separator: " ")
      selfView.nameTextField.text = String(credantials.first ?? "")
      selfView.surnameTextField.text = String(credantials.last ?? "")
      selfView.pressureTextField.text = "\(Int(user.averagePressure))"
      selfView.workHoursTextField.text = "\(user.workHoursCount)"
    }
    updateSexLabel()
    updateBloodTypeLabel()
    updateContinueButton()
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
    let nameIsValid = Validator.isValidString(selfView.nameTextField.text, ofType: .name)
    if !nameIsValid {
      selfView.nameTextField.hasError = true
    }
    let surnameIsValid = Validator.isValidString(selfView.surnameTextField.text, ofType: .name)
    if !surnameIsValid {
      selfView.surnameTextField.hasError = true
    }
    let pressureIsValid = Validator.isValidString(selfView.pressureTextField.text, ofType: .pressure)
    if !pressureIsValid {
      selfView.pressureTextField.hasError = true
    }
    let hoursIsValid = Validator.isValidString(selfView.workHoursTextField.text, ofType: .hours)
    if !hoursIsValid {
      selfView.workHoursTextField.hasError = true
    }
    return emailIsValid && nameIsValid && surnameIsValid && pressureIsValid && hoursIsValid
  }
  
  private func isDataChanged() -> Bool {
    guard let user = ProfileService.shared.user else { return false }
    let credantials = user.fullName.split(separator: " ").map { String($0) }
    return selfView.emailTextField.text != user.email ||
    selfView.nameTextField.text != credantials.first ||
    selfView.surnameTextField.text != credantials.last ||
    selfView.pressureTextField.text != "\(Int(user.averagePressure))" ||
    selfView.workHoursTextField.text != "\(user.workHoursCount)"
  }
  
  private func updateContinueButton() {
    guard isDataChanged(),
          !selfView.emailTextField.text.isNilOrEmpty,
          !selfView.nameTextField.text.isNilOrEmpty,
          !selfView.surnameTextField.text.isNilOrEmpty,
          !selfView.pressureTextField.text.isNilOrEmpty,
          !selfView.workHoursTextField.text.isNilOrEmpty else {
      selfView.registerButton.isEnabled = false
      return
    }
    selfView.registerButton.isEnabled = true
  }
  
  private func showSuccsessAlert() {
    showInfo(title: localizator.localizedString("profile.success_update"),
             message: "", cancelButtonTitle: localizator.localizedString("profile.success_update.ok"),
             cancelHandler: { self.output?.back(from: self) })
  }
  
  @objc
  private func didTapRegister() {
    guard isAllDataValid(),
          let email = selfView.emailTextField.text,
          let name = selfView.nameTextField.text,
          let surname = selfView.surnameTextField.text,
          let pressure = Double(selfView.pressureTextField.text ?? ""),
          let hours = Int(selfView.workHoursTextField.text ?? ""),
          let sex = Gender(sex: sex),
          let bloodType = bloodType else {
      return
    }
    SVProgressHUD.show()
    ProfileService.shared.update(email: email, fullName: name + " " + surname, gender: sex, bloodType: bloodType, averagePressure: pressure, workHoursCount: hours) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .success:
          self.showSuccsessAlert()
        case .failure(let error):
          self.handleError(error)
        }
      }
    }
  }
  
  @objc
  private func didTapBack() {
    output?.back(from: self)
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

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
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

extension HKBiologicalSex {
  init?(gender: Gender) {
    switch gender {
    case .male:
      self = .male
    case .female:
      self = .female
    }
  }
}
