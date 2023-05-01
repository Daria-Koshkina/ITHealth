//
//  SettingsView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.04.2023.
//

import UIKit

struct ProfileItemInfoViewModel {
  let type: ProfileItemType
  let image: UIImage
  let title: String
  let subtitle: String?
  let showRightArrow: Bool
  let needBottomSpace: Bool
}

protocol ProfileItemDelegate: AnyObject {
  func didTapOnProfileItem(_ viewModel: ProfileItemInfoViewModel)
}

class SettingsView: InitView {
  
  // MARK: - Public variables
  var delegate: ProfileItemDelegate?

  // MARK: - Private variables
  private let scrollView = ContentScrollView()
  private let contentStackView = UIStackView()
  
  // MARK: - Life cycle
  override func initConfigure() {
    super.initConfigure()
    configureSelfView()
    configureScrollView()
    configureContentStackView()
  }
  
  private func configureSelfView() {
    backgroundColor = UIConstants.SelfView.backgroundColor
  }
  
  private func configureScrollView() {
    addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    scrollView.backgroundColor = UIConstants.ScrollView.backgroundColor
  }
  
  private func configureContentStackView() {
    scrollView.contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .offset(UIConstants.StackView.top)
      make.leading.trailing.bottom.equalToSuperview()
    }
    contentStackView.backgroundColor = UIConstants.StackView.backgroundColor
    contentStackView.distribution = .equalSpacing
    contentStackView.spacing = UIConstants.StackView.spacing
    contentStackView.axis = .vertical
  }
  
  // MARK: - Interface
  
  func configure(items: [ProfileItemInfoViewModel]) {
    contentStackView.subviews.forEach { $0.removeFromSuperview() }
    for (index, viewModel) in items.enumerated() {
      let itemView = ProfileItemView()
      itemView.delegate = delegate
      itemView.configure(
        viewModel: viewModel,
        showSeparator: index < items.count - 1 && !viewModel.needBottomSpace)
      contentStackView.addArrangedSubview(itemView)
      
      if viewModel.needBottomSpace {
        addSpaceView()
      }
    }
  }
  
  // MARK: - Private methods
  private func addSpaceView() {
    let spaceView = UIView()
    spaceView.backgroundColor = UIConstants.SpaceView.backgroundColor
    contentStackView.addArrangedSubview(spaceView)
    spaceView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.SpaceView.height)
    }
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.white
  }
  enum ScrollView {
    static let backgroundColor = UIColor.clear
  }
  enum StackView {
    static let backgroundColor = UIColor.white
    static let spacing: CGFloat = 0
    static let top: CGFloat = 32
  }
  enum SpaceView {
    static let backgroundColor = UIColor.clear
    static let height: CGFloat = 32
  }
  enum SocialView {
    static let top: CGFloat = 40
  }
}
