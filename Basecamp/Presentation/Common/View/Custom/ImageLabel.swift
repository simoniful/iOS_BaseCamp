//
//  ImageLabel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/05.
//

import UIKit
import SnapKit

final class ImageLabel: UIView {
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage())
    imageView.backgroundColor = .brown1.withAlphaComponent(0.8)
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 8.0
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var pillLabel: StackingLabel = {
    let label = StackingLabel(title: "", font: .title1M16, textColor: .black, textAlignment: .center, backgroundColor: .white, padding: .init(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0))
    label.layer.cornerRadius = 16.0
    label.clipsToBounds = true
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
    [backgroundImageView, pillLabel].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    backgroundImageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.height.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    pillLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  public func setupData(image: UIImage, text: String) {
    backgroundImageView.image = image
    pillLabel.text = text
  }
}
