//
//  UIViewController+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 15.02.2023.
//

import UIKit

extension UIViewController {
  func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool = true) {
    view.hideKeyboardWhenTappedAround(cancelsTouchesInView: cancelsTouchesInView)
  }
}

extension UIView {
  
  func hideKeyboardWhenTappedAround(cancelsTouchesInView: Bool) {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                             action: #selector(UIView.dismissKeyboard))
    tap.cancelsTouchesInView = cancelsTouchesInView
    addGestureRecognizer(tap)
  }
  
  func image() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
  
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds,
                            byRoundingCorners: corners,
                            cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  @objc
  private func dismissKeyboard() {
    endEditing(true)
  }
}
