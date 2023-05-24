//
//  ButtonsFactory.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import UIKit

class ButtonsFactory {
  class func getNavigationBarBackButton() -> UIButton {
    let button = UIButton()
    button.setImage(Images.back, for: .normal)
    return button
  }
}
