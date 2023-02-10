//
//  CustomClusterView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/09.
//

import UIKit

final class CustomClusterMarker: UIView {
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "clusterMarker"))
    imageView.backgroundColor = .paleBlue
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 18.0
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var countLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14.0, weight: .bold)
    label.textColor = .white
    return label
  }()
  
  override init(frame: CGRect){
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    [imageView, countLabel].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    imageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.height.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    countLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  public func setupData(count: UInt, corner: Double, color: UIColor, font: UIFont) {
    countLabel.text = "\(count)"
    countLabel.font = font
    imageView.layer.cornerRadius = corner
    imageView.backgroundColor = color
  }
}
