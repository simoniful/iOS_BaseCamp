//
//  DetailImageCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/04.
//

import UIKit
import Kingfisher

final class DetailImageCell: UICollectionViewCell {
  static let identifier = "DetailImageCell"
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
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
}

extension DetailImageCell: ViewRepresentable {
  func setupView() {
    contentView.addSubview(imageView)
    contentView.layer.cornerRadius = 12.0
    contentView.clipsToBounds = true
  }
  
  func setupConstraints() {
    imageView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
  
  func setupData(data: DetailImageItem) {
    let imageUrl = URL(string: data.image)
    let processor = DownsamplingImageProcessor(size: CGSize(width: 400, height: 300))
    let resource = ImageResource(downloadURL: imageUrl!)
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(with: resource,
                          options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(1)),
                            .cacheMemoryOnly
                          ]
    )
  }
}
