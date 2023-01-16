//
//  SearchCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/15.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchCell: UITableViewCell {
  static let identifier = "SearchCell"
  
  private lazy var thumbnailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 12.0
    return imageView
  }()
  
  private var titleLabel = DefaultLabel(title: "이름", font: .title1M16, textAlignment: .left)
  private var addressLabel = DefaultLabel(title: "주소", font: .body4R12, textColor: .gray7, textAlignment: .left)
  private var introLabel = DefaultLabel(title: "소개", font: .body4R12, textColor: .gray7, textAlignment: .left)
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupData(campsite: Campsite) {
    guard let urlString = campsite.firstImageURL else { return }
    let url = URL(string: urlString)
    let processor = DownsamplingImageProcessor(size: CGSize(width: 400, height: 300))
    thumbnailImageView.kf.indicatorType = .activity
    thumbnailImageView.kf.setImage(
        with: url,
        options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
    {
        result in
        switch result {
        case .success(let value):
            print("Task done for: \(value.source.url?.absoluteString ?? "")")
        case .failure(let error):
            print("Job failed: \(error.localizedDescription)")
        }
    }
    titleLabel.text = campsite.facltNm
    addressLabel.text = campsite.addr1
    introLabel.text = campsite.lineIntro!.isEmpty ? "" : campsite.lineIntro
  }
  
}

extension SearchCell: ViewRepresentable {
  func setupView() {
    [thumbnailImageView, titleLabel, addressLabel, introLabel].forEach { 
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.width.equalTo(64.0)
      $0.height.lessThanOrEqualTo(64.0)
      $0.top.equalToSuperview().offset(8.0)
      $0.leading.equalToSuperview().offset(16.0)
      // $0.bottom.equalToSuperview().offset(-8.0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8.0)
      $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8.0)
      $0.trailing.equalToSuperview().offset(-8.0)
    }
    
    addressLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
      $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8.0)
      $0.trailing.equalToSuperview().offset(-8.0)
    }
    
    introLabel.snp.makeConstraints {
      $0.top.equalTo(addressLabel.snp.bottom)
      $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8.0)
      $0.trailing.equalToSuperview().offset(-8.0)
      $0.bottom.equalToSuperview().offset(-8.0)
    }
  }
}
