//
//  InputView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

protocol InputViewDelegate: AnyObject {
  func rightViewWasTapped(in textField: UITextField)
  func rightLabelWasTapped(in textField: UITextField)
}

class InputView: UITextField {
  
  weak var inputViewDelegate: (InputViewDelegate & UITextFieldDelegate)? {
    didSet {
      delegate = inputViewDelegate
    }
  }
  
  // MARK: - Public variables
  var title: String? {
    didSet {
      updateTitleLabel()
    }
  }
  
  var titleColor: UIColor? = UIConstants.TitleLabel.color {
    didSet {
      updateTitleColor()
    }
  }
  
  var titleFont: UIFont? = UIConstants.TitleLabel.font {
    didSet {
      updateTitleFont()
    }
  }
  
  var rightTitle: String? {
    didSet {
      updateRightTitleLabel()
    }
  }
  
  var rightTitleColor: UIColor? = UIConstants.TitleLabel.rightColor {
    didSet {
      updateRightTitleColor()
    }
  }
  
  var rightTitleFont: UIFont? = UIConstants.TitleLabel.rightFont {
    didSet {
      updateRightTitleFont()
    }
  }
  
  var inputPlaceholder: String? {
    didSet {
      updatePlaceholder()
    }
  }
  
  var placeholderColor: UIColor? = UIConstants.TextField.placeholderColor {
    didSet {
      updatePlaceholder()
    }
  }
  
  var hasError: Bool = false {
    didSet {
      updateBorder()
    }
  }
  
  var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  
  var canCopy = true
  
  // MARK: Private variables
  private let titleLabel = UILabel()
  private let rightTitleLabel = UILabel()
  
