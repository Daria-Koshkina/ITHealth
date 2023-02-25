//
//  OutlinedButton.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

class OutlinedButton: UIButton {
  
  // MARK: - Public variables
  override var isEnabled: Bool {
    didSet {
      update()
    }
  }
  
  override var isHighlighted: Bool {
    didSet {
      if oldValue != isHighlighted {
        update()
      }
    }
  }
  
  // MARK: - Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  // MARK: - Configure
  private func setupView() {
    titleLabel?.font = UIConstants.Label.font
    setTitleColor(UIConstants.Label.defaultColor, for: .normal)
    setTitleColor(UIConstants.Label.disabledColor, for: .disabled)
    setTitleColor(UIConstants.Label.highlightedColor, for: .highlighted)
    layer.cornerRadius = UIConstants.Button.cornerRadius
    layer.borderWidth = UIConstants.Button.borderWidth
    layer.borderColor = UIConstants.Button.borderColor.cgColor
    update()
  }
  
  // MARK: - Private methods
  private func update() {
    if isEnabled && isHighlighted {
      backgroundColor = UIConstants.Button.highlightedColor
    } else if !isEnabled {
      backgroundColor = UIConstants.Button.disabledColor
    } else {
      backgroundColor = UIConstants.Button.defaultColor
    }
  }
  
}

private enum UIConstants {
  enum Label {
    static let font = Fonts.semibold16
    static let highlightedColor = Colors.blueDark
    static let defaultColor = Colors.blueDark
    static let disabledColor = Colors.blueDark.withAlphaComponent(0.4)
  }
  enum Button {
    static let cornerRadius: CGFloat = 12
    static let highlightedColor: UIColor = .clear
    static let defaultColor: UIColor = .clear
    static let disabledColor = Colors.blueDark.withAlphaComponent(0.4)
    static let borderColor = Colors.blueDark
    static let borderWidth: CGFloat = 1
  }
}

