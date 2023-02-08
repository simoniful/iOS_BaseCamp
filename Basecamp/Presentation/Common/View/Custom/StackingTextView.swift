//
//  StackingTextView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/13.
//

import UIKit

final class StackingTextView: UITextView {
  
  private var padding = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
  }
  
  convenience init(
    font: UIFont,
    padding: UIEdgeInsets = UIEdgeInsets(
      top: 8.0, left: 8.0, bottom: 8.0, right: 8.0
    )
  ) {
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
    self.textAlignment = .natural
    self.padding = padding
  }
  
  convenience init(
    title text: String,
    font: UIFont,
    textColor: UIColor = .label,
    textAlignment: NSTextAlignment = .natural,
    backgroundColor: UIColor = .systemBackground,
    padding: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)) {
    self.init()
    self.text = text
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.backgroundColor = backgroundColor
    self.textContainerInset = padding
  }
  
  required init?(coder: NSCoder) {
    fatalError("LocationLabel: fatal Error Message")
  }
  
  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.height += padding.top + padding.bottom
    contentSize.width += padding.left + padding.right
    
    return contentSize
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect.inset(by: padding))
  }
}


  
