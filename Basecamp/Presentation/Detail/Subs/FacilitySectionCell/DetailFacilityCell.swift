//
//  DetailFacilityCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit

final class DetailFacilityCell: UICollectionViewCell {
  static let identifier = "DetailFacilityCell"
  
  private lazy var iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .center
    return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .body4R12
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

extension DetailFacilityCell: ViewRepresentable {
  func setupView() {
    [iconImageView, titleLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    iconImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8.0)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.height.equalTo(iconImageView.snp.width).multipliedBy(1.0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerX.equalTo(iconImageView.snp.centerX)
      $0.top.equalTo(iconImageView.snp.bottom)
//      $0.bottom.equalToSuperview().offset(-8.0)
    }
  }
  
  func setupData(data: DetailCampsiteFacilityItem) {
    iconImageView.image = UIImage(named: data.facility.iconName)?.resize(newWidth: 32.0)
    titleLabel.text = data.facility.rawValue
  }
}
