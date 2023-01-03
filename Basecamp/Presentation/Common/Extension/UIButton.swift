//
//  UIButton.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import UIKit

extension UIButton {
  func alignTextBelow(spacing: CGFloat = 4.0) {
    guard let image = self.imageView?.image else {
      return
    }
    
    guard let titleLabel = self.titleLabel else {
      return
    }
    
    guard let titleText = titleLabel.text else {
      return
    }
    
    let titleSize = titleText.size(withAttributes: [
      NSAttributedString.Key.font: titleLabel.font as Any
    ])
    
    titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
    imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
  }
}
