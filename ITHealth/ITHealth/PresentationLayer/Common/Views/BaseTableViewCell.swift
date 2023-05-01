//
//  BaseTableViewCell.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 01.05.2023.
//

import UIKit

class BaseTableViewCell: UITableViewCell, ReusableView {
  
  // MARK: - Private variables
  private let topBorder = UIView()
  private let leftBorder = UIView()
  private let rightBorder = UIView()
  private let bottomBorder = UIView()
  
  // MARK: - Life cycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    initConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func initConfigure() {
    bordersConfigure()
  }
  
  func showBorders(_ borderPosition: UIRectEdge) {
    topBorder.isHidden = !(borderPosition.contains(.all) || borderPosition.contains(.top))
    leftBorder.isHidden = !(borderPosition.contains(.all) || borderPosition.contains(.left))
    rightBorder.isHidden = !(borderPosition.contains(.all) || borderPosition.contains(.right))
    bottomBorder.isHidden = !(borderPosition.contains(.all) || borderPosition.contains(.bottom))
  }
  
  private func bordersConfigure() {
    // top border
    contentView.addSubview(topBorder)
    topBorder.backgroundColor = UIConstants.color
    topBorder.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
      make.height.equalTo(UIConstants.width)
    }
    // left border
    contentView.addSubview(leftBorder)
    leftBorder.backgroundColor = UIConstants.color
    leftBorder.snp.makeConstraints { make in
      make.left.top.bottom.equalToSuperview()
      make.width.equalTo(UIConstants.width)
    }
    // right border
    contentView.addSubview(rightBorder)
    rightBorder.backgroundColor = UIConstants.color
    rightBorder.snp.makeConstraints { make in
      make.bottom.top.right.equalToSuperview()
      make.width.equalTo(UIConstants.width)
    }
    // bottom border
    contentView.addSubview(bottomBorder)
    bottomBorder.backgroundColor = UIConstants.color
    bottomBorder.snp.makeConstraints { make in
      make.left.bottom.right.equalToSuperview()
      make.height.equalTo(UIConstants.width)
    }
    showBorders([])
  }
}

private enum UIConstants {
  static let color = UIColor.lightGray
  static let width: CGFloat = 1
}

