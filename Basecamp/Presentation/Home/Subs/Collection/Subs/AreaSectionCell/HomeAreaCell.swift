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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupView()
    setupConstraints()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeAreaCell: ViewRepresentable {
  func setupView() {
    contentView.addSubview(areaLabel)
  }
  
  func setupConstraints() {
    areaLabel.snp.makeConstraints {
      $0.top.bottom.left.equalToSuperview()
      $0.right.equalToSuperview().priority(999)
    }
  }
  
  func setupData(area: Area) {
    areaLabel.text = area.abbreviation
  }
}
