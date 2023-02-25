//
//  AlertDisplayble.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

protocol AlertDisplayable: AnyObject {
  func showAlert(title: String?, completion: (() -> Void)?)
  func showAlert(title: String?, message: String?, completion: (() -> Void)?)
  func showAlert(title: String?,
                 message: String?,
                 image: UIImage?,
                 okButtonTitle: String?,
                 cancelButtonTitle: String?,
                 shouldAutomaticallyHide: Bool,
                 okHandler: (() -> Void)?,
                 cancelHandler: (() -> Void)?,
                 cancelButtonPosition: CancelButtonPosition,
                 completion: (() -> Void)?)
  func showInfo(title: String,
                message: String,
                cancelButtonTitle: String,
                cancelHandler: (() -> Void)?,
                completion: (() -> Void)?)
}

extension AlertDisplayable where Self: UIViewController {
  func showAlert(title: String?, completion: (() -> Void)? = nil) {
    showAlert(title: title, message: nil, completion: completion)
  }
  
  func showAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
    showAlert(title: title,
              message: message,
              image: nil,
              okButtonTitle: Localizator.standard.localizedString("OK"),
              cancelButtonTitle: nil,
              shouldAutomaticallyHide: true,
              okHandler: nil,
              cancelHandler: nil,
              cancelButtonPosition: .bottom,
              completion: completion)
  }
  
  func showAlert(title: String?,
                 message: String? = nil,
                 image: UIImage? = nil,
                 okButtonTitle: String? = nil,
                 cancelButtonTitle: String? = Localizator.standard.localizedString("OK"),
                 shouldAutomaticallyHide: Bool = true,
                 okHandler: (() -> Void)? = nil,
                 cancelHandler: (() -> Void)? = nil,
                 cancelButtonPosition: CancelButtonPosition = .bottom,
                 completion: (() -> Void)? = nil) {
    let blurAlertController = createAlertViewController(title: title,
                                                        message: message,
                                                        image: image,
                                                        okButtonTitle: okButtonTitle,
                                                        cancelButtonTitle: cancelButtonTitle,
                                                        shouldAutomaticallyHide: shouldAutomaticallyHide,
                                                        okHandler: okHandler,
                                                        cancelHandler: cancelHandler,
                                                        cancelButtonPosition: cancelButtonPosition)
    if let tabBarController = tabBarController {
      tabBarController.present(blurAlertController,
                               animated: false) {
        completion?()
      }
    } else {
      present(blurAlertController, animated: false) {
        completion?()
      }
    }
  }
  
  func showInfo(title: String,
                 message: String,
                 cancelButtonTitle: String,
                 cancelHandler: (() -> Void)? = nil,
                completion: (() -> Void)? = nil) {
    let blurAlertController = createInfoAlertViewController(title: title,
                                                            message: message,
                                                            cancelButtonTitle: cancelButtonTitle)
    if let tabBarController = tabBarController {
      tabBarController.present(blurAlertController,
                               animated: false) {
        completion?()
      }
    } else {
      present(blurAlertController, animated: false) {
        completion?()
      }
    }
  }
}

extension AlertDisplayable where Self: UINavigationController {
  func showAlert(title: String?, completion: (() -> Void)?) {
    showAlert(title: title, message: nil, completion: completion)
  }
  
  func showAlert(title: String?, message: String?, completion: (() -> Void)?) {
    showAlert(title: title,
              message: message,
              okButtonTitle: nil,
              cancelButtonTitle: Localizator.standard.localizedString("OK"),
              shouldAutomaticallyHide: true,
              okHandler: nil,
              cancelHandler: nil,
              cancelButtonPosition: .bottom,
              completion: completion)
  }
  
  func showAlert(title: String?,
                 message: String? = nil,
                 okButtonTitle: String?,
                 cancelButtonTitle: String?,
                 shouldAutomaticallyHide: Bool = true,
                 okHandler: (() -> Void)? = nil,
                 cancelHandler: (() -> Void)? = nil,
                 cancelButtonPosition: CancelButtonPosition,
                 completion: (() -> Void)?) {
    let blurAlertController = createAlertViewController(title: title,
                                                        message: message,
                                                        okButtonTitle: okButtonTitle,
                                                        cancelButtonTitle: cancelButtonTitle,
                                                        shouldAutomaticallyHide: shouldAutomaticallyHide,
                                                        okHandler: okHandler,
                                                        cancelHandler: cancelHandler,
                                                        cancelButtonPosition: cancelButtonPosition)
    if let tabBarController = tabBarController {
      tabBarController.present(blurAlertController,
                               animated: false) {
        completion?()
      }
    } else {
      present(blurAlertController, animated: false) {
        completion?()
      }
    }
  }
}

private func createAlertViewController(title: String?,
                                       message: String? = nil,
                                       image: UIImage? = nil,
                                       okButtonTitle: String? = nil,
                                       cancelButtonTitle: String? = nil,
                                       shouldAutomaticallyHide: Bool = true,
                                       okHandler: (() -> Void)? = nil,
                                       cancelHandler: (() -> Void)? = nil,
                                       cancelButtonPosition: CancelButtonPosition) -> AlertViewController {
  let contentView = BaseAlertView(cancelButtonPosition: cancelButtonPosition)
  if let image = image {
    contentView.configure(title: title ?? "",
                          description: message ?? "",
                          image: image,
                          buttonText: okButtonTitle,
                          cancelButtonText: cancelButtonTitle,
                          okHandler: okHandler,
                          cancelHandler: cancelHandler)
  } else {
    contentView.configure(title: title ?? "",
                          description: message ?? "",
                          buttonText: okButtonTitle,
                          cancelButtonText: cancelButtonTitle,
                          okHandler: okHandler,
                          cancelHandler: cancelHandler)
  }
  
  let alertViewController = AlertViewController(view: contentView)
  alertViewController.modalPresentationStyle = .overFullScreen
  return alertViewController
}

private func createInfoAlertViewController(title: String,
                                       message: String,
                                       cancelButtonTitle: String,
                                       cancelHandler: (() -> Void)? = nil) -> AlertViewController {
  let contentView = InfoAlertView()
  contentView.configure(title: title,
                        description: message,
                        cancelButtonText: cancelButtonTitle,
                        cancelHandler: cancelHandler)
  
  let alertViewController = AlertViewController(view: contentView)
  alertViewController.modalPresentationStyle = .overFullScreen
  return alertViewController
}

