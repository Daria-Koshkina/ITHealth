//
//  ProfileItemView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.04.2023.
//

import UIKit

class ProfileItemView: InitView {
  
  // MARK: - Public variables
  var delegate: ProfileItemDelegate?
  var viewModel: ProfileItemInfoViewModel?
  
  let backgroundView = InitView()
  let itemImageView = UIImageView()
  let titleLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.Title.font)
      .textColor(UIConstants.Title.textColor)
      .numberOfLines(UIConstants.Title.numberOfLines)
    return label
  }()
  let subtitleLabel: UILabel = {
    let label = UILabel()
    label.config
      .font(UIConstants.Subtitle.font)
      .textColor(UIConstants.Subtitle.textColor)
      .numberOfLines(UIConstants.Subtitle.numberOfLines)
    return label
  }()
  let rightArrowImageView = UIImageView()
  let bottomLine = UIView()
  
  // MARK: - Private variables
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    backgroundViewConfigure()
    configureImageView()
    configureTitle()
    configureRightArrowImageView()
    configureBottomLineView()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnProfileItem))
    addGestureRecognizer(tapGesture)
  }
  
  private func backgroundViewConfigure() {
    addSubview(backgroundView)
    backgroundView.backgroundColor = UIConstants.BackgroundView.color
    backgroundView.layer.masksToBounds = true
    backgroundView.layer.cornerRadius = UIConstants.BackgroundView.cornerRadius
    
    backgroundView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.BackgroundView.top)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
        .offset(UIConstants.BackgroundView.leading)
      make.width.height.equalTo(UIConstants.BackgroundView.side)
    }
  }
  
  private func configureImageView() {
    backgroundView.addSubview(itemImageView)
    itemImageView.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.width.height.equalTo(UIConstants.ImageView.side)
    }
  }
  
  private func configureTitle() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalTo(backgroundView)
        .priority(.low)
      make.leading.equalTo(backgroundView.snp.trailing)
        .offset(UIConstants.Title.insets)
    }
  }
  
  private func configureRightArrowImageView() {
    addSubview(rightArrowImageView)
    rightArrowImageView.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel.snp.trailing)
        .offset(UIConstants.RightImageView.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.RightImageView.trailing)
      make.width.height.equalTo(UIConstants.RightImageView.side)
      make.centerY.equalToSuperview()
    }
    rightArrowImageView.image = UIConstants.RightImageView.image
  }
  
  private func configureBottomLineView() {
    addSubview(bottomLine)
    bottomLine.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.BottomLine.height)
      make.leading.equalToSuperview()
        .offset(UIConstants.BottomLine.leading)
      make.trailing.equalToSuperview()
        .inset(UIConstants.BottomLine.trailing)
      make.bottom.equalToSuperview()
    }
    bottomLine.backgroundColor = UIConstants.BottomLine.backgroundColor
  }

  // MARK: - Interface
  func configure(viewModel: ProfileItemInfoViewModel, showSeparator: Bool) {
    self.viewModel = viewModel
    itemImageView.image = viewModel.image
    titleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    rightArrowImageView.isHidden = !viewModel.showRightArrow
    bottomLine.isHidden = !showSeparator
    
    if viewModel.subtitle != nil {
      configureWithSubtitle()
    } else {
      subtitleLabel.removeFromSuperview()
    }
  }
  
  // MARK: - Private methods
  private func configureWithSubtitle() {
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.Subtitle.top)
      make.leading.trailing.equalTo(titleLabel)
      make.bottom.equalToSuperview()
        .inset(UIConstants.Subtitle.bottom)
    }
  }
  
  @objc
  private func didTapOnProfileItem() {
    guard let viewModel = viewModel else { return }
    delegate?.didTapOnProfileItem(viewModel)
  }
}

private enum UIConstants {
  enum BackgroundView {
    static let top: CGFloat = 9
    static let leading: CGFloat = 24
    static let side: CGFloat = 44
    static let color = Colors.lightBlue
    static let cornerRadius: CGFloat = 16
  }
  enum ImageView {
    static let side: CGFloat = 24
  }
  enum Title {
    static let font = Fonts.semibold16
    static let textColor = UIColor.darkGray
    static let numberOfLines = 1
    
    static let insets: CGFloat = 12
  }
  enum Subtitle {
    static let font = Fonts.regular12
    static let textColor = UIColor.darkGray
    static let numberOfLines = 1
    static let top: CGFloat = 1
    static let bottom: CGFloat = 12
  }
  enum RightImageView {
    static let image = Images.arrowRight
    static let side: CGFloat = 24
    static let leading: CGFloat = 5
    static let trailing: CGFloat = 24
  }
  enum BottomLine {
    static let backgroundColor = UIColor.lightGray
    static let height: CGFloat = 1
    static let leading: CGFloat = 80
    static let trailing: CGFloat = 24
  }
}

