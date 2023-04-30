//
//  UICollectionView+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 29.04.2023.
//

import Foundation
import UIKit

extension UICollectionView {
  func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
    register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func register<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String) {
    register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
    }
    return cell
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(
    withReuseIdentifier reuseIdentifier: String,
    for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
    }
    return cell
  }
  
  func dequeueReusableSupplementaryView<T: UICollectionReusableView>(of kind: String,
                                                                     with reuseIdentifier: String,
                                                                     for indexPath: IndexPath) -> T where T: ReusableView {
    guard let view = dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as? T else {
      fatalError("Could not dequeue view with identifier: \(reuseIdentifier)")
    }
    return view
  }
}
