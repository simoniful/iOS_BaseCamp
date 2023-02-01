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
  
//  private lazy var overviewTextView: UITextView = {
//    let textView = UITextView()
//    textView.isEditable = false
//    textView.font = .body1M16
//    textView.textContainerInset = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
//    textView.layer.cornerRadius = 8.0
//    textView.clipsToBounds = true
//    textView.layer.borderWidth = 1
//    textView.layer.borderColor = UIColor.orange.cgColor
//    return textView
//  }()
  
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
    
//    overviewTextView.snp.makeConstraints {
//      $0.top.equalTo(infoStack.snp.bottom).offset(8.0)
//      $0.leading.equalToSuperview()
//      $0.trailing.equalToSuperview()
//      $0.width.greaterThanOrEqualTo(200.0)
//    }
    
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
      tooltipLabel.text = data.tooltip.isEmpty ? "･ 캠핑장에 주변 지역 관광 정보가 구비되어있습니다" : "･  " + data.tooltip
      infoStackSetFlag.toggle()
    }
//    overviewTextView.text = data.overview.isEmpty ? "캠핑장 사이트에서 자세히 알 수 있습니다." : data.overview
//    themaEnvrnClLabel.text = data.themaEnvrnCl == "" ? "자체 행사 관련하여 캠핑장으로 추가적인 문의바랍니다." : data.themaEnvrnCl
  }
}
