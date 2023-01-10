//
//  DetailInfoCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit

final class DetailInfoCell: UICollectionViewCell {
  static let identifier = "DetailInfoCell"
  
  private lazy var infoStack = DetailInfoStackView()
  
  private lazy var overviewTextView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    textView.font = .body1M16
    textView.textContainerInset = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    textView.layer.cornerRadius = 8.0
    textView.clipsToBounds = true
    textView.layer.borderWidth = 1
    textView.layer.borderColor = UIColor.orange.cgColor
    return textView
  }()
  
  // 커스텀 뷰
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

extension DetailInfoCell: ViewRepresentable {
  func setupView() {
    [overviewTextView, tooltipLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
//    infoStack.snp.makeConstraints {
//      $0.top.equalToSuperview().offset(8.0)
//      $0.leading.equalToSuperview().offset(8.0)
//      $0.trailing.equalToSuperview().offset(-8.0)
//    }
    
    overviewTextView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    
    tooltipLabel.snp.makeConstraints {
      $0.top.equalTo(overviewTextView.snp.bottom).offset(16.0)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  func setupData(data: DetailCampsiteInfoItem) {
    overviewTextView.text = data.overview
//    themaEnvrnClLabel.text = data.themaEnvrnCl == "" ? "자체 행사 관련하여 캠핑장으로 추가적인 문의바랍니다." : data.themaEnvrnCl
    tooltipLabel.text = data.tooltip  == "" ? "캠핑장에 주변 지역 관광 정보가 구비되어있습니다." : data.tooltip
  }
}
