//
//  UITableView+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import UIKit

extension UITableView {
  
  var visibleItems: [IndexPath: UITableViewCell] {
    let visibleIndexes = indexPathsForVisibleRows ?? []
    return Dictionary(uniqueKeysWithValues: zip(visibleIndexes, visibleCells))
  }
  
  func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
    register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
    guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
    }
    return cell
  }
  
  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, identifier: String) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with type: \(T.self)")
    }
    return cell
  }
  
  func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(with identifier: String) -> T {
    guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
      fatalError("Could not dequeue view with type: \(T.self)")
    }
    return view
  }
}