  // MARK: - Life cycle
  init() {
    super.init(frame: .zero)
    setupBaseConfiguration()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupBaseConfiguration()
  }
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    let x = padding.left
    let y = padding.top
    let width = bounds.width - padding.left - padding.right - (rightView?.bounds.width ?? .zero)
    let height = bounds.height - padding.top - padding.bottom
    let viewBounds = CGRect(x: x, y: y, width: width, height: height)
    return viewBounds
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    let x = padding.left
    let y = padding.top
    let width = bounds.width - padding.left - padding.right - (rightView?.bounds.width ?? .zero)
    let height = bounds.height - padding.top - padding.bottom
    let viewBounds = CGRect(x: x, y: y, width: width, height: height)
    return viewBounds
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    let x = padding.left
    let y = padding.top
    let width = bounds.width - padding.left - padding.right - (rightView?.bounds.width ?? .zero)
    let height = bounds.height - padding.top - padding.bottom
    let viewBounds = CGRect(x: x, y: y, width: width, height: height)
    return viewBounds
  }
  
  override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    return getRightViewBounds(forBounds: bounds)
  }
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(UIResponderStandardEditActions.copy(_:)) {
      return canCopy
    }
    return super.canPerformAction(action, withSender: sender)
  }
  
  private func getRightViewBounds(forBounds bounds: CGRect) -> CGRect {
    let x = bounds.width - (rightView?.bounds.width ?? .zero) - padding.right
    let y = (bounds.height - (rightView?.bounds.height ?? .zero)) / 2
    let rightViewBounds = CGRect(x: x, y: y,
                                 width: rightView?.bounds.width ?? .zero,
                                 height: rightView?.bounds.height ?? .zero)
    return rightViewBounds
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let rightLabelBounds = CGRect(
      x: bounds.minX + bounds.width - rightTitleLabel.bounds.width,
      y: bounds.minY - rightTitleLabel.bounds.height,
      width: rightTitleLabel.bounds.width,
      height: rightTitleLabel.bounds.height)
    let newBounds = CGRect(
      x: bounds.minX,
      y: bounds.minY - rightTitleLabel.bounds.height,
      width: bounds.width,
      height: bounds.height + rightTitleLabel.bounds.height)
    let rightViewBounds = getRightViewBounds(forBounds: bounds)
    
    if rightViewBounds.contains(point) {
      return rightView
    } else if newBounds.contains(point) {
      return rightLabelBounds.contains(point) ?
      rightTitleLabel :
      super.hitTest(point, with: event)
    } else {
      return super.hitTest(point, with: event)
    }
  }

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return bounds.contains(point)
  }
  
  func setIsEnable(_ isEnabled: Bool) {
    isUserInteractionEnabled = isEnabled
    alpha = isEnabled ? 1.0 : 0.5
  }
  
  func setRightImage(_ image: UIImage) {
    let imageView = UIImageView(image: image)
    imageView.contentMode = .center
    imageView.frame = CGRect(x: UIConstants.TextField.startPosition,
                             y: UIConstants.TextField.startPosition,
                             width: UIConstants.TextField.width,
                             height: UIConstants.TextField.height)
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapRightView))
    rightView = imageView
    rightView?.addGestureRecognizer(tap)
    rightView?.isUserInteractionEnabled = true
    rightViewMode = .always
  }
  
  private func setupBaseConfiguration() {
    font = UIConstants.TextField.font
    textColor = UIConstants.TextField.color
    backgroundColor = UIConstants.TextField.backgroundColor
    layer.borderWidth = UIConstants.TextField.borderWidth
    layer.cornerRadius = UIConstants.TextField.cornerRadius
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapRightTitle))
    rightTitleLabel.addGestureRecognizer(tap)
  }
  
  private func updateTitleLabel() {
    titleLabel.text = title
    if title.isNilOrEmpty {
      guard titleLabel.superview != nil else { return }
      titleLabel.snp.removeConstraints()
      titleLabel.removeFromSuperview()
    } else {
      guard titleLabel.superview == nil else { return }
      addSubview(titleLabel)
      titleLabel.snp.makeConstraints { make in
        make.leading.trailing.equalToSuperview()
        make.bottom.equalTo(snp.top)
          .inset(-UIConstants.TitleLabel.top)
      }
      titleLabel.setContentHuggingPriority(.required, for: .vertical)
      titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
      titleLabel.font = titleFont
      titleLabel.textColor = titleColor
    }
    setNeedsDisplay()
  }
  
  private func updateTitleColor() {
    titleLabel.textColor = titleColor
    setNeedsDisplay()
  }
  
  private func updateTitleFont() {
    titleLabel.font = titleFont
    setNeedsDisplay()
  }
  
  private func updateRightTitleLabel() {
    rightTitleLabel.text = rightTitle
    if rightTitle.isNilOrEmpty {
      guard rightTitleLabel.superview != nil else { return }
      rightTitleLabel.snp.removeConstraints()
      rightTitleLabel.removeFromSuperview()
    } else {
      guard rightTitleLabel.superview == nil else { return }
      addSubview(rightTitleLabel)
      rightTitleLabel.snp.makeConstraints { make in
        if titleLabel.superview == nil {
          make.leading.equalToSuperview()
        } else {
          titleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(snp.top)
              .inset(-UIConstants.TitleLabel.top)
          }
          make.leading.equalTo(titleLabel.snp.trailing)
        }
        make.trailing.equalToSuperview()
        make.bottom.equalTo(snp.top)
          .inset(-UIConstants.TitleLabel.top)
      }
      rightTitleLabel.setContentHuggingPriority(.required, for: .vertical)
      rightTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
      rightTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
      rightTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
      rightTitleLabel.font = rightTitleFont
      rightTitleLabel.textColor = rightTitleColor
      rightTitleLabel.textAlignment = .right
    }
    setNeedsDisplay()
  }
  
  private func updateRightTitleColor() {
    rightTitleLabel.textColor = rightTitleColor
    setNeedsDisplay()
  }
  
  private func updateRightTitleFont() {
    rightTitleLabel.font = rightTitleFont
    setNeedsDisplay()
  }
  
  private func updateBorder() {
    layer.borderColor = hasError ? UIConstants.TextField.errorBorderColor.cgColor : UIConstants.TextField.borderColor.cgColor
    setNeedsDisplay()
  }
  
  private func updatePlaceholder() {
    placeholder = inputPlaceholder
    attributedPlaceholder = NSAttributedString(
      string: inputPlaceholder ?? "",
      attributes: [NSAttributedString.Key.foregroundColor: placeholderColor as Any])
    setNeedsDisplay()
  }
  
  @objc
  private func didTapRightView() {
    inputViewDelegate?.rightViewWasTapped(in: self)
  }
  
  @objc
  private func didTapRightTitle() {
    inputViewDelegate?.rightLabelWasTapped(in: self)
  }
}

private enum UIConstants {
  enum TitleLabel {
    static let font = Fonts.regular12
    static let color = Colors.blueDark
    static let rightFont = Fonts.regular12
    static let rightColor = Colors.blueDark
    static let top: CGFloat = 6
  }
  enum TextField {
    static let font = Fonts.regular16
    static let placeholderColor = Colors.textColorDark.withAlphaComponent(0.6)
    static let color = UIColor.black
    static let backgroundColor = UIColor.white
    static let cornerRadius: CGFloat = 16
    static let borderWidth: CGFloat = 1
    static let borderColor = Colors.textColorDark
    static let errorBorderColor = UIColor.systemRed
    
    static let startPosition: CGFloat = 0
    static let width: CGFloat = 24
    static let height: CGFloat = 24
  }
}
