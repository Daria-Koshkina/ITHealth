//
//  ColoredTabBarController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import UIKit
import ESTabBarController_swift

class ColoredTabBarController: ESTabBarController {
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.barTintColor = UIColor.white
    tabBar.isTranslucent = false
    configureBackgroundColor()
  }
  
  // MARK: - Private methods
  private func configureBackgroundColor() {
    let colorView = UIView()
    colorView.backgroundColor = UIColor.white
    tabBar.isTranslucent = false
    tabBar.addSubview(colorView)
    colorView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
}
