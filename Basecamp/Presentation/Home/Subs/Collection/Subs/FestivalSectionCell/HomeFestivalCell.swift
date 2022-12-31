//
//  HomeFestivalCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/18.
//

import UIKit

class HomeFestivalCell: UICollectionViewCell {
  static let identifier = "HomeFestivalCell"
  
  private var areaLabel = AreaLabel()
  // Image, name, date
  override init(frame: CGRect) {
    super.init(frame: frame)
    setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraint() {
    contentView.addSubview(areaLabel)
    areaLabel.snp.makeConstraints { make in
      make.top.bottom.left.equalToSuperview()
      make.right.equalToSuperview().priority(999)
    }
  }

  func setData(touristInfo: TouristInfo) {
    
  }
}
