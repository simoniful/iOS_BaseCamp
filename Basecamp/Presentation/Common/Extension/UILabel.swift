//
//  UILabel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/07.
//

import UIKit

extension UILabel {
  func asColor(targetString: String, color: UIColor?) {
    let fullText = text ?? ""
    let range = (fullText as NSString).range(of: targetString)
    let attributedString = NSMutableAttributedString(string: fullText)
    attributedString.addAttribute(.foregroundColor, value: color as Any, range: range)
    attributedText = attributedString
  }
}
