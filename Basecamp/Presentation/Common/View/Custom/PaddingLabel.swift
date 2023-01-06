//
//  LocationLabel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/15.
//

import UIKit.UILabel

final class PaddingLabel: UILabel {
  
  private var padding = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setConfiguration()
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
  
  required init?(coder: NSCoder) {
    fatalError("LocationLabel: fatal Error Message")
  }
  
  private func setConfiguration() {
    font = .title4R14
    numberOfLines = 1
    textAlignment = .center
    layer.cornerRadius = 16.0
    layer.borderWidth = 1
    layer.borderColor = UIColor.systemGray5.cgColor
  }
}
