//
//  BaseAlertView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

enum CancelButtonPosition {
  case top
  case bottom
}

class BaseAlertView: InitView, AlertViewProtocol {
  
  // MARK: - Public variables
  var delegate: AlertViewDelegate?
  
  // MARK: - Private variables
  private let containerView = InitView()
  private let touchView = UIView()
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let stackView = UIStackView()
  
  private var okHandler: (() -> Void)?
  private var cancelHandler: (() -> Void)?
  
  private let cancelButtonPosition: CancelButtonPosition
  
  // MARK: - Life cycle
  init(cancelButtonPosition: CancelButtonPosition = .bottom) {
    self.cancelButtonPosition = cancelButtonPosition
    super.init()
  }
  
  required init() {
    self.cancelButtonPosition = .bottom
    super.init()
  }
  
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    contentViewConfigure()
    configureTouchView()
    imageViewConfigure()
    titleLabelConfigure()
    descriptionLabelConfigure()
    stackViewConfigure()
  }
  
  func configure(title: String,
                 description: String,
                 image: UIImage = UIImage(),
                 buttonText: String?,
                 cancelButtonText: String?,
                 okHandler: (() -> Void)?,
                 cancelHandler: (() -> Void)?) {
    self.okHandler = okHandler
    self.cancelHandler = cancelHandler
    titleLabel.text = title
    descriptionLabel.text = description
    imageView.image = image
    stackView.removeFullyAllArrangedSubviews()
    if let buttonText = buttonText {
      let okButton = PrimaryButton()
      stackView.addArrangedSubview(okButton)
      okButton.snp.makeConstraints { make in
        make.height.equalTo(UIConstants.Button.height)
        make.width.equalToSuperview()
      }
      okButton.setTitle(buttonText, for: .normal)
      okButton.setContentHuggingPriority(.required, for: .horizontal)
      okButton.setContentCompressionResistancePriority(.required, for: .horizontal)
      switch cancelButtonPosition {
      case .top:
        okButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
      case .bottom:
        okButton.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
      }
    }
    if let cancelButtonText = cancelButtonText {
      let cancelButton = OutlinedButton()
      stackView.addArrangedSubview(cancelButton)
      cancelButton.snp.makeConstraints { make in
        make.height.equalTo(UIConstants.Button.height)
        make.width.equalToSuperview()
      }
      cancelButton.setTitle(cancelButtonText, for: .normal)
      cancelButton.setContentHuggingPriority(.required, for: .horizontal)
      cancelButton.setContentCompressionResistancePriority(.required, for: .horizontal)
      switch cancelButtonPosition {
      case .top:
        cancelButton.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
      case .bottom:
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
      }
    }
  }
  
  // MARK: - Private methods
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func contentViewConfigure() {
    addSubview(containerView)
    containerView.layer.masksToBounds = true
    containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    containerView.layer.cornerRadius = 30
    containerView.backgroundColor = UIConstants.ContainerView.color
    
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func configureTouchView() {
    containerView.addSubview(touchView)
    touchView.backgroundColor = UIConstants.TouchView.color
    touchView.layer.cornerRadius = UIConstants.TouchView.cornerRadius
    touchView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.TouchView.top)
      make.centerX.equalToSuperview()
      make.width.equalTo(UIConstants.TouchView.width)
      make.height.equalTo(UIConstants.TouchView.height)
    }
  }
  
  private func imageViewConfigure() {
    containerView.addSubview(imageView)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    
    imageView.snp.makeConstraints { make in
      make.top.equalTo(touchView.snp.bottom)
        .offset(UIConstants.ImageView.top)
      make.centerX.equalToSuperview()
      make.width.height.equalTo(UIConstants.ImageView.width)
    }
  }
  
  private func titleLabelConfigure() {
    containerView.addSubview(titleLabel)
    titleLabel.font = UIConstants.TitleLabel.font
    titleLabel.textColor = UIConstants.TitleLabel.color
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = UIConstants.TitleLabel.numberOfLines
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom)
        .offset(UIConstants.TitleLabel.top)
      make.left.right.equalToSuperview()
        .inset(UIConstants.TitleLabel.left)
    }
  }
  
  private func descriptionLabelConfigure() {
    containerView.addSubview(descriptionLabel)
    descriptionLabel.font = UIConstants.DescriptionLabel.font
    descriptionLabel.textColor = UIConstants.DescriptionLabel.color
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = UIConstants.DescriptionLabel.numberOfLines
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.DescriptionLabel.top)
      make.left.right.equalToSuperview()
        .inset(UIConstants.DescriptionLabel.left)
    }
  }
  
  private func stackViewConfigure() {
    containerView.addSubview(stackView)
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    stackView.spacing = UIConstants.StackView.spacing
    
    stackView.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom)
        .offset(UIConstants.StackView.top)
      make.left.right.equalToSuperview()
        .inset(UIConstants.StackView.left)
      make.bottom.equalToSuperview()
        .inset(UIConstants.StackView.bottom)
    }
  }
  
  @objc
  private func cancelButtonAction() {
    self.delegate?.hideView {
      self.cancelHandler?()
    }
  }
  
  @objc
  private func okButtonAction() {
    self.delegate?.hideView {
      self.okHandler?()
    }
  }
}

// MARK: - UIConstants
private enum UIConstants {
  enum TouchView {
    static let width: CGFloat = 48
    static let height: CGFloat = 5
    static let cornerRadius: CGFloat = 2.5
    static let top: CGFloat = 16
    static let color = UIColor.lightGray
  }
  enum ImageView {
    static let width: CGFloat = 120
    static let top: CGFloat = 32
  }
  enum TitleLabel {
    static let top: CGFloat = 12
    static let left: CGFloat = 24
    static let numberOfLines: Int = .zero
    static let font = Fonts.medium32
    static let color = Colors.textColorDark
  }
  enum DescriptionLabel {
    static let top: CGFloat = 8
    static let left: CGFloat = 67
    static let font = Fonts.regular16
    static let color = Colors.textColorDark
    static let numberOfLines = 3
  }
  enum StackView {
    static let top: CGFloat = 32
    static let bottom: CGFloat = 37
    static let left: CGFloat = 16
    static let spacing: CGFloat = 8
  }
  enum Button {
    static let height: CGFloat = 54
  }
  enum SelfView {
    static let top: CGFloat = 8
    static let backgroundColor: UIColor = .clear
  }
  enum ContainerView {
    static let color = UIColor.white
  }
}

