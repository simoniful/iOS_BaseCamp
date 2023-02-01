//
//  DetailSocialCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/04.
//

import UIKit

final class DetailSocialCell: UICollectionViewCell {
  static let identifier = "DetailSocialCell"
  
  private lazy var iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 8.0
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var infoStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .title3M14
    label.numberOfLines = 1
    label.text = "타이틀"
    return label
  }()
  
  private lazy var descLabel: UILabel = {
    let label = UILabel()
    label.font = .body4R12
    label.numberOfLines = 3
    label.text = "설명"
    label.textColor = .darkGray
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

extension DetailSocialCell: ViewRepresentable {
  func setupView() {
    infoStack.addArrangedSubview(titleLabel)
    infoStack.addArrangedSubview(descLabel)
    [iconImageView, infoStack].forEach {
      contentView.addSubview($0)
    }
    
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.gray4.cgColor
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 8.0
  }
  
  func setupConstraints() {
    iconImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(8.0)
      $0.width.equalTo(36.0)
      $0.height.equalTo(36.0)
    }
    
    infoStack.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8.0)
      $0.leading.equalTo(iconImageView.snp.trailing).offset(12.0)
      $0.trailing.equalToSuperview().offset(-8.0)
      $0.bottom.equalToSuperview().offset(-8.0)
    }
  }
  
  func setupData(data: DetailSocialItem) {
    titleLabel.text = data.socialMediaInfo.title?.htmlToString
    descLabel.text = data.socialMediaInfo.description?.htmlToString
    iconImageView.image = UIImage(named: data.socialMediaInfo.type == "naverBlog" ? "blogLogo" : "youtubeLogo")
  }
}
