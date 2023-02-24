//
//  DetailInfoCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit

final class DetailCampsiteInfoCell: UICollectionViewCell {
  static let identifier = "DetailCampsiteInfoCell"
  private var infoStackSetFlag: Bool = false
  
  private lazy var infoStack = DetailCampsiteInfoStackView()
  
  private lazy var tooltipLabel: UILabel = {
    let label = DefaultLabel(font: .body3R14)
    label.text = "정보 플러스"
    label.numberOfLines = 0
    return label
  }()
  
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

extension DetailCampsiteInfoCell: ViewRepresentable {
  func setupView() {
    [infoStack, tooltipLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    infoStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    
    tooltipLabel.snp.makeConstraints {
      $0.top.equalTo(infoStack.snp.bottom).offset(8.0)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-16.0)
    }
  }
  
  func setupData(data: DetailCampsiteInfoItem) {
    if infoStackSetFlag == false {
      infoStack.setData(data: data)
      tooltipLabel.text = data.tooltip.isEmpty ? "･ 캠핑장에 주변 지역 관광 정보가 구비되어있습니다" : "･ " + data.tooltip
      infoStackSetFlag.toggle()
    }
  }
}
