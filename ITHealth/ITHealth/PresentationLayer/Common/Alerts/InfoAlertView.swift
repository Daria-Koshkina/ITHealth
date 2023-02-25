//
//  InfoAlertView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.02.2023.
//

import UIKit

class InfoAlertView: InitView, AlertViewProtocol {
  
  // MARK: - Public variables
  var delegate: AlertViewDelegate?
  
  // MARK: - Private variables
  private let containerView = InitView()
  private let touchView = UIView()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let closeButton = PrimaryButton()
  
  private var cancelHandler: (() -> Void)?
  
  // MARK: - Life cycle
  
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    contentViewConfigure()
    configureTouchView()
    titleLabelConfigure()
    descriptionLabelConfigure()
    closeButtonConfigure()
  }
  
  func configure(title: String,
                 description: String,
                 cancelButtonText: String?,
                 cancelHandler: (() -> Void)?) {
    self.cancelHandler = cancelHandler
    titleLabel.text = title
    descriptionLabel.text = description
    closeButton.setTitle(cancelButtonText, for: .normal)
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
  
  private func titleLabelConfigure() {
    containerView.addSubview(titleLabel)
    titleLabel.font = UIConstants.TitleLabel.font
    titleLabel.textColor = UIConstants.TitleLabel.color
    titleLabel.numberOfLines = UIConstants.TitleLabel.numberOfLines
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.TitleLabel.top)
      make.left.right.equalToSuperview()
        .inset(UIConstants.TitleLabel.left)
    }
  }
  
  private func descriptionLabelConfigure() {
    containerView.addSubview(descriptionLabel)
    descriptionLabel.font = UIConstants.DescriptionLabel.font
    descriptionLabel.textColor = UIConstants.DescriptionLabel.color
    descriptionLabel.numberOfLines = UIConstants.DescriptionLabel.numberOfLines
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.DescriptionLabel.top)
      make.left.right.equalToSuperview()
        .inset(UIConstants.DescriptionLabel.left)
    }
  }
  
  private func closeButtonConfigure() {
    containerView.addSubview(closeButton)
    closeButton.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom)
        .offset(UIConstants.Button.top)
      make.left.right.equalToSuperview()
        .inset(UIConstants.Button.left)
      make.height.equalTo(UIConstants.Button.height)
      make.bottom.equalToSuperview()
        .inset(UIConstants.Button.bottom)
    }
    closeButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
  }
  
  @objc
  private func cancelButtonAction() {
    self.delegate?.hideView {
      self.cancelHandler?()
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
  enum TitleLabel {
    static let top: CGFloat = 32
    static let left: CGFloat = 16
    static let numberOfLines: Int = .zero
    static let font = Fonts.medium32
    static let color = Colors.textColorDark
  }
  enum DescriptionLabel {
    static let top: CGFloat = 16
    static let left: CGFloat = 16
    static let font = Fonts.regular16
    static let color = Colors.textColorDark
    static let numberOfLines = 0
  }
  enum Button {
    static let top: CGFloat = 32
    static let left: CGFloat = 16
    static let height: CGFloat = 54
    static let bottom: CGFloat = 38
  }
  enum SelfView {
    static let top: CGFloat = 8
    static let backgroundColor: UIColor = .clear
  }
  enum ContainerView {
    static let color = UIColor.white
  }
}


