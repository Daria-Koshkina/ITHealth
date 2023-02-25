//
//  ErrorAlertDisplayable.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

protocol ErrorHandlable: AnyObject {
  func handleError(_ error: Error, completion: (() -> Void)?)
}

protocol ErrorAlertDisplayable: ErrorHandlable, AlertDisplayable { }

extension ErrorAlertDisplayable {
  func handleErrors(_ errors: [Error], completion: (() -> Void)? = nil) {
    if errors.count > 1 {
      handleError(ServerError.unknown, completion: completion)
    } else {
      guard let error = errors.first else { return }
      handleError(error, completion: completion)
    }
  }
  
  func handleError(_ error: Error, completion: (() -> Void)? = nil) {
    if let serverError = error as? ServerError {
      switch serverError.type {
      case .noInternetConnection,
          .webViewNoInternet:
        showNoInternetErrorAlert(serverError, completion: completion)
      case .unknown:
        showAlert(title: serverError.title,
                  message: serverError.description,
                  completion: completion)
      case .unauthorized:
        showUnathorizedErrorAlert(ServerError.unauthorized, completion: completion)
      case .accessDenied,
          .notFound:
        showAlert(title: ServerError.unknown.title,
                  message: serverError.description,
                  completion: completion)
      }
    } else {
      showAlert(title: ServerError.unknown.title,
                message: error.localizedDescription,
                completion: completion)
    }
  }
  
  @discardableResult
  func checkAuthorized(_ error: Error?) -> Bool {
    guard let error = error as? ServerError else { return true }
    switch error.type {
    case .unauthorized:
      ProfileService.shared.logout()
    case .noInternetConnection,
        .webViewNoInternet,
        .unknown,
        .accessDenied,
        .notFound:
      break
    }
    return error.type != .unauthorized
  }
  
  // MARK: - Private
  private func showNoInternetErrorAlert(_ error: ServerError, completion: (() -> Void)?) {
    showAlert(title: error.title,
              message: error.description,
              image: UIImage(),
              okButtonTitle: Localizator.standard.localizedString("OK"),
              cancelButtonTitle: nil,
              shouldAutomaticallyHide: true,
              okHandler: nil,
              cancelHandler: nil,
              cancelButtonPosition: .bottom,
              completion: completion)
  }
  
  private func showUnathorizedErrorAlert(_ error: ServerError, completion: (() -> Void)?) {
    showAlert(title: error.title,
              message: error.description,
              image: nil,
              okButtonTitle: Localizator.standard.localizedString("OK"),
              cancelButtonTitle: nil,
              shouldAutomaticallyHide: true,
              okHandler: { ProfileService.shared.logout() },
              cancelHandler: { ProfileService.shared.logout() },
              cancelButtonPosition: .bottom,
              completion: completion)
  }
}
