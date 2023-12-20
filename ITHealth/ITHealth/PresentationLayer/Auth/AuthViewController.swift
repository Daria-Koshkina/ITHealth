//
//  AuthViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit
import SVProgressHUD

protocol AuthViewControllerOutput: AnyObject {
  func wasAuthorized(from: AuthViewController)
  func register(from: AuthViewController)
}

class AuthViewController: LocalizableViewController, ErrorAlertDisplayable {
  
  // MARK: - Public variables
  weak var output: AuthViewControllerOutput?
  
  // MARK: - Private variables
  private let selfView = AuthView()
  
  private var passwordIsShown = false
  private var password: String?
  private var email: String?
  private let passwordSign = "*"
  
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
    (navigationController as? MainNavigationController)?.setupSelfConfiguration()
    healthAuthIfNeeded()
  }
  
  override func localize() {
    super.localize()
    selfView.titleLabel.text = localizator.localizedString("auth.title")
    selfView.emailTextField.title = localizator.localizedString("auth.email.title")
    selfView.emailTextField.inputPlaceholder = localizator.localizedString("auth.email.placeholder")
    selfView.passwordTextField.title = localizator.localizedString("auth.email.password")
    selfView.passwordTextField.inputPlaceholder = localizator.localizedString("auth.email.password")
    selfView.passwordTextField.rightTitle = localizator.localizedString("auth.email.password.forgot")
    selfView.authButton.setTitle(localizator.localizedString("auth.auth_button.title"), for: .normal)
    selfView.registerButton.setTitle(localizator.localizedString("auth.register_button.title"), for: .normal)
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
    }
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
    hideKeyboardWhenTappedAround()
    selfView.emailTextField.inputViewDelegate = self
    selfView.passwordTextField.inputViewDelegate = self
    selfView.authButton.addTarget(self, action: #selector(didTapAuth), for: .touchUpInside)
    selfView.registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    updatePasswordStyleIfNeeded()
  }
  
  private func isAllDataValid() -> Bool {
    let emailIsValid = Validator.isValidString(selfView.emailTextField.text, ofType: .email)
    if !emailIsValid {
      selfView.emailTextField.hasError = true
    }
    let passwordIsValid = Validator.isValidString(password, ofType: .password)
    if !passwordIsValid {
      selfView.passwordTextField.hasError = true
    }
    return emailIsValid && passwordIsValid
  }
  
  @objc
  private func didTapAuth() {
    guard isAllDataValid(),
          let email = selfView.emailTextField.text,
          let password = password else { return }
    SVProgressHUD.show()
    ProfileService.shared.auth(email: email, password: password) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .success:
          self.output?.wasAuthorized(from: self)
        case .failure(let error):
          self.handleError(error)
        }
      }
    }
  }
  
  @objc
  private func didTapRegister() {
    output?.register(from: self)
  }
  
  // MARK: - Keyboard
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard let kbSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    guard let kbDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
    selfView.updateBottomOffset(kbSizeValue.cgRectValue.height, duration: TimeInterval(truncating: kbDuration))
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    selfView.updateBottomOffset(0, duration: 0)
  }
}

// MARK: - InputViewDelegate
extension AuthViewController: InputViewDelegate {
  func rightViewWasTapped(in textField: UITextField) {
    guard !textField.text.isNilOrEmpty else { return }
    passwordIsShown.toggle()
    updatePasswordStyleIfNeeded()
  }
  
  func rightLabelWasTapped(in textField: UITextField) {
    if textField == selfView.passwordTextField,
    let url = URL(string: "https://ithealth.azurewebsites.net/reset") {
      UIApplication.shared.openURL(url)
    }
  } 
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldString: String = (textField == selfView.passwordTextField ? password : textField.text) ?? ""
    guard let newString = (oldString as NSString?)?
      .replacingCharacters(in: range,
                           with: string) else { return false }
    shouldChangeCharacters(textField, newString: newString)
    return false
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    defer {
      if textField == selfView.emailTextField {
        selfView.passwordTextField.becomeFirstResponder()
      } else {
        textField.resignFirstResponder()
      }
    }
    return true
  }
  
  private func shouldChangeCharacters(_ textField: UITextField, newString: String) {
    let isNewStringValid: Bool
    if textField == selfView.emailTextField {
      let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        .removingCharacters(from: Validator.allowedCharacterSet(for: .email).inverted)
      isNewStringValid = Validator.maxSymbolsCount(for: .email) >= trimmedString.count
      if isNewStringValid {
        email = trimmedString
        textField.setTextWithSavingCursorPosition(trimmedString)
        selfView.emailTextField.hasError = false
      }
    } else if textField == selfView.passwordTextField {
      var charSet: CharacterSet = Validator.allowedCharacterSet(for: .password)
      charSet.insert(charactersIn: passwordSign)
      let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        .removingCharacters(from: charSet.inverted)
      isNewStringValid = Validator.maxSymbolsCount(for: .password) >= trimmedString.count
      if isNewStringValid {
        password = trimmedString
        updatePasswordStyleIfNeeded()
        selfView.passwordTextField.hasError = false
      }
    } else {
      isNewStringValid = false
    }
  }
  
  private func updatePasswordStyleIfNeeded() {
    if passwordIsShown {
      selfView.passwordTextField.setTextWithSavingCursorPosition(password)
    } else {
      let secretString = String(repeating: passwordSign, count: password?.count ?? .zero)
      selfView.passwordTextField.setTextWithSavingCursorPosition(secretString)
    }
    if (selfView.passwordTextField.text ?? "").isEmpty {
      selfView.passwordTextField.setRightImage(Images.eye)
    } else {
      let image = passwordIsShown ? Images.strikethroughEye : Images.whiteEye
      selfView.passwordTextField.setRightImage(image)
    }
  }
}
