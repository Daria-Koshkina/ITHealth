//
//  LocalizebleViewController.swift
//  RoomvoDev
//
//  Created by Dasha Koshkina on 31.05.2022.
//

import Foundation

class LocalizableViewController: InitViewController {
  
  var localizator = Localizator.standard
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLocalization()
  }
  
  // MARK: - Private
  private func setupLocalization() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(localize),
      name: Notification.Name.LokaliseDidUpdateLocalization,
      object: nil)
  }
  
  // MARK: - Localization
  @objc
  func localize() { }
}
