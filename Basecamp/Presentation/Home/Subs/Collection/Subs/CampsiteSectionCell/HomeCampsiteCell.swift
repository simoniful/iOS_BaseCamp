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
    return imageView
  }()
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "캠핑장 개요"
    label.textColor = .white
    label.font = .title5M12
    return label
  }()
  
  private var locationLabel: UILabel = {
    let label = UILabel()
    label.text = "캠핑장 위치"
    label.textColor = .white
    label.font = .captionR10
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraint() {
    [imageView, titleLabel, locationLabel].forEach {
      contentView.addSubview($0)
    }

    imageView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(4.0)
      $0.trailing.equalToSuperview().offset(-4.0)
    }
    
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
      $0.trailing.equalToSuperview().offset(-4.0)
      $0.leading.equalToSuperview().offset(4.0)
    }
  }
  
  func setData(campsite: Campsite) {
    guard let urlString = campsite.firstImageURL else { return }
    let url = URL(string: urlString)
    let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
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
    locationLabel.text = campsite.addr1
  }
  
}
