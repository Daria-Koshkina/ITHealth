//
//  LanguageTableViewCell.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 01.05.2023.
//

import UIKit

class LanguageTableViewCell: BaseTableViewCell {
  
  // MARK: - Private variables
  private let flagImageView = UIImageView()
  let titleLabel = UILabel()
  private let selectedImageView = UIImageView()
  
  // MARK: - Life cycle
  
  override func initConfigure() {
    super.initConfigure()
    flagImageViewConfigure()
    titleLabelConfigure()
    selectedImageViewConfigure()
  }
  
  func configure(languageTitle: String, flagImage: UIImage, isSelected: Bool) {
    titleLabel.text = languageTitle
    flagImageView.image = flagImage
    selectedImageView.isHidden = !isSelected
  }
  
  private func flagImageViewConfigure() {
    contentView.addSubview(flagImageView)
    flagImageView.contentMode = .scaleAspectFit
    
    flagImageView.snp.makeConstraints {make in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview()
        .offset(UIConstants.FlagImageView.left)
      make.width.height.equalTo(UIConstants.FlagImageView.width)
    }
  }
  
  private func titleLabelConfigure() {
    contentView.addSubview(titleLabel)
    titleLabel.font = UIConstants.TitleLabel.font
    titleLabel.textColor = UIConstants.TitleLabel.color
    
    titleLabel.snp.makeConstraints {make in
      make.centerY.equalToSuperview()
      make.left.equalTo(flagImageView.snp.right)
        .offset(UIConstants.TitleLabel.left)
    }
  }
  
  private func selectedImageViewConfigure() {
    contentView.addSubview(selectedImageView)
    selectedImageView.contentMode = .scaleAspectFit
    selectedImageView.image = UIConstants.SelectedImageView.image
    
    selectedImageView.snp.makeConstraints {make in
      make.centerY.equalToSuperview()
      make.left.equalTo(titleLabel.snp.right)
        .offset(UIConstants.SelectedImageView.left)
      make.right.equalToSuperview()
        .inset(UIConstants.SelectedImageView.right)
      make.width.height.equalTo(UIConstants.SelectedImageView.width)
    }
  }
}

private enum UIConstants {
  enum FlagImageView {
    static let top: CGFloat = 16
    static let left: CGFloat = 24
    static let width: CGFloat = 24
  }
  enum TitleLabel {
    static let left: CGFloat = 9
    static let font = Fonts.regular16
    static let color = UIColor.black
  }
  enum SelectedImageView {
    static let left: CGFloat = 10
    static let right: CGFloat = 24
    static let width: CGFloat = 24
    static let image: UIImage = Images.arrowRight
  }
}

