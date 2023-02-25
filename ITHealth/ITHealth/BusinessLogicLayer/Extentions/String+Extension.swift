//
//  String+Extension.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 15.02.2023.
//

import UIKit

extension String {
  func upperCaseFirst() -> String {
    return prefix(1).capitalized + dropFirst()
  }
  
  func utf8DecodedString() -> String {
    let data = self.data(using: .utf8)
    let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
    return message
  }
  
  func utf8EncodedString() -> String {
    guard let messageData = self.data(using: .nonLossyASCII) else {
      return ""
    }
    let text = String(data: messageData, encoding: .utf8) ?? ""
    return text
  }
  
  mutating func upperCaseFirst() {
    self = self.upperCaseFirst()
  }
  
  func removingCharacters(from forbiddenChars: CharacterSet) -> String {
    let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
    return String(String.UnicodeScalarView(passed))
  }
  
  func removingSuffix(_ suffix: String) -> String {
    guard self.hasSuffix(suffix) else {
      return self
    }
    return String(dropLast(suffix.count))
  }
  
  func widthOfString(usingFont font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttributes)
    return size.width
  }
}

extension StringProtocol {
  func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
  
  func distance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
}

extension String.Index {
  func distance<S: StringProtocol>(in string: S) -> Int { string.distance(from: string.startIndex, to: self) }
}

