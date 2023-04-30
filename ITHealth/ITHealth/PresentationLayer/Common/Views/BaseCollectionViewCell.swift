//
//  BaseCollectionViewCell.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import Foundation

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ReusableView {
  
  // MARK: Borders
  private let topBorder = InitView()
  private let leftBorder = InitView()
  private let rightBorder = InitView()
  private let bottomBorder = InitView()
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func initConfigure() {
    configureBorders()
  }
  
  private func configureBorders() {
    // top border
    contentView.addSubview(topBorder)
    topBorder.backgroundColor = UIConstants.Borders.color
    topBorder.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
      make.height.equalTo(UIConstants.Borders.width)
    }
    // left border
    contentView.addSubview(leftBorder)
    leftBorder.backgroundColor = UIConstants.Borders.color
    leftBorder.snp.makeConstraints { make in
      make.left.top.bottom.equalToSuperview()
      make.width.equalTo(UIConstants.Borders.width)
    }
    // right border
    contentView.addSubview(rightBorder)
    rightBorder.backgroundColor = UIConstants.Borders.color
    rightBorder.snp.makeConstraints { make in
      make.bottom.top.right.equalToSuperview()
      make.width.equalTo(UIConstants.Borders.width)
    }
    // bottom border
    contentView.addSubview(bottomBorder)
    bottomBorder.backgroundColor = UIConstants.Borders.color
    bottomBorder.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
        .offset(UIConstants.Borders.width)
      make.height.equalTo(UIConstants.Borders.width)
    }
    showBorders([])
  }
  
  func showBorders(_ borderPosition: UIRectEdge) {
    topBorder.isHidden = !(borderPosition.contains(.all) || borderPosition.contains(.top))
    leftBorder.isHidden = !(borderPosition.contains(.all) || borderPosition.contains(.left))
    rightBorder.isHidden = !(borderPosition.contains(.all) || borderPosition.contains(.right))
    bottomBorder.isHidden = !(borderPosition.contains(.all) || borderPosition.contains(.bottom))
  }
}

private enum UIConstants {
  enum Borders {
    static let color = UIColor.lightGray
    static let width: CGFloat = 1
  }
}

import UIKit

protocol ReusableView: AnyObject {
  static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
  static var defaultReuseIdentifier: String {
    return String(describing: Self.self)
  }
}
