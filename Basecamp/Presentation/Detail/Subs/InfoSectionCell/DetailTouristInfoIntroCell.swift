//
//  DetailTouristInfoIntroCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/12.
//

import UIKit

final class DetailTouristInfoIntroCell: UICollectionViewCell {
  static let identifier = "DetailTouristInfoIntroCell"
  private var infoStackSetFlag: Bool = false
  
  private lazy var infoStack = DetailTouristInfoIntroStackView()
  
  override func layoutSubviews() {
      super.layoutSubviews()
      setupView()
      setupConstraints()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DetailTouristInfoIntroCell: ViewRepresentable {
  func setupView() {
    contentView.addSubview(infoStack)
  }
  
  func setupConstraints() {
    infoStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-16.0)
    }
  }
  
  func setupData(data: any DetailTouristInfoIntroItem) {
    if infoStackSetFlag == false {
      infoStack.setData(data: data)
      infoStackSetFlag.toggle()
    }
  }
}
