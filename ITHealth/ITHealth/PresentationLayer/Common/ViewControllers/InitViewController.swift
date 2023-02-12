//
//  InitViewController.swift
//  RoomvoDev
//
//  Created by Dasha Koshkina on 31.05.2022.
//

import UIKit

class InitViewController: UIViewController {
  
  // MARK: - Life cycle
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    commonConfigure()
    initConfigure()
  }
  
  // MARK: - Init configure
  func initConfigure() {}
  
  // MARK: - Common configure
  private func commonConfigure() {
    modalPresentationStyle = .fullScreen
    if #available(iOS 14, *) {
      navigationItem.backButtonDisplayMode = .minimal
    } else {
      navigationItem.backButtonTitle = ""
    }
  }
}
