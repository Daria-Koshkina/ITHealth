//
//  MainNavigationController.swift
//  RoomvoDev
//
//  Created by Dasha Koshkina on 31.05.2022.
//

import UIKit

enum ColorStyle {
  case white(withLine: Bool)
}

class MainNavigationController: SwipableNavigationController {
  
  // MARK: - Life cycle
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    setupSelfConfiguration()
    modalPresentationStyle = .fullScreen
  }
  
  init(rootViewController: UIViewController, style: ColorStyle = .white(withLine: false)) {
    super.init(rootViewController: rootViewController)
    setupSelfConfiguration(with: style)
    modalPresentationStyle = .fullScreen
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupSelfConfiguration()
    modalPresentationStyle = .fullScreen
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setupSelfConfiguration()
    modalPresentationStyle = .fullScreen
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
    setupSelfConfiguration()
    modalPresentationStyle = .fullScreen
  }
  
  // MARK: - Configure
  func setupSelfConfiguration(with style: ColorStyle = .white(withLine: false)) {
    navigationBar.barStyle = UIBarStyle.default
    navigationBar.tintColor = UIColor.black
    switch style {
    case .white(let withLine):
      if #available(iOS 13.0, *) {
        navigationBar.standardAppearance.backgroundColor = .white
        navigationBar.compactAppearance = navigationBar.standardAppearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        navigationBar.barTintColor = nil
        navigationBar.shadowImage = nil
      } else {
        view.backgroundColor = .white
      }
      navigationBar.backgroundColor = .white
      navigationBar.barTintColor = .red
      UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
      navigationBar.shadowImage = withLine ? nil : UIImage()
        navigationBar.standardAppearance.shadowColor =
        withLine ?
        UIColor.darkGray.withAlphaComponent(0.5) :
        .white
      navigationBar.layoutIfNeeded()
    }
    
    if navigationBar.titleTextAttributes == nil {
      navigationBar.titleTextAttributes = [:]
    }
    navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] =
    UIConstants.foregroundColor
    navigationBar.largeTitleTextAttributes?[NSAttributedString.Key.backgroundColor] =
    UIConstants.backgroundColor
    edgesForExtendedLayout = []
  }
}

// MARK: - UIConstants
private enum UIConstants {
  static let foregroundColor = UIColor.darkGray
  static let backgroundColor = UIColor.white
}
