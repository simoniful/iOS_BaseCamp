//
//  HomeAreaCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/15.
//

import UIKit

class HomeAreaCell: UICollectionViewCell {
  static let identifier = "HomeAreaCell"
  
  private var areaLabel = PaddingLabel()
  
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
  
  func setupData(area: Area) {
    areaLabel.text = area.abbreviation
  }
}
