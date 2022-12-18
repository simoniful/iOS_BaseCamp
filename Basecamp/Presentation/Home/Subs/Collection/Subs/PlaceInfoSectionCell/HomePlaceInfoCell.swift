//
//  HomeInfoCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import UIKit

class HomePlaceInfoCell: UICollectionViewCell {
  static let identifier = "HomePlaceInfoCell"
  
  // Image, name, location
  override init(frame: CGRect) {
    super.init(frame: frame)
    setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraint() {
    
  }

}
