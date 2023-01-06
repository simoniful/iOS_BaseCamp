//
//  DetailImageCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/04.
//

import UIKit

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
}

extension DetailImageCell: ViewRepresentable {
  func setupView() {
    contentView.addSubview(imageView)
  }
  
  func setupConstraints() {
    imageView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
  
  func setupData(data: DetailImageItem) {
    
  }
}
