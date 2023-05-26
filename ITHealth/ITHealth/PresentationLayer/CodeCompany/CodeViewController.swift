//
//  CodeViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 17.05.2023.
//

import Foundation
import UIKit
import SVProgressHUD

protocol CodeViewControllerOutput: AnyObject {
  func codeWasEntered(from: CodeViewController)
}

class CodeViewController: LocalizableViewController, ErrorAlertDisplayable, NavigationButtoned {
  
  weak var output: CodeViewControllerOutput?
  
  private let selfView = ChangePasswordView()
  
  override func loadView() {
    view = selfView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.hidesBackButton = true
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
    navigationItem.title = localizator.localizedString("company_code.navbar")
    selfView.passwordTextField.title = localizator.localizedString("company_code.textfield.title")
    selfView.passwordTextField.inputPlaceholder = localizator.localizedString("company_code.textfield.placeholder")
    selfView.button.setTitle(localizator.localizedString("company_code.button"), for: .normal)
  }
  
  private func updateContinueButton() {
    selfView.button.isEnabled = !selfView.passwordTextField.text.isNilOrEmpty
  }
  
  @objc
  private func didTapButton() {
    guard let password = selfView.passwordTextField.text else { return }
    SVProgressHUD.show()
    ProfileService.shared.addToCompany(code: password) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success:
          self.output?.codeWasEntered(from: self)
        }
      }
    }
  }
}

extension CodeViewController: InputViewDelegate, UITextFieldDelegate {
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
