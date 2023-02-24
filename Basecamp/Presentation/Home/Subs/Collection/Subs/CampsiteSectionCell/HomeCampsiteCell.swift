//
//  HomeInfoCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import UIKit
import Kingfisher

class HomeCampsiteCell: UICollectionViewCell {
  static let identifier = "HomeCampsiteCell"
  
  private var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "placeHolder")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.alpha = 0.4
    imageView.layer.cornerRadius = 12.0
    return imageView
  }()
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "캠핑장 개요"
    label.textColor = .brown1
    label.font = .title1M16
    return label
  }()
  
  private var locationLabel: UILabel = {
    let label = UILabel()
    label.text = "캠핑장 위치"
    label.textColor = .white
    label.font = .title3M14
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
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.kf.cancelDownloadTask()
    imageView.image = nil
  }
  
}

extension HomeCampsiteCell: ViewRepresentable {
  func setupView() {
    [imageView, titleLabel, locationLabel].forEach {
      contentView.addSubview($0)
    }
    
    contentView.backgroundColor = .black
    contentView.layer.cornerRadius = 12.0
    contentView.clipsToBounds = true
  }
  
  func setupConstraints() {
    imageView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8.0)
      $0.leading.equalToSuperview().offset(12.0)
      $0.trailing.equalToSuperview().offset(-12.0)
    }
    
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.trailing.equalToSuperview().offset(-12.0)
      $0.leading.equalToSuperview().offset(12.0)
    }
  }
  
  func setData(campsite: Campsite) {
    let urlString = campsite.firstImageURL 
    let url = URL(string: urlString)
    let processor = DownsamplingImageProcessor(size: CGSize(width: 400, height: 300))
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(
        with: url,
        placeholder: UIImage(named: "placeHolder"),
        options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]
    )
    titleLabel.text = campsite.facltNm
    let doNm = campsite.doNm
    let sigunguNm = campsite.sigunguNm
    locationLabel.text = doNm + " " + sigunguNm
  }
}
