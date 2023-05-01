//
//  LabelConfigurator.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 30.04.2023.
//

import UIKit

public class LabelConfigurator {
  
  // MARK: - Private variables
  private let label: UILabel
  
  // MARK: - Life cycle
  init(label: UILabel) {
    self.label = label
  }
  
  // MARK: - Public
  @discardableResult
  public func font(_ font: UIFont) -> LabelConfigurator {
    label.font = font
    return self
  }
  
  @discardableResult
  public func textColor(_ color: UIColor) -> LabelConfigurator {
    label.textColor = color
    return self
  }
  
  @discardableResult
  public func textAlignment(_ alignment: NSTextAlignment) -> LabelConfigurator {
    label.textAlignment = alignment
    return self
  }
  
  @discardableResult
  public func numberOfLines(_ lines: Int) -> LabelConfigurator {
    label.numberOfLines = lines
    return self
  }
}

public extension UILabel {
  var config: LabelConfigurator {
    return LabelConfigurator(label: self)
  }
}
