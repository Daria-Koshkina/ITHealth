//
//  BaseNavigationViewController.swift
//  RoomvoDev
//
//  Created by Dasha Koshkina on 31.05.2022.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.portrait
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return UIInterfaceOrientation.portrait
  }
  
  override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
    super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    modalPresentationStyle = .fullScreen
    self.view.backgroundColor = .white
  }
  
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    modalPresentationStyle = .fullScreen
    self.view.backgroundColor = .white
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    modalPresentationStyle = .fullScreen
    self.view.backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    modalPresentationStyle = .fullScreen
    self.view.backgroundColor = .white
  }
}
