//
//  HomeFestivalCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/18.
//

import UIKit
import Kingfisher

class HomeFestivalCell: UICollectionViewCell {
  static let identifier = "HomeFestivalCell"
  
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
    label.text = "축제 개요"
    label.textColor = .brown1
    label.font = .title1M16
    return label
  }()
  
  private var rangeLabel: UILabel = {
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


  func setData(touristInfo: TouristInfo) {
    guard let urlString = touristInfo.subImage else { return }
    let url = URL(string: urlString)
    let processor = DownsamplingImageProcessor(size: CGSize(width: 300, height: 400))
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(
        with: url,
        placeholder: UIImage(named: "placeHolder"),
        options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
    
    titleLabel.text = touristInfo.title
    
    guard let eventStartDate = touristInfo.eventStartDate, let eventEndDate = touristInfo.eventEndDate else { return }
    
    rangeLabel.text = eventStartDate.toString(format: "MM.dd") + " ~ " + eventEndDate.toString(format: "MM.dd")
  }
}
extension HomeFestivalCell: ViewRepresentable {
  func setupView() {
    [imageView, titleLabel, rangeLabel].forEach {
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
    
    rangeLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-8.0)
      $0.leading.equalToSuperview().offset(12.0)
      $0.trailing.equalToSuperview().offset(-12.0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.bottom.equalTo(rangeLabel.snp.top)
      $0.trailing.equalToSuperview().offset(-12.0)
      $0.leading.equalToSuperview().offset(12.0)
    }
  }
}
