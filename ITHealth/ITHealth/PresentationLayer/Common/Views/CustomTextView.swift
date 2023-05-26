//
//  CustomTextView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 26.05.2023.
//

import UIKit

protocol CustomTextViewDelegate: AnyObject {
  func shouldChangeText(in range: NSRange, replacementText text: String, in view: CustomTextView) -> Bool
}

class CustomTextView: UITextView {
  
  // MARK: - Public variables
  weak var inputTextViewDelegate: CustomTextViewDelegate?
  
  var inputPlaceholder: String? {
    didSet {
      showPlaceholder()
    }
  }
  
  var placeholderColor: UIColor? = UIConstants.TextField.placeholderColor
  
  var hasError: Bool = false {
    didSet {
      updateBorder()
    }
  }
  
  var padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) {
    didSet {
      textContainerInset = padding
    }
  }
  
  var placeholderIsShown: Bool {
    get {
      return textColor == placeholderColor
    }
  }
  
  // MARK: - Life cycle
  init() {
    super.init(frame: .zero, textContainer: nil)
    setupBaseConfiguration()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupBaseConfiguration()
  }
  
  private func setupBaseConfiguration() {
    font = UIConstants.TextField.font
    textColor = UIConstants.TextField.color
    backgroundColor = UIConstants.TextField.backgroundColor
    layer.borderWidth = UIConstants.TextField.borderWidth
    layer.cornerRadius = UIConstants.TextField.cornerRadius
    textContainerInset = padding
    textContainer.lineFragmentPadding = 0
    delegate = self
  }
  
  private func updateBorder() {
    layer.borderColor = hasError ? UIConstants.TextField.errorBorderColor.cgColor : UIConstants.TextField.borderColor.cgColor
    setNeedsDisplay()
  }
  
  func showPlaceholder() {
    if text.isEmpty {
      text = inputPlaceholder
      textColor = placeholderColor
    }
  }
  
  private func hidePlaceholder() {
    if textColor == placeholderColor {
      text = nil
      textColor = UIConstants.TextField.color
    }
  }
}

// MARK: - UITextViewDelegate
extension CustomTextView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    hidePlaceholder()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    showPlaceholder()
  }
}

private enum UIConstants {
  enum TextField {
    static let font = Fonts.regular16
    static let placeholderColor = Colors.lightBlue
    static let color = UIColor.black
    static let backgroundColor = UIColor.white
    static let cornerRadius: CGFloat = 16
    static let borderWidth: CGFloat = 1
    static let borderColor = Colors.lightBlue
    static let errorBorderColor = UIColor.red
  }
}
