//
//  TabItemConfigurable.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import UIKit
import ESTabBarController_swift

class TabBarItem: ESTabBarItem { }

class TabItemView: ESTabBarItemMoreContentView { }

protocol TabItemConfigurable {
  func configureTabBarItem(tabItem: TabItem)
  func configureNotification(notificationCount: Int)
}

extension TabItemConfigurable where Self: UIViewController {
  func configureTabBarItem(tabItem: TabItem) {
    let tabView = createTabView(tabItem: tabItem)
    tabBarItem = TabBarItem(
      tabView,
      title: tabItem.title.capitalized,
      image: tabItem.image.withRenderingMode(.alwaysTemplate),
      selectedImage: tabItem.selectedImage.withRenderingMode(.alwaysTemplate))
    
    configureNotification(notificationCount: tabItem.notificationValue)
  }
  
  func configureNotification(notificationCount: Int) {
    if notificationCount <= 0 {
      tabBarItem.badgeValue = nil
    } else {
      tabBarItem.badgeValue = notificationCount == 1 ? "" : "\(notificationCount)"
    }
  }
  
  private func createTabView(tabItem: TabItem) -> TabItemView {
    let view = TabItemView()
    configureTabItemView(view)
    configureBadgeView(in: view, tabItem: tabItem)
    return view
  }
  
  private func configureTabItemView(_ view: TabItemView) {
    view.itemContentMode = .alwaysOriginal
    view.imageView.contentMode = .scaleAspectFit
    view.textColor = UIConstants.ItemView.unselectedColor
    view.highlightTextColor = UIConstants.ItemView.selectedColor
    view.iconColor = UIConstants.ItemView.unselectedColor
    view.highlightIconColor = UIConstants.ItemView.selectedColor
    view.titleLabel.font = UIConstants.ItemView.font
  }
  
  private func configureBadgeView(in view: TabItemView, tabItem: TabItem) {
    view.badgeView = BadgeView()
    view.badgeView.badgeColor = UIConstants.Badge.backgroundColor
    view.badgeView.badgeLabel.font = UIConstants.Badge.font
    view.badgeView.badgeLabel.textColor = UIConstants.Badge.textColor
    view.badgeOffset = tabItem.notificationValue <= 1 ? UIConstants.Badge.offset : UIConstants.Badge.valueOffset
  }
}

// MARK: - UI constants
private enum UIConstants {
  enum ItemView {
    static let selectedColor = Colors.blueDark
    static let unselectedColor = UIColor.lightGray
    static let font = Fonts.regular12
  }
  enum Badge {
    static let backgroundColor = UIColor.red
    static let textColor = UIColor.white
    static let font = Fonts.regular12
    
    static let offset = UIOffset(horizontal: 8, vertical: -24)
    static let valueOffset = UIOffset(horizontal: 0, vertical: -21)
  }
}

class BadgeView: ESTabBarItemBadgeView {
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    switch badgeValue?.count {
    case 2:
      return CGSize(width: 20, height: 16)
    case 3:
      return CGSize(width: 26, height: 16)
    case 4:
      return CGSize(width: 34, height: 16)
    case nil:
      return CGSize(width: 6, height: 6)
    default:
      return CGSize(width: 16, height: 16)
    }
  }
}
