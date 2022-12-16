//
//  HomeCollectionViewCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/15.
//

import UIKit

class HomeRegionCell: UICollectionViewCell {
  static let identifier = "HomeRegionCell"
  
  private var regionLabel = RegionLabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraint() {
    contentView.addSubview(regionLabel)
    regionLabel.snp.makeConstraints { make in
      make.top.bottom.left.equalToSuperview()
      make.right.equalToSuperview().priority(999)
    }
  }
  
  func updateUI(hobby text: String) {
    regionLabel.text = text
  }
}
