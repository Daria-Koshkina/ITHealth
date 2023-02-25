//
//  UIColor+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

typealias ColorDiapason = UInt8
typealias Color = UIColor

extension UIColor {
  
  // swiftlint:disable identifier_name
  class func color(r: ColorDiapason,
                   g: ColorDiapason,
                   b: ColorDiapason,
                   a: CGFloat = 1) -> UIColor {
    let convertedRed = CGFloat(r) / CGFloat(ColorDiapason.max)
    let convertedGreen = CGFloat(g) / CGFloat(ColorDiapason.max)
    let convertedBlue = CGFloat(b) / CGFloat(ColorDiapason.max)
    let convertedAlpha = a
    let color = UIColor(red: convertedRed,
                        green: convertedGreen,
                        blue: convertedBlue,
                        alpha: convertedAlpha)
    return color
  }
  
  convenience init(hex: String) {
    var mutableHex = hex
    if hex.hasPrefix("#") {
      mutableHex = String(hex.suffix(mutableHex.count - 1))
    }
    guard mutableHex.count > 2 else {
      self.init(red: 0, green: 0, blue: 0, alpha: 1)
      return
    }
    let colorRedInt = Int(mutableHex.prefix(2), radix: 16)
    mutableHex = String(mutableHex.suffix(mutableHex.count - 2))
    
    let colorGreenInt = Int(mutableHex.prefix(2), radix: 16)
    mutableHex = String(mutableHex.suffix(mutableHex.count - 2))
    
    let colorBlueInt = Int(mutableHex.prefix(2), radix: 16)
    mutableHex = String(mutableHex.suffix(mutableHex.count - 2))
    
    let colorAlphaInt = Int(mutableHex.prefix(2), radix: 16)
    
    self.init(red: CGFloat(colorRedInt ?? 0) / 255,
              green: CGFloat(colorGreenInt ?? 0) / 255,
              blue: CGFloat(colorBlueInt ?? 0) / 255,
              alpha: CGFloat(colorAlphaInt ?? 255) / 255)
  }
}
