//
//  StackingLabel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/11.
//

import UIKit.UILabel

final class StackingLabel: UILabel {
  
  private var padding = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setConfiguration()
  }
  
  convenience init(font: UIFont, padding: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)) {
    self.init()
    self.font = font
    self.padding = padding
  }
  
  convenience init(font: UIFont,
                   textColor: UIColor = .label,
                   padding: UIEdgeInsets = UIEdgeInsets(
                    top: 8.0, left: 8.0, bottom: 8.0, right: 8.0
                   )
  ) {
    self.init()
    self.font = font
    self.textColor = textColor
    self.textAlignment = .center
    self.padding = padding
  }
  
  convenience init(
    title text: String,
    font: UIFont,
    textColor: UIColor = .label,
    textAlignment: NSTextAlignment = .center,
    backgroundColor: UIColor = .systemBackground,
    padding: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)) {
    self.init()
    self.text = text
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.backgroundColor = backgroundColor
    self.padding = padding
  }

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.height += padding.top + padding.bottom
    contentSize.width += padding.left + padding.right
    
    return contentSize
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: padding))
  }
  
  private func setConfiguration() {
    numberOfLines = 0
  }
}
