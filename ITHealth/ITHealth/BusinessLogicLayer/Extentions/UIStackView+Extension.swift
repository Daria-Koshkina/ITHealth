//
//  UIStackView+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

extension UIStackView {
  
  func removeFully(view: UIView) {
    removeArrangedSubview(view)
    view.removeFromSuperview()
  }
  
  func removeFullyAllArrangedSubviews() {
    arrangedSubviews.forEach { (view) in
      removeFully(view: view)
    }
  }
}
