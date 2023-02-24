//
//  DetailAroundSubCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/09.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailAroundSubCell: UICollectionViewCell {
  static let identifier = "DetailAroundSubCell"
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var nameLabel = DefaultLabel(title: "이름", font: .title1M16)
  private lazy var addressLabel = DefaultLabel(title: "주소", font: .body4R12, textColor: .darkGray)
  private lazy var distLabel = DefaultLabel(title: "거리", font: .body4R12, textColor: .main.withAlphaComponent(0.85))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupView()
    setupConstraints()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.kf.cancelDownloadTask()
    imageView.image = nil
  }
  
  func setupData(data: TouristInfo) {
    if let urlStr = data.subImage,
       let url = URL(string: urlStr) {
      let resource = ImageResource(downloadURL: url)
      let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 150))
      imageView.kf.setImage(with: resource, options: [
        .processor(processor),
        .transition(.fade(1)),
        .cacheOriginalImage
      ]) 
    }
    nameLabel.text = data.title
    addressLabel.text = data.address
    
    if let dist = data.dist,
       let doubleDist = Double(dist) {
      let intDist = Int(doubleDist)
      let decimal = doubleDist / 1000
      distLabel.text = doubleDist > 1000 ? String(format: "%.1f", decimal) + "km" : String(intDist) + "m"
    }
  }
}

extension DetailAroundSubCell: ViewRepresentable {
  func setupView() {
    [imageView, nameLabel, addressLabel, distLabel].forEach {
      contentView.addSubview($0)
    }
    
    [nameLabel, addressLabel, distLabel].forEach {
      $0.textAlignment = .left
    }
    
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.gray4.cgColor
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 8.0
  }
  
  func setupConstraints() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.width.equalTo(imageView.snp.height).multipliedBy(1.0)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8.0)
      $0.leading.equalTo(imageView.snp.trailing).offset(8.0)
      $0.trailing.equalToSuperview().offset(-8.0)
      $0.height.equalTo(20.0)
    }
    
    addressLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom)
      $0.leading.equalTo(imageView.snp.trailing).offset(8.0)
      $0.trailing.equalToSuperview().offset(-8.0)
    }
    
    distLabel.snp.makeConstraints {
      $0.top.equalTo(addressLabel.snp.bottom)
      $0.leading.equalTo(imageView.snp.trailing).offset(8.0)
      $0.trailing.equalToSuperview().offset(-8.0)
      $0.height.equalTo(16.0)
      $0.bottom.equalToSuperview().offset(-8.0)
    }
  }
}
