//
//  InitView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

class InitView: UIView {
  
  // MARK: - Life cycle
  required init() {
    super.init(frame: .zero)
    initConfigure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initConfigure()
  }
  
  // MARK: - Init configure
  open func initConfigure() {
    backgroundColor = .white
  }
}
