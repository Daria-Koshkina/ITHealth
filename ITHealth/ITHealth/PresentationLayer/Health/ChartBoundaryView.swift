//
//  ChartBoundaryView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 12.05.2023.
//

import UIKit

enum BoundaryLinePosition {
  case top
  case bottom
}

class ChartBoundaryView: InitView {
  
  // MARK: - Private variables
  private let stackView = UIStackView()
  private let containerView = InitView()
  private let titleLabel = UILabel()
  private let amountLabel = UILabel()
  private let dashedView = DashedView()
  
  private(set) var position: BoundaryLinePosition = .top
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    backgroundColor = .clear
    configureStackView()
    configureContainerView()
    configureLabels()
    configure(position: position, color: UIConstants.DashedView.defaultColor)
  }
  
  func configure(position: BoundaryLinePosition, color: UIColor) {
    self.position = position
    titleLabel.textColor = color
    amountLabel.textColor = color
    dashedView.config = .init(color: color, dashLength: 5, dashGap: 2)
    stackView.removeFullyAllArrangedSubviews()
    switch position {
    case .top:
      stackView.addArrangedSubview(dashedView)
      stackView.addArrangedSubview(containerView)
    case .bottom:
      stackView.addArrangedSubview(containerView)
      stackView.addArrangedSubview(dashedView)
    }
    layoutIfNeeded()
  }
  
  func configure(leftTitle: String?, rightTitle: String?) {
    titleLabel.text = leftTitle
    amountLabel.text = rightTitle
  }
  
  private func configureStackView() {
    addSubview(stackView)
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.spacing = UIConstants.DashedView.top
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func configureContainerView() {
    containerView.backgroundColor = .clear
  }
  
  private func configureLabels() {
    containerView.addSubview(titleLabel)
    containerView.addSubview(amountLabel)
    titleLabel.font = UIConstants.TextField.font
    amountLabel.font = UIConstants.TextField.font
    amountLabel.textAlignment = .right
    amountLabel.setContentHuggingPriority(.required, for: .horizontal)
    amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    amountLabel.setContentHuggingPriority(.required, for: .vertical)
    amountLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    dashedView.setContentHuggingPriority(.required, for: .vertical)
    dashedView.setContentCompressionResistancePriority(.required, for: .vertical)
    titleLabel.snp.makeConstraints { make in
      make.top.left.bottom.equalToSuperview()
      make.height.equalTo(UIConstants.TextField.height)
    }
    amountLabel.snp.makeConstraints { make in
      make.top.right.bottom.equalToSuperview()
      make.left.equalTo(titleLabel.snp.right)
        .offset(UIConstants.TextField.space)
      make.height.equalTo(UIConstants.TextField.height)
    }
  }
}

private enum UIConstants {
  enum TextField {
    static let font = Fonts.regular12
    static let space: CGFloat = 10
    static let height: CGFloat = 20
  }
  enum DashedView {
    static let top: CGFloat = 8
    static let defaultColor = UIColor.darkGray
  }
}
