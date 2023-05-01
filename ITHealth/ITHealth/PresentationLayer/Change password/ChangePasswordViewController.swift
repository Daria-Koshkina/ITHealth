//
//  ChangePasswordViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 01.05.2023.
//

import Foundation
import UIKit
import SVProgressHUD

protocol ChangePasswordViewControllerOutput: AnyObject {
  func back(from: ChangePasswordViewController)
}

class ChangePasswordViewController: LocalizableViewController, ErrorAlertDisplayable {
  
  weak var output: ChangePasswordViewControllerOutput?
  
  private let selfView = ChangePasswordView()
  
  override func loadView() {
    view = selfView
  }
  
  override func initConfigure() {
    super.initConfigure()
    localize()
    selfView.passwordTextField.inputViewDelegate = self
    selfView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    updateContinueButton()
  }
  
  override func localize() {
    super.localize()
    navigationItem.title = localizator.localizedString("change_password.navbar")
    selfView.passwordTextField.title = localizator.localizedString("change_password.textfield.title")
    selfView.passwordTextField.inputPlaceholder = localizator.localizedString("change_password.textfield.placeholder")
    selfView.button.setTitle(localizator.localizedString("change_password.button"), for: .normal)
  }
  
  private func updateContinueButton() {
    selfView.button.isEnabled = !selfView.passwordTextField.text.isNilOrEmpty
  }
  
  private func showAlert() {
    showInfo(title: localizator.localizedString("change_password.success"), message: "", cancelButtonTitle: localizator.localizedString("change_password.success.button"), cancelHandler: { self.output?.back(from: self) })
  }
  
  @objc
  private func didTapButton() {
    let passwordIsValid = Validator.isValidString(selfView.passwordTextField.text, ofType: .password)
    if !passwordIsValid {
      selfView.passwordTextField.hasError = true
      updateContinueButton()
    }
    guard let password = selfView.passwordTextField.text,
          passwordIsValid else { return }
    SVProgressHUD.show()
    ProfileService.shared.changePassword(password: password) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success:
          self.showAlert()
        }
      }
    }
  }
}

extension ChangePasswordViewController: InputViewDelegate, UITextFieldDelegate {
  func rightViewWasTapped(in textField: UITextField) {
    
  }
  
  func rightLabelWasTapped(in textField: UITextField) {
    
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let newString = ((textField.text ?? "") as NSString?)?
      .replacingCharacters(in: range,
                           with: string) else { return false }
    let trimmedString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
      .removingCharacters(from: Validator.allowedCharacterSet(for: .password).inverted)
    let isNewStringValid = Validator.maxSymbolsCount(for: .password) >= trimmedString.count
    if isNewStringValid {
      textField.setTextWithSavingCursorPosition(trimmedString)
      selfView.passwordTextField.hasError = false
    }
    updateContinueButton()
    return false
  }
}
