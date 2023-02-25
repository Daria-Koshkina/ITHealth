//
//  UITextField+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 15.02.2023.
//

import UIKit

extension UITextField {
  func setTextWithSavingCursorPosition(_ newString: String?) {
    guard let newString = newString else { return }
    let cursor = selectedTextRange
    let oldString = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    text = newString
    let difference = newString.count - oldString.count
    if let cursor = cursor,
       let newPosition = position(from: cursor.start, offset: difference) {
      selectedTextRange = textRange(from: newPosition, to: newPosition)
    }
  }
}
